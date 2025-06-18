import re
import random
import string

CYPHER_CLAUSE = ["optional match", "match", "with distinct", "with", "return", "where",
                 "order by", "limit", "call", "yield", "unwind"]

VAR_PATTERN = re.compile(r'\((\w+|\s*)\s*:\s*(\w+)\s*\)')
VAR_PATTERN_WITH_PREDICATE = re.compile(r'\((\w*)\s*:\s*(\w+)\s*\{(.*?)\}\)')


class Clause:
    def __init__(self, keyword: str, clause_text: str):
        self.keyword = keyword
        self.clause_text = clause_text
        self.raw_clause_component = self.compute_clause_component()
        self.clause_modified = False
        self.clause_component = None

    def copy(self):
        return Clause(self.keyword, self.clause_text)

    def compute_clause_component(self) -> set[str]:
        if self.keyword.lower() == "where":
            pattern = re.compile(r"\s+and\s+", re.IGNORECASE)
            # todo: skip the wrong where clause component
        elif self.keyword.lower() == "match":
            return set()
        else:
            pattern = re.compile(r"\s*,\s*")
        return set([i.strip() for i in re.split(pattern, self.clause_text[len(self.keyword):])])

    def get_clause_component(self) -> set[str]:
        if self.clause_component is not None:
            return self.clause_component
        self.clause_component = self.compute_clause_component()
        return self.clause_component

    def get_clause_text(self) -> str:
        if self.clause_modified:
            clause_component = self.get_clause_component()
            if len(clause_component) == 0:
                return ""
            delimiter = ", "
            if self.keyword == "where":
                delimiter = " and "
            component_text = delimiter.join(clause_component)
            return self.clause_text[:len(self.keyword) + 1] + component_text
        return self.clause_text

    def add_clause_component(self, component):
        if self.clause_component is None:
            self.clause_component = self.get_clause_component()
        if component not in self.clause_component:
            self.clause_component.add(component)
            self.clause_modified = True

    def remove_clause_component(self, component: str):
        if self.clause_component is None:
            self.clause_component = self.get_clause_component()
        self.clause_component.remove(component)
        self.clause_modified = True


class ReturnClause(Clause):
    def __init__(self, clause_text):
        self.return_mapping = {}
        # get the alias which is not returned in the final select sql clause and keep the corresponding component text
        self.return_join_var = {}
        super().__init__("return", clause_text)

    # get the mapping from alias to var.prop
    def process_return(self, returned_neo4j_prop):
        for i in super().get_clause_component():
            comp_list = re.split(r'\s+AS\s+', i, flags=re.IGNORECASE)
            if len(comp_list) == 1:
                alias = comp_list[0]
                var_prop = comp_list[0]
            else:
                assert len(comp_list) == 2
                alias = comp_list[1]
                var_prop = comp_list[0]
            self.return_mapping[alias] = var_prop
            # a map from alias to return clause, it stores the alias returned from cypher but not in the sql
            # select clause, it is either unnecessary return or used for join
            if alias not in returned_neo4j_prop:
                self.return_join_var[alias] = i

    def copy(self):
        return ReturnClause(self.clause_text)


class CypherParseInfo:
    def __init__(self, match_clauses: list[Clause], where_clause: Clause, return_clause: ReturnClause, all_vars: dict):
        self.match_clauses = match_clauses
        self.where_clause = where_clause
        self.return_clause = return_clause
        self.all_vars = all_vars


def get_query_wo_predicates(cypher_parsed: CypherParseInfo):
    return ("\n".join([i.get_clause_text() for i in cypher_parsed.match_clauses]) + "\n"
            + cypher_parsed.return_clause.get_clause_text())


def get_query_card(cypher_parsed: CypherParseInfo):
    # todo: remove where clause
    if cypher_parsed.where_clause:
        print("Cypher where clause: " + cypher_parsed.where_clause.get_clause_text())
    # where_clause = None
    match_clauses = cypher_parsed.match_clauses

    # if where_clause:
    #     return ("\n".join([i.get_clause_text() for i in match_clauses]) + "\n" +
    #             where_clause.get_clause_text() + "\n" + "return count(*)")
    # else:
    count_query = "\n".join([i.get_clause_text() for i in match_clauses]) + "\n" + "return count(*)"
    return f"CALL apoc.cypher.runTimeboxed(\"{count_query}\", {{}}, 100000)"


