import regex as rex


class SQLStats:
    def __init__(self):
        self.num_of_tables_touched = 0
        # self.touched_tables = set()  # how many tables it touched
        self.touched_table_types = set()  # how many different types of tables it touched

    def touch_table(self, table_label: str):
        self.num_of_tables_touched += 1
        # self.touched_tables.add(tabel_name)
        self.touched_table_types.add(table_label)


class CypherStats:
    def __init__(self):
        self.num_of_path = 0
        self.total_path_length = 0

    def add_path(self, path_len: int):
        self.num_of_path += 1
        self.total_path_length += path_len
        self.total_path_length = min(self.total_path_length, 100)


class Stats:
    def __init__(self, sql_stats: SQLStats, cypher_stats: CypherStats):
        self.num_of_path = cypher_stats.num_of_path
        self.total_path_length = cypher_stats.total_path_length
        self.num_of_tables_touched = sql_stats.num_of_tables_touched
        self.touched_table_types = sql_stats.touched_table_types

    def __str__(self):
        return (f"Num of path: {self.num_of_path}; total path len: {self.total_path_length}; "
                + f"num of tables visited: {self.num_of_tables_touched}; "
                + f"table types: {", ".join(self.touched_table_types)}")


def get_path_len(path: str):
    edge_pattern = r'\((\w*\s*\:?\w*)\s*(?:\{.*?\})?\s*\)<?-\[(\w*\s*\:\w*\d*\s*)\s*(?:\{.*?\})?\*?\d?\.?\.?\d?\s*\]->?\((\w*\s*:?\w*)\s*(?:\{.*?\})?\s*\)'
    # edge_pattern = r'\((\w*\s*\:?\w*)\s*(?:\{.*?\})?\s*\)<?-\[(\w*\s*\:\w*\s*)\s*(?:\{.*?\})?\s*\]->?\((\w*\s*:?\w*)\s*(?:\{.*?\})?\s*\)'
    edges = rex.findall(edge_pattern, path, overlapped=True)
    if "*" in path:
        return 100
    return len(edges)
