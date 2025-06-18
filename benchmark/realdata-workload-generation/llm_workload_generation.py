import openai
from openai import OpenAI
import os
import re
from neo4j import GraphDatabase
import json
import regex as rex
from collections import defaultdict
import random
import string

# Test API using OpenAI Sample Code
client = OpenAI(
    # This is the default and can be omitted
    api_key=os.environ.get("OPENAI_API_KEY"),
)


# generate new workloads for real data
def generate_real_data_queries(schema_description: str, file_path: str,
                               num_queries=100, queries_per_batch=10):
    prompt = f"""
    I have graph data collected from openalex publication. 
    Given the graph data schema below, generate {queries_per_batch} Cypher queries that explore complex queries with path traversals.
    The path should be complex, return node properties. No filter predicates in where clause.   
    Give me only queries seprated by ; for me to process them easily.   
    {schema_description}
    """
    # Calculate the number of batches needed
    num_batches = num_queries // queries_per_batch

    queries = []
    for i in range(num_batches):
        response = client.chat.completions.create(
            model="gpt-4o",
            messages=[
                {"role": "user", "content": prompt}
            ],
            max_tokens=3000,  # Adjust based on the expected complexity of the queries
            n=1,
            temperature=0.7  # Lower temperature for more predictable outputs
        )

        crt_queries = response.choices[0].message.content.strip()
        queries.append(crt_queries)
        if (i + 1) % 5 == 0:
            with open(file_path, "a") as file:
                for qs in queries:
                    file.write(qs + "\n")
            queries = []

    if len(queries) > 0:
        with open(file_path, "a") as file:
            for qs in queries:
                file.write(qs + "\n")


if __name__ == '__main__':
    node_properties = """
    Node properties: 
    Author: id, orcid, name, works_count, cited_by_count
    Institution: id, name, ror, works_count, cited_by_count 
    Topic: id, name, works_count, cited_by_count 
    Subfield: id, name
    Field: id, name
    Keyword: name
    Work: id, name, year, type, cited_by_count
    """
    relationship = """
    Relationships:
    (Author)-[WORK_AT]->(Institution)
    (Institution)-[CHILD_OF]->(Institution)
    (Topic)-[HAS_SIBLING]-(Topic)
    (Keyword)-[BELONGS_TO]->(Topic)
    (Topic)-[BELONGS_TO]->(Subfield)
    (Subfield)-[BELONGS_TO]->(Field)
    (Field)-[BELONGS_TO]->(Domain)
    (Work)-[CREATED_BY]->(Author)
    (Work)-[CREATED_BY]->(Institution)
    (Work)-[RELATED_TO]->(Work)
    (Work)-[ABOUT]->(Topic)
    """
    schema = node_properties + "\n" + relationship
    generate_real_data_queries(schema, "C:/Users/sauzh/Documents/Work/crossmodel/workloads-realdata/new_llm.cypher",
                               num_queries=200)