class CypherRewriter:
    def __init__(self, cypher_parsed: CypherParseInfo, processed_where_statements: list):
        """
        :param cypher_parsed: parsed cypher info
        # :param table_moved: a dictionary of table varname with the columns to be moved to neo4j
        :param processed_where_statements: tables to be passed to neo4j
        """
        self.match_clauses = [i.copy() for i in cypher_parsed.match_clauses]
        if cypher_parsed.where_clause:
            print("Cypher where clause: " + cypher_parsed.where_clause.get_clause_text())
        self.where_clause = None
        self.return_clause = cypher_parsed.return_clause.copy()
        # self.table_moved = table_moved
        self.processed_where_statements = processed_where_statements

    def to_cypher(self):
        if self.where_clause:
            return ("\n".join([i.get_clause_text() for i in self.match_clauses]) + "\n" +
                    self.where_clause.get_clause_text() + "\n" + self.return_clause.get_clause_text())
        else:
            return ("\n".join([i.get_clause_text() for i in self.match_clauses]) + "\n"
                    + self.return_clause.get_clause_text())

    def to_count_cypher(self):
        if self.where_clause:
            count_query = ("\n".join([i.get_clause_text() for i in self.match_clauses]) + "\n" +
                           self.where_clause.get_clause_text() + "\n" + "return count(*)")
        else:
            count_query = ("\n".join([i.get_clause_text() for i in self.match_clauses]) + "\n"
                           + "return count(*)")
        return f"CALL apoc.cypher.runTimeboxed(\"{count_query}\", {{}}, 240000)"

    # todo: table_mapping is from table alias to table name (label)
    def rewrite_match(self, varname, label):
        # for each table to be moved, need to modify the match clause
        self.match_clauses.append(Clause("match", "match ({}:{}T)".format(varname, label)))

    def rewrite_where(self, neo4j_var_prop, tmp_var, table_col):
        new_component = "{varprop} = {newvarname}.{tprop}".format(varprop=neo4j_var_prop, newvarname=tmp_var,
                                                                  tprop=table_col)
        if self.where_clause:
            self.where_clause.add_clause_component(new_component)
        else:
            wc = Clause('where', 'where {nc}'.format(nc=new_component))
            self.where_clause = wc

    def rewrite_return(self, tmp_var, cols, neo4j_alias, neo4j_join_only_var):
        for col in cols:
            self.return_clause.add_clause_component('{var}.{prop} as {var}{prop}'.format(var=tmp_var, prop=col))
        if neo4j_alias in neo4j_join_only_var:
            # if the neo4j var is returned to just to be joined with the relation, then remove it from return clause
            self.return_clause.remove_clause_component(neo4j_join_only_var[neo4j_alias])

    def rewrite(self, tmp_var, label, neo4j_var_prop, neo4j_alias, table_join_col, table_returned_cols, join_only_var):
        # crt_var, label, neo4j_var_prop, table_join_col, cols, neo4j_alias
        self.rewrite_match(tmp_var, label)
        self.rewrite_where(neo4j_var_prop, tmp_var, table_join_col)
        self.rewrite_return(tmp_var, table_returned_cols, neo4j_alias, join_only_var)


class CypherParser:
    def __init__(self, raw_query: str, join_vars: list[str]):
        self.query = raw_query.rstrip(';\n\r ')
        self.join_vars = join_vars

    def parser(self):
        all_vars = self.get_all_var_names()
        clauses = self.get_clauses()
        match_clauses = []
        where_clause = None
        return_clause = None
        for i in clauses:
            if i.keyword == "match":
                match_clauses.append(i)
            if i.keyword == "where":
                where_clause = i
            if i.keyword == "return":
                assert isinstance(i, ReturnClause)
                return_clause = i
        return CypherParseInfo(match_clauses, where_clause, return_clause, all_vars)

    # todo: this should return a dict, if the label does not exist, use None as value
    def get_all_var_names(self) -> dict:
        var_names = dict()
        for match in VAR_PATTERN.finditer(self.query):
            if match.group(1) != "":
                if match.group(2) != "":
                    var_names[match.group(1)] = match.group(2)
                else:
                    var_names[match.group(1)] = None
        for match in VAR_PATTERN_WITH_PREDICATE.finditer(self.query):
            if match.group(1) != "":
                if match.group(2) != "":
                    var_names[match.group(1)] = match.group(2)
                else:
                    var_names[match.group(1)] = None
        return var_names

    # get the start and end of all clause
    def get_clauses(self) -> list[Clause]:
        clauses = r'\b(' + "|".join(['{}'.format(word) for word in CYPHER_CLAUSE]) + r')\b'
        clauses_pattern = re.compile(clauses, re.IGNORECASE)

        end_idx = len(self.query)
        matches = list(re.finditer(clauses_pattern, self.query))

        clauses_match = []
        for i in range(len(matches) - 1):
            keyword = matches[i].group().lower().strip()
            if keyword == "return":
                clause = ReturnClause(self.query[matches[i].start():matches[i + 1].start()].strip())
                clause.process_return(self.join_vars)
            else:
                clause = Clause(keyword, self.query[matches[i].start():matches[i + 1].start()].strip())
            clauses_match.append(clause)
        keyword = matches[-1].group().lower().strip()
        if keyword == "return":
            last_clause = ReturnClause(self.query[matches[-1].start():end_idx].strip())
            last_clause.process_return(self.join_vars)
        else:
            last_clause = Clause(keyword, self.query[matches[-1].start():end_idx].strip())
        clauses_match.append(last_clause)
        return clauses_match
