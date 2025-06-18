-- Recursive CTE to simulate RELATED_TO*1..3
WITH RECURSIVE related_path AS (
  -- Base case: 1-hop relationship
  SELECT work_id, related_work_id, 1 AS depth
  FROM openalex_subset_works_related_works
  JOIN filter_work3 fw1 ON work_id = fw1.id

  UNION ALL

  -- Recursive step: extend the path
  SELECT rp.work_id, wr.related_work_id, rp.depth + 1
  FROM related_path rp
  JOIN openalex_subset_works_related_works wr
    ON rp.related_work_id = wr.work_id
  WHERE rp.depth < 3
)

SELECT f0.name, f1.name, f2.name
FROM
  uspto.publication_cited_by_patent work1,
  uspto.publication_cited_by_patent2 work0,
  uspto.inventors2 author0,
  filter_author2 f0,
  filter_work3 f1,
  openalex_subset_works_author e0,
  filter_work3 f2,
  related_path e1  -- use the recursive CTE instead of the base table
WHERE
  f0.name = author0.name AND
  f1.name = work1.name AND
  f2.name = work0.name AND
  e0.work_id = e1.work_id AND
  f0.id = e0.author_id AND
  f1.id = e0.work_id AND
  f2.id = e1.related_work_id;

-- Recursive CTE for CHILD_OF* (any depth)
WITH RECURSIVE institution_hierarchy AS (
  -- Base case: direct CHILD_OF relationship
  SELECT institution_id, associated_institution_id
  FROM institutions_child_of_institutions

  UNION ALL

  -- Recursive step: walk up the hierarchy
  SELECT ih.institution_id, ici.associated_institution_id
  FROM institution_hierarchy ih
  JOIN institutions_child_of_institutions ici
    ON ih.associated_institution_id = ici.institution_id
)

SELECT 
  f1.works_count,
  e0.work_id,
  f2.name,
  f0.name,
  f1.name,
  f1.cited_by_count,
  f2.ror 
FROM 
  uspto.publication_cited_by_patent1 work0,
  uspto.institution1 institution0,
  uspto.institution2 institution1,
  filter_work3 f0,
  filter_institution2 f1,
  openalex_subset_works_institution e0,
  filter_institution2 f2,
  institution_hierarchy e1  -- using recursive path
WHERE 
  f2.ror = institution0.ror AND
  f0.name = work0.name AND
  f1.ror = institution1.ror AND
  e0.institution_id = e1.institution_id AND
  f0.id = e0.work_id AND
  f1.id = e0.institution_id AND
  f2.id = e1.associated_institution_id;


SELECT f2.name, e0.work_id, f2.works_count, f1.name, f0.name, f2.cited_by_count
FROM uspto.topic_patent2 topic0, uspto.inventors2 author0, uspto.publication_cited_by_patent1 work0, filter_author2 f0, filter_work3 f1, openalex_subset_works_author e0, filter_topic1 f2, openalex_subset_works_topics_final e1
WHERE f0.name = author0.name and e1.topic_id = topic0.id and f1.name = work0.name and e0.work_id=e1.work_id and f0.id=e0.author_id and f1.id=e0.work_id and f2.id=e1.topic_id;


-- Step 1: Create recursive hierarchy CTE
WITH RECURSIVE institution_hierarchy AS (
  -- Base case: direct CHILD_OF relationship
  SELECT institution_id, associated_institution_id
  FROM institutions_child_of_institutions

  UNION ALL

  -- Recursive case: chain multiple CHILD_OF relationships
  SELECT ih.institution_id, ici.associated_institution_id
  FROM institution_hierarchy ih
  JOIN institutions_child_of_institutions ici
    ON ih.associated_institution_id = ici.institution_id
)

-- Step 2: Main query using the recursive hierarchy
SELECT 
  f1.name,     -- immediate institution name
  f2.name,     -- ancestor institution name via CHILD_OF*
  f0.name      -- work name
