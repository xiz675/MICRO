import os

from pathlib import Path
from utils.sql_rewrite_util import rewrite_cm_queries_to_sql, split_queries

EDGE_RELATION_MAPPING = {
    "PUBLISHED_IN": {("Author", "Year"): ("openalex_subset_authors_counts_by_year", "author_id", "year"),
                     ("Institution", "Year"): ("institutions_counts_by_year", "institution_id", "year")
                     },
    "WORK_AT": ("openalex_subset_author_institution", "id", "institution_id"),
    "CHILD_OF": ("institutions_child_of_institutions", "institution_id", "associated_institution_id"),
    "HAS_SIBLING": ("openalex_subset_topics_topics", "id", "sibling_id"),
    "BELONGS_TO": {
        ("Keyword", "Topic"): ("openalex_subset_keywords_topics", "word", "id"),
        ("Topic", "Subfield"): ("openalex_subset_topics_subfield", "id", "subfield_id"),
        ("Subfield", "Field"): ("openalex_subset_subfield_field", "id", "field_id"),
        ("Field", "Domain"): ("openalex_subset_field_domain", "id", "domain_id")
    },
    "CREATED_BY": {
        ("Work", "Author"): ("openalex_subset_works_author", "work_id", "author_id"),
        ("Work", "Institution"): ("openalex_subset_works_institution", "work_id", "institution_id")
    },
    "RELATED_TO": ("openalex_subset_works_related_works", "work_id", "related_work_id"),
    "ABOUT": ("openalex_subset_works_topics_final", "work_id", "topic_id")
}




# for different cypher node labels (openalex nodes), create filter tables


if __name__ == '__main__':
    query_path = r"C:\Users\sauzh\Documents\Work\crossmodel\workloads-realdata\cross_model_queries.txt"
    sql_query_dir = r"C:\Users\sauzh\Documents\Work\crossmodel\workloads-realdata"
    with open(query_path, 'r') as file:
        queries = file.read()
    cross_model_queries = [i.strip() for i in queries.split("##########") if i != ""]
    print(len(cross_model_queries))
    sql_queries = rewrite_cm_queries_to_sql(cross_model_queries, EDGE_RELATION_MAPPING)
    print(len(sql_queries))

    train_idx, test_idx = split_queries(len(sql_queries))

    train_queries = [sql_queries[i] for i in train_idx]
    test_queries = [sql_queries[i] for i in test_idx]

    train_cm_queries = [cross_model_queries[i] for i in train_idx]
    test_cm_queries = [cross_model_queries[i] for i in test_idx]

    file_path = Path(os.path.join(sql_query_dir, "train.sql"))
    file_path.write_text(";\n".join(train_queries))

    file_path = Path(os.path.join(sql_query_dir, "test.sql"))
    file_path.write_text(";\n".join(test_queries))

    Path(os.path.join(sql_query_dir, "train.txt")).write_text("\n##########\n".join(train_cm_queries))
    Path(os.path.join(sql_query_dir, "test.txt")).write_text("\n##########\n".join(test_cm_queries))

