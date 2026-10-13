TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.pid
from neo4j1, r_person person0
where Person0.birthday < $birthday and neo4j1.pid = Person0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e2.tagclass_id AS tcid, e1.tag_id AS tid, e0.person_id AS pid, e0.message_id AS poid
FROM filter_person1 f0, filter_post2 f1, message f2, message_hascreator_person e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE f2.type='Post' and e0.message_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select count(DISTINCT neo4j2.pid) AS alumnusCount, Tag0.name AS tagName
from neo4j2, r_tagclass tagclass0, r_post post0, r_tag tag0, seg1
where TagClass0.name = $tagClassName and Post0.creationDate > $postDate and neo4j2.tcid = TagClass0.id and neo4j2.poid = Post0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name
ORDER BY alumnusCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.loc_id AS plid, e0.org_id AS uid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='University' and f0.id=e0.org_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.plid
from neo4j1, r_university university0
where University0.name <> $excludedUniversityName and neo4j1.uid = University0.id
group by neo4j1.plid
) b1
where c > 5
),
neo4j2 AS (
SELECT e1.forum_id AS fid, e2.tag_id AS tid, e0.person_id AS pid, e0.loc_id AS plid
FROM filter_person1 f0, person_islocatedin_place e0, filter_forum2 f1, forum_hasmember_person e1, forum_hastag_tag e2
WHERE e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_tag tag0, r_person person0, r_forum forum0, seg1
where Person0.gender = $gender and Forum0.creationDate > $forumDate and neo4j2.tid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.fid = Forum0.id and neo4j2.plid = seg1.plid
group by Tag0.name
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS ciid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='University' and f1.type='City' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select neo4j1.ciid, count(neo4j1.uid) AS c
from neo4j1, r_city city0
where City0.name <> $excludedCityName and neo4j1.ciid = City0.id
group by neo4j1.ciid
) b1
where c > 2
),
neo4j2 AS (
SELECT e2.message_id AS mid, e0.org_id AS oid, e1.person_id AS pid, e0.loc_id AS ciid
FROM place f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, filter_message2 f2, person_likes_message e2
WHERE f0.type='City' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e1.person_id and f2.id=e2.message_id
)
select count(DISTINCT neo4j2.pid) AS likerCount, Message0.browserUsed AS messageBrowser
from neo4j2, r_organisation organisation0, r_message message0, seg1
where Organisation0.name <> $excludedOrganisationName and Message0.length > $minLength and neo4j2.oid = Organisation0.id and neo4j2.mid = Message0.id and neo4j2.ciid = seg1.ciid
group by Message0.browserUsed
ORDER BY likerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.loc_id AS plid, e0.org_id AS uid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='University' and f0.id=e0.org_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.plid
from neo4j1, r_place place0
where Place0.name = $placeName and neo4j1.plid = Place0.id
group by neo4j1.plid
) b1
where c > 2
),
neo4j2 AS (
SELECT e2.friend_id AS qid, e1.person_id AS pid, e0.org_id AS coid, e0.loc_id AS plid
FROM organisation f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, filter_person1 f2, person_knows_person e2
WHERE f0.type='Company' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.org_id and f1.id=e1.person_id and f2.id=e2.friend_id
)
select Person0.gender AS friendGender, count(DISTINCT neo4j2.pid) AS employeeCount
from neo4j2, r_company company0, r_person person0, seg1
where Person0.browserUsed = $browser and Company0.name <> $excludedCompanyName and neo4j2.coid = Company0.id and neo4j2.qid = Person0.id and neo4j2.plid = seg1.plid
group by Person0.gender
ORDER BY employeeCount DESC, 1, 2
LIMIT 20;
TODO;
TODO;
TODO;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.message_id AS poid, e0.person_id AS authorid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, organisation f3, person_workat_organisation e1, place f4, organisation_islocatedin_place e2
WHERE f1.type='Post' and f3.type='Company' and f4.type='Country' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.company_id and f4.id=e2.loc_id
),
seg1 AS (
select avg(Post0.length) AS avgPostLength, neo4j1.authorid
from neo4j1, r_post post0
where Post0.creationDate > $postDate and neo4j1.poid = Post0.id
group by neo4j1.authorid
ORDER BY avgPostLength DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.friend_id AS friendid, e0.person_id AS authorid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0
WHERE f0.id=e0.person_id and f1.id=e0.friend_id
)
select Person0.browserUsed AS browser, count(DISTINCT neo4j2.authorid) AS authorCount
from neo4j2, r_person person0, seg1
where Person0.gender = $gender and neo4j2.friendid = Person0.id and neo4j2.authorid = seg1.authorid
group by Person0.browserUsed
ORDER BY authorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.message_id AS poid, e0.tag_id AS tagid
FROM filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tagid, max(Post0.creationDate) AS latestPostDate
from neo4j1, r_post post0, r_tag tag0
where Tag0.name = $tagName and neo4j1.poid = Post0.id and neo4j1.tagid = Tag0.id
group by neo4j1.tagid
ORDER BY latestPostDate DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Person0.locationIP AS locationIP, count(DISTINCT neo4j2.tagid) AS tagCount
from neo4j2, r_person person0, seg1
where Person0.birthday < $birthdayBefore and neo4j2.personid = Person0.id and neo4j2.tagid = seg1.tagid
group by Person0.locationIP
ORDER BY tagCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.message_id AS commentid, e1.person_id AS personid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, place f5, person_islocatedin_place e2
WHERE f1.type='Post' and f3.type='Comment' and f5.type='City' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id and f4.id=e1.person_id and f5.id=e2.loc_id
),
seg1 AS (
select min(Comment0.creationDate) AS firstReplyDate, neo4j1.personid
from neo4j1, r_comment comment0
where Comment0.length > $minCommentLength and neo4j1.commentid = Comment0.id
group by neo4j1.personid
ORDER BY firstReplyDate ASC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.university_id AS universityid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0
WHERE f1.type='University' and f0.id=e0.person_id and f1.id=e0.university_id
)
select count(DISTINCT neo4j2.personid) AS personCount, University0.name AS university
from neo4j2, r_university university0, seg1
where University0.name <> $excludedUniversity and neo4j2.universityid = University0.id and neo4j2.personid = seg1.personid
group by University0.name
ORDER BY personCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.post_id AS poid, e0.forum_id AS forumid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0, filter_person1 f3, forum_hasmoderator_person e1, organisation f4, person_workat_organisation e2
WHERE f1.type='Post' and f4.type='Company' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id and f3.id=e1.person_id and f4.id=e2.company_id
),
seg1 AS (
select avg(Post0.length) AS avgPostLength, neo4j1.forumid
from neo4j1, r_forum forum0, r_post post0
where Forum0.creationDate > $forumDate and neo4j1.forumid = Forum0.id and neo4j1.poid = Post0.id
group by neo4j1.forumid
ORDER BY avgPostLength DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.forum_id AS forumid, e0.person_id AS memberid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0
WHERE f0.id=e0.forum_id and f1.id=e0.person_id
)
select Person0.gender AS gender, count(DISTINCT neo4j2.forumid) AS forumCount
from neo4j2, r_person person0, seg1
where Person0.browserUsed = $browser and neo4j2.memberid = Person0.id and neo4j2.forumid = seg1.forumid
group by Person0.gender
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.message_id AS likedid, e0.loc_id AS placeid
FROM filter_post2 f0, message f1, message_islocatedin_place e0, filter_person1 f2, person_islocatedin_place e1, filter_post2 f3, message f4, person_likes_message e2
WHERE f1.type='Post' and f4.type='Post' and e0.loc_id=e1.loc_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.message_id and f4.id=e2.message_id
),
seg1 AS (
select neo4j1.placeid, avg(Post0.length) AS avgLikedPostLength
from neo4j1, r_post post0
where Post0.creationDate > $likedPostDate and neo4j1.likedid = Post0.id
group by neo4j1.placeid
ORDER BY avgLikedPostLength DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.loc_id AS placeid, e0.org_id AS universityid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='University' and f0.id=e0.org_id
)
select count(DISTINCT neo4j2.placeid) AS placeCount, University0.name AS university
from neo4j2, r_university university0, seg1
where University0.name <> $excludedUniversity and neo4j2.universityid = University0.id and neo4j2.placeid = seg1.placeid
group by University0.name
ORDER BY placeCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.pid
from neo4j1, r_university university0
where University0.name <> $excludedUniversity and neo4j1.uid = University0.id
group by neo4j1.pid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.person_id AS pid, e1.tag_id AS tid, e0.message_id AS poid
FROM filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0, message_hastag_tag e1
WHERE f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select count(DISTINCT neo4j2.pid) AS alumniCount, Tag0.name
from neo4j2, r_post post0, r_tag tag0, seg1
where Post0.length > $length and Post0.creationDate > $postDate and neo4j2.poid = Post0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name;
WITH neo4j1 AS (
SELECT e0.loc_id AS plid, e0.org_id AS uid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='University' and f0.id=e0.org_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.plid
from neo4j1, r_university university0
where University0.name <> $excludedUniversity and neo4j1.uid = University0.id
group by neo4j1.plid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.org_id AS coid, e1.person_id AS pid, e0.loc_id AS plid
FROM organisation f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1
WHERE f0.type='Company' and e0.org_id=e1.company_id and f0.id=e0.org_id and f1.id=e1.person_id
)
select Company0.name, Person0.gender, count(DISTINCT neo4j2.pid) AS workerCount
from neo4j2, r_company company0, r_person person0, seg1
where Company0.name <> $excludedCompany and Person0.birthday < $birthday and neo4j2.coid = Company0.id and neo4j2.pid = Person0.id and neo4j2.plid = seg1.plid
group by Company0.name, Person0.gender;
WITH neo4j1 AS (
SELECT e0.loc_id AS plid, e0.org_id AS uid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='University' and f0.id=e0.org_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.plid
from neo4j1, r_place place0
where Place0.name <> $excludedPlace and neo4j1.plid = Place0.id
group by neo4j1.plid
) b1
where c > 10
),
neo4j2 AS (
SELECT e1.message_id AS cmid, e0.reg_id AS coid, e0.subreg_id AS plid
FROM place f0, place_ispartof_place e0, filter_comment2 f1, message f2, message_islocatedin_place e1
WHERE f0.type='Country' and f2.type='Comment' and e0.reg_id=e1.loc_id and f0.id=e0.reg_id and f1.id=e1.message_id and f2.id=e1.message_id
)
select Country0.name, count(DISTINCT neo4j2.cmid) AS commentCount, Comment0.browserUsed
from neo4j2, r_country country0, r_comment comment0, seg1
where Country0.name <> $excludedCountry and Comment0.length > $length and neo4j2.coid = Country0.id and neo4j2.cmid = Comment0.id and neo4j2.plid = seg1.plid
group by Country0.name, Comment0.browserUsed;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS ciid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='University' and f1.type='City' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select neo4j1.ciid, count(neo4j1.uid) AS c
from neo4j1, r_city city0
where City0.name <> $excludedCity and neo4j1.ciid = City0.id
group by neo4j1.ciid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.tag_id AS tid, e0.person_id AS pid, e0.loc_id AS ciid
FROM place f0, person_islocatedin_place e0, person_hasinterest_tag e1
WHERE f0.type='City' and e0.person_id=e1.person_id and f0.id=e0.loc_id
)
select Person0.browserUsed, count(DISTINCT neo4j2.pid) AS residentCount, Tag0.name
from neo4j2, r_tag tag0, r_person person0, seg1
where Person0.gender = $gender and Tag0.name <> $excludedTag and neo4j2.tid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.ciid = seg1.ciid
group by Person0.browserUsed, Tag0.name;
WITH neo4j1 AS (
SELECT e1.message_id AS poid, e0.company_id AS coid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0, filter_post2 f2, message f3, message_hascreator_person e1, message_hastag_tag e2
WHERE f0.type='Company' and f3.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.company_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select count(neo4j1.poid) AS c, neo4j1.pid
from neo4j1, r_company company0
where Company0.name = $companyName and neo4j1.coid = Company0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e2.tag_id AS rtid, e0.person_id AS pid
FROM filter_person1 f0, filter_comment2 f1, message f2, message_hascreator_person e0, filter_post2 f3, message f4, message_replyof_message e1, message_hastag_tag e2
WHERE f2.type='Comment' and f4.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.replied_message_id and f4.id=e1.replied_message_id
)
select Person0.firstName AS firstName, Tag0.name AS replyTagName, Person0.lastName AS lastName, Comment0.creationDate AS commentCreationDate
from neo4j2, r_person person0, r_comment comment0, r_tag tag0, seg1
where Comment0.length > $length and neo4j2.pid = Person0.id and neo4j2.cmid = Comment0.id and neo4j2.rtid = Tag0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e1.message_id AS mid, e2.person_id AS pid, e0.org_id AS coid
FROM organisation f0, organisation_islocatedin_place e0, filter_message2 f1, message_islocatedin_place e1, filter_person1 f2, message_hascreator_person e2
WHERE f0.type='Company' and e0.loc_id=e1.loc_id and e1.message_id=e2.message_id and f0.id=e0.org_id and f1.id=e1.message_id and f2.id=e2.person_id
),
seg1 AS (
select count(neo4j1.mid) AS c, neo4j1.pid
from neo4j1, r_company company0, r_message message0
where Message0.length > $minLength and Company0.name = $companyName and neo4j1.coid = Company0.id and neo4j1.mid = Message0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.forum_id AS foid, e2.tag_id AS tagid, e0.person_id AS pid, e1.post_id AS postid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmember_person e0, filter_post2 f2, message f3, forum_containerof_message e1, message_hastag_tag e2
WHERE f3.type='Post' and e0.forum_id=e1.forum_id and e1.post_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.forum_id and f2.id=e1.post_id and f3.id=e1.post_id
)
select Forum0.title AS forumTitle, Person0.lastName AS lastName, Tag0.name AS postTagName, Person0.firstName AS firstName, Post0.creationDate AS postCreationDate
from neo4j2, r_forum forum0, r_post post0, r_person person0, r_tag tag0, seg1
where Forum0.creationDate > $forumDate and neo4j2.foid = Forum0.id and neo4j2.postid = Post0.id and neo4j2.pid = Person0.id and neo4j2.tagid = Tag0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.company_id AS coid, e2.tagclass_id AS tcid, e1.tag_id AS tid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE f0.type='Company' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select neo4j1.tid, count(neo4j1.pid) AS c
from neo4j1, r_tagclass tagclass0, r_company company0
where TagClass0.name = $tagClassName and Company0.name = $companyName and neo4j1.tcid = TagClass0.id and neo4j1.coid = Company0.id
group by neo4j1.tid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.forum_id AS foid, e1.person_id AS modid, e0.tag_id AS tid, e2.loc_id AS cityid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_person1 f1, forum_hasmoderator_person e1, place f2, person_islocatedin_place e2
WHERE f2.type='City' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.forum_id and f1.id=e1.person_id and f2.id=e2.loc_id
)
select Forum0.title AS forumTitle, City0.name AS moderatorCityName, Person0.firstName AS moderatorFirstName, Tag0.name AS tagName, Person0.lastName AS moderatorLastName
from neo4j2, r_person person0, r_forum forum0, r_tag tag0, r_city city0, seg1
where Person0.gender = $gender and neo4j2.modid = Person0.id and neo4j2.foid = Forum0.id and neo4j2.tid = Tag0.id and neo4j2.cityid = City0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e2.person_id AS pid, e0.loc_id AS countryid, e0.org_id AS coid
FROM organisation f0, place f1, organisation_islocatedin_place e0, place f2, place_ispartof_place e1, filter_person1 f3, person_islocatedin_place e2
WHERE f0.type='Company' and f1.type='Country' and f2.type='City' and e0.loc_id=e1.reg_id and e1.subreg_id=e2.loc_id and f0.id=e0.org_id and f1.id=e0.loc_id and f2.id=e1.subreg_id and f3.id=e2.person_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.countryid
from neo4j1, r_person person0, r_company company0
where Person0.gender = $gender and Company0.name <> $excludedCompanyName and neo4j1.pid = Person0.id and neo4j1.coid = Company0.id
group by neo4j1.countryid
ORDER BY c DESC, 1, 2
LIMIT 56
),
neo4j2 AS (
SELECT e0.subreg_id AS homeid, e1.person_id AS personid, e0.reg_id AS countryid, e2.message_id AS postid
FROM place f0, place f1, place_ispartof_place e0, filter_person1 f2, person_islocatedin_place e1, filter_post2 f3, message f4, person_likes_message e2
WHERE f0.type='Country' and f1.type='City' and f4.type='Post' and e0.subreg_id=e1.loc_id and e1.person_id=e2.person_id and f0.id=e0.reg_id and f1.id=e0.subreg_id and f2.id=e1.person_id and f3.id=e2.message_id and f4.id=e2.message_id
)
select Person0.lastName AS personLastName, City0.name AS cityName, Post0.content AS likedPostContent, Country0.name AS countryName, Person0.firstName AS personFirstName
from neo4j2, r_city city0, r_country country0, r_post post0, r_person person0, seg1
where Post0.creationDate > $postDate and neo4j2.homeid = City0.id and neo4j2.countryid = Country0.id and neo4j2.postid = Post0.id and neo4j2.personid = Person0.id and neo4j2.countryid = seg1.countryid;
WITH neo4j1 AS (
SELECT e1.forum_id AS foid, e0.person_id AS pid, e0.company_id AS coid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0, filter_forum2 f2, forum_hasmember_person e1, forum_hastag_tag e2
WHERE f0.type='Company' and e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.company_id and f1.id=e0.person_id and f2.id=e1.forum_id
),
seg1 AS (
select neo4j1.foid, count(neo4j1.pid) AS c
from neo4j1, r_company company0
where Company0.name = $companyName and neo4j1.coid = Company0.id
group by neo4j1.foid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e1.message_id AS cmid, e0.forum_id AS foid, e2.person_id AS authorid, e0.post_id AS postid
FROM filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, filter_comment2 f3, message f4, message_replyof_message e1, filter_person1 f5, message_hascreator_person e2
WHERE f2.type='Post' and f4.type='Comment' and e0.post_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.message_id and f4.id=e1.message_id and f5.id=e2.person_id
)
select Forum0.title AS forumTitle, Comment0.content AS commentContent, Person0.lastName AS authorLastName, Post0.content AS postContent, Person0.firstName AS authorFirstName
from neo4j2, r_comment comment0, r_forum forum0, r_post post0, r_person person0, seg1
where Comment0.length > $commentLength and neo4j2.cmid = Comment0.id and neo4j2.foid = Forum0.id and neo4j2.postid = Post0.id and neo4j2.authorid = Person0.id and neo4j2.foid = seg1.foid;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e2.tagclass_id AS tcid, e0.message_id AS cmid, e0.person_id AS pid
FROM filter_comment2 f0, message f1, filter_person1 f2, message_hascreator_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE f1.type='Comment' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmid) AS c, neo4j1.pid
from neo4j1, r_comment comment0, r_tagclass tagclass0
where TagClass0.name = $tagClassName and Comment0.length > $minCommentLength and neo4j1.cmid = Comment0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.pid
) b1
where c > 20
),
neo4j2 AS (
SELECT e1.loc_id AS plid, e0.person_id AS pid, e0.company_id AS coid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0, organisation_islocatedin_place e1
WHERE f1.type='Company' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id
)
select Company0.name AS companyName, Place0.name AS placeName, count(DISTINCT neo4j2.pid) AS personCount
from neo4j2, r_company company0, r_place place0, seg1
where Place0.name = $workPlaceName and neo4j2.coid = Company0.id and neo4j2.plid = Place0.id and neo4j2.pid = seg1.pid
group by Company0.name, Place0.name;
WITH neo4j1 AS (
SELECT e0.message_id AS cmid, e1.person_id AS pid, e2.loc_id AS ciid
FROM filter_comment2 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, place f5, person_islocatedin_place e2
WHERE f1.type='Comment' and f3.type='Post' and f5.type='City' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id and f5.id=e2.loc_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmid) AS c, neo4j1.pid
from neo4j1, r_comment comment0, r_city city0
where City0.name = $creatorCityName and Comment0.creationDate > $commentSince and neo4j1.cmid = Comment0.id and neo4j1.ciid = City0.id
group by neo4j1.pid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.forum_id AS foid, e1.tag_id AS tid, e0.person_id AS pid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmoderator_person e0, forum_hastag_tag e1
WHERE e0.forum_id=e1.forum_id and f0.id=e0.person_id and f1.id=e0.forum_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.foid) AS forumCount
from neo4j2, r_tag tag0, r_forum forum0, seg1
where Tag0.name <> $excludedTagName and Forum0.creationDate > $forumSince and neo4j2.tid = Tag0.id and neo4j2.foid = Forum0.id and neo4j2.pid = seg1.pid
group by Tag0.name;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.tag_id AS parentid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Comment' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select neo4j1.tid, count(DISTINCT neo4j1.cmid) AS c
from neo4j1, r_comment comment0, r_tagclass tagclass0
where Comment0.length < $maxCommentLength and TagClass0.name = $parentClassName and neo4j1.cmid = Comment0.id and neo4j1.parentid = TagClass0.id
group by neo4j1.tid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.forum_id AS foid, e1.person_id AS pid, e0.tag_id AS tid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_person1 f1, forum_hasmember_person e1
WHERE e0.forum_id=e1.forum_id and f0.id=e0.forum_id and f1.id=e1.person_id
)
select count(DISTINCT neo4j2.foid) AS forumCount, Person0.browserUsed AS browserUsed
from neo4j2, r_person person0, r_forum forum0, seg1
where Forum0.creationDate > $forumSince and Person0.gender = $memberGender and neo4j2.pid = Person0.id and neo4j2.foid = Forum0.id and neo4j2.tid = seg1.tid
group by Person0.browserUsed;
WITH neo4j1 AS (
SELECT e0.replied_message_id AS pcid, e2.university_id AS uid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, organisation f5, person_studyat_organisation e2
WHERE f1.type='Comment' and f3.type='Comment' and f5.type='University' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id and f5.id=e2.university_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmid) AS c, neo4j1.uid
from neo4j1, r_comment comment0, r_comment comment1
where Comment0.creationDate > $parentCommentSince and Comment1.length > $replyLength and neo4j1.pcid = Comment0.id and neo4j1.cmid = Comment1.id
group by neo4j1.uid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.person_id AS sid, e1.message_id AS mid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, filter_message2 f2, person_likes_message e1
WHERE f0.type='University' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.message_id
)
select count(DISTINCT neo4j2.sid) AS likerCount, Message0.browserUsed AS browserUsed, Person0.gender AS gender
from neo4j2, r_message message0, r_person person0, seg1
where Person0.birthday < $birthdayBefore and Message0.length > $likedMessageLength and neo4j2.mid = Message0.id and neo4j2.sid = Person0.id and neo4j2.uid = seg1.uid
group by Message0.browserUsed, Person0.gender;
WITH neo4j1 AS (
SELECT e1.message_id AS mid, e0.message_id AS cmid, e2.person_id AS pid
FROM filter_comment2 f0, message f1, message_islocatedin_place e0, filter_message2 f2, message_islocatedin_place e1, filter_person1 f3, message_hascreator_person e2
WHERE f1.type='Comment' and e0.loc_id=e1.loc_id and e1.message_id=e2.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.message_id and f3.id=e2.person_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmid) AS c, neo4j1.pid
from neo4j1, r_comment comment0, r_message message0
where Comment0.creationDate < $commentBefore and Message0.length > $messageLength and neo4j1.cmid = Comment0.id and neo4j1.mid = Message0.id
group by neo4j1.pid
) b1
where c > 5
),
neo4j2 AS (
SELECT e1.tag_id AS tid, e0.person_id AS pid, e0.message_id AS poid
FROM filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0, message_hastag_tag e1
WHERE f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Tag0.name AS tagName, Post0.browserUsed AS browserUsed, count(DISTINCT neo4j2.pid) AS likerCount
from neo4j2, r_post post0, r_tag tag0, seg1
where Tag0.name = $likedTagName and Post0.creationDate > $postSince and neo4j2.poid = Post0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name, Post0.browserUsed;
WITH neo4j1 AS (
SELECT e0.org_id AS companyid, e0.loc_id AS countryid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select count(neo4j1.companyid) AS c, neo4j1.countryid
from neo4j1, r_company company0
where Company0.name <> $companyName and neo4j1.companyid = Company0.id
group by neo4j1.countryid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.person_id AS personid, e2.tag_id AS tagid, e0.loc_id AS countryid, e0.message_id AS postid
FROM place f0, filter_post2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, person_hasinterest_tag e2
WHERE f0.type='Country' and f2.type='Post' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select Post0.content, Person0.lastName, Person0.firstName, Tag0.name, Post0.length, Country0.name
from neo4j2, r_person person0, r_tag tag0, r_post post0, r_country country0, seg1
where Post0.creationDate > $postDate and Tag0.name = $tagName and neo4j2.personid = Person0.id and neo4j2.tagid = Tag0.id and neo4j2.postid = Post0.id and neo4j2.countryid = Country0.id and neo4j2.countryid = seg1.countryid;
WITH neo4j1 AS (
SELECT e0.company_id AS companyid, e0.person_id AS workerid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select * from (
select neo4j1.companyid, count(neo4j1.workerid) AS c
from neo4j1, r_person person0
where Person0.birthday < $birthday and neo4j1.workerid = Person0.id
group by neo4j1.companyid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.loc_id AS placeid, e0.org_id AS companyid, e2.tag_id AS tagid, e1.message_id AS messageid
FROM organisation f0, organisation_islocatedin_place e0, filter_message2 f1, message_islocatedin_place e1, message_hastag_tag e2
WHERE f0.type='Company' and e0.loc_id=e1.loc_id and e1.message_id=e2.message_id and f0.id=e0.org_id and f1.id=e1.message_id
)
select Company0.name, Message0.length, Message0.content, Tag0.name, Place0.name
from neo4j2, r_tag tag0, r_place place0, r_company company0, r_message message0, seg1
where Tag0.name = $tagName and Message0.length > $messageLength and neo4j2.tagid = Tag0.id and neo4j2.placeid = Place0.id and neo4j2.companyid = Company0.id and neo4j2.messageid = Message0.id and neo4j2.companyid = seg1.companyid;
WITH neo4j1 AS (
SELECT e0.loc_id AS placeid, e0.org_id AS companyid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='Company' and f0.id=e0.org_id
),
seg1 AS (
select * from (
select neo4j1.placeid, count(neo4j1.companyid) AS c
from neo4j1, r_company company0
where Company0.name <> $excludedCompanyName and neo4j1.companyid = Company0.id
group by neo4j1.placeid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.loc_id AS placeid, e0.person_id AS personid, e2.tag_id AS tagid, e1.forum_id AS forumid
FROM filter_person1 f0, person_islocatedin_place e0, filter_forum2 f1, forum_hasmember_person e1, forum_hastag_tag e2
WHERE e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id
)
select Person0.lastName, Forum0.title, Person0.firstName, Tag0.name, Place0.name
from neo4j2, r_tag tag0, r_person person0, r_place place0, r_forum forum0, seg1
where Forum0.creationDate > $forumDate and Person0.gender = $gender and Tag0.name = $tagName and neo4j2.tagid = Tag0.id and neo4j2.personid = Person0.id and neo4j2.placeid = Place0.id and neo4j2.forumid = Forum0.id and neo4j2.placeid = seg1.placeid;
WITH neo4j1 AS (
SELECT e0.org_id AS companyid, e0.loc_id AS countryid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select count(neo4j1.companyid) AS c, neo4j1.countryid
from neo4j1, r_company company0
where Company0.name = $companyName and neo4j1.companyid = Company0.id
group by neo4j1.countryid
) b1
where c > 10
),
neo4j2 AS (
SELECT e2.university_id AS universityid, e0.message_id AS commentid, e1.person_id AS authorid, e0.loc_id AS countryid
FROM place f0, filter_comment2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, organisation f4, person_studyat_organisation e2
WHERE f0.type='Country' and f2.type='Comment' and f4.type='University' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id and f4.id=e2.university_id
)
select Person0.firstName, Person0.lastName, Comment0.content, Comment0.length, University0.name, Country0.name
from neo4j2, r_university university0, r_person person0, r_comment comment0, r_country country0, seg1
where University0.name = $universityName and Comment0.creationDate < $commentDate and neo4j2.universityid = University0.id and neo4j2.authorid = Person0.id and neo4j2.commentid = Comment0.id and neo4j2.countryid = Country0.id and neo4j2.countryid = seg1.countryid;
WITH neo4j1 AS (
SELECT e0.subreg_id AS ciid, e0.reg_id AS coid
FROM place f0, place f1, place_ispartof_place e0
WHERE f0.type='Country' and f1.type='City' and f0.id=e0.reg_id and f1.id=e0.subreg_id
),
seg1 AS (
select count(neo4j1.ciid) AS c, neo4j1.coid
from neo4j1, r_city city0
where City0.name <> $excludedCity and neo4j1.ciid = City0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 6
),
neo4j2 AS (
SELECT e2.tag_id AS tid, e1.person_id AS pid, e0.message_id AS poid, e0.loc_id AS coid
FROM place f0, filter_post2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, person_hasinterest_tag e2
WHERE f0.type='Country' and f2.type='Post' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.poid) AS postCount
from neo4j2, r_tag tag0, r_post post0, r_person person0, seg1
where Person0.gender = $gender and Post0.creationDate > $postDate and neo4j2.tid = Tag0.id and neo4j2.poid = Post0.id and neo4j2.pid = Person0.id and neo4j2.coid = seg1.coid
group by Tag0.name;
WITH neo4j1 AS (
SELECT e0.org_id AS compid, e0.loc_id AS coid
FROM place f0, organisation f1, organisation_islocatedin_place e0
WHERE f0.type='Country' and f1.type='Company' and f0.id=e0.loc_id and f1.id=e0.org_id
),
seg1 AS (
select neo4j1.coid, count(neo4j1.compid) AS c
from neo4j1, r_company company0
where Company0.name <> $excludedCompany and neo4j1.compid = Company0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 22
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e1.person_id AS pid, e2.company_id AS orgid, e0.loc_id AS coid
FROM place f0, filter_comment2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, person_workat_organisation e2
WHERE f0.type='Country' and f2.type='Comment' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select count(DISTINCT neo4j2.cmid) AS commentCount, Person0.browserUsed AS browserUsed, Organisation0.name AS organisationName
from neo4j2, r_organisation organisation0, r_person person0, r_comment comment0, seg1
where Person0.browserUsed = $browser and Comment0.length > $minCommentLength and neo4j2.orgid = Organisation0.id and neo4j2.pid = Person0.id and neo4j2.cmid = Comment0.id and neo4j2.coid = seg1.coid
group by Person0.browserUsed, Organisation0.name;
WITH neo4j1 AS (
SELECT e0.message_id AS mid, e0.loc_id AS coid
FROM place f0, filter_message2 f1, message_islocatedin_place e0
WHERE f0.type='Country' and f0.id=e0.loc_id and f1.id=e0.message_id
),
seg1 AS (
select count(neo4j1.mid) AS c, neo4j1.coid
from neo4j1, r_message message0
where Message0.length > $minMessageLength and neo4j1.mid = Message0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 56
),
neo4j2 AS (
SELECT e2.tag_id AS tid, e1.message_id AS cmid, e0.loc_id AS coid
FROM place f0, filter_post2 f1, message f2, message_islocatedin_place e0, filter_comment2 f3, message f4, message_replyof_message e1, message_hastag_tag e2
WHERE f0.type='Country' and f2.type='Post' and f4.type='Comment' and e0.message_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.message_id and f4.id=e1.message_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.cmid) AS replyCount
from neo4j2, r_comment comment0, r_tag tag0, seg1
where Tag0.name <> $excludedTag and Comment0.creationDate > $commentDate and neo4j2.cmid = Comment0.id and neo4j2.tid = Tag0.id and neo4j2.coid = seg1.coid
group by Tag0.name;
WITH neo4j1 AS (
SELECT e0.org_id AS org0id, e0.loc_id AS coid
FROM place f0, organisation_islocatedin_place e0
WHERE f0.type='Country' and f0.id=e0.loc_id
),
seg1 AS (
select neo4j1.coid, count(neo4j1.org0id) AS c
from neo4j1, r_organisation organisation0
where Organisation0.name <> $excludedOrganisation and neo4j1.org0id = Organisation0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 6
),
neo4j2 AS (
SELECT e2.forum_id AS fid, e1.person_id AS pid, e0.org_id AS orgid, e0.loc_id AS coid
FROM place f0, organisation_islocatedin_place e0, filter_person1 f1, person_studyat_organisation e1, filter_forum2 f2, forum_hasmember_person e2
WHERE f0.type='Country' and e0.org_id=e1.university_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e1.person_id and f2.id=e2.forum_id
)
select count(DISTINCT neo4j2.pid) AS studentMemberCount, Forum0.title AS forumTitle, Organisation0.name AS organisationName
from neo4j2, r_forum forum0, r_person person0, r_organisation organisation0, seg1
where Forum0.creationDate > $forumDate and Person0.birthday < $birthdayCutoff and neo4j2.fid = Forum0.id and neo4j2.pid = Person0.id and neo4j2.orgid = Organisation0.id and neo4j2.coid = seg1.coid
group by Forum0.title, Organisation0.name;
WITH neo4j1 AS (
SELECT e0.subreg_id AS plid, e0.reg_id AS coid
FROM place f0, place_ispartof_place e0
WHERE f0.type='Country' and f0.id=e0.reg_id
),
seg1 AS (
select neo4j1.coid, count(neo4j1.plid) AS c
from neo4j1, r_place place0
where Place0.name <> $excludedPlace and neo4j1.plid = Place0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 56
),
neo4j2 AS (
SELECT e2.forum_id AS fid, e0.message_id AS msgid, e1.person_id AS pid, e0.loc_id AS coid
FROM place f0, filter_message2 f1, message_islocatedin_place e0, filter_person1 f2, person_likes_message e1, filter_forum2 f3, forum_hasmoderator_person e2
WHERE f0.type='Country' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.forum_id
)
select Forum0.title AS forumTitle, count(DISTINCT neo4j2.msgid) AS likedMessageCount, Person0.browserUsed AS browserUsed
from neo4j2, r_person person0, r_message message0, r_forum forum0, seg1
where Message0.length > $minLikedMessageLength and Forum0.title <> $excludedForumTitle and neo4j2.pid = Person0.id and neo4j2.msgid = Message0.id and neo4j2.fid = Forum0.id and neo4j2.coid = seg1.coid
group by Forum0.title, Person0.browserUsed;
TODO;
TODO;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.person_id AS authorid, e1.forum_id AS foid, e2.tag_id AS tid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, filter_forum2 f3, forum_hasmember_person e1, forum_hastag_tag e2
WHERE f1.type='Post' and e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.forum_id
),
seg1 AS (
select * from (
select count(neo4j1.foid) AS c, neo4j1.authorid
from neo4j1, r_tag tag0, r_post post0
where Tag0.name = $tagName and Post0.creationDate > $postDate and neo4j1.tid = Tag0.id and neo4j1.poid = Post0.id
group by neo4j1.authorid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.friend_id AS friendid, e0.person_id AS authorid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0
WHERE f0.id=e0.person_id and f1.id=e0.friend_id
)
select Person0.browserUsed AS browser, count(DISTINCT neo4j2.authorid) AS authorCount
from neo4j2, r_person person0, seg1
where Person0.gender = $gender and neo4j2.friendid = Person0.id and neo4j2.authorid = seg1.authorid
group by Person0.browserUsed
ORDER BY authorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.person_id AS workerid, e1.org_id AS orgid, e0.message_id AS poid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0, organisation_islocatedin_place e1, filter_person1 f3, person_workat_organisation e2
WHERE f1.type='Post' and f2.type='Country' and e0.loc_id=e1.loc_id and e1.org_id=e2.company_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id and f3.id=e2.person_id
),
seg1 AS (
select * from (
select neo4j1.workerid, count(DISTINCT neo4j1.poid) AS c
from neo4j1, r_organisation organisation0, r_post post0
where Post0.length > $minLength and Organisation0.name <> $orgName and neo4j1.orgid = Organisation0.id and neo4j1.poid = Post0.id
group by neo4j1.workerid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.message_id AS msgid, e0.person_id AS workerid
FROM filter_person1 f0, filter_message2 f1, person_likes_message e0
WHERE f0.id=e0.person_id and f1.id=e0.message_id
)
select Message0.browserUsed AS browser, count(DISTINCT neo4j2.workerid) AS workerCount
from neo4j2, r_message message0, seg1
where Message0.length > $likedMinLength and neo4j2.msgid = Message0.id and neo4j2.workerid = seg1.workerid
group by Message0.browserUsed
ORDER BY workerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.tag_id AS tagid, e2.tagclass_id AS tcid, e0.message_id AS comid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE f1.type='Post' and f3.type='Comment' and e0.message_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id
),
seg1 AS (
select * from (
select neo4j1.tagid, count(neo4j1.comid) AS c
from neo4j1, r_tagclass tagclass0, r_comment comment0
where Comment0.creationDate > $commentDate and TagClass0.name = $className and neo4j1.tcid = TagClass0.id and neo4j1.comid = Comment0.id
group by neo4j1.tagid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Person0.locationIP AS locationIP, count(DISTINCT neo4j2.tagid) AS tagCount
from neo4j2, r_person person0, seg1
where Person0.birthday < $birthday and neo4j2.personid = Person0.id and neo4j2.tagid = seg1.tagid
group by Person0.locationIP
ORDER BY tagCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.university_id AS uniid, e0.forum_id AS foid, e1.person_id AS modid, e0.post_id AS poid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0, filter_person1 f3, forum_hasmoderator_person e1, organisation f4, person_studyat_organisation e2
WHERE f1.type='Post' and f4.type='University' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id and f3.id=e1.person_id and f4.id=e2.university_id
),
seg1 AS (
select * from (
select neo4j1.modid, count(DISTINCT neo4j1.poid) AS c
from neo4j1, r_university university0, r_forum forum0
where University0.name = $universityName and Forum0.creationDate > $forumDate and neo4j1.uniid = University0.id and neo4j1.foid = Forum0.id
group by neo4j1.modid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.company_id AS compid, e0.person_id AS modid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0
WHERE f1.type='Company' and f0.id=e0.person_id and f1.id=e0.company_id
)
select Company0.name AS company, count(DISTINCT neo4j2.modid) AS moderatorCount
from neo4j2, r_company company0, seg1
where Company0.name <> $companyName and neo4j2.compid = Company0.id and neo4j2.modid = seg1.modid
group by Company0.name
ORDER BY moderatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.person_id AS personid, e0.tag_id AS tagid, e2.loc_id AS cityid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_person1 f2, person_hasinterest_tag e1, place f3, person_islocatedin_place e2
WHERE f1.type='Post' and f3.type='City' and e0.tag_id=e1.tag_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.loc_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.personid) AS c, neo4j1.cityid
from neo4j1, r_post post0, r_tag tag0
where Post0.length > $minPostLength and Tag0.name = $tagName and neo4j1.poid = Post0.id and neo4j1.tagid = Tag0.id
group by neo4j1.cityid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.subreg_id AS cityid, e0.reg_id AS countryid
FROM place f0, place f1, place_ispartof_place e0
WHERE f0.type='City' and f1.type='Country' and f0.id=e0.subreg_id and f1.id=e0.reg_id
)
select count(DISTINCT neo4j2.cityid) AS cityCount, Country0.name AS country
from neo4j2, r_country country0, seg1
where Country0.name <> $excludedCountry and neo4j2.countryid = Country0.id and neo4j2.cityid = seg1.cityid
group by Country0.name
ORDER BY cityCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select avg(Post0.length) AS avgPostLength, neo4j1.tid
from neo4j1, r_post post0
where Post0.creationDate > $postDate and neo4j1.poid = Post0.id
group by neo4j1.tid
ORDER BY avgPostLength DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.message_id AS p2id, e1.person_id AS creatorid, e0.tag_id AS tid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_person1 f2, message_hascreator_person e1
WHERE f1.type='Post' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id
)
select count(DISTINCT neo4j2.p2id) AS postCount, Person0.gender AS gender, Person0.browserUsed AS browserUsed
from neo4j2, r_person person0, r_post post0, seg1
where Post0.length > $minPostLength and neo4j2.creatorid = Person0.id and neo4j2.p2id = Post0.id and neo4j2.tid = seg1.tid
group by Person0.gender, Person0.browserUsed;
WITH neo4j1 AS (
SELECT e0.message_id AS cid, e0.tag_id AS tid
FROM filter_comment2 f0, message f1, message_hastag_tag e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tid, max(Comment0.length) AS maxCommentLength
from neo4j1, r_comment comment0
where Comment0.creationDate > $commentDate and neo4j1.cid = Comment0.id
group by neo4j1.tid
ORDER BY maxCommentLength DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.message_id AS c2id, e1.loc_id AS countryid, e0.tag_id AS tid
FROM filter_comment2 f0, message f1, message_hastag_tag e0, place f2, message_islocatedin_place e1
WHERE f1.type='Comment' and f2.type='Country' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.loc_id
)
select Country0.name AS countryName, count(DISTINCT neo4j2.c2id) AS commentCount
from neo4j2, r_country country0, r_comment comment0, seg1
where Comment0.length > $minCommentLength and neo4j2.countryid = Country0.id and neo4j2.c2id = Comment0.id and neo4j2.tid = seg1.tid
group by Country0.name;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS mid
FROM filter_message2 f0, message_hastag_tag e0
WHERE f0.id=e0.message_id
),
seg1 AS (
select max(Message0.creationDate) AS latestMessageDate, neo4j1.tid
from neo4j1, r_message message0
where Message0.creationDate > $messageDate and neo4j1.mid = Message0.id
group by neo4j1.tid
ORDER BY latestMessageDate DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e1.replied_message_id AS parentid, e0.message_id AS m2id, e0.tag_id AS tid
FROM filter_message2 f0, message_hastag_tag e0, filter_post2 f1, message f2, message_replyof_message e1
WHERE f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e1.replied_message_id and f2.id=e1.replied_message_id
)
select Post0.browserUsed AS parentBrowser, Post0.locationIP AS parentLocationIP, count(DISTINCT neo4j2.m2id) AS replyCount
from neo4j2, r_message message0, r_post post0, seg1
where Message0.length > $minMessageLength and neo4j2.m2id = Message0.id and neo4j2.parentid = Post0.id and neo4j2.tid = seg1.tid
group by Post0.browserUsed, Post0.locationIP;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e1.forum_id AS foid, e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, filter_forum2 f2, forum_hasmember_person e1
WHERE f0.type='University' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.forum_id
),
seg1 AS (
select * from (
select count(neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_university university0, r_forum forum0
where University0.name = $universityName and Forum0.creationDate > $forumDate and neo4j1.uid = University0.id and neo4j1.foid = Forum0.id
group by neo4j1.pid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.tag_id AS tid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select count(DISTINCT neo4j2.pid) AS qualifiedPersonCount, Tag0.name AS interestName
from neo4j2, r_tag tag0, seg1
where Tag0.name <> $excludedTagName and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name
ORDER BY qualifiedPersonCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e1.company_id AS coid
FROM organisation f0, person_studyat_organisation e0, organisation f1, person_workat_organisation e1
WHERE f0.type='University' and f1.type='Company' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e1.company_id
),
seg1 AS (
select * from (
select neo4j1.coid, count(neo4j1.pid) AS c
from neo4j1, r_company company0, r_person person0
where Person0.birthday > $birthday and Company0.name <> $excludedCompanyName and neo4j1.coid = Company0.id and neo4j1.pid = Person0.id
group by neo4j1.coid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.loc_id AS countryid, e0.org_id AS coid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
)
select count(DISTINCT neo4j2.coid) AS companyCount, Country0.name AS countryName
from neo4j2, r_country country0, seg1
where Country0.name <> $excludedCountryName and neo4j2.countryid = Country0.id and neo4j2.coid = seg1.coid
group by Country0.name
ORDER BY companyCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.loc_id AS cityid, e1.org_id AS orgid, e0.org_id AS uid
FROM organisation f0, place f1, organisation_islocatedin_place e0, organisation_islocatedin_place e1
WHERE f0.type='University' and f1.type='City' and e0.loc_id=e1.loc_id and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.orgid
from neo4j1, r_city city0, r_organisation organisation0
where Organisation0.name <> $excludedOrganisationName and City0.name = $cityName and neo4j1.cityid = City0.id and neo4j1.orgid = Organisation0.id
group by neo4j1.orgid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.company_id AS orgid
FROM filter_person1 f0, person_workat_organisation e0
WHERE f0.id=e0.person_id
)
select Person0.browserUsed AS browser, count(DISTINCT neo4j2.pid) AS workerCount
from neo4j2, r_person person0, seg1
where Person0.gender = $gender and neo4j2.pid = Person0.id and neo4j2.orgid = seg1.orgid
group by Person0.browserUsed
ORDER BY workerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.message_id AS cmtid, e0.university_id AS uid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, filter_comment2 f2, message f3, message_hascreator_person e1
WHERE f0.type='University' and f3.type='Comment' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select * from (
select count(neo4j1.cmtid) AS c, neo4j1.pid
from neo4j1, r_comment comment0, r_university university0
where University0.name <> $excludedUniversityName and Comment0.length > $minCommentLength and neo4j1.cmtid = Comment0.id and neo4j1.uid = University0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.message_id AS poid
FROM filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0
WHERE f2.type='Post' and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Post0.browserUsed AS browser, count(DISTINCT neo4j2.pid) AS likerCount
from neo4j2, r_post post0, seg1
where Post0.creationDate > $likedPostSince and neo4j2.poid = Post0.id and neo4j2.pid = seg1.pid
group by Post0.browserUsed
ORDER BY likerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.forum_id AS fid, e0.tag_id AS tid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_forum2 f2, forum_containerof_message e1
WHERE f1.type='Post' and e0.message_id=e1.post_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.forum_id
),
seg1 AS (
select neo4j1.fid, count(neo4j1.poid) AS c
from neo4j1, r_post post0, r_tag tag0
where Tag0.name = $tag and Post0.creationDate > $postDate and neo4j1.poid = Post0.id and neo4j1.tid = Tag0.id
group by neo4j1.fid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.person_id AS mdid, e0.forum_id AS fid, e1.company_id AS coid, e2.loc_id AS countryid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0, organisation f2, person_workat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE f2.type='Company' and f3.type='Country' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.company_id and f3.id=e2.loc_id
)
select Person0.browserUsed AS moderatorBrowser, Country0.name AS countryName, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_company company0, r_person person0, r_country country0, seg1
where Person0.gender = $gender and Company0.name <> $companyName and neo4j2.coid = Company0.id and neo4j2.mdid = Person0.id and neo4j2.countryid = Country0.id and neo4j2.fid = seg1.fid
group by Person0.browserUsed, Country0.name;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e1.message_id AS cmid, e0.person_id AS pid
FROM filter_person1 f0, person_hasinterest_tag e0, filter_comment2 f1, message f2, message_hascreator_person e1
WHERE f2.type='Comment' and e0.person_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e1.message_id
),
seg1 AS (
select count(neo4j1.cmid) AS c, neo4j1.pid
from neo4j1, r_tag tag0, r_comment comment0
where Tag0.name = $tag and Comment0.length > $minLength and neo4j1.tid = Tag0.id and neo4j1.cmid = Comment0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.friend_id AS frid, e2.loc_id AS coid, e0.person_id AS pid, e1.message_id AS poid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0, filter_post2 f2, message f3, person_likes_message e1, place f4, message_islocatedin_place e2
WHERE f3.type='Post' and f4.type='Country' and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.loc_id
)
select Person0.browserUsed AS friendBrowser, Country0.name AS countryName, count(DISTINCT neo4j2.pid) AS personCount
from neo4j2, r_post post0, r_country country0, r_person person0, seg1
where Person0.gender = $gender and Post0.creationDate > $likedPostDate and neo4j2.poid = Post0.id and neo4j2.coid = Country0.id and neo4j2.frid = Person0.id and neo4j2.pid = seg1.pid
group by Person0.browserUsed, Country0.name;
WITH neo4j1 AS (
SELECT e1.tag_id AS rtid, e0.tagclass_id AS tcid, e0.tag_id AS tid
FROM tag_hastype_tagclass e0, tag_hastype_tagclass e1
WHERE e0.tagclass_id=e1.tagclass_id
),
seg1 AS (
select count(neo4j1.tcid) AS c, neo4j1.rtid
from neo4j1, r_tag tag0, r_tag tag1
where Tag0.name = $tag and Tag1.name <> $excludedTag and neo4j1.tid = Tag0.id and neo4j1.rtid = Tag1.id
group by neo4j1.rtid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e1.person_id AS creatorid, e0.message_id AS mid, e2.loc_id AS cityid, e0.tag_id AS rtid
FROM filter_message2 f0, message_hastag_tag e0, filter_person1 f1, message_hascreator_person e1, place f2, person_islocatedin_place e2
WHERE f2.type='City' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e1.person_id and f2.id=e2.loc_id
)
select City0.name AS cityName, Person0.browserUsed AS creatorBrowser, count(DISTINCT neo4j2.mid) AS messageCount
from neo4j2, r_message message0, r_city city0, r_person person0, seg1
where Person0.gender = $gender and Message0.length > $minMessageLength and neo4j2.mid = Message0.id and neo4j2.cityid = City0.id and neo4j2.creatorid = Person0.id and neo4j2.rtid = seg1.rtid
group by City0.name, Person0.browserUsed;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.forum_id AS foid, e1.person_id AS pid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_person1 f1, forum_hasmember_person e1
WHERE e0.forum_id=e1.forum_id and f0.id=e0.forum_id and f1.id=e1.person_id
),
seg1 AS (
select count(neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_tag tag0, r_forum forum0
where Tag0.name = $tag and Forum0.creationDate > $forumDate and neo4j1.tid = Tag0.id and neo4j1.foid = Forum0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e1.loc_id AS cityid, e0.person_id AS pid, e2.reg_id AS countryid, e0.university_id AS uid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE f1.type='University' and f2.type='City' and f3.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.reg_id
)
select count(DISTINCT neo4j2.pid) AS memberCount, Country0.name AS countryName, University0.name AS universityName
from neo4j2, r_city city0, r_university university0, r_country country0, seg1
where University0.name <> $universityName and City0.name <> $cityName and neo4j2.cityid = City0.id and neo4j2.uid = University0.id and neo4j2.countryid = Country0.id and neo4j2.pid = seg1.pid
group by Country0.name, University0.name;
WITH neo4j1 AS (
SELECT e0.message_id AS cmid, e0.tag_id AS tid, e1.replied_message_id AS poid
FROM filter_comment2 f0, message f1, message_hastag_tag e0, filter_post2 f2, message f3, message_replyof_message e1
WHERE f1.type='Comment' and f3.type='Post' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.replied_message_id and f3.id=e1.replied_message_id
),
seg1 AS (
select neo4j1.poid, count(neo4j1.cmid) AS c
from neo4j1, r_comment comment0, r_tag tag0
where Tag0.name = $tag and Comment0.creationDate > $commentDate and neo4j1.cmid = Comment0.id and neo4j1.tid = Tag0.id
group by neo4j1.poid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.person_id AS authorid, e2.loc_id AS plid, e1.company_id AS orgid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, person_workat_organisation e1, organisation_islocatedin_place e2
WHERE f1.type='Post' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
)
select Place0.name AS placeName, count(DISTINCT neo4j2.poid) AS postCount, Person0.gender AS authorGender
from neo4j2, r_person person0, r_organisation organisation0, r_place place0, seg1
where Organisation0.name <> $organisationName and Person0.browserUsed = $browser and neo4j2.authorid = Person0.id and neo4j2.orgid = Organisation0.id and neo4j2.plid = Place0.id and neo4j2.poid = seg1.poid
group by Place0.name, Person0.gender;
WITH neo4j1 AS (
SELECT e1.tagclass_id AS tcid, e0.tag_id AS tid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tid, count(neo4j1.poid) AS c
from neo4j1, r_post post0, r_tagclass tagclass0
where TagClass0.name = $tagClass and Post0.creationDate > $postDate and neo4j1.poid = Post0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.tid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.tag_id AS tid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Person0.lastName, Person0.firstName, Person0.browserUsed, Tag0.name
from neo4j2, r_person person0, r_tag tag0, seg1
where Person0.gender = $gender and neo4j2.personid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e0.person_id AS authorid, e2.reg_id AS countryid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, place f3, person_islocatedin_place e1, place f4, place_ispartof_place e2
WHERE f1.type='Post' and f3.type='City' and f4.type='Country' and e0.person_id=e1.person_id and e1.loc_id=e2.subreg_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.loc_id and f4.id=e2.reg_id
),
seg1 AS (
select neo4j1.authorid, count(neo4j1.poid) AS c
from neo4j1, r_country country0, r_post post0
where Post0.length > $minLength and Country0.name = $country and neo4j1.countryid = Country0.id and neo4j1.poid = Post0.id
group by neo4j1.authorid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS authorid, e0.company_id AS companyid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0
WHERE f1.type='Company' and f0.id=e0.person_id and f1.id=e0.company_id
)
select Person0.firstName, Person0.lastName, Person0.browserUsed, Company0.name
from neo4j2, r_person person0, r_company company0, seg1
where Company0.name = $companyName and neo4j2.authorid = Person0.id and neo4j2.companyid = Company0.id and neo4j2.authorid = seg1.authorid;
WITH neo4j1 AS (
SELECT e2.tag_id AS tagid, e0.forum_id AS forumid, e0.post_id AS poid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0, filter_person1 f3, forum_hasmember_person e1, person_hasinterest_tag e2
WHERE f1.type='Post' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id and f3.id=e1.person_id
),
seg1 AS (
select neo4j1.forumid, count(neo4j1.poid) AS c
from neo4j1, r_tag tag0, r_forum forum0
where Tag0.name = $interestTag and Forum0.creationDate < $forumBefore and neo4j1.tagid = Tag0.id and neo4j1.forumid = Forum0.id
group by neo4j1.forumid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.forum_id AS forumid, e0.person_id AS moderatorid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0
WHERE f0.id=e0.forum_id and f1.id=e0.person_id
)
select Person0.lastName, Forum0.title, Person0.firstName, Forum0.creationDate
from neo4j2, r_person person0, r_forum forum0, seg1
where Person0.browserUsed = $browser and neo4j2.moderatorid = Person0.id and neo4j2.forumid = Forum0.id and neo4j2.forumid = seg1.forumid;
WITH neo4j1 AS (
SELECT e1.subreg_id AS cityid, e0.loc_id AS countryid, e0.message_id AS poid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0, place f3, place_ispartof_place e1, filter_person1 f4, person_islocatedin_place e2
WHERE f1.type='Post' and f2.type='Country' and f3.type='City' and e0.loc_id=e1.reg_id and e1.subreg_id=e2.loc_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id and f3.id=e1.subreg_id and f4.id=e2.person_id
),
seg1 AS (
select neo4j1.cityid, count(neo4j1.poid) AS c
from neo4j1, r_post post0, r_country country0
where Post0.creationDate > $postAfter and Country0.name = $country and neo4j1.poid = Post0.id and neo4j1.countryid = Country0.id
group by neo4j1.cityid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.loc_id AS cityid, e0.org_id AS orgid
FROM place f0, organisation_islocatedin_place e0
WHERE f0.type='City' and f0.id=e0.loc_id
)
select City0.name, Organisation0.name
from neo4j2, r_city city0, r_organisation organisation0, seg1
where Organisation0.name = $organisationName and neo4j2.cityid = City0.id and neo4j2.orgid = Organisation0.id and neo4j2.cityid = seg1.cityid;
WITH neo4j1 AS (
SELECT e0.message_id AS commentid, e1.person_id AS personid, e2.university_id AS univid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, organisation f5, person_studyat_organisation e2
WHERE f1.type='Post' and f3.type='Comment' and f5.type='University' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id and f4.id=e1.person_id and f5.id=e2.university_id
),
seg1 AS (
select count(neo4j1.commentid) AS c, neo4j1.personid
from neo4j1, r_university university0, r_comment comment0
where Comment0.length > $minCommentLength and University0.name = $university and neo4j1.univid = University0.id and neo4j1.commentid = Comment0.id
group by neo4j1.personid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.message_id AS likedid
FROM filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0
WHERE f2.type='Post' and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Post0.content, Person0.lastName, Person0.firstName, Post0.length
from neo4j2, r_person person0, r_post post0, seg1
where Post0.creationDate > $likedAfter and neo4j2.personid = Person0.id and neo4j2.likedid = Post0.id and neo4j2.personid = seg1.personid;
WITH neo4j1 AS (
SELECT e1.person_id AS pid, e0.loc_id AS ciid, e0.org_id AS uid
FROM place f0, organisation f1, organisation_islocatedin_place e0, filter_person1 f2, person_studyat_organisation e1
WHERE f0.type='City' and f1.type='University' and e0.org_id=e1.university_id and f0.id=e0.loc_id and f1.id=e0.org_id and f2.id=e1.person_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.uid
from neo4j1, r_person person0, r_city city0
where City0.name = $cityName and Person0.gender = $gender and neo4j1.pid = Person0.id and neo4j1.ciid = City0.id
group by neo4j1.uid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.person_id AS alid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
)
select Person0.browserUsed AS browser, count(neo4j2.alid) AS alumniCount
from neo4j2, r_person person0, seg1
where Person0.birthday > $birthday and neo4j2.alid = Person0.id and neo4j2.uid = seg1.uid
group by Person0.browserUsed
ORDER BY alumniCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.reg_id AS coid, e1.org_id AS compid, e0.subreg_id AS ciid
FROM place f0, place f1, place_ispartof_place e0, organisation f2, organisation_islocatedin_place e1
WHERE f0.type='City' and f1.type='Country' and f2.type='Company' and e0.reg_id=e1.loc_id and f0.id=e0.subreg_id and f1.id=e0.reg_id and f2.id=e1.org_id
),
seg1 AS (
select neo4j1.coid, count(neo4j1.compid) AS c
from neo4j1, r_city city0, r_company company0
where Company0.name <> $excludedCompany and City0.name <> $excludedCity and neo4j1.ciid = City0.id and neo4j1.compid = Company0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 22
),
neo4j2 AS (
SELECT e0.message_id AS poid, e0.loc_id AS coid
FROM place f0, filter_post2 f1, message f2, message_islocatedin_place e0
WHERE f0.type='Country' and f2.type='Post' and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Post0.browserUsed AS browser, count(neo4j2.poid) AS postCount
from neo4j2, r_post post0, seg1
where Post0.length > $postLength and neo4j2.poid = Post0.id and neo4j2.coid = seg1.coid
group by Post0.browserUsed
ORDER BY postCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.message_id AS poid, e0.loc_id AS ciid, e0.person_id AS pid
FROM place f0, filter_person1 f1, person_islocatedin_place e0, filter_post2 f2, message f3, message_hascreator_person e1
WHERE f0.type='City' and f3.type='Post' and e0.person_id=e1.person_id and f0.id=e0.loc_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select count(neo4j1.poid) AS c, neo4j1.pid
from neo4j1, r_city city0, r_post post0
where City0.name = $cityName and Post0.creationDate > $postSince and neo4j1.ciid = City0.id and neo4j1.poid = Post0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e0.person_id AS pid
FROM filter_person1 f0, filter_comment2 f1, message f2, person_likes_message e0
WHERE f2.type='Comment' and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select count(neo4j2.cmid) AS likedCommentCount, Comment0.browserUsed AS browser
from neo4j2, r_comment comment0, seg1
where Comment0.length > $commentLength and neo4j2.cmid = Comment0.id and neo4j2.pid = seg1.pid
group by Comment0.browserUsed
ORDER BY likedCommentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.forum_id AS foid, e0.tag_id AS tid, e1.person_id AS pid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_person1 f2, message_hascreator_person e1, filter_forum2 f3, forum_hasmember_person e2
WHERE f1.type='Post' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.forum_id
),
seg1 AS (
select count(neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_tag tag0, r_post post0
where Tag0.name = $tagName and Post0.creationDate > $postDate and neo4j1.tid = Tag0.id and neo4j1.poid = Post0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.loc_id AS cityid, e0.person_id AS pid, e2.org_id AS coid
FROM filter_person1 f0, place f1, person_islocatedin_place e0, place f2, place_ispartof_place e1, organisation f3, organisation_islocatedin_place e2
WHERE f1.type='City' and f2.type='Country' and f3.type='Company' and e0.loc_id=e1.subreg_id and e1.reg_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.loc_id and f2.id=e1.reg_id and f3.id=e2.org_id
)
select City0.name AS cityName, count(DISTINCT neo4j2.pid) AS creatorCount
from neo4j2, r_company company0, r_city city0, seg1
where Company0.name = $companyName and neo4j2.coid = Company0.id and neo4j2.cityid = City0.id and neo4j2.pid = seg1.pid
group by City0.name
ORDER BY creatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.forum_id AS foid, e0.tag_id AS tid, e1.message_id AS mid
FROM filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, message_hascreator_person e1, filter_forum2 f2, forum_containerof_message e2
WHERE e0.person_id=e1.person_id and e1.message_id=e2.post_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.forum_id
),
seg1 AS (
select neo4j1.foid, count(neo4j1.mid) AS c
from neo4j1, r_tag tag0, r_message message0
where Tag0.name = $tagName and Message0.length > $minLength and neo4j1.tid = Tag0.id and neo4j1.mid = Message0.id
group by neo4j1.foid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e1.message_id AS cmid, e0.forum_id AS foid, e2.loc_id AS coid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, filter_comment2 f2, message f3, person_likes_message e1, place f4, message_islocatedin_place e2
WHERE f3.type='Comment' and f4.type='Country' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.loc_id
)
select count(DISTINCT neo4j2.foid) AS forumCount, Country0.name AS countryName
from neo4j2, r_comment comment0, r_country country0, seg1
where Comment0.creationDate > $commentDate and neo4j2.cmid = Comment0.id and neo4j2.coid = Country0.id and neo4j2.foid = seg1.foid
group by Country0.name
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.person_id AS authorid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, message_hastag_tag e0, filter_post2 f2, message f3, message_replyof_message e1, filter_person1 f4, message_hascreator_person e2
WHERE f1.type='Comment' and f3.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.replied_message_id and f3.id=e1.replied_message_id and f4.id=e2.person_id
),
seg1 AS (
select count(neo4j1.cmid) AS c, neo4j1.authorid
from neo4j1, r_comment comment0, r_tag tag0
where Tag0.name = $tagName and Comment0.length > $minCommentLength and neo4j1.cmid = Comment0.id and neo4j1.tid = Tag0.id
group by neo4j1.authorid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS authorid, e0.university_id AS uid, e2.reg_id AS coid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE f1.type='University' and f2.type='City' and f3.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.reg_id
)
select University0.name AS universityName, count(DISTINCT neo4j2.authorid) AS authorCount
from neo4j2, r_country country0, r_university university0, seg1
where Country0.name = $countryName and neo4j2.coid = Country0.id and neo4j2.uid = University0.id and neo4j2.authorid = seg1.authorid
group by University0.name
ORDER BY authorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.forum_id AS foid, e1.person_id AS modid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_person1 f1, forum_hasmoderator_person e1, place f2, person_islocatedin_place e2
WHERE f2.type='City' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.forum_id and f1.id=e1.person_id and f2.id=e2.loc_id
),
seg1 AS (
select count(neo4j1.foid) AS c, neo4j1.modid
from neo4j1, r_tag tag0, r_forum forum0
where Tag0.name = $tagName and Forum0.creationDate > $forumDate and neo4j1.tid = Tag0.id and neo4j1.foid = Forum0.id
group by neo4j1.modid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.person_id AS modid, e2.tag_id AS replytagid, e0.message_id AS cmid
FROM filter_person1 f0, filter_comment2 f1, message f2, message_hascreator_person e0, filter_message2 f3, message_replyof_message e1, message_hastag_tag e2
WHERE f2.type='Comment' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.replied_message_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.modid) AS moderatorCount
from neo4j2, r_comment comment0, r_tag tag0, seg1
where Comment0.creationDate > $commentDate and neo4j2.cmid = Comment0.id and neo4j2.replyTagid = Tag0.id and neo4j2.modid = seg1.modid
group by Tag0.name
ORDER BY moderatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.company_id AS cid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select max(Person0.birthday) AS birthdayRank, neo4j1.pid
from neo4j1, r_person person0, r_company company0
where Company0.name <> $excludedCompany and neo4j1.pid = Person0.id and neo4j1.cid = Company0.id
group by neo4j1.pid
ORDER BY birthdayRank DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.friend_id AS fid, e0.person_id AS pid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0
WHERE f0.id=e0.person_id and f1.id=e0.friend_id
)
select Person0.browserUsed AS browser, count(DISTINCT neo4j2.pid) AS employeeCount
from neo4j2, r_person person0, seg1
where Person0.gender = $gender and neo4j2.fid = Person0.id and neo4j2.pid = seg1.pid
group by Person0.browserUsed
ORDER BY employeeCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.company_id AS cid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select min(Person0.birthday) AS birthdayRank, neo4j1.pid
from neo4j1, r_company company0, r_person person0
where Company0.name <> $excludedCompany and neo4j1.cid = Company0.id and neo4j1.pid = Person0.id
group by neo4j1.pid
ORDER BY birthdayRank ASC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.university_id AS uid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0
WHERE f1.type='University' and f0.id=e0.person_id and f1.id=e0.university_id
)
select University0.name AS university, count(DISTINCT neo4j2.pid) AS employeeCount
from neo4j2, r_university university0, seg1
where University0.name <> $excludedUniversity and neo4j2.uid = University0.id and neo4j2.pid = seg1.pid
group by University0.name
ORDER BY employeeCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.company_id AS cid, e0.person_id AS pid
FROM organisation f0, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id
),
seg1 AS (
select max(Person0.birthday) AS birthdayRank, neo4j1.pid
from neo4j1, r_company company0, r_person person0
where Company0.name <> $excludedCompany and neo4j1.cid = Company0.id and neo4j1.pid = Person0.id
group by neo4j1.pid
ORDER BY birthdayRank DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.loc_id AS ciid
FROM place f0, person_islocatedin_place e0
WHERE f0.type='City' and f0.id=e0.loc_id
)
select City0.name AS city, count(DISTINCT neo4j2.pid) AS employeeCount
from neo4j2, r_city city0, seg1
where City0.name <> $excludedCity and neo4j2.ciid = City0.id and neo4j2.pid = seg1.pid
group by City0.name
ORDER BY employeeCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.message_id AS cmid, e0.person_id AS pid
FROM filter_comment2 f0, message f1, filter_person1 f2, message_hascreator_person e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select * from (
select count(neo4j1.cmid) AS c, neo4j1.pid
from neo4j1, r_comment comment0
where Comment0.length > $minCommentLength and neo4j1.cmid = Comment0.id
group by neo4j1.pid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.forum_id AS fid, e1.tag_id AS tid, e0.person_id AS pid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmember_person e0, forum_hastag_tag e1
WHERE e0.forum_id=e1.forum_id and f0.id=e0.person_id and f1.id=e0.forum_id
)
select Person0.firstName AS firstName, Forum0.title AS forumTitle, Tag0.name AS tagName, Person0.lastName AS lastName
from neo4j2, r_tag tag0, r_forum forum0, r_person person0, seg1
where Forum0.creationDate > $forumDate and Tag0.name = $tagName and neo4j2.tid = Tag0.id and neo4j2.fid = Forum0.id and neo4j2.pid = Person0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.replied_message_id AS poid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0
WHERE f1.type='Comment' and f3.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id
),
seg1 AS (
select * from (
select neo4j1.poid, count(neo4j1.cmid) AS c
from neo4j1, r_comment comment0
where Comment0.creationDate > $commentDate and neo4j1.cmid = Comment0.id
group by neo4j1.poid
) b1
where c > 20
),
neo4j2 AS (
SELECT e1.reg_id AS coid, e0.loc_id AS plid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_islocatedin_place e0, place f2, place_ispartof_place e1
WHERE f1.type='Post' and f2.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.reg_id
)
select Post0.content AS postContent, Place0.name AS placeName, Country0.name AS countryName
from neo4j2, r_post post0, r_country country0, r_place place0, seg1
where Country0.name = $countryName and Post0.creationDate > $postDate and neo4j2.poid = Post0.id and neo4j2.coid = Country0.id and neo4j2.plid = Place0.id and neo4j2.poid = seg1.poid;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS cmid
FROM filter_comment1 f0, message f1, message_hastag_tag e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select neo4j1.tid, count(neo4j1.cmid) AS c
from neo4j1, r_comment comment0
where Comment0.length < $maxCommentLength and neo4j1.cmid = Comment0.id
group by neo4j1.tid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tid, e1.tag_id AS parentid
FROM tag_hastype_tagclass e0, tagclass_issubclassof_tagclass e1
WHERE e0.tagclass_id=e1.subtag_id
)
select Tag0.name AS tagName, TagClass1.name AS parentClassName, TagClass0.name AS className
from neo4j2, r_tagclass tagclass0, r_tagclass tagclass1, r_tag tag0, seg1
where TagClass1.name <> $excludedParentClass and TagClass0.name = $tagClassName and neo4j2.tcid = TagClass0.id and neo4j2.parentid = TagClass1.id and neo4j2.tid = Tag0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e0.loc_id AS plid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, message_islocatedin_place e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select neo4j1.plid, count(neo4j1.cmid) AS c
from neo4j1, r_comment comment0
where Comment0.creationDate < $beforeDate and neo4j1.cmid = Comment0.id
group by neo4j1.plid
) b1
where c > 20
),
neo4j2 AS (
SELECT e1.person_id AS workerid, e0.loc_id AS plid, e0.org_id AS compid
FROM organisation f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1
WHERE f0.type='Company' and e0.org_id=e1.company_id and f0.id=e0.org_id and f1.id=e1.person_id
)
select Company0.name AS companyName, Person0.lastName AS lastName, Place0.name AS placeName, Person0.firstName AS firstName
from neo4j2, r_place place0, r_person person0, r_company company0, seg1
where Person0.browserUsed = $browser and Company0.name <> $excludedCompanyName and neo4j2.plid = Place0.id and neo4j2.workerid = Person0.id and neo4j2.compid = Company0.id and neo4j2.plid = seg1.plid;
WITH neo4j1 AS (
SELECT e0.message_id AS cmid, e0.person_id AS pid
FROM filter_comment2 f0, message f1, filter_person1 f2, person_likes_message e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select * from (
select count(neo4j1.cmid) AS c, neo4j1.pid
from neo4j1, r_comment comment0
where Comment0.length >= $likedCommentLength and neo4j1.cmid = Comment0.id
group by neo4j1.pid
) b1
where c > 5
),
neo4j2 AS (
SELECT e1.loc_id AS cityid, e0.person_id AS pid, e0.university_id AS uid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE f1.type='University' and f2.type='City' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id
)
select City0.name AS cityName, Person0.email AS email, University0.name AS universityName
from neo4j2, r_university university0, r_city city0, r_person person0, seg1
where University0.name <> $excludedUniversityName and City0.name = $cityName and neo4j2.uid = University0.id and neo4j2.cityid = City0.id and neo4j2.pid = Person0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.loc_id AS plid, e0.org_id AS coid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='Company' and f0.id=e0.org_id
),
seg1 AS (
select neo4j1.plid, count(neo4j1.coid) AS c
from neo4j1, r_company company0
where Company0.name <> $excludedCompanyName and neo4j1.coid = Company0.id
group by neo4j1.plid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e1.message_id AS poid, e2.tag_id AS tid, e0.loc_id AS plid, e0.person_id AS pid
FROM filter_person1 f0, person_islocatedin_place e0, filter_post2 f1, message f2, message_hascreator_person e1, message_hastag_tag e2
WHERE f2.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e1.message_id
)
select Post0.content AS postContent, Tag0.name AS tagName, Place0.name AS placeName, Person0.firstName AS firstName, Person0.lastName AS lastName
from neo4j2, r_post post0, r_person person0, r_tag tag0, r_place place0, seg1
where Person0.gender = $gender and Post0.creationDate > $postDate and neo4j2.poid = Post0.id and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.plid = Place0.id and neo4j2.plid = seg1.plid;
WITH neo4j1 AS (
SELECT e0.loc_id AS cnid, e0.org_id AS coid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select neo4j1.cnid, count(neo4j1.coid) AS c
from neo4j1, r_company company0
where Company0.name <> $excludedCompanyName and neo4j1.coid = Company0.id
group by neo4j1.cnid
ORDER BY c DESC, 1, 2
LIMIT 22
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e2.tag_id AS tid, e1.person_id AS pid, e0.loc_id AS cnid
FROM place f0, filter_comment2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, person_hasinterest_tag e2
WHERE f0.type='Country' and f2.type='Comment' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select Country0.name AS countryName, Comment0.content AS commentContent, Tag0.name AS interestName, Person0.firstName AS firstName, Person0.lastName AS lastName
from neo4j2, r_country country0, r_person person0, r_tag tag0, r_comment comment0, seg1
where Person0.browserUsed = $browserUsed and Comment0.length > $minCommentLength and neo4j2.cnid = Country0.id and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.cmid = Comment0.id and neo4j2.cnid = seg1.cnid;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.company_id AS coid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select count(neo4j1.coid) AS c, neo4j1.pid
from neo4j1, r_person person0
where Person0.birthday > $birthday and neo4j1.pid = Person0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e1.post_id AS mid, e0.forum_id AS foid, e2.tag_id AS tid, e0.person_id AS pid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmember_person e0, filter_message2 f2, forum_containerof_message e1, message_hastag_tag e2
WHERE e0.forum_id=e1.forum_id and e1.post_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.forum_id and f2.id=e1.post_id
)
select Forum0.title AS forumTitle, Message0.content AS messageContent, Tag0.name AS tagName, Person0.firstName AS firstName, Person0.lastName AS lastName
from neo4j2, r_forum forum0, r_person person0, r_tag tag0, r_message message0, seg1
where Message0.length > $minMessageLength and Forum0.creationDate > $forumDate and neo4j2.foid = Forum0.id and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.mid = Message0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.company_id AS coid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select neo4j1.coid, count(neo4j1.pid) AS c
from neo4j1, r_person person0
where Person0.gender = $employeeGender and neo4j1.pid = Person0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e1.message_id AS mid, e2.person_id AS lpid, e0.org_id AS coid, e0.loc_id AS plid
FROM organisation f0, organisation_islocatedin_place e0, filter_message2 f1, message_islocatedin_place e1, filter_person1 f2, person_likes_message e2
WHERE f0.type='Company' and e0.loc_id=e1.loc_id and e1.message_id=e2.message_id and f0.id=e0.org_id and f1.id=e1.message_id and f2.id=e2.person_id
)
select Person0.lastName AS likerLastName, Company0.name AS companyName, Person0.firstName AS likerFirstName, Message0.content AS messageContent, Place0.name AS placeName
from neo4j2, r_message message0, r_person person0, r_company company0, r_place place0, seg1
where Person0.locationIP = $locationIP and Message0.creationDate > $messageDate and neo4j2.mid = Message0.id and neo4j2.lpid = Person0.id and neo4j2.coid = Company0.id and neo4j2.plid = Place0.id and neo4j2.coid = seg1.coid;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e0.forum_id AS foid, e0.person_id AS pid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1
WHERE e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id
),
seg1 AS (
select count(neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_tag tag0, r_forum forum0
where Forum0.creationDate > $forumDate and Tag0.name = $tagName and neo4j1.tid = Tag0.id and neo4j1.foid = Forum0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e2.reg_id AS coid, e0.person_id AS pid, e0.university_id AS uid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE f1.type='University' and f2.type='City' and f3.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.reg_id
)
select count(neo4j2.pid) AS personCount, University0.name AS universityName, Country0.name AS countryName
from neo4j2, r_university university0, r_country country0, seg1
where Country0.name = $countryName and University0.name <> $excludedUniversity and neo4j2.uid = University0.id and neo4j2.coid = Country0.id and neo4j2.pid = seg1.pid
group by University0.name, Country0.name;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e0.post_id AS poid
FROM filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, message_hastag_tag e1
WHERE f2.type='Post' and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id
),
seg1 AS (
select neo4j1.tid, count(neo4j1.poid) AS c
from neo4j1, r_post post0, r_tag tag0
where Tag0.name <> $excludedTag and Post0.creationDate > $postDate and neo4j1.poid = Post0.id and neo4j1.tid = Tag0.id
group by neo4j1.tid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e1.tag_id AS superid, e0.tag_id AS tid, e2.tag_id AS rootid
FROM tag_hastype_tagclass e0, tagclass_issubclassof_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.tagclass_id=e1.subtag_id and e1.tag_id=e2.subtag_id
)
select TagClass0.name AS superClassName, count(neo4j2.tid) AS tagCount, TagClass1.name AS rootClassName
from neo4j2, r_tagclass tagclass0, r_tagclass tagclass1, seg1
where TagClass0.name = $superClassName and neo4j2.superid = TagClass0.id and neo4j2.rootid = TagClass1.id and neo4j2.tid = seg1.tid
group by TagClass0.name, TagClass1.name;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e1.loc_id AS cityid, e0.person_id AS modid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0, place f2, person_islocatedin_place e1
WHERE f2.type='City' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.loc_id
),
seg1 AS (
select count(neo4j1.foid) AS c, neo4j1.cityid
from neo4j1, r_person person0
where Person0.gender = $moderatorGender and neo4j1.modid = Person0.id
group by neo4j1.cityid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e2.person_id AS employeeid, e1.org_id AS orgid, e0.subreg_id AS cityid
FROM place f0, place f1, place_ispartof_place e0, organisation_islocatedin_place e1, filter_person1 f2, person_workat_organisation e2
WHERE f0.type='City' and f1.type='Country' and e0.reg_id=e1.loc_id and e1.org_id=e2.company_id and f0.id=e0.subreg_id and f1.id=e0.reg_id and f2.id=e2.person_id
)
select count(neo4j2.employeeid) AS employeeCount, Person0.gender AS employeeGender, Organisation0.name AS organisationName
from neo4j2, r_organisation organisation0, r_person person0, seg1
where Person0.browserUsed = $browser and neo4j2.orgid = Organisation0.id and neo4j2.employeeid = Person0.id and neo4j2.cityid = seg1.cityid
group by Person0.gender, Organisation0.name;
WITH neo4j1 AS (
SELECT e1.person_id AS pid, e0.post_id AS mid
FROM filter_forum2 f0, filter_message2 f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1
WHERE e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e1.person_id
),
seg1 AS (
select count(neo4j1.mid) AS c, neo4j1.pid
from neo4j1, r_message message0
where Message0.length > $minLength and neo4j1.mid = Message0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e2.tag_id AS tagid, e1.replied_message_id AS poid, e0.person_id AS pid
FROM filter_person1 f0, filter_comment2 f1, message f2, person_likes_message e0, filter_post2 f3, message f4, message_replyof_message e1, message_hastag_tag e2
WHERE f2.type='Comment' and f4.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.replied_message_id and f4.id=e1.replied_message_id
)
select Post0.browserUsed AS postBrowser, count(neo4j2.pid) AS likerCount, Tag0.name AS tagName
from neo4j2, r_tag tag0, r_post post0, r_comment comment0, seg1
where Tag0.name = $likedTag and Comment0.creationDate > $commentDate and neo4j2.tagid = Tag0.id and neo4j2.poid = Post0.id and neo4j2.cmid = Comment0.id and neo4j2.pid = seg1.pid
group by Post0.browserUsed, Tag0.name;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e1.tagclass_id AS tcid
FROM filter_forum2 f0, forum_hastag_tag e0, tag_hastype_tagclass e1
WHERE e0.tag_id=e1.tag_id and f0.id=e0.forum_id
),
seg1 AS (
select count(neo4j1.foid) AS c, neo4j1.tcid
from neo4j1, r_forum forum0, r_tagclass tagclass0
where TagClass0.name <> $excludedClass and Forum0.creationDate > $forumStartDate and neo4j1.foid = Forum0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.tcid
ORDER BY c DESC, 1, 2
LIMIT 4
),
neo4j2 AS (
SELECT e1.message_id AS msgid, e0.tag_id AS tagid, e2.loc_id AS plid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1, message_islocatedin_place e2
WHERE e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id
)
select Place0.name AS placeName, count(neo4j2.msgid) AS messageCount, Tag0.name AS tagName
from neo4j2, r_message message0, r_place place0, r_tag tag0, seg1
where Place0.name = $placeName and Message0.length >= $messageLength and neo4j2.msgid = Message0.id and neo4j2.plid = Place0.id and neo4j2.tagid = Tag0.id and neo4j2.tcid = seg1.tcid
group by Place0.name, Tag0.name;
WITH neo4j1 AS (
SELECT e0.message_id AS pid, e0.person_id AS creatorid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select neo4j1.creatorid, count(neo4j1.pid) AS c
from neo4j1, r_post post0
where Post0.creationDate > $postDate and neo4j1.pid = Post0.id
group by neo4j1.creatorid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.person_id AS creatorid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Person0.gender AS gender, count(DISTINCT neo4j2.creatorid) AS creatorCount
from neo4j2, r_person person0, r_tag tag0, seg1
where Tag0.name = $interestName and neo4j2.creatorid = Person0.id and neo4j2.tagid = Tag0.id and neo4j2.creatorid = seg1.creatorid
group by Person0.gender;
WITH neo4j1 AS (
SELECT e0.tag_id AS tagid, e0.message_id AS pid
FROM filter_post1 f0, message f1, message_hastag_tag e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tagid, count(neo4j1.pid) AS c
from neo4j1, r_post post0
where Post0.length > $minPostLength and neo4j1.pid = Post0.id
group by neo4j1.tagid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
)
select TagClass0.name AS tagClassName, count(neo4j2.tagid) AS tagCount
from neo4j2, r_tagclass tagclass0, seg1
where TagClass0.name <> $excludedTagClassName and neo4j2.tcid = TagClass0.id and neo4j2.tagid = seg1.tagid
group by TagClass0.name;
WITH neo4j1 AS (
SELECT e0.message_id AS pid, e0.loc_id AS countryid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0
WHERE f1.type='Post' and f2.type='Country' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.countryid
from neo4j1, r_post post0
where Post0.browserUsed = $browserUsed and neo4j1.pid = Post0.id
group by neo4j1.countryid
ORDER BY c DESC, 1, 2
LIMIT 56
),
neo4j2 AS (
SELECT e0.org_id AS companyid, e0.loc_id AS countryid
FROM place f0, organisation f1, organisation_islocatedin_place e0
WHERE f0.type='Country' and f1.type='Company' and f0.id=e0.loc_id and f1.id=e0.org_id
)
select Country0.name AS countryName, count(neo4j2.companyid) AS companyCount
from neo4j2, r_country country0, r_company company0, seg1
where Company0.name <> $excludedCompanyName and neo4j2.countryid = Country0.id and neo4j2.companyid = Company0.id and neo4j2.countryid = seg1.countryid
group by Country0.name;
WITH neo4j1 AS (
SELECT e0.post_id AS pid, e0.forum_id AS forumid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0
WHERE f1.type='Post' and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.forumid
from neo4j1, r_forum forum0
where Forum0.creationDate > $forumDate and neo4j1.forumid = Forum0.id
group by neo4j1.forumid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.forum_id AS forumid, e0.person_id AS memberid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0
WHERE f0.id=e0.forum_id and f1.id=e0.person_id
)
select Person0.browserUsed AS browserUsed, count(neo4j2.memberid) AS memberCount, Forum0.title AS forumTitle
from neo4j2, r_person person0, r_forum forum0, seg1
where Person0.birthday < $birthday and neo4j2.memberid = Person0.id and neo4j2.forumid = Forum0.id and neo4j2.forumid = seg1.forumid
group by Person0.browserUsed, Forum0.title;
WITH neo4j1 AS (
SELECT e0.replied_message_id AS pid, e0.message_id AS commentid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0
WHERE f1.type='Post' and f3.type='Comment' and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id
),
seg1 AS (
select count(neo4j1.commentid) AS c, neo4j1.pid
from neo4j1, r_comment comment0
where Comment0.length > $minCommentLength and neo4j1.commentid = Comment0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.message_id AS pid, e0.person_id AS likerid
FROM filter_post2 f0, message f1, filter_person1 f2, person_likes_message e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
)
select Person0.browserUsed AS likerBrowserUsed, count(neo4j2.likerid) AS likeCount, Post0.browserUsed AS postBrowserUsed
from neo4j2, r_post post0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.pid = Post0.id and neo4j2.likerid = Person0.id and neo4j2.pid = seg1.pid
group by Person0.browserUsed, Post0.browserUsed;
WITH neo4j1 AS (
SELECT e0.person_id AS sid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select neo4j1.uid, min(Person0.birthday) AS earliestStudentBirthday
from neo4j1, r_person person0
where Person0.birthday < $olderThanBirthday and neo4j1.sid = Person0.id
group by neo4j1.uid
ORDER BY earliestStudentBirthday ASC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e1.company_id AS coid, e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, organisation f2, person_workat_organisation e1
WHERE f0.type='University' and f2.type='Company' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.company_id
)
select count(DISTINCT neo4j2.pid) AS employeeStudentCount, University0.name AS universityName, Company0.name AS companyName
from neo4j2, r_university university0, r_company company0, r_person person0, seg1
where Company0.name <> $excludedCompany and Person0.browserUsed = $browser and neo4j2.uid = University0.id and neo4j2.coid = Company0.id and neo4j2.pid = Person0.id and neo4j2.uid = seg1.uid
group by University0.name, Company0.name
ORDER BY employeeStudentCount DESC, 1, 2, 3
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS sid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select max(Person0.birthday) AS latestStudentBirthday, neo4j1.uid
from neo4j1, r_university university0, r_person person0
where University0.name <> $excludedUniversity and neo4j1.uid = University0.id and neo4j1.sid = Person0.id
group by neo4j1.uid
ORDER BY latestStudentBirthday DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e1.message_id AS cid, e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, filter_comment2 f2, message f3, message_hascreator_person e1
WHERE f0.type='University' and f3.type='Comment' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
)
select count(DISTINCT neo4j2.cid) AS commentCount, Comment0.browserUsed AS commentBrowser, University0.name AS universityName
from neo4j2, r_person person0, r_comment comment0, r_university university0, seg1
where Person0.gender = $creatorGender and Comment0.length > $minCommentLength and neo4j2.pid = Person0.id and neo4j2.cid = Comment0.id and neo4j2.uid = University0.id and neo4j2.uid = seg1.uid
group by Comment0.browserUsed, University0.name
ORDER BY commentCount DESC, 1, 2, 3
LIMIT 20;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS ciid
FROM place f0, organisation f1, organisation_islocatedin_place e0
WHERE f0.type='City' and f1.type='University' and f0.id=e0.loc_id and f1.id=e0.org_id
),
seg1 AS (
select * from (
select count(neo4j1.ciid) AS c, neo4j1.uid
from neo4j1, r_city city0, r_university university0
where City0.name = $city and University0.name <> $excludedUniversity and neo4j1.ciid = City0.id and neo4j1.uid = University0.id
group by neo4j1.uid
) b1
where c > 3
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
)
select Person0.gender AS gender, count(DISTINCT neo4j2.pid) AS studentCount
from neo4j2, r_person person0, seg1
where Person0.birthday > $birthday and neo4j2.pid = Person0.id and neo4j2.uid = seg1.uid
group by Person0.gender
ORDER BY studentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.subreg_id AS ciid, e0.reg_id AS coid
FROM place f0, place f1, place_ispartof_place e0
WHERE f0.type='City' and f1.type='Country' and f0.id=e0.subreg_id and f1.id=e0.reg_id
),
seg1 AS (
select * from (
select count(neo4j1.ciid) AS c, neo4j1.coid
from neo4j1, r_city city0
where City0.name <> $excludedCity and neo4j1.ciid = City0.id
group by neo4j1.coid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.message_id AS poid, e0.loc_id AS coid
FROM place f0, filter_post2 f1, message f2, message_islocatedin_place e0
WHERE f0.type='Country' and f2.type='Post' and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Country0.name AS country, count(DISTINCT neo4j2.poid) AS postCount
from neo4j2, r_country country0, r_post post0, seg1
where Post0.creationDate > $postSince and neo4j2.coid = Country0.id and neo4j2.poid = Post0.id and neo4j2.coid = seg1.coid
group by Country0.name
ORDER BY postCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.loc_id AS ciid
FROM place f0, filter_person1 f1, person_islocatedin_place e0
WHERE f0.type='City' and f0.id=e0.loc_id and f1.id=e0.person_id
),
seg1 AS (
select * from (
select count(neo4j1.ciid) AS c, neo4j1.pid
from neo4j1, r_city city0, r_person person0
where City0.name = $city and Person0.birthday > $birthday and neo4j1.ciid = City0.id and neo4j1.pid = Person0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.forum_id AS foid, e0.person_id AS pid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmember_person e0
WHERE f0.id=e0.person_id and f1.id=e0.forum_id
)
select Forum0.title AS forumTitle, count(DISTINCT neo4j2.pid) AS memberCount
from neo4j2, r_forum forum0, seg1
where Forum0.creationDate > $forumSince and neo4j2.foid = Forum0.id and neo4j2.pid = seg1.pid
group by Forum0.title
ORDER BY memberCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS authorid, e0.message_id AS poid, e2.loc_id AS coid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, organisation f3, person_workat_organisation e1, place f4, organisation_islocatedin_place e2
WHERE f1.type='Post' and f3.type='Company' and f4.type='Country' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.company_id and f4.id=e2.loc_id
),
seg1 AS (
select avg(Post0.length) AS avgPostLength, neo4j1.authorid
from neo4j1, r_post post0, r_country country0
where Country0.name = $countryName and Post0.creationDate > $postDate and neo4j1.poid = Post0.id and neo4j1.coid = Country0.id
group by neo4j1.authorid
ORDER BY avgPostLength DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.person_id AS authorid, e0.tag_id AS tagid, e1.tagclass_id AS tcid
FROM filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1
WHERE e0.tag_id=e1.tag_id and f0.id=e0.person_id
)
select TagClass0.name, Person0.firstName, Person0.lastName, Tag0.name
from neo4j2, r_person person0, r_tag tag0, r_tagclass tagclass0, seg1
where TagClass0.name = $tagClassName and neo4j2.authorid = Person0.id and neo4j2.tagid = Tag0.id and neo4j2.tcid = TagClass0.id and neo4j2.authorid = seg1.authorid;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e2.loc_id AS cityid, e0.post_id AS poid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0, filter_person1 f3, forum_hasmember_person e1, place f4, person_islocatedin_place e2
WHERE f1.type='Post' and f4.type='City' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id and f3.id=e1.person_id and f4.id=e2.loc_id
),
seg1 AS (
select neo4j1.foid, min(Post0.creationDate) AS earliestPostDate
from neo4j1, r_city city0, r_forum forum0, r_post post0
where Forum0.creationDate > $forumDate and City0.name = $cityName and neo4j1.cityid = City0.id and neo4j1.foid = Forum0.id and neo4j1.poid = Post0.id
group by neo4j1.foid
ORDER BY earliestPostDate ASC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.forum_id AS foid, e0.person_id AS modid, e1.company_id AS orgid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0, person_workat_organisation e1
WHERE e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id
)
select Forum0.title, Organisation0.name, Person0.lastName, Person0.firstName
from neo4j2, r_person person0, r_forum forum0, r_organisation organisation0, seg1
where Person0.gender = $gender and Organisation0.name = $organisationName and neo4j2.modid = Person0.id and neo4j2.foid = Forum0.id and neo4j2.orgid = Organisation0.id and neo4j2.foid = seg1.foid;
WITH neo4j1 AS (
SELECT e0.message_id AS poid, e0.tag_id AS tagid
FROM filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tagid, max(Post0.creationDate) AS latestPostDate
from neo4j1, r_tag tag0, r_post post0
where Post0.length > $minLength and Tag0.name = $tagName and neo4j1.tagid = Tag0.id and neo4j1.poid = Post0.id
group by neo4j1.tagid
ORDER BY latestPostDate DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e1.university_id AS uniid, e0.person_id AS personid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0, organisation f1, person_studyat_organisation e1
WHERE f1.type='University' and e0.person_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.university_id
)
select Person0.lastName, University0.name, Person0.firstName, Tag0.name
from neo4j2, r_tag tag0, r_university university0, r_person person0, seg1
where Person0.birthday < $birthday and University0.name = $universityName and neo4j2.tagid = Tag0.id and neo4j2.uniid = University0.id and neo4j2.personid = Person0.id and neo4j2.tagid = seg1.tagid;
WITH neo4j1 AS (
SELECT e2.loc_id AS placeid, e1.person_id AS creatorid, e0.replied_message_id AS poid, e0.message_id AS replyid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, person_islocatedin_place e2
WHERE f1.type='Post' and f3.type='Comment' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id and f4.id=e1.person_id
),
seg1 AS (
select neo4j1.creatorid, avg(Comment0.length) AS avgReplyLength
from neo4j1, r_place place0, r_comment comment0, r_post post0
where Place0.name = $placeName and Post0.creationDate > $postDate2 and neo4j1.placeid = Place0.id and neo4j1.replyid = Comment0.id and neo4j1.poid = Post0.id
group by neo4j1.creatorid
ORDER BY avgReplyLength DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.person_id AS creatorid, e1.tag_id AS tagid, e0.message_id AS msgid
FROM filter_person1 f0, filter_message2 f1, person_likes_message e0, message_hastag_tag e1
WHERE e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id
)
select Message0.content, Person0.lastName, Person0.firstName, Tag0.name
from neo4j2, r_tag tag0, r_person person0, r_message message0, seg1
where Tag0.name = $likedTagName and Message0.creationDate > $messageDate and neo4j2.tagid = Tag0.id and neo4j2.creatorid = Person0.id and neo4j2.msgid = Message0.id and neo4j2.creatorid = seg1.creatorid;
WITH neo4j1 AS (
SELECT e2.org_id AS uniid, e0.message_id AS poid, e0.loc_id AS coid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0, place f3, place_ispartof_place e1, organisation f4, organisation_islocatedin_place e2
WHERE f1.type='Post' and f2.type='Country' and f3.type='City' and f4.type='University' and e0.loc_id=e1.reg_id and e1.subreg_id=e2.loc_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id and f3.id=e1.subreg_id and f4.id=e2.org_id
),
seg1 AS (
select neo4j1.coid, min(Post0.length) AS shortestPostLength
from neo4j1, r_university university0, r_country country0, r_post post0
where University0.name = $universityName2 and Country0.name = $countryName2 and neo4j1.uniid = University0.id and neo4j1.coid = Country0.id and neo4j1.poid = Post0.id
group by neo4j1.coid
ORDER BY shortestPostLength ASC, 1, 2
LIMIT 56
),
neo4j2 AS (
SELECT e0.message_id AS commentid, e1.person_id AS personid, e0.loc_id AS coid
FROM place f0, filter_comment2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1
WHERE f0.type='Country' and f2.type='Comment' and e0.message_id=e1.message_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select Person0.lastName, Person0.browserUsed, Person0.firstName, Comment0.content, Country0.name
from neo4j2, r_comment comment0, r_country country0, r_person person0, seg1
where Comment0.length > $minCommentLength and Comment0.creationDate > $commentDate and neo4j2.commentid = Comment0.id and neo4j2.coid = Country0.id and neo4j2.personid = Person0.id and neo4j2.coid = seg1.coid;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.forum_id AS foid, e1.person_id AS pid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_person1 f2, message_hascreator_person e1, filter_forum2 f3, forum_hasmember_person e2
WHERE f1.type='Post' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.forum_id
),
seg1 AS (
select count(DISTINCT neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_tag tag0
where Tag0.name = $postTag and neo4j1.tid = Tag0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.company_id AS coid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0
WHERE f1.type='Company' and f0.id=e0.person_id and f1.id=e0.company_id
)
select Company0.name AS companyName, count(DISTINCT neo4j2.pid) AS personCount
from neo4j2, r_person person0, r_company company0, seg1
where Person0.gender = $gender and neo4j2.pid = Person0.id and neo4j2.coid = Company0.id and neo4j2.pid = seg1.pid
group by Company0.name
ORDER BY personCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.post_id AS mid, e1.forum_id AS fid
FROM filter_person1 f0, person_hasinterest_tag e0, filter_forum2 f1, forum_hasmoderator_person e1, filter_post2 f2, message f3, forum_containerof_message e2
WHERE f3.type='Post' and e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id and f2.id=e2.post_id and f3.id=e2.post_id
),
seg1 AS (
select neo4j1.fid, count(DISTINCT neo4j1.mid) AS c
from neo4j1, r_tag tag0
where Tag0.name = $interestTag and neo4j1.tid = Tag0.id
group by neo4j1.fid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.forum_id AS fid, e0.tag_id AS ftid
FROM filter_forum2 f0, forum_hastag_tag e0
WHERE f0.id=e0.forum_id
)
select Tag0.name AS forumTagName, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_tag tag0, seg1
where Tag0.name <> $excludedTag and neo4j2.ftid = Tag0.id and neo4j2.fid = seg1.fid
group by Tag0.name
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.tag_id AS rtid, e0.tag_id AS tid, e2.message_id AS mid
FROM tag_hastype_tagclass e0, tag_hastype_tagclass e1, filter_message1 f0, message_hastag_tag e2
WHERE e0.tagclass_id=e1.tagclass_id and e1.tag_id=e2.tag_id and f0.id=e2.message_id
),
seg1 AS (
select neo4j1.mid, count(DISTINCT neo4j1.rtid) AS c
from neo4j1, r_tag tag0
where Tag0.name = $seedTag and neo4j1.tid = Tag0.id
group by neo4j1.mid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.loc_id AS plid, e0.message_id AS mid
FROM filter_message1 f0, message_islocatedin_place e0
WHERE f0.id=e0.message_id
)
select Place0.name AS placeName, count(DISTINCT neo4j2.mid) AS messageCount
from neo4j2, r_place place0, r_message message0, seg1
where Message0.length > $minLength and neo4j2.plid = Place0.id and neo4j2.mid = Message0.id and neo4j2.mid = seg1.mid
group by Place0.name
ORDER BY messageCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.person_id AS pid, e0.message_id AS cmtid, e0.tag_id AS tid
FROM filter_comment2 f0, message f1, message_hastag_tag e0, filter_post2 f2, message f3, message_replyof_message e1, filter_person1 f4, message_hascreator_person e2
WHERE f1.type='Comment' and f3.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.replied_message_id and f3.id=e1.replied_message_id and f4.id=e2.person_id
),
seg1 AS (
select count(DISTINCT neo4j1.cmtid) AS c, neo4j1.pid
from neo4j1, r_tag tag0
where Tag0.name = $commentTag and neo4j1.tid = Tag0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.friend_id AS frid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0
WHERE f0.id=e0.person_id and f1.id=e0.friend_id
)
select Person0.browserUsed AS browserUsed, count(DISTINCT neo4j2.pid) AS authorCount
from neo4j2, r_person person0, seg1
where Person0.gender = $friendGender and neo4j2.frid = Person0.id and neo4j2.pid = seg1.pid
group by Person0.browserUsed
ORDER BY authorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.person_id AS pid, e0.tag_id AS tid, e2.loc_id AS ciid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_person1 f1, forum_hasmember_person e1, place f2, person_islocatedin_place e2
WHERE f2.type='City' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.forum_id and f1.id=e1.person_id and f2.id=e2.loc_id
),
seg1 AS (
select neo4j1.ciid, count(DISTINCT neo4j1.pid) AS c
from neo4j1, r_tag tag0
where Tag0.name = $forumTag and neo4j1.tid = Tag0.id
group by neo4j1.ciid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.loc_id AS ciid, e0.org_id AS uid
FROM place f0, organisation f1, organisation_islocatedin_place e0
WHERE f0.type='City' and f1.type='University' and f0.id=e0.loc_id and f1.id=e0.org_id
)
select count(DISTINCT neo4j2.ciid) AS cityCount, University0.name AS universityName
from neo4j2, r_university university0, seg1
where University0.name <> $excludedUniversity and neo4j2.uid = University0.id and neo4j2.ciid = seg1.ciid
group by University0.name
ORDER BY cityCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e1.forum_id AS foid
FROM place f0, filter_person1 f1, person_islocatedin_place e0, filter_forum2 f2, forum_hasmember_person e1
WHERE f0.type='City' and e0.person_id=e1.person_id and f0.id=e0.loc_id and f1.id=e0.person_id and f2.id=e1.forum_id
),
seg1 AS (
select count(neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_forum forum0
where Forum0.creationDate > $forumDate and neo4j1.foid = Forum0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.friend_id AS friendid, e0.person_id AS pid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0
WHERE f0.id=e0.person_id and f1.id=e0.friend_id
)
select Person0.browserUsed, Person0.firstName, Person0.lastName, Person1.lastName, Person1.firstName, Person1.locationIP
from neo4j2, r_person person0, r_person person1, seg1
where Person1.gender = $gender and neo4j2.pid = Person0.id and neo4j2.friendid = Person1.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e1.person_id AS pid, e0.org_id AS uid
FROM place f0, organisation f1, organisation_islocatedin_place e0, filter_person1 f2, person_studyat_organisation e1
WHERE f0.type='City' and f1.type='University' and e0.org_id=e1.university_id and f0.id=e0.loc_id and f1.id=e0.org_id and f2.id=e1.person_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.uid
from neo4j1, r_person person0
where Person0.birthday > $birthday and neo4j1.pid = Person0.id
group by neo4j1.uid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS studentid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
)
select University0.name, Person0.lastName, Person0.firstName, Person0.email
from neo4j2, r_university university0, r_person person0, seg1
where Person0.browserUsed = $browser and neo4j2.uid = University0.id and neo4j2.studentid = Person0.id and neo4j2.uid = seg1.uid;
WITH neo4j1 AS (
SELECT e1.message_id AS poid, e0.person_id AS pid
FROM place f0, filter_person1 f1, person_islocatedin_place e0, filter_post2 f2, message f3, message_hascreator_person e1
WHERE f0.type='City' and f3.type='Post' and e0.person_id=e1.person_id and f0.id=e0.loc_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select count(neo4j1.poid) AS c, neo4j1.pid
from neo4j1, r_post post0
where Post0.length > $minPostLength and neo4j1.poid = Post0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.message_id AS coid, e0.person_id AS pid
FROM filter_person1 f0, filter_comment2 f1, message f2, message_hascreator_person e0
WHERE f2.type='Comment' and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Comment0.content, Person0.lastName, Person0.firstName, Comment0.length
from neo4j2, r_comment comment0, r_person person0, seg1
where Comment0.creationDate > $commentDate and neo4j2.coid = Comment0.id and neo4j2.pid = Person0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e1.message_id AS mid
FROM place f0, filter_person1 f1, person_islocatedin_place e0, filter_message2 f2, person_likes_message e1
WHERE f0.type='City' and e0.person_id=e1.person_id and f0.id=e0.loc_id and f1.id=e0.person_id and f2.id=e1.message_id
),
seg1 AS (
select count(neo4j1.mid) AS c, neo4j1.pid
from neo4j1, r_message message0
where Message0.length > $minMessageLength and neo4j1.mid = Message0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e0.person_id AS pid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Person0.locationIP, Person0.lastName, Tag0.name, Person0.firstName
from neo4j2, r_person person0, r_tag tag0, seg1
where Tag0.name <> $excludedTag and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.message_id AS poid, e0.loc_id AS coid, e1.person_id AS pid
FROM place f0, filter_post2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1
WHERE f0.type='Country' and f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
),
seg1 AS (
select count(neo4j1.poid) AS c, neo4j1.pid
from neo4j1, r_country country0, r_post post0
where Country0.name = $countryName and Post0.creationDate > $postDate and neo4j1.coid = Country0.id and neo4j1.poid = Post0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.tag_id AS tid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Tag0.name AS tagName, Person0.gender AS gender, count(DISTINCT neo4j2.pid) AS personCount
from neo4j2, r_tag tag0, r_person person0, seg1
where Tag0.name <> $excludedTagName and neo4j2.tid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.pid = seg1.pid
group by Tag0.name, Person0.gender;
WITH neo4j1 AS (
SELECT e1.forum_id AS fid, e0.message_id AS mid, e0.loc_id AS coid
FROM place f0, filter_message2 f1, message_islocatedin_place e0, filter_forum2 f2, forum_containerof_message e1
WHERE f0.type='Country' and e0.message_id=e1.post_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e1.forum_id
),
seg1 AS (
select count(neo4j1.mid) AS c, neo4j1.fid
from neo4j1, r_message message0, r_country country0
where Country0.name = $countryName and Message0.length > $minLength and neo4j1.mid = Message0.id and neo4j1.coid = Country0.id
group by neo4j1.fid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.person_id AS mdid, e0.forum_id AS fid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0
WHERE f0.id=e0.forum_id and f1.id=e0.person_id
)
select Person0.gender AS moderatorGender, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_person person0, seg1
where Person0.browserUsed = $browserUsed and neo4j2.mdid = Person0.id and neo4j2.fid = seg1.fid
group by Person0.gender;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e0.message_id AS mid, e0.loc_id AS coid
FROM place f0, filter_message2 f1, message_islocatedin_place e0, message_hastag_tag e1
WHERE f0.type='Country' and e0.message_id=e1.message_id and f0.id=e0.loc_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tid, count(neo4j1.mid) AS c
from neo4j1, r_message message0, r_country country0
where Country0.name = $countryName and Message0.creationDate > $messageDate and neo4j1.mid = Message0.id and neo4j1.coid = Country0.id
group by neo4j1.tid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tid
FROM tag_hastype_tagclass e0
)
select TagClass0.name AS tagClassName, count(DISTINCT neo4j2.tid) AS tagCount
from neo4j2, r_tagclass tagclass0, seg1
where TagClass0.name <> $excludedTagClassName and neo4j2.tcid = TagClass0.id and neo4j2.tid = seg1.tid
group by TagClass0.name;
WITH neo4j1 AS (
SELECT e0.reg_id AS coid, e1.org_id AS uid, e0.subreg_id AS ciid
FROM place f0, place f1, place_ispartof_place e0, organisation f2, organisation_islocatedin_place e1
WHERE f0.type='Country' and f1.type='City' and f2.type='University' and e0.subreg_id=e1.loc_id and f0.id=e0.reg_id and f1.id=e0.subreg_id and f2.id=e1.org_id
),
seg1 AS (
select neo4j1.ciid, count(neo4j1.uid) AS c
from neo4j1, r_university university0, r_country country0
where Country0.name = $countryName and University0.name <> $excludedUniversityName and neo4j1.uid = University0.id and neo4j1.coid = Country0.id
group by neo4j1.ciid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.loc_id AS ciid
FROM place f0, person_islocatedin_place e0
WHERE f0.type='City' and f0.id=e0.loc_id
)
select City0.name AS cityName, count(neo4j2.pid) AS residentCount, Person0.browserUsed AS browserUsed
from neo4j2, r_person person0, r_city city0, seg1
where Person0.gender = $gender and neo4j2.pid = Person0.id and neo4j2.ciid = City0.id and neo4j2.ciid = seg1.ciid
group by City0.name, Person0.browserUsed;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.company_id AS compid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select * from (
select neo4j1.compid, count(neo4j1.pid) AS c
from neo4j1, r_person person0
where Person0.birthday < $birthCutoff and neo4j1.pid = Person0.id
group by neo4j1.compid
) b1
where c > 3
),
neo4j2 AS (
SELECT e0.person_id AS p2id, e2.tag_id AS tid, e1.message_id AS poid, e0.company_id AS compid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0, filter_post2 f2, message f3, message_hascreator_person e1, message_hastag_tag e2
WHERE f0.type='Company' and f3.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.company_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.poid) AS postCount
from neo4j2, r_tag tag0, r_post post0, r_person person0, seg1
where Person0.gender = $gender and Post0.creationDate > $postSince and neo4j2.tid = Tag0.id and neo4j2.poid = Post0.id and neo4j2.p2id = Person0.id and neo4j2.compid = seg1.compid
group by Tag0.name
ORDER BY postCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.org_id AS compid, e0.loc_id AS coid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select neo4j1.coid, count(neo4j1.compid) AS c
from neo4j1, r_company company0
where Company0.name <> $excludedCompany and neo4j1.compid = Company0.id
group by neo4j1.coid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.person_id AS pid, e2.tag_id AS tid, e0.message_id AS mid, e0.loc_id AS coid
FROM place f0, filter_message2 f1, message_islocatedin_place e0, filter_person1 f2, person_likes_message e1, person_hasinterest_tag e2
WHERE f0.type='Country' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e1.person_id
)
select Tag0.name AS interestTag, count(DISTINCT neo4j2.pid) AS likerCount
from neo4j2, r_tag tag0, r_message message0, r_person person0, seg1
where Person0.browserUsed = $browser and Message0.length > $minLength and neo4j2.tid = Tag0.id and neo4j2.mid = Message0.id and neo4j2.pid = Person0.id and neo4j2.coid = seg1.coid
group by Tag0.name
ORDER BY likerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.org_id AS compid, e0.loc_id AS plid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='Company' and f0.id=e0.org_id
),
seg1 AS (
select * from (
select neo4j1.plid, count(neo4j1.compid) AS c
from neo4j1, r_place place0
where Place0.name <> $excludedPlace and neo4j1.plid = Place0.id
group by neo4j1.plid
) b1
where c > 2
),
neo4j2 AS (
SELECT e2.friend_id AS qid, e1.person_id AS pid, e0.org_id AS uid, e0.loc_id AS plid
FROM organisation f0, organisation_islocatedin_place e0, filter_person1 f1, person_studyat_organisation e1, filter_person1 f2, person_knows_person e2
WHERE f0.type='University' and e0.org_id=e1.university_id and e1.person_id=e2.person_id and f0.id=e0.org_id and f1.id=e1.person_id and f2.id=e2.friend_id
)
select Person0.browserUsed AS browser, count(DISTINCT neo4j2.pid) AS studentCount
from neo4j2, r_person person0, r_university university0, seg1
where University0.name <> $excludedUniversity and Person0.gender = $gender and neo4j2.qid = Person0.id and neo4j2.uid = University0.id and neo4j2.plid = seg1.plid
group by Person0.browserUsed
ORDER BY studentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.company_id AS compid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select * from (
select count(neo4j1.compid) AS c, neo4j1.pid
from neo4j1, r_company company0
where Company0.name <> $excludedCompany and neo4j1.compid = Company0.id
group by neo4j1.pid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e2.person_id AS authorid, e0.person_id AS pid
FROM filter_person1 f0, filter_comment2 f1, message f2, person_likes_message e0, filter_post2 f3, message f4, message_replyof_message e1, filter_person1 f5, message_hascreator_person e2
WHERE f2.type='Comment' and f4.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.replied_message_id and f4.id=e1.replied_message_id and f5.id=e2.person_id
)
select count(DISTINCT neo4j2.cmid) AS likedReplyCount, Person0.browserUsed AS authorBrowser
from neo4j2, r_person person0, r_comment comment0, seg1
where Comment0.creationDate > $commentSince and Person0.gender = $authorGender and neo4j2.authorid = Person0.id and neo4j2.cmid = Comment0.id and neo4j2.pid = seg1.pid
group by Person0.browserUsed
ORDER BY likedReplyCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.tag_id AS tid
FROM person_hasinterest_tag e0
),
seg1 AS (
select * from (
select count(neo4j1.tid) AS c, neo4j1.pid
from neo4j1, r_tag tag0
where Tag0.name <> $excludedInterestName and neo4j1.tid = Tag0.id
group by neo4j1.pid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.company_id AS coid, e0.person_id AS pid, e1.loc_id AS countryid
FROM organisation f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE f0.type='Company' and f1.type='Country' and e0.company_id=e1.org_id and f0.id=e0.company_id and f1.id=e1.loc_id
)
select count(DISTINCT neo4j2.pid) AS interestedEmployeeCount, Company0.name AS companyName
from neo4j2, r_country country0, r_company company0, seg1
where Country0.name = $countryName and Company0.name <> $excludedCompanyName and neo4j2.countryid = Country0.id and neo4j2.coid = Company0.id and neo4j2.pid = seg1.pid
group by Company0.name
ORDER BY interestedEmployeeCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.forum_id AS fid
FROM filter_forum2 f0, forum_hastag_tag e0
WHERE f0.id=e0.forum_id
),
seg1 AS (
select * from (
select count(neo4j1.tid) AS c, neo4j1.fid
from neo4j1, r_tag tag0, r_forum forum0
where Tag0.name <> $excludedTagName and Forum0.creationDate > $forumCreatedAfter and neo4j1.tid = Tag0.id and neo4j1.fid = Forum0.id
group by neo4j1.fid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.message_id AS likedid, e0.person_id AS memberid, e0.forum_id AS fid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, filter_post2 f2, message f3, person_likes_message e1
WHERE f3.type='Post' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
)
select count(DISTINCT neo4j2.memberid) AS memberCount, Post0.browserUsed AS browserUsed
from neo4j2, r_person person0, r_post post0, seg1
where Person0.gender = $gender and Post0.creationDate > $postCreatedAfter and neo4j2.memberid = Person0.id and neo4j2.likedid = Post0.id and neo4j2.fid = seg1.fid
group by Post0.browserUsed
ORDER BY memberCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, message_hastag_tag e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select count(neo4j1.tid) AS c, neo4j1.cmid
from neo4j1, r_comment comment0, r_tag tag0
where Tag0.name <> $excludedTagName and Comment0.length > $minCommentLength and neo4j1.cmid = Comment0.id and neo4j1.tid = Tag0.id
group by neo4j1.cmid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.person_id AS creatorid, e0.message_id AS cmid, e0.replied_message_id AS poid
FROM filter_comment2 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1
WHERE f1.type='Comment' and f3.type='Post' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id
)
select Person0.browserUsed AS browserUsed, count(DISTINCT neo4j2.cmid) AS replyCommentCount
from neo4j2, r_post post0, r_person person0, seg1
where Post0.length > $minPostLength and Person0.gender = $gender and neo4j2.poid = Post0.id and neo4j2.creatorid = Person0.id and neo4j2.cmid = seg1.cmid
group by Person0.browserUsed
ORDER BY replyCommentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select * from (
select count(neo4j1.tid) AS c, neo4j1.tcid
from neo4j1, r_tag tag0
where Tag0.name <> $excludedTagName and neo4j1.tid = Tag0.id
group by neo4j1.tcid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.tag_id AS topicid, e1.message_id AS msgid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1
WHERE e0.tag_id=e1.tag_id and f0.id=e1.message_id
)
select count(DISTINCT neo4j2.msgid) AS messageCount, Tag0.name AS tagName
from neo4j2, r_message message0, r_tag tag0, seg1
where Message0.creationDate > $messageCreatedAfter and Message0.length > $minMessageLength and neo4j2.msgid = Message0.id and neo4j2.topicid = Tag0.id and neo4j2.tcid = seg1.tcid
group by Tag0.name
ORDER BY messageCount DESC, 1, 2
LIMIT 20;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.message_id AS poid, e0.person_id AS pid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select * from (
select count(neo4j1.poid) AS c, neo4j1.pid
from neo4j1, r_post post0
where Post0.creationDate > $postDate and neo4j1.poid = Post0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e2.tagclass_id AS tcid, e0.person_id AS pid, e0.friend_id AS fid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id
)
select TagClass0.name AS tagClassName, count(DISTINCT neo4j2.pid) AS creatorCount
from neo4j2, r_person person0, r_tagclass tagclass0, seg1
where Person0.gender = $gender and neo4j2.fid = Person0.id and neo4j2.tcid = TagClass0.id and neo4j2.pid = seg1.pid
group by TagClass0.name
ORDER BY creatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select neo4j1.tid, count(neo4j1.poid) AS c
from neo4j1, r_post post0
where Post0.creationDate > $postDate and neo4j1.poid = Post0.id
group by neo4j1.tid
) b1
where c > 3
),
neo4j2 AS (
SELECT e2.loc_id AS plid, e0.message_id AS mid, e0.tag_id AS tid
FROM filter_message2 f0, message_hastag_tag e0, filter_person1 f1, message_hascreator_person e1, person_islocatedin_place e2
WHERE e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e1.person_id
)
select Place0.name AS placeName, count(DISTINCT neo4j2.mid) AS messageCount
from neo4j2, r_place place0, r_message message0, seg1
where Message0.length > $messageLength and neo4j2.plid = Place0.id and neo4j2.mid = Message0.id and neo4j2.tid = seg1.tid
group by Place0.name
ORDER BY messageCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.loc_id AS coid, e0.message_id AS poid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0
WHERE f1.type='Post' and f2.type='Country' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id
),
seg1 AS (
select * from (
select neo4j1.coid, count(neo4j1.poid) AS c
from neo4j1, r_post post0
where Post0.browserUsed = $browser and neo4j1.poid = Post0.id
group by neo4j1.coid
) b1
where c > 20
),
neo4j2 AS (
SELECT e2.message_id AS cmid, e1.person_id AS personid, e0.org_id AS orgid, e0.loc_id AS coid
FROM place f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, filter_comment2 f2, message f3, person_likes_message e2
WHERE f0.type='Country' and f3.type='Comment' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e1.person_id and f2.id=e2.message_id and f3.id=e2.message_id
)
select count(DISTINCT neo4j2.cmid) AS likedCommentCount, Organisation0.name AS organisationName
from neo4j2, r_organisation organisation0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.orgid = Organisation0.id and neo4j2.personid = Person0.id and neo4j2.coid = seg1.coid
group by Organisation0.name
ORDER BY likedCommentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e0.post_id AS poid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0
WHERE f1.type='Post' and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id
),
seg1 AS (
select * from (
select neo4j1.foid, count(neo4j1.poid) AS c
from neo4j1, r_post post0
where Post0.length > $postLength and neo4j1.poid = Post0.id
group by neo4j1.foid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.forum_id AS foid, e2.loc_id AS ciid, e0.person_id AS memberid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_studyat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE f2.type='University' and f3.type='City' and e0.person_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.university_id and f3.id=e2.loc_id
)
select City0.name AS cityName, count(DISTINCT neo4j2.foid) AS forumCount
from neo4j2, r_city city0, r_person person0, seg1
where Person0.birthday > $birthday and neo4j2.ciid = City0.id and neo4j2.memberid = Person0.id and neo4j2.foid = seg1.foid
group by City0.name
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.replied_message_id AS poid, e0.message_id AS cmid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0
WHERE f1.type='Post' and f3.type='Comment' and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id
),
seg1 AS (
select * from (
select neo4j1.poid, count(neo4j1.cmid) AS c
from neo4j1, r_comment comment0
where Comment0.length > $replyLength and neo4j1.cmid = Comment0.id
group by neo4j1.poid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e2.tag_id AS parentid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.message_id and f1.id=e0.message_id
)
select count(DISTINCT neo4j2.poid) AS postCount, TagClass0.name AS parentClassName
from neo4j2, r_tagclass tagclass0, r_tag tag0, seg1
where Tag0.name <> $tagName and neo4j2.parentid = TagClass0.id and neo4j2.tid = Tag0.id and neo4j2.poid = seg1.poid
group by TagClass0.name
ORDER BY postCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.message_id AS poid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_post2 f0, message f1, message_hastag_tag e1
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and f0.id=e1.message_id and f1.id=e1.message_id
),
seg1 AS (
select avg(Post0.length) AS avgPostLength, neo4j1.poid
from neo4j1, r_post post0, r_tagclass tagclass0
where TagClass0.name = $tagClassName and Post0.creationDate > $postSince and neo4j1.poid = Post0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.poid
ORDER BY avgPostLength DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e1.company_id AS cid, e0.person_id AS pid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, organisation f3, person_workat_organisation e1
WHERE f1.type='Post' and f3.type='Company' and e0.person_id=e1.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.company_id
)
select Company0.name AS companyName, count(DISTINCT neo4j2.poid) AS postCount, Person0.gender AS gender
from neo4j2, r_company company0, r_person person0, seg1
where Person0.gender = $gender and Company0.name <> $excludedCompany and neo4j2.cid = Company0.id and neo4j2.pid = Person0.id and neo4j2.poid = seg1.poid
group by Company0.name, Person0.gender;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e1.message_id AS cmid
FROM tag_hastype_tagclass e0, filter_comment2 f0, message f1, message_hastag_tag e1
WHERE f1.type='Comment' and e0.tag_id=e1.tag_id and f0.id=e1.message_id and f1.id=e1.message_id
),
seg1 AS (
select max(Comment0.creationDate) AS latestCommentDate, neo4j1.cmid
from neo4j1, r_tagclass tagclass0, r_comment comment0
where Comment0.length > $minCommentLength and TagClass0.name = $tagClassName and neo4j1.tcid = TagClass0.id and neo4j1.cmid = Comment0.id
group by neo4j1.cmid
ORDER BY latestCommentDate DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e1.loc_id AS coid, e0.replied_message_id AS poid
FROM filter_comment2 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0, place f4, message_islocatedin_place e1
WHERE f1.type='Comment' and f3.type='Post' and f4.type='Country' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.loc_id
)
select count(DISTINCT neo4j2.cmid) AS commentCount, Country0.name AS countryName
from neo4j2, r_post post0, r_country country0, seg1
where Country0.name <> $excludedCountry and Post0.creationDate > $postSince and neo4j2.poid = Post0.id and neo4j2.coid = Country0.id and neo4j2.cmid = seg1.cmid
group by Country0.name;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e1.forum_id AS fid
FROM tag_hastype_tagclass e0, filter_forum2 f0, forum_hastag_tag e1
WHERE e0.tag_id=e1.tag_id and f0.id=e1.forum_id
),
seg1 AS (
select neo4j1.fid, max(Forum0.creationDate) AS latestForumDate
from neo4j1, r_tagclass tagclass0, r_forum forum0
where TagClass0.name = $tagClassName and Forum0.creationDate > $forumSince and neo4j1.tcid = TagClass0.id and neo4j1.fid = Forum0.id
group by neo4j1.fid
ORDER BY latestForumDate DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.forum_id AS fid, e0.person_id AS pid, e1.university_id AS uid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_studyat_organisation e1
WHERE f2.type='University' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.university_id
)
select University0.name AS universityName, Person0.browserUsed AS browserUsed, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_person person0, r_university university0, seg1
where University0.name <> $excludedUniversity and Person0.locationIP <> $blockedIP and neo4j2.pid = Person0.id and neo4j2.uid = University0.id and neo4j2.fid = seg1.fid
group by University0.name, Person0.browserUsed;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e1.message_id AS mid
FROM tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1
WHERE e0.tag_id=e1.tag_id and f0.id=e1.message_id
),
seg1 AS (
select neo4j1.mid, avg(Message0.length) AS avgMessageLength
from neo4j1, r_tagclass tagclass0, r_message message0
where Message0.length > $minMessageLength and TagClass0.name = $tagClassName and neo4j1.tcid = TagClass0.id and neo4j1.mid = Message0.id
group by neo4j1.mid
ORDER BY avgMessageLength DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.message_id AS mid, e0.person_id AS pid, e1.loc_id AS ciid
FROM filter_message2 f0, filter_person1 f1, message_hascreator_person e0, place f2, person_islocatedin_place e1
WHERE f2.type='City' and e0.person_id=e1.person_id and f0.id=e0.message_id and f1.id=e0.person_id and f2.id=e1.loc_id
)
select City0.name AS cityName, Person0.browserUsed AS browserUsed, count(DISTINCT neo4j2.mid) AS messageCount
from neo4j2, r_city city0, r_person person0, seg1
where Person0.birthday < $birthdayBefore and City0.name <> $excludedCity and neo4j2.ciid = City0.id and neo4j2.pid = Person0.id and neo4j2.mid = seg1.mid
group by City0.name, Person0.browserUsed;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e1.person_id AS pid, e0.post_id AS poid
FROM filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, filter_person1 f3, message_hascreator_person e1
WHERE f2.type='Post' and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.person_id
),
seg1 AS (
select * from (
select count(neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_post post0
where Post0.creationDate > $postDate and neo4j1.poid = Post0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.tag_id AS tid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Person0.lastName AS personLastName, Person0.firstName AS personFirstName, Tag0.name AS interestName
from neo4j2, r_tag tag0, r_person person0, seg1
where Tag0.name = $tagName and neo4j2.tid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e0.tag_id AS tid, e1.tagclass_id AS tcid
FROM filter_forum2 f0, forum_hastag_tag e0, tag_hastype_tagclass e1
WHERE e0.tag_id=e1.tag_id and f0.id=e0.forum_id
),
seg1 AS (
select * from (
select count(neo4j1.foid) AS c, neo4j1.tid
from neo4j1, r_tagclass tagclass0
where TagClass0.name = $tagClassName and neo4j1.tcid = TagClass0.id
group by neo4j1.tid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e0.person_id AS pid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Tag0.name AS tagName, Person0.firstName AS personFirstName, Person0.lastName AS personLastName
from neo4j2, r_person person0, r_tag tag0, seg1
where Person0.gender = $gender and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e0.post_id AS mid
FROM filter_forum2 f0, filter_message2 f1, forum_containerof_message e0, message_hastag_tag e1
WHERE e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id
),
seg1 AS (
select * from (
select neo4j1.tid, count(neo4j1.mid) AS c
from neo4j1, r_message message0
where Message0.length > $minLength and neo4j1.mid = Message0.id
group by neo4j1.tid
) b1
where c > 3
),
neo4j2 AS (
SELECT e0.message_id AS cmtid, e0.tag_id AS tid
FROM filter_comment2 f0, message f1, message_hastag_tag e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
)
select Tag0.name AS tagName, Comment0.length AS commentLength, Comment0.content AS commentContent
from neo4j2, r_comment comment0, r_tag tag0, seg1
where Comment0.creationDate > $commentDate and neo4j2.cmtid = Comment0.id and neo4j2.tid = Tag0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e0.person_id AS mdid, e1.message_id AS poid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0, filter_post2 f2, message f3, message_hascreator_person e1
WHERE f3.type='Post' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select * from (
select neo4j1.mdid, count(neo4j1.poid) AS c
from neo4j1, r_person person0
where Person0.browserUsed = $browser and neo4j1.mdid = Person0.id
group by neo4j1.mdid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.person_id AS mdid, e0.message_id AS cmid
FROM filter_person1 f0, filter_comment2 f1, message f2, person_likes_message e0
WHERE f2.type='Comment' and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Person0.lastName AS moderatorLastName, Person0.firstName AS moderatorFirstName, Comment0.content AS likedCommentContent
from neo4j2, r_comment comment0, r_person person0, seg1
where Comment0.length < $maxLength and neo4j2.cmid = Comment0.id and neo4j2.mdid = Person0.id and neo4j2.mdid = seg1.mdid;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select count(neo4j1.tagid) AS c, neo4j1.tcid
from neo4j1, r_tagclass tagclass0
where TagClass0.name <> $excludedTagClass and neo4j1.tcid = TagClass0.id
group by neo4j1.tcid
ORDER BY c DESC, 1, 2
LIMIT 14
),
neo4j2 AS (
SELECT e1.message_id AS mid, e2.person_id AS pid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1, filter_person1 f1, message_hascreator_person e2
WHERE e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e2.person_id
)
select Person0.browserUsed AS browser, count(DISTINCT neo4j2.mid) AS messageCount, Person0.gender AS gender
from neo4j2, r_message message0, r_person person0, seg1
where Message0.creationDate > $messageDate and neo4j2.mid = Message0.id and neo4j2.pid = Person0.id and neo4j2.tcid = seg1.tcid
group by Person0.browserUsed, Person0.gender;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select count(neo4j1.tagid) AS c, neo4j1.tcid
from neo4j1, r_tagclass tagclass0
where TagClass0.name <> $excludedTagClass and neo4j1.tcid = TagClass0.id
group by neo4j1.tcid
ORDER BY c DESC, 1, 2
LIMIT 4
),
neo4j2 AS (
SELECT e2.company_id AS companyid, e1.person_id AS pid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_person1 f0, person_hasinterest_tag e1, organisation f1, person_workat_organisation e2
WHERE f1.type='Company' and e0.tag_id=e1.tag_id and e1.person_id=e2.person_id and f0.id=e1.person_id and f1.id=e2.company_id
)
select Person0.browserUsed AS browser, count(DISTINCT neo4j2.pid) AS interestedWorkers, Company0.name AS companyName
from neo4j2, r_person person0, r_company company0, seg1
where Person0.gender = $gender and neo4j2.pid = Person0.id and neo4j2.companyid = Company0.id and neo4j2.tcid = seg1.tcid
group by Person0.browserUsed, Company0.name;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select count(neo4j1.tagid) AS c, neo4j1.tcid
from neo4j1, r_tag tag0
where Tag0.name <> $excludedTag and neo4j1.tagid = Tag0.id
group by neo4j1.tcid
ORDER BY c DESC, 1, 2
LIMIT 36
),
neo4j2 AS (
SELECT e1.forum_id AS fid, e2.person_id AS modid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_forum2 f0, forum_hastag_tag e1, filter_person1 f1, forum_hasmoderator_person e2
WHERE e0.tag_id=e1.tag_id and e1.forum_id=e2.forum_id and f0.id=e1.forum_id and f1.id=e2.person_id
)
select Person0.gender AS moderatorGender, count(DISTINCT neo4j2.fid) AS forumCount, Person0.browserUsed AS moderatorBrowser
from neo4j2, r_person person0, r_forum forum0, seg1
where Forum0.creationDate > $forumDate and neo4j2.modid = Person0.id and neo4j2.fid = Forum0.id and neo4j2.tcid = seg1.tcid
group by Person0.gender, Person0.browserUsed;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select count(neo4j1.tagid) AS c, neo4j1.tcid
from neo4j1, r_tag tag0
where Tag0.name <> $excludedTag and neo4j1.tagid = Tag0.id
group by neo4j1.tcid
ORDER BY c DESC, 1, 2
LIMIT 14
),
neo4j2 AS (
SELECT e2.loc_id AS countryid, e1.message_id AS postid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_post1 f0, message f1, message_hastag_tag e1, place f2, message_islocatedin_place e2
WHERE f1.type='Post' and f2.type='Country' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e1.message_id and f2.id=e2.loc_id
)
select Post0.browserUsed AS browser, Country0.name AS countryName, count(DISTINCT neo4j2.postid) AS postCount
from neo4j2, r_post post0, r_country country0, seg1
where Post0.length > $minLength and neo4j2.postid = Post0.id and neo4j2.countryid = Country0.id and neo4j2.tcid = seg1.tcid
group by Post0.browserUsed, Country0.name;
WITH neo4j1 AS (
SELECT e0.subtag_id AS childid, e0.tag_id AS parentid
FROM tagclass_issubclassof_tagclass e0
),
seg1 AS (
select count(neo4j1.parentid) AS c, neo4j1.childid
from neo4j1, r_tagclass tagclass0
where TagClass0.name <> $excludedParentClass and neo4j1.parentid = TagClass0.id
group by neo4j1.childid
ORDER BY c DESC, 1, 2
LIMIT 14
),
neo4j2 AS (
SELECT e1.message_id AS commentid, e2.replied_message_id AS postid, e0.tagclass_id AS childid
FROM tag_hastype_tagclass e0, filter_comment2 f0, message f1, message_hastag_tag e1, filter_post2 f2, message f3, message_replyof_message e2
WHERE f1.type='Comment' and f3.type='Post' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e1.message_id and f2.id=e2.replied_message_id and f3.id=e2.replied_message_id
)
select Post0.browserUsed AS repliedPostBrowser, Comment0.locationIP AS commenterLocationIP, count(DISTINCT neo4j2.commentid) AS replyCount
from neo4j2, r_comment comment0, r_post post0, seg1
where Comment0.creationDate > $commentDate and neo4j2.commentid = Comment0.id and neo4j2.postid = Post0.id and neo4j2.childid = seg1.childid
group by Post0.browserUsed, Comment0.locationIP;
WITH neo4j1 AS (
SELECT e0.person_id AS alid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select neo4j1.uid, min(Person0.birthday) AS earliestAlumniBirthday
from neo4j1, r_person person0
where neo4j1.alid = Person0.id
group by neo4j1.uid
ORDER BY earliestAlumniBirthday ASC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e1.tag_id AS tid, e2.message_id AS mid, e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, person_hasinterest_tag e1, filter_post2 f2, message f3, message_hastag_tag e2
WHERE f0.type='University' and f3.type='Post' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e2.message_id and f3.id=e2.message_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.mid) AS postCount
from neo4j2, r_post post0, r_person person0, r_tag tag0, seg1
where Person0.gender = $gender and Post0.creationDate > $postDate and neo4j2.mid = Post0.id and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.uid = seg1.uid
group by Tag0.name;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select max(Person0.birthday) AS birthdayRank, neo4j1.pid
from neo4j1, r_university university0, r_person person0
where University0.name = $universityName and neo4j1.uid = University0.id and neo4j1.pid = Person0.id
group by neo4j1.pid
ORDER BY birthdayRank DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e2.person_id AS mdid, e1.forum_id AS fid, e0.message_id AS poid, e0.person_id AS pid
FROM filter_person1 f0, filter_post2 f1, message f2, message_hascreator_person e0, filter_forum2 f3, forum_containerof_message e1, filter_person1 f4, forum_hasmoderator_person e2
WHERE f2.type='Post' and e0.message_id=e1.post_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.forum_id and f4.id=e2.person_id
)
select Person0.browserUsed AS moderatorBrowser, Person0.gender AS moderatorGender, count(DISTINCT neo4j2.poid) AS postCount
from neo4j2, r_post post0, r_forum forum0, r_person person0, seg1
where Forum0.creationDate > $forumDate and Post0.length > $postLength and neo4j2.poid = Post0.id and neo4j2.fid = Forum0.id and neo4j2.mdid = Person0.id and neo4j2.pid = seg1.pid
group by Person0.browserUsed, Person0.gender;
WITH neo4j1 AS (
SELECT e2.tag_id AS tid, e0.forum_id AS foid, e0.person_id AS pid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, filter_post2 f2, message f3, message_hascreator_person e1, message_hastag_tag e2
WHERE f3.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_tag tag0, r_forum forum0
where Forum0.creationDate > $forumDate and Tag0.name = $tagName and neo4j1.tid = Tag0.id and neo4j1.foid = Forum0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.person_id AS pid, e1.loc_id AS countryid, e0.company_id AS coid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id
)
select Company0.name AS companyName, count(DISTINCT neo4j2.pid) AS qualifyingPeople
from neo4j2, r_country country0, r_company company0, seg1
where Country0.name = $countryName and neo4j2.countryid = Country0.id and neo4j2.coid = Company0.id and neo4j2.pid = seg1.pid
group by Company0.name
ORDER BY qualifyingPeople DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.post_id AS mid, e2.loc_id AS cityid, e1.person_id AS pid
FROM filter_forum2 f0, filter_message2 f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1, place f3, person_islocatedin_place e2
WHERE f3.type='City' and e0.post_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e1.person_id and f3.id=e2.loc_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.mid) AS c, neo4j1.pid
from neo4j1, r_message message0, r_city city0
where City0.name = $cityName and Message0.length > $minLength and neo4j1.mid = Message0.id and neo4j1.cityid = City0.id
group by neo4j1.pid
) b1
where c > 10
),
neo4j2 AS (
SELECT e1.tagclass_id AS tcid, e0.person_id AS pid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1
WHERE e0.tag_id=e1.tag_id and f0.id=e0.person_id
)
select count(DISTINCT neo4j2.pid) AS creatorCount, Tag0.name AS interestTag
from neo4j2, r_tagclass tagclass0, r_tag tag0, seg1
where TagClass0.name = $tagClassName and neo4j2.tcid = TagClass0.id and neo4j2.tagid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name
ORDER BY creatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.message_id AS cmtid, e0.forum_id AS foid, e0.person_id AS modid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0, filter_comment2 f2, message f3, message_hascreator_person e1, place f4, message_islocatedin_place e2
WHERE f3.type='Comment' and f4.type='Country' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.loc_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmtid) AS c, neo4j1.modid
from neo4j1, r_comment comment0, r_forum forum0
where Comment0.length > $minCommentLength and Forum0.title = $forumTitle and neo4j1.cmtid = Comment0.id and neo4j1.foid = Forum0.id
group by neo4j1.modid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.university_id AS uniid, e1.loc_id AS placeid, e0.person_id AS modid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, organisation_islocatedin_place e1
WHERE f1.type='University' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id
)
select count(DISTINCT neo4j2.modid) AS moderatorCount, Place0.name AS universityPlace
from neo4j2, r_place place0, r_university university0, seg1
where University0.name = $universityName and neo4j2.placeid = Place0.id and neo4j2.uniid = University0.id and neo4j2.modid = seg1.modid
group by Place0.name
ORDER BY moderatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e0.tag_id AS tid, e2.loc_id AS countryid, e1.message_id AS poid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_post2 f1, message f2, message_hastag_tag e1, place f3, message_islocatedin_place e2
WHERE f2.type='Post' and f3.type='Country' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e1.message_id and f2.id=e1.message_id and f3.id=e2.loc_id
),
seg1 AS (
select * from (
select neo4j1.tid, count(DISTINCT neo4j1.poid) AS c
from neo4j1, r_country country0, r_forum forum0
where Country0.name = $countryName and Forum0.creationDate < $beforeDate and neo4j1.countryid = Country0.id and neo4j1.foid = Forum0.id
group by neo4j1.tid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.person_id AS pid, e1.message_id AS msgid, e0.tag_id AS tid
FROM filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, person_likes_message e1
WHERE e0.person_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.message_id
)
select Person0.browserUsed AS browser, count(DISTINCT neo4j2.msgid) AS likedMessageCount
from neo4j2, r_person person0, r_message message0, seg1
where Message0.length > $minLikedLength and neo4j2.pid = Person0.id and neo4j2.msgid = Message0.id and neo4j2.tid = seg1.tid
group by Person0.browserUsed
ORDER BY likedMessageCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.post_id AS postid, e1.message_id AS replyid, e2.person_id AS pid
FROM filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, filter_comment2 f3, message f4, message_replyof_message e1, filter_person1 f5, message_hascreator_person e2
WHERE f2.type='Post' and f4.type='Comment' and e0.post_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.message_id and f4.id=e1.message_id and f5.id=e2.person_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.replyid) AS c, neo4j1.pid
from neo4j1, r_post post0, r_comment comment0
where Post0.creationDate > $postDate and Comment0.length > $replyMinLength and neo4j1.postid = Post0.id and neo4j1.replyid = Comment0.id
group by neo4j1.pid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.message_id AS likedid, e0.person_id AS pid, e1.tag_id AS tagid
FROM filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0, message_hastag_tag e1
WHERE f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select count(DISTINCT neo4j2.pid) AS likerCount, Tag0.name AS tagName
from neo4j2, r_tag tag0, r_post post0, seg1
where Post0.creationDate < $likedBefore and neo4j2.tagid = Tag0.id and neo4j2.likedid = Post0.id and neo4j2.pid = seg1.pid
group by Tag0.name
ORDER BY likerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS authorid, e1.forum_id AS foid, e2.tag_id AS tagid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, filter_forum2 f3, forum_hasmember_person e1, forum_hastag_tag e2
WHERE f1.type='Post' and e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.forum_id
),
seg1 AS (
select count(DISTINCT neo4j1.foid) AS c, neo4j1.authorid
from neo4j1, r_post post0, r_tag tag0
where Tag0.name = $tagName and Post0.creationDate > $postDate and neo4j1.poid = Post0.id and neo4j1.tagid = Tag0.id
group by neo4j1.authorid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e2.loc_id AS countryid, e0.friend_id AS friendid, e0.person_id AS authorid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0, organisation f2, person_workat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE f2.type='Company' and f3.type='Country' and e0.friend_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.company_id and f3.id=e2.loc_id
)
select Country0.name AS countryName, count(DISTINCT neo4j2.friendid) AS friendCount
from neo4j2, r_country country0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.countryid = Country0.id and neo4j2.friendid = Person0.id and neo4j2.authorid = seg1.authorid
group by Country0.name
ORDER BY friendCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tagid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tagid, count(DISTINCT neo4j1.poid) AS c
from neo4j1, r_post post0
where Post0.length > $minPostLength and neo4j1.poid = Post0.id
group by neo4j1.tagid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e2.loc_id AS placeid, e0.person_id AS personid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0, organisation f1, person_studyat_organisation e1, organisation_islocatedin_place e2
WHERE f1.type='University' and e0.person_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.person_id and f1.id=e1.university_id
)
select Place0.name AS placeName, count(DISTINCT neo4j2.personid) AS personCount
from neo4j2, r_place place0, r_person person0, seg1
where Person0.browserUsed = $browserUsed and neo4j2.placeid = Place0.id and neo4j2.personid = Person0.id and neo4j2.tagid = seg1.tagid
group by Place0.name
ORDER BY personCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.person_id AS workerid, e1.org_id AS coid, e0.loc_id AS countryid, e0.message_id AS poid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0, organisation f3, organisation_islocatedin_place e1, filter_person1 f4, person_workat_organisation e2
WHERE f1.type='Post' and f2.type='Country' and f3.type='Company' and e0.loc_id=e1.loc_id and e1.org_id=e2.company_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id and f3.id=e1.org_id and f4.id=e2.person_id
),
seg1 AS (
select count(DISTINCT neo4j1.workerid) AS c, neo4j1.countryid
from neo4j1, r_company company0, r_post post0
where Company0.name <> $excludedCompany and Post0.creationDate < $beforeDate and neo4j1.coid = Company0.id and neo4j1.poid = Post0.id
group by neo4j1.countryid
ORDER BY c DESC, 1, 2
LIMIT 6
),
neo4j2 AS (
SELECT e2.message_id AS commentid, e1.person_id AS residentid, e0.reg_id AS countryid
FROM place f0, place f1, place_ispartof_place e0, filter_person1 f2, person_islocatedin_place e1, filter_comment2 f3, message f4, message_hascreator_person e2
WHERE f0.type='Country' and f1.type='City' and f4.type='Comment' and e0.subreg_id=e1.loc_id and e1.person_id=e2.person_id and f0.id=e0.reg_id and f1.id=e0.subreg_id and f2.id=e1.person_id and f3.id=e2.message_id and f4.id=e2.message_id
)
select count(DISTINCT neo4j2.commentid) AS commentCount, Person0.browserUsed AS browserUsed
from neo4j2, r_comment comment0, r_person person0, seg1
where Comment0.length > $minCommentLength and neo4j2.commentid = Comment0.id and neo4j2.residentid = Person0.id and neo4j2.countryid = seg1.countryid
group by Person0.browserUsed
ORDER BY commentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.message_id AS commentid, e0.person_id AS creatorid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, person_hasinterest_tag e1, filter_comment2 f3, message f4, message_hastag_tag e2
WHERE f1.type='Post' and f4.type='Comment' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e2.message_id and f4.id=e2.message_id
),
seg1 AS (
select neo4j1.creatorid, count(DISTINCT neo4j1.commentid) AS c
from neo4j1, r_post post0, r_comment comment0
where Comment0.length > $minCommentLength and Post0.browserUsed = $postBrowser and neo4j1.poid = Post0.id and neo4j1.commentid = Comment0.id
group by neo4j1.creatorid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.message_id AS msgid, e2.person_id AS moderatorid, e0.person_id AS creatorid
FROM filter_person1 f0, filter_message2 f1, message_hascreator_person e0, filter_forum2 f2, forum_containerof_message e1, filter_person1 f3, forum_hasmoderator_person e2
WHERE e0.message_id=e1.post_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e1.forum_id and f3.id=e2.person_id
)
select Person0.browserUsed AS moderatorBrowser, count(DISTINCT neo4j2.msgid) AS messageCount
from neo4j2, r_person person0, r_message message0, seg1
where Person0.gender = $moderatorGender and Message0.creationDate > $messageDate and neo4j2.moderatorid = Person0.id and neo4j2.msgid = Message0.id and neo4j2.creatorid = seg1.creatorid
group by Person0.browserUsed
ORDER BY messageCount DESC, 1, 2
LIMIT 20