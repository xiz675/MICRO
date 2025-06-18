import re
import random
import string

VAR_PATTERN = re.compile(r'\((\w+|\s*)\s*:\s*(\w+)\s*\)')
VAR_PATTERN_WITH_PREDICATE = re.compile(r'\((\w*)\s*:\s*(\w+)\s*\{(.*?)\}\)')
VAR_PATTERN_WITH_OPTIONAL_PROPS = re.compile(
    r'\(\s*(\w*)\s*:\s*(\w+)\s*(?:\{(.*?)\})?\s*\)'
)
VAR_PROP_PATTERN = re.compile(r'(\w+)\.(\w+)')
AGG_PATTERN = r'(\w+)\((.*)\)'
CYPHER_CLAUSE = ["optional match", "match", "with distinct", "with", "return", "where",
                 "order by", "limit", "call", "yield", "unwind"]


class Clause:
    def __init__(self, id: int, keyword_start_idx: int, keyword_end_idx: int, keyword: str, clause_text: str):
        self.id = id
        self.keyword_start_idx = keyword_start_idx
        self.keyword_end_idx = keyword_end_idx
        self.clause_start_idx = keyword_start_idx
        self.keyword = keyword
        self.clause_text = clause_text
        self.raw_clause_component = self.compute_clause_component()
        self.clause_modified = False
        self.clause_component = None

    def copy(self):
        return Clause(self.id, self.keyword_start_idx, self.keyword_end_idx, self.keyword, self.clause_text)

    def get_id(self):
        return self.id

    def compute_clause_component(self) -> set[str]:
        if self.keyword.lower() == "where":
            pattern = re.compile(r"\s+and\s+", re.IGNORECASE)
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

    def recompute_clause_component(self):
        self.clause_component = self.compute_clause_component()

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

    def modify_clause_component(self, old_comp: str, new_comp: str):
        self.remove_clause_component(old_comp)
        if new_comp != "":
            self.add_clause_component(new_comp)

    def modify_clause_substring(self, start_idx, end_idx, new_string):
        self.clause_text = self.clause_text[:start_idx] + new_string + self.clause_text[end_idx:]
        if self.clause_component is not None:
            # recompute the clause component when the text is modified
            self.recompute_clause_component()

    def replace_substring(self, original_substring, new_substring):
        self.clause_text = self.clause_text.replace(original_substring, new_substring)
        if self.clause_component is not None:
            self.recompute_clause_component()


class Variable:
    def __init__(self, variable_name: str, variable_label: str):
        self.variable_name = variable_name
        self.variable_label = variable_label
        # self.start_idx_in_clause = start_idx_in_clause
        # self.end_idx_in_clause = end_idx_in_clause
        # self.clause = None

    #         self.predicates = []
    #         self.return_property = []

    def __str__(self):
        return f"{self.variable_name}:{self.variable_label}"

    def info(self):
        return f"{self.variable_name}({self.start_idx, self.end_idx})"

    #     def get_predicates(self):
    #         return self.predicates

    #     def get_return_properties(self):
    #         return self.return_property

    #     def get_clause(self):
    #         return self.clause

    #     def add_predicate(self, predicate: Predicate):
    #         self.predicates.append(predicate)

    #     def add_return_property(self, prop: Property):
    #         self.return_property.append(prop)

    # def set_clause(self, clause: Clause):
    #     self.clause = clause

    #         clause_idx = clause.clause_start_idx
    #         self.start_idx_in_clause = self.start_idx - clause_idx
    #         self.end_idx_in_clause = self.end_idx - clause_idx

    def modify_var_name(self, new_var_name):
        self.variable_name = new_var_name
        # new_string = "({var_name}:{label_name})".format(var_name=new_var_name, label_name=self.variable_label)
        # # needs to replace the old file with new file which has the variable names
        # self.clause.modify_clause_substring(self.start_idx_in_clause, self.end_idx_in_clause, new_string)
        # self.end_idx_in_clause = self.start_idx_in_clause + len(new_string)


def find_all_keywords_match(query: str, keywords: list[str]) -> list[Clause]:
    cleaned_query = query.rstrip(';\n\r ')
    clauses = r'\b(' + "|".join(['{}'.format(word) for word in keywords]) + r')\b'
    clauses_pattern = re.compile(clauses, re.IGNORECASE)
    return get_clauses(list(re.finditer(clauses_pattern, cleaned_query)), len(cleaned_query), cleaned_query)


# get the start and end of all clause
def get_clauses(matches: list[re.Match], end_idx: int, raw_query: str) -> list[Clause]:
    clauses_match = []
    for i in range(len(matches) - 1):
        clause = Clause(i, matches[i].start(), matches[i].end(),
                        matches[i].group().lower().strip(), raw_query[matches[i].start():matches[i + 1].start()].strip())
        clauses_match.append(clause)
    last_clause = Clause(i, matches[-1].start(), matches[-1].end(), matches[-1].group().lower().strip(),
                         raw_query[matches[-1].start():end_idx].strip())
    clauses_match.append(last_clause)
    return clauses_match


def get_all_var_names(query: str):
    var_names = set()
    for match in VAR_PATTERN.finditer(query):
        if match.group(1) != "":
            var_names.add(match.group(1))
    for match in VAR_PATTERN_WITH_PREDICATE.finditer(query):
        if match.group(1) != "":
            var_names.add(match.group(1))
    return var_names


def prop_not_in_neo4j(label_name, prop, prop_mapping):
    prop_pg = prop_mapping[label_name]
    if prop in prop_pg:
        return True
    return False


def generate_var_name(global_vars):
    new_var_name = generate_random_string()
    while new_var_name in global_vars or new_var_name in CYPHER_CLAUSE:
        new_var_name = generate_random_string()
    return new_var_name


def generate_random_string():
    length = random.randint(1, 2)
    return ''.join(random.choice(string.ascii_lowercase) for _ in range(length))


def return_component_helper(component_name: str):
    if "." in component_name:
        var_name = component_name.split(".")[0]
        prop_name = component_name.split(".")[1]
    else:
        # if there is no prop, need to add id prop
        var_name = component_name
        prop_name = "id"
    return var_name, prop_name
