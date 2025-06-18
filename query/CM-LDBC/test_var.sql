-- Step 1: recursive CTE to simulate IS_SUBCLASS_OF*
WITH RECURSIVE subclass_hierarchy AS (
  -- base case: direct subclass relationships
  SELECT tag_id AS supertag_id, subtag_id
  FROM tagclass_issubclassof_tagclass

  UNION ALL

  -- recursive step: walk up the hierarchy
  SELECT sh.supertag_id, t.subtag_id
  FROM subclass_hierarchy sh
  JOIN tagclass_issubclassof_tagclass t
    ON sh.subtag_id = t.tag_id
)

-- Step 2: main query using subclass hierarchy
SELECT 
  post0.content,
  tagclass1.name,
  e0.message_id,
  tag0.name
FROM 
  r_post post0,
  r_tag tag0,
  r_tagclass tagclass0,
  r_tagclass tagclass1,
  filter_post2 f0,
  message f1,
  message_hastag_tag e0,
  tag_hastype_tagclass e1,
  subclass_hierarchy e2
WHERE 
  e0.tag_id = tag0.id AND
  e1.tag_id = e0.tag_id AND
  e1.tagclass_id = tagclass0.id AND
  e1.tagclass_id = e2.supertag_id AND
  e2.subtag_id = tagclass1.id AND
  e0.message_id = post0.id AND
  f1.type = 'Post' AND
  f0.id = e0.message_id AND
  f1.id = e0.message_id;

-- Step 1: Recursive CTE to walk REPLY_OF* from comment to message
WITH RECURSIVE reply_chain AS (
  -- Base case: direct reply
  SELECT 
    message_id AS comment_id,
    replied_message_id AS ancestor_message_id
  FROM message_replyof_message mrm
   JOIN filter_comment2 fc ON fc.id = mrm.message_id

  UNION ALL

  -- Recursive step: climb the reply chain
  SELECT 
    rc.comment_id,
    mrm.replied_message_id AS ancestor_message_id
  FROM reply_chain rc
  JOIN message_replyof_message mrm 
    ON rc.ancestor_message_id = mrm.message_id
)

-- Step 2: Join forum + filter tables
SELECT 
  message0.content AS original_message,
  comment0.content AS replying_comment,
  forum0.title AS forum_title
FROM 
  reply_chain rc
JOIN r_comment comment0 ON rc.comment_id = comment0.id
JOIN r_message message0 ON rc.ancestor_message_id = message0.id
JOIN forum_containerof_message e1 ON rc.ancestor_message_id = e1.post_id
JOIN r_forum forum0 ON e1.forum_id = forum0.id
JOIN filter_message1 f2 ON f2.id = message0.id
JOIN message f1 ON f1.id = comment0.id
WHERE f1.type = 'Comment';


WITH RECURSIVE reply_chain AS (
  -- Base case: 1-hop replies from liked & filtered comments only
  SELECT 
    mrm.replied_message_id AS comment_id,
    mrm.message_id AS child_message_id,
    1 AS depth
  FROM message_replyof_message mrm
  JOIN filter_comment2 f0 ON f0.id = mrm.replied_message_id         -- restrict to filtered comments
  JOIN message f1 ON f1.id = mrm.replied_message_id AND f1.type = 'Comment'
  JOIN person_likes_message e0 ON e0.message_id = mrm.replied_message_id 
	JOIN r_person person0 ON e0.person_id = person0.id
  -- restrict to liked comments

  UNION ALL

  -- Recursive step: go one more level up (to depth = 2 max)
  SELECT 
    rc.comment_id,
    mrm.message_id AS child_message_id,
    rc.depth + 1
  FROM reply_chain rc
  JOIN message_replyof_message mrm
    ON rc.child_message_id = mrm.replied_message_id
  WHERE rc.depth < 2
)

-- Final query
SELECT 
  comment0.creationdate,
  comment0.content,
  rc.comment_id AS message_id
FROM 
  reply_chain rc
JOIN r_comment comment0 ON rc.comment_id = comment0.id
JOIN r_message message0 ON rc.child_message_id = message0.id
JOIN filter_message2 f2 ON f2.id = message0.id;



WITH RECURSIVE subclass_chain(tag_id, subtag_id, depth) AS (
  -- Base case: direct subclass relationship (depth = 1)
  SELECT tag_id, subtag_id, 1
  FROM tagclass_issubclassof_tagclass

  UNION ALL

  -- Recursive step: go one level deeper (max depth = 2)
  SELECT sc.tag_id, t.subtag_id, sc.depth + 1
  FROM subclass_chain sc
  JOIN tagclass_issubclassof_tagclass t
    ON sc.subtag_id = t.tag_id
  WHERE sc.depth < 2
)

SELECT 
  tagclass0.name,        -- top-level class
  post0.content,
  e0.message_id,
  tag0.name              -- tag name
FROM 
  subclass_chain sc
JOIN r_tagclass tagclass0 ON sc.subtag_id = tagclass0.id
JOIN tag_hastype_tagclass e1 ON e1.tagclass_id = sc.tag_id
JOIN r_tag tag0 ON e1.tag_id = tag0.id
JOIN message_hastag_tag e0 ON e0.tag_id = tag0.id
JOIN r_post post0 ON e0.message_id = post0.id
JOIN filter_post2 f0 ON f0.id = e0.message_id
JOIN message f1 ON f1.id = e0.message_id AND f1.type = 'Post';

-- Step 1: Build a recursive knows chain
WITH RECURSIVE knows_chain AS (
  -- Base case: 1-hop
  SELECT person_id AS src, friend_id AS dst, 1 AS depth
  FROM person_knows_person

  UNION ALL

  -- 2nd hop: find friends of friends
  SELECT kc.src, p2.friend_id AS dst, 2 AS depth
  FROM knows_chain kc
  JOIN person_knows_person p2 ON kc.dst = p2.person_id
  WHERE kc.depth = 1
)

-- Step 2: Main query using length-2 relationships
SELECT 
  person1.lastname,
  person0.lastname,
  post0.content,
  person1.firstname,
  person0.firstname
FROM knows_chain kc
JOIN r_person person0 ON person0.id = kc.src
JOIN r_person person1 ON person1.id = kc.dst
JOIN person_likes_message e1 ON e1.person_id = person0.id
JOIN r_post post0 ON e1.message_id = post0.id
JOIN message f3 ON f3.id = e1.message_id AND f3.type = 'Post'
JOIN message_hastag_tag e2 ON e1.message_id = e2.message_id
JOIN r_tag tag0 ON e2.tag_id = tag0.id
JOIN filter_person3 f0 ON f0.id = person1.id
JOIN filter_person3 f1 ON f1.id = person0.id
JOIN filter_post3 f2 ON f2.id = post0.id
WHERE kc.depth = 2;