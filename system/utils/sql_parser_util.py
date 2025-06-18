from collections import defaultdict
import sqlparse
from sqlparse.sql import Identifier, IdentifierList, Where, Comparison, TokenList
from sqlparse.tokens import Keyword, DML, Whitespace, Operator
from collections import defaultdict
import copy


class SQLParseInfo:
    def __init__(self, select_mapping: dict, from_mapping: dict, join_condition: list):
        self.select_mapping = select_mapping
        self.from_mapping = from_mapping
        self.join_condition = join_condition


class SQLRewriter:
    def __init__(self, sql_parsed: SQLParseInfo, processed_where_statements: list, label_2_table_dict: dict):
        self.select_mapping = copy.deepcopy(sql_parsed.select_mapping)
        self.from_mapping = copy.deepcopy(sql_parsed.from_mapping)
        self.join_condition = sql_parsed.join_condition[:]
        self.processed_where_statements = processed_where_statements
        # this is for translating the table labels to real underlying table names
        self.label_2_table_dict = label_2_table_dict

    # for select mapping: a table is passed the neo4j, then the table entry is removed from the map,
    #  and the neo4j entry's value will add the table's returned columns
    def rewrite_select(self, table_list: list[str], neo4j_prop: list[str]):
        """
        :param table_list: a list of table alias
        :param neo4j_prop: a list of neo4j returned prop alias
        """
        for i in table_list:
            if i in self.select_mapping:
                self.select_mapping.pop(i)
        for new_prop in neo4j_prop:
            self.select_mapping['neo4j'].append(new_prop)

    # for join condition, all the conditions passed to neo4j will be removed
    def rewrite_where(self):
        for i in self.processed_where_statements:
            self.join_condition.remove(i)

    def rewrite_from(self, table_list: list[str]):
        """
        :param table_list: a list of table alias
        :return:
        """
        for i in table_list:
            self.from_mapping.pop(i)

    def rewrite(self, table_removed: list[str], neo4j_prop_selected: list[str]):
        """
        :param table_removed: table removed from sql select
        :param neo4j_prop_selected: columns selected from neo4j
        :return:
        """
        self.rewrite_select(table_removed, neo4j_prop_selected)
        self.rewrite_from(table_removed)
        self.rewrite_where()

    def to_sql(self):
        select_clause = ', '.join([f'{table}.{col}' for table, cols in self.select_mapping.items() for col in cols])
        print(len(select_clause.split(', ')))
        from_component = []
        for alias, table_name in self.from_mapping.items():
            if self.label_2_table_dict is not None and table_name != 'neo4j':
                table_name = self.label_2_table_dict[table_name]
            from_component.append(f'{table_name} as {alias}')
            # from_component.append(f'"{table_name}" as {alias}')
        from_clause = ', '.join(from_component)
        where_clause = ' AND '.join([f'{left} = {right}' for left, right in self.join_condition])
        if where_clause == '':
            return f'select {select_clause} \n from {from_clause}'
        return f'select {select_clause} \n from {from_clause} \n where {where_clause}'


class SQLParser:
    def __init__(self, raw_query: str):
        self.query = raw_query
        self.statement = None

    def parser(self):
        parsed = sqlparse.parse(self.query)
        self.statement = parsed[0]
        select_mapping = self.extract_select_clause()
        from_mapping = self.extract_from_clause()
        join_condition = self.extract_where_clause()
        return SQLParseInfo(select_mapping, from_mapping, join_condition)

    def extract_select_clause(self):
        """Extract the SELECT clause."""
        select_map = defaultdict(list)
        in_select = False

        for token in self.statement.tokens:
            if token.ttype is DML and token.value.upper() == 'SELECT':
                in_select = True
            elif in_select:
                if token.ttype is Keyword and token.value.upper() == 'FROM':
                    break  # Stop at the FROM clause
                if isinstance(token, IdentifierList):
                    for identifier in token.get_identifiers():
                        select_map[identifier.get_parent_name()].append(identifier.get_real_name())
                elif isinstance(token, Identifier):
                    select_map[token.get_parent_name()].append(token.get_real_name())
        return select_map

    # get alias to table real name/label mapping
    def extract_from_clause(self):
        """Extract the FROM clause including table names and aliases."""
        in_from = False
        from_clause_text = ''
        for token in self.statement.tokens:
            if token.ttype is Keyword and token.value.upper() == 'FROM':
                in_from = True
            elif in_from:
                if isinstance(token, Where) or (
                        token.ttype is Keyword and token.value.upper() in {'WHERE', 'GROUP', 'ORDER', 'LIMIT'}):
                    break  # Stop at the next clause (WHERE, GROUP BY, etc.)
                from_clause_text += token.value

        table_name_alias = [i.strip().split(' ') for i in from_clause_text.strip().split(',')]

        # Extract table real name and alias
        tables_map = {}
        for i in table_name_alias:
            if len(i) == 2:
                tables_map[i[-1]] = i[0]
            elif len(i) == 0:
                continue
            else:
                tables_map[i[0]] = i[0]
        return tables_map

    @staticmethod
    def process_where_token(token_list):
        token_list = [i for i in token_list if not i.is_whitespace]
        if len(token_list) == 3:
            # only keep the joins between neo4j and table
            if (isinstance(token_list[0], Identifier) and isinstance(token_list[-1], Identifier) and
                    token_list[1].value.strip() == "="):
                left = token_list[0].value.strip()
                right = token_list[-1].value.strip()
                if "neo4j" in left or "neo4j" in right:
                    return left, right

    def split_where_conditions(self, where_clause):
        """Split WHERE clause into individual components (conditions and operators)."""
        components = []
        for token in where_clause.tokens:
            if not token.is_whitespace and isinstance(token, Comparison):
                # process the token, only keep it if it contains Identifier = Identifier
                clause = self.process_where_token(token.tokens)
                if clause:
                    components.append(clause)
        return components

    def extract_where_clause(self):
        """Extract and split the WHERE clause into components."""
        where_clause = None
        for token in self.statement.tokens:
            if isinstance(token, Where):
                where_clause = token
                break
        if where_clause:
            return self.split_where_conditions(where_clause)
        return []