FROM 
  uspto.institution institution0,
  uspto.publication_cited_by_patent1 work0,
  uspto.institution2 institution1,
  filter_work3 f0,
  filter_institution2 f1,
  openalex_subset_works_institution e0,
  filter_institution2 f2,
  institution_hierarchy e1
WHERE 
  f1.ror = institution1.ror AND
  f0.name = work0.name AND
  f2.ror = institution0.ror AND
  f0.id = e0.work_id AND
  f1.id = e0.institution_id AND
  e0.institution_id = e1.institution_id AND
  f2.id = e1.associated_institution_id;


-- Recursive CTE for institution ancestry
WITH RECURSIVE institution_hierarchy AS (
  -- Base case: direct CHILD_OF
  SELECT institution_id, associated_institution_id
  FROM institutions_child_of_institutions

  UNION ALL

  -- Recursive step: walk up the hierarchy
  SELECT ih.institution_id, ici.associated_institution_id
  FROM institution_hierarchy ih
  JOIN institutions_child_of_institutions ici
    ON ih.associated_institution_id = ici.institution_id
)

-- Main query
SELECT f1.name, f0.name
FROM uspto.institution institution1,
     uspto.institution2 institution0,
     filter_institution2 f0,
     filter_institution2 f1,
     institution_hierarchy e0
WHERE f0.ror = institution1.ror
  AND f1.ror = institution0.ror
  AND f0.id = e0.institution_id
  AND f1.id = e0.associated_institution_id;


WITH RECURSIVE related_works AS (
  -- Base case: 1-hop
  SELECT work_id AS source_id, related_work_id AS target_id, 1 AS depth
  FROM openalex_subset_works_related_works
  JOIN filter_work3 fw1 ON work_id = fw1.id

  UNION ALL

  -- Recursive step: continue walking
  SELECT rw.source_id, r.related_work_id AS target_id, rw.depth + 1
  FROM related_works rw
  JOIN openalex_subset_works_related_works r
    ON rw.target_id = r.work_id
  WHERE rw.depth < 3
),
-- Step 2: Main query with filter_author2 and openalex_subset_works_author
joined_authors AS (
  SELECT DISTINCT
    f1.name AS related_work_name,
    rw.target_id AS related_work_id,
    f2.name AS author_name
  FROM related_works rw
  JOIN filter_work3 f0 ON f0.id = rw.source_id  -- original work
  JOIN filter_work3 f1 ON f1.id = rw.target_id  -- related work
  JOIN openalex_subset_works_author e1 ON rw.target_id = e1.work_id
  JOIN filter_author2 f2 ON f2.id = e1.author_id
)
SELECT *
FROM joined_authors;


-- Step 1: Recursive CTE for CHILD_OF*
WITH RECURSIVE institution_hierarchy AS (
  -- Direct CHILD_OF
  SELECT institution_id, associated_institution_id
  FROM institutions_child_of_institutions

  UNION ALL

  -- Recursive step: go up the hierarchy
  SELECT ih.institution_id, ici.associated_institution_id
  FROM institution_hierarchy ih
  JOIN institutions_child_of_institutions ici
    ON ih.associated_institution_id = ici.institution_id
)

-- Step 2: Main query using the recursive hierarchy
SELECT 
  f3.name AS ultimate_ancestor_institution,
  f0.name AS work_name,
  f2.name AS direct_institution,
  f1.name AS author_name
FROM 
  uspto.publication_cited_by_patent2 work0,
  uspto.inventors1 author0,
  uspto.institution institution1,
  uspto.institution institution0,
  filter_work3 f0,
  filter_author2 f1,
  openalex_subset_works_author e0,
  filter_institution2 f2,
  openalex_subset_author_institution e1,
  filter_institution2 f3,
  institution_hierarchy e2
WHERE 
  f1.name = author0.name AND
  f0.name = work0.name AND
  f2.ror = institution1.ror AND
  f3.ror = institution0.ror AND
  e0.author_id = e1.id AND
  f0.id = e0.work_id AND
  f1.id = e0.author_id AND
  f2.id = e1.institution_id AND
  e1.institution_id = e2.associated_institution_id AND
  f3.id = e2.institution_id;

-- Step 1: recursive CTE for institution ancestry
WITH RECURSIVE institution_hierarchy AS (
  -- base: direct CHILD_OF
  SELECT institution_id, associated_institution_id
  FROM institutions_child_of_institutions

  UNION ALL

  -- recursive step
  SELECT ih.institution_id, ici.associated_institution_id
  FROM institution_hierarchy ih
  JOIN institutions_child_of_institutions ici
    ON ih.associated_institution_id = ici.institution_id
)

-- Step 2: full query using the CTE
SELECT 
  f2.name AS ancestor_institution,
  f1.name AS direct_institution,
  f0.name AS author_name
FROM 
  uspto.institution institution1,
  uspto.inventors1 author0,
  uspto.institution2 institution0,
  filter_author2 f0,
  filter_institution2 f1,
  openalex_subset_author_institution e0,
  filter_institution2 f2,
  institution_hierarchy e1
WHERE 
  f0.name = author0.name AND
  f1.ror = institution1.ror AND
  f2.ror = institution0.ror AND
  f0.id = e0.id AND
  f1.id = e0.institution_id AND
  e0.institution_id = e1.associated_institution_id AND
  f2.id = e1.institution_id;


-- Step 1: Recursive CTE to trace institutional ancestry
WITH RECURSIVE institution_hierarchy AS (
  -- Base: direct parent-child relationship
  SELECT institution_id, associated_institution_id
  FROM institutions_child_of_institutions

  UNION ALL

  -- Recursive step: walk up the hierarchy
  SELECT ih.institution_id, ici.associated_institution_id
  FROM institution_hierarchy ih
  JOIN institutions_child_of_institutions ici
    ON ih.associated_institution_id = ici.institution_id
)

-- Step 2: Main query using hierarchy
SELECT 
  f2.name AS ancestor_institution,
  f1.name AS direct_institution,
  f0.name AS author_name
FROM 
  uspto.inventors1 author0,
  uspto.institution2 institution0,
  uspto.institution2 institution1,
  filter_author2 f0,
  filter_institution2 f1,
  openalex_subset_author_institution e0,
  filter_institution2 f2,
  institution_hierarchy e1
WHERE 
  f0.name = author0.name AND
  f2.ror = institution0.ror AND
  f1.ror = institution1.ror AND
  f0.id = e0.id AND
  f1.id = e0.institution_id AND
  e0.institution_id = e1.institution_id AND
  f2.id = e1.associated_institution_id;


-- Step 1: Recursive CTE to simulate RELATED_TO*2..3
WITH RECURSIVE related_paths AS (
  -- Base case: 1-hop relationships
  SELECT work_id AS source_id, related_work_id AS target_id, 1 AS depth
  FROM openalex_subset_works_related_works
  JOIN filter_work3 fw1 ON work_id = fw1.id

  UNION ALL

  -- Recursive step: extend to next hop
  SELECT rp.source_id, r.related_work_id AS target_id, rp.depth + 1
  FROM related_paths rp
  JOIN openalex_subset_works_related_works r
    ON rp.target_id = r.work_id
  WHERE rp.depth < 3
),
filtered_paths AS (
  -- Only keep paths of length 2 or 3
  SELECT * FROM related_paths WHERE depth BETWEEN 2 AND 3
)

-- Step 2: Join back to work tables for names
SELECT 
  f1.name AS target_work_name,
  f0.name AS source_work_name
FROM 
  filtered_paths rp
JOIN filter_work3 f0 ON rp.source_id = f0.id
JOIN filter_work3 f1 ON rp.target_id = f1.id
JOIN uspto.publication_cited_by_patent work0 ON f1.name = work0.name
JOIN uspto.publication_cited_by_patent work1 ON f0.name = work1.name;


