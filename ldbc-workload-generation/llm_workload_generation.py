# use gpt-4 for generating workloads

from openai import OpenAI
import os

relationship_map = {
    "IS_PART_OF": {("Country", "Continent"), ("City", "Country")},
    "IS_SUBCLASS_OF": {("TagClass", "TagClass")},
    "IS_LOCATED_IN": {("Company", "Country"), ("Message", "Country"), ("Person", "City"), ("University", "City")},
    "HAS_TYPE": {("Tag", "TagClass")},
    "CONTAINER_OF": {("Forum", "Post")},
    "HAS_MEMBER": {("Forum", "Person")},
    "HAS_MODERATOR": {("Forum", "Person")},
    "HAS_INTEREST": {("Person", "Tag")},
    "HAS_CREATOR": {("Comment", "Person"), ("Post", "Person")},
    "REPLY_OF": {("Comment", "Comment"), ("Comment", "Post")},
    "HAS_TAG": {("Forum", "Tag"), ("Comment", "Tag"), ("Post", "Tag")},
    "STUDY_AT": {("Person", "University")},
    "WORK_AT": {("Person", "Company")},
    "KNOWS": {("Person", "Person")},
    "LIKES": {("Person", "Comment"), ("Person", "Post")}
}

replaceable_nodes = {
    "Continent": ["Place"],
    "Country": ["Place"],
    "City": ["Place"],
    "University": ["Organisation"],
    "Company": ["Organisation"],
    "Comment": ["Message"],
    "Post": ["Message"]
}

# define excluded relationships
# excluded_relationship = {
#     "IS_PART_OF": {("Country", "City"), ("Continent", "Country"), ("Continent", "City"), ("City", "Continent")},
#     "IS_LOCATED_IN": {("University", "Country"), }
# }


def generate_replaceable_relationships(rel_map: dict, replaceable_nodes_map: dict, exclude_relationship=None):
    """
    :param rel_map: a dictionary from a string (relationship type) to a set of nodes pairs
    :param replaceable_nodes_map: a dictionary from a string (node label) to a list of node labels that are its superclass
    :param exclude_relationship: a dictionary from a string (relationship type) to a set of nodes pairs that
    should not exist
    :return: an extended relationship map with the replaceable labels
    """
    if exclude_relationship is None:
        exclude_relationship = {}
    extended_relation_map = {}
    for i in rel_map:
        values = rel_map[i]
        replaced_rels = set()
        for pair in values:
            ele1 = pair[0]
            ele2 = pair[1]
            ele1_replace = [] if ele1 not in replaceable_nodes_map else replaceable_nodes_map[ele1]
            ele2_replace = [] if ele2 not in replaceable_nodes_map else replaceable_nodes_map[ele2]
            # only when both of them are empty, skip
            if len(ele1_replace) == 0 and len(ele2_replace) == 0:
                continue
            ele1_replace.append(ele1)
            ele2_replace.append(ele2)
            for j in ele1_replace:
                for k in ele2_replace:
                    if j != k:
                        replaced_rels.add((j, k))
        # get the excluded node pairs
        if i in exclude_relationship:
            excluded_rels = exclude_relationship[i]
            replaced_rels = replaced_rels - excluded_rels
        values.update(replaced_rels)
        extended_relation_map[i] = values
    return extended_relation_map


# randomly generate queries without aggregation
def generate_cypher_queries_wo_agg(openai_client, schema_description, file_prefix: str, num_queries=100, queries_per_batch=10):
    prompt = f"""
    Given the graph data schema below, generate {queries_per_batch} Cypher queries that explore 
    complex queries with path traversals.
    There can be filter conditions on multiple node properties.
    Use placeholders $param for values in the predicates; I will replace them with real values later. 
    For datetime, do not use it in equality condition.
    Return node properties. 
    Do not have aggregation or other operators in the queries, just joins with filters.  
    Give me only queries separated by ; for me to process them easily.   
    {schema_description}
    """
    file_path = file_prefix + "llm.cypher"
    # Calculate the number of batches needed
    num_batches = num_queries // queries_per_batch

    queries = []
    for i in range(num_batches):
        response = openai_client.chat.completions.create(
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


#         file = open(result_file, 'w')
#         file.write(queries)
#         file.close()

extended_rel_map = generate_replaceable_relationships(relationship_map, replaceable_nodes)

if __name__ == '__main__':
    # define node properties
    # virtual graph nodes
    node_property = """
    Node properties:
    Country, City, Place: id, name
    Organisation, University, Company: id, name
    TagClass: id, name
    Tag: id, name
    Forum: creationDate, id, title 
    Person: creationDate, id, firstName, lastName, gender, birthday, speaks, locationIP, browserUsed, email
    Post, Comment, Message: creationDate, id, locationIP, browserUsed, content, length 
    Country or City are Place
    Post or Comment are Message
    University or Company are Organisation
    """

    # define relationships
    relationship = ("Relationship type with a list of source node label and target node label: \n" +
                    "\n".join(i + ":" + ", ".join(f"({a}, {b})" for a, b in extended_rel_map[i]) for i in extended_rel_map))

    schema_description = node_property + "\n" + relationship

    client = OpenAI(
        # This is the default and can be omitted
        api_key=os.environ.get("OPENAI_API_KEY"),
    )

    generate_cypher_queries_wo_agg(client, schema_description,
                                   "C:/Users/sauzh/Documents/Work/crossmodel/workloads/gpt4-wo-agg/", num_queries=100)