-- Step 1: Recursive CTE for RELATED_TO*2..4
WITH RECURSIVE related_paths AS (
  -- Base case: direct 1-hop
  SELECT 
    work_id AS source_id,
    related_work_id AS target_id,
    1 AS depth
  FROM openalex_subset_works_related_works
  JOIN filter_work3 fw1 ON work_id = fw1.id

  UNION ALL

  -- Recursive case: extend the path
  SELECT 
    rp.source_id,
    r.related_work_id AS target_id,
    rp.depth + 1
  FROM related_paths rp
  JOIN openalex_subset_works_related_works r
    ON rp.target_id = r.work_id
  WHERE rp.depth < 4
),
filtered_paths AS (
  -- Keep only 2 to 4 hop paths
  SELECT * FROM related_paths WHERE depth BETWEEN 2 AND 4
)

-- Step 2: Join to works for names
SELECT 
  fp.target_id AS related_work_id,
  fp.source_id AS work_id,
  f0.name AS source_work_name,
  f1.name AS related_work_name,
  fp.source_id
FROM 
  filtered_paths fp
JOIN filter_work3 f0 ON fp.source_id = f0.id
JOIN filter_work3 f1 ON fp.target_id = f1.id
JOIN uspto.publication_cited_by_patent1 work1 ON f0.name = work1.name
JOIN uspto.publication_cited_by_patent work0 ON f1.name = work0.name;

-- Step 1: recursive CTE to get paths up to 3 hops
WITH RECURSIVE related_paths AS (
  -- Base: direct RELATED_TO
  SELECT
    work_id AS source_id,
    related_work_id AS target_id,
    1 AS depth
  FROM openalex_subset_works_related_works
  JOIN filter_work3 fw1 ON work_id = fw1.id

  UNION ALL

  -- Recursive step: extend path
  SELECT
    rp.source_id,
    r.related_work_id AS target_id,
    rp.depth + 1
  FROM related_paths rp
  JOIN openalex_subset_works_related_works r
    ON rp.target_id = r.work_id
  WHERE rp.depth < 3
)

-- Step 2: main query to get names and IDs
SELECT 
  f1.name AS related_work_name,
  rp.target_id AS related_work_id,
  f0.name AS source_work_name,
  rp.source_id AS work_id
FROM 
  related_paths rp
JOIN filter_work3 f0 ON rp.source_id = f0.id
JOIN filter_work3 f1 ON rp.target_id = f1.id
JOIN uspto.publication_cited_by_patent work0 ON f1.name = work0.name
JOIN uspto.publication_cited_by_patent work1 ON f0.name = work1.name;

-- -- Step 1: Recursive CTE for sibling chains (undirected if needed)
-- WITH RECURSIVE sibling_chain AS (
--   -- Base case: direct sibling relationship
--   SELECT id, sibling_id
--   FROM openalex_subset_topics_topics

--   UNION ALL

--   -- Recursive step: expand from both directions (if undirected)
--   SELECT sc.id, ott.sibling_id
--   FROM sibling_chain sc
--   JOIN openalex_subset_topics_topics ott ON sc.sibling_id = ott.id
-- )

-- -- Step 2: Use the recursive sibling_chain to get work-topic pairs
-- SELECT 
--   f2.name AS work_name,
--   f0.name AS topic_name,
--   f1.name AS sibling_name
-- FROM 
--   sibling_chain sc
-- JOIN filter_topic1 f0 ON f0.id = sc.id
-- JOIN filter_topic1 f1 ON f1.id = sc.sibling_id
-- JOIN openalex_subset_works_topics_final e1 ON sc.sibling_id = e1.topic_id
-- JOIN filter_work3 f2 ON f2.id = e1.work_id
-- JOIN uspto.publication_cited_by_patent2 work0 ON f2.name = work0.name
-- JOIN uspto.topic_patent topic0 ON sc.sibling_id = topic0.id
-- JOIN uspto.topic_patent1 topic1 ON sc.id = topic1.id;