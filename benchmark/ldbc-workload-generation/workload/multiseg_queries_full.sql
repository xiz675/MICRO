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
SELECT e1.tag_id AS tid, e2.tagclass_id AS tcid, e0.person_id AS pid, e0.message_id AS poid
FROM filter_person1 f0, filter_post2 f1, message f2, message_hascreator_person e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE f2.type='Post' and e0.message_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select count(DISTINCT neo4j2.pid) AS alumnusCount, Tag0.name AS tagName
from neo4j2, r_post post0, r_tagclass tagclass0, r_tag tag0, seg1
where Post0.creationDate > $postDate and TagClass0.name = $tagClassName and neo4j2.poid = Post0.id and neo4j2.tcid = TagClass0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name AS tagName
ORDER BY alumnusCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS plid
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
SELECT e2.tag_id AS tid, e1.forum_id AS fid, e0.person_id AS pid, e0.loc_id AS plid
FROM filter_person1 f0, person_islocatedin_place e0, filter_forum2 f1, forum_hasmember_person e1, forum_hastag_tag e2
WHERE e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_person person0, r_tag tag0, r_forum forum0, seg1
where Person0.gender = $gender and Forum0.creationDate > $forumDate and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.fid = Forum0.id and neo4j2.plid = seg1.plid
group by Tag0.name AS tagName
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS ciid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='University' and f1.type='City' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.ciid
from neo4j1, r_city city0
where City0.name <> $excludedCityName and neo4j1.ciid = City0.id
group by neo4j1.ciid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.person_id AS pid, e2.message_id AS mid, e0.org_id AS oid, e0.loc_id AS ciid
FROM place f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, filter_message2 f2, person_likes_message e2
WHERE f0.type='City' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e1.person_id and f2.id=e2.message_id
)
select Message0.browserUsed AS messageBrowser, count(DISTINCT neo4j2.pid) AS likerCount
from neo4j2, r_message message0, r_organisation organisation0, seg1
where Message0.length > $minLength and Organisation0.name <> $excludedOrganisationName and neo4j2.mid = Message0.id and neo4j2.oid = Organisation0.id and neo4j2.ciid = seg1.ciid
group by Message0.browserUsed AS messageBrowser
ORDER BY likerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS plid
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
SELECT e1.person_id AS pid, e0.org_id AS coid, e2.friend_id AS qid, e0.loc_id AS plid
FROM organisation f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, filter_person1 f2, person_knows_person e2
WHERE f0.type='Company' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.org_id and f1.id=e1.person_id and f2.id=e2.friend_id
)
select count(DISTINCT neo4j2.pid) AS employeeCount, Person0.gender AS friendGender
from neo4j2, r_person person0, r_company company0, seg1
where Company0.name <> $excludedCompanyName and Person0.browserUsed = $browser and neo4j2.qid = Person0.id and neo4j2.coid = Company0.id and neo4j2.plid = seg1.plid
group by Person0.gender AS friendGender
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
select count(DISTINCT neo4j2.authorid) AS authorCount, Person0.browserUsed AS browser
from neo4j2, r_person person0, seg1
where Person0.gender = $gender and neo4j2.friendid = Person0.id and neo4j2.authorid = seg1.authorid
group by Person0.browserUsed AS browser
ORDER BY authorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tagid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tagid, max(Post0.creationDate) AS latestPostDate
from neo4j1, r_tag tag0, r_post post0
where Tag0.name = $tagName and neo4j1.tagid = Tag0.id and neo4j1.poid = Post0.id
group by neo4j1.tagid
ORDER BY latestPostDate DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select count(DISTINCT neo4j2.tagid) AS tagCount, Person0.locationIP AS locationIP
from neo4j2, r_person person0, seg1
where Person0.birthday < $birthdayBefore and neo4j2.personid = Person0.id and neo4j2.tagid = seg1.tagid
group by Person0.locationIP AS locationIP
ORDER BY tagCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.person_id AS personid, e0.message_id AS commentid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, place f5, person_islocatedin_place e2
WHERE f1.type='Post' and f3.type='Comment' and f5.type='City' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id and f4.id=e1.person_id and f5.id=e2.loc_id
),
seg1 AS (
select neo4j1.personid, min(Comment0.creationDate) AS firstReplyDate
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
select University0.name AS university, count(DISTINCT neo4j2.personid) AS personCount
from neo4j2, r_university university0, seg1
where University0.name <> $excludedUniversity and neo4j2.universityid = University0.id and neo4j2.personid = seg1.personid
group by University0.name AS university
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
SELECT e0.person_id AS memberid, e0.forum_id AS forumid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0
WHERE f0.id=e0.forum_id and f1.id=e0.person_id
)
select count(DISTINCT neo4j2.forumid) AS forumCount, Person0.gender AS gender
from neo4j2, r_person person0, seg1
where Person0.browserUsed = $browser and neo4j2.memberid = Person0.id and neo4j2.forumid = seg1.forumid
group by Person0.gender AS gender
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
SELECT e0.org_id AS universityid, e0.loc_id AS placeid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='University' and f0.id=e0.org_id
)
select University0.name AS university, count(DISTINCT neo4j2.placeid) AS placeCount
from neo4j2, r_university university0, seg1
where University0.name <> $excludedUniversity and neo4j2.universityid = University0.id and neo4j2.placeid = seg1.placeid
group by University0.name AS university
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
SELECT e1.tag_id AS tid, e0.person_id AS pid, e0.message_id AS poid
FROM filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0, message_hastag_tag e1
WHERE f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Tag0.name, count(DISTINCT neo4j2.pid) AS alumniCount
from neo4j2, r_post post0, r_tag tag0, seg1
where Post0.length > $length and Post0.creationDate > $postDate and neo4j2.poid = Post0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS plid
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
select count(DISTINCT neo4j2.pid) AS workerCount, Person0.gender, Company0.name
from neo4j2, r_person person0, r_company company0, seg1
where Person0.birthday < $birthday and Company0.name <> $excludedCompany and neo4j2.pid = Person0.id and neo4j2.coid = Company0.id and neo4j2.plid = seg1.plid
group by Person0.gender, Company0.name;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS plid
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
select Comment0.browserUsed, Country0.name, count(DISTINCT neo4j2.cmid) AS commentCount
from neo4j2, r_country country0, r_comment comment0, seg1
where Country0.name <> $excludedCountry and Comment0.length > $length and neo4j2.coid = Country0.id and neo4j2.cmid = Comment0.id and neo4j2.plid = seg1.plid
group by Comment0.browserUsed, Country0.name;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS ciid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='University' and f1.type='City' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select count(neo4j1.uid) AS c, neo4j1.ciid
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
select Tag0.name, Person0.browserUsed, count(DISTINCT neo4j2.pid) AS residentCount
from neo4j2, r_tag tag0, r_person person0, seg1
where Person0.gender = $gender and Tag0.name <> $excludedTag and neo4j2.tid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.ciid = seg1.ciid
group by Tag0.name, Person0.browserUsed;
WITH neo4j1 AS (
SELECT e0.company_id AS coid, e0.person_id AS pid, e1.message_id AS poid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0, filter_post2 f2, message f3, message_hascreator_person e1, message_hastag_tag e2
WHERE f0.type='Company' and f3.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.company_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select neo4j1.pid, count(neo4j1.poid) AS c
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
select Person0.firstName AS firstName, Person0.lastName AS lastName, Comment0.creationDate AS commentCreationDate, Tag0.name AS replyTagName
from neo4j2, r_tag tag0, r_person person0, r_comment comment0, seg1
where Comment0.length > $length and neo4j2.rtid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.cmid = Comment0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.org_id AS coid, e2.person_id AS pid, e1.message_id AS mid
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
SELECT e1.post_id AS postid, e2.tag_id AS tagid, e0.forum_id AS foid, e0.person_id AS pid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmember_person e0, filter_post2 f2, message f3, forum_containerof_message e1, message_hastag_tag e2
WHERE f3.type='Post' and e0.forum_id=e1.forum_id and e1.post_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.forum_id and f2.id=e1.post_id and f3.id=e1.post_id
)
select Forum0.title AS forumTitle, Person0.firstName AS firstName, Person0.lastName AS lastName, Post0.creationDate AS postCreationDate, Tag0.name AS postTagName
from neo4j2, r_person person0, r_tag tag0, r_forum forum0, r_post post0, seg1
where Forum0.creationDate > $forumDate and neo4j2.pid = Person0.id and neo4j2.tagid = Tag0.id and neo4j2.foid = Forum0.id and neo4j2.postid = Post0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e2.tagclass_id AS tcid, e0.company_id AS coid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE f0.type='Company' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.tid
from neo4j1, r_tagclass tagclass0, r_company company0
where TagClass0.name = $tagClassName and Company0.name = $companyName and neo4j1.tcid = TagClass0.id and neo4j1.coid = Company0.id
group by neo4j1.tid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e2.loc_id AS cityid, e0.forum_id AS foid, e1.person_id AS modid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_person1 f1, forum_hasmoderator_person e1, place f2, person_islocatedin_place e2
WHERE f2.type='City' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.forum_id and f1.id=e1.person_id and f2.id=e2.loc_id
)
select Forum0.title AS forumTitle, City0.name AS moderatorCityName, Person0.firstName AS moderatorFirstName, Tag0.name AS tagName, Person0.lastName AS moderatorLastName
from neo4j2, r_person person0, r_city city0, r_forum forum0, r_tag tag0, seg1
where Person0.gender = $gender and neo4j2.modid = Person0.id and neo4j2.cityid = City0.id and neo4j2.foid = Forum0.id and neo4j2.tid = Tag0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e0.loc_id AS countryid, e0.org_id AS coid, e2.person_id AS pid
FROM organisation f0, place f1, organisation_islocatedin_place e0, place f2, place_ispartof_place e1, filter_person1 f3, person_islocatedin_place e2
WHERE f0.type='Company' and f1.type='Country' and f2.type='City' and e0.loc_id=e1.reg_id and e1.subreg_id=e2.loc_id and f0.id=e0.org_id and f1.id=e0.loc_id and f2.id=e1.subreg_id and f3.id=e2.person_id
),
seg1 AS (
select neo4j1.countryid, count(neo4j1.pid) AS c
from neo4j1, r_person person0, r_company company0
where Person0.gender = $gender and Company0.name <> $excludedCompanyName and neo4j1.pid = Person0.id and neo4j1.coid = Company0.id
group by neo4j1.countryid
ORDER BY c DESC, 1, 2
LIMIT 56
),
neo4j2 AS (
SELECT e1.person_id AS personid, e0.reg_id AS countryid, e2.message_id AS postid, e0.subreg_id AS homeid
FROM place f0, place f1, place_ispartof_place e0, filter_person1 f2, person_islocatedin_place e1, filter_post2 f3, message f4, person_likes_message e2
WHERE f0.type='Country' and f1.type='City' and f4.type='Post' and e0.subreg_id=e1.loc_id and e1.person_id=e2.person_id and f0.id=e0.reg_id and f1.id=e0.subreg_id and f2.id=e1.person_id and f3.id=e2.message_id and f4.id=e2.message_id
)
select Post0.content AS likedPostContent, Country0.name AS countryName, City0.name AS cityName, Person0.firstName AS personFirstName, Person0.lastName AS personLastName
from neo4j2, r_country country0, r_post post0, r_city city0, r_person person0, seg1
where Post0.creationDate > $postDate and neo4j2.countryid = Country0.id and neo4j2.postid = Post0.id and neo4j2.homeid = City0.id and neo4j2.personid = Person0.id and neo4j2.countryid = seg1.countryid;
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
SELECT e1.message_id AS cmid, e0.post_id AS postid, e2.person_id AS authorid, e0.forum_id AS foid
FROM filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, filter_comment2 f3, message f4, message_replyof_message e1, filter_person1 f5, message_hascreator_person e2
WHERE f2.type='Post' and f4.type='Comment' and e0.post_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.message_id and f4.id=e1.message_id and f5.id=e2.person_id
)
select Forum0.title AS forumTitle, Person0.firstName AS authorFirstName, Post0.content AS postContent, Comment0.content AS commentContent, Person0.lastName AS authorLastName
from neo4j2, r_post post0, r_forum forum0, r_person person0, r_comment comment0, seg1
where Comment0.length > $commentLength and neo4j2.postid = Post0.id and neo4j2.foid = Forum0.id and neo4j2.authorid = Person0.id and neo4j2.cmid = Comment0.id and neo4j2.foid = seg1.foid;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.message_id AS cmid, e0.person_id AS pid, e2.tagclass_id AS tcid
FROM filter_comment2 f0, message f1, filter_person1 f2, message_hascreator_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE f1.type='Comment' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmid) AS c, neo4j1.pid
from neo4j1, r_comment comment0, r_tagclass tagclass0
where Comment0.length > $minCommentLength and TagClass0.name = $tagClassName and neo4j1.cmid = Comment0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.pid
) b1
where c > 20
),
neo4j2 AS (
SELECT e1.loc_id AS plid, e0.company_id AS coid, e0.person_id AS pid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0, organisation_islocatedin_place e1
WHERE f1.type='Company' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id
)
select Company0.name AS companyName, count(DISTINCT neo4j2.pid) AS personCount, Place0.name AS placeName
from neo4j2, r_company company0, r_place place0, seg1
where Place0.name = $workPlaceName and neo4j2.coid = Company0.id and neo4j2.plid = Place0.id and neo4j2.pid = seg1.pid
group by Company0.name AS companyName, Place0.name AS placeName;
WITH neo4j1 AS (
SELECT e2.loc_id AS ciid, e0.message_id AS cmid, e1.person_id AS pid
FROM filter_comment2 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, place f5, person_islocatedin_place e2
WHERE f1.type='Comment' and f3.type='Post' and f5.type='City' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id and f5.id=e2.loc_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmid) AS c, neo4j1.pid
from neo4j1, r_city city0, r_comment comment0
where Comment0.creationDate > $commentSince and City0.name = $creatorCityName and neo4j1.ciid = City0.id and neo4j1.cmid = Comment0.id
group by neo4j1.pid
) b1
where c > 20
),
neo4j2 AS (
SELECT e1.tag_id AS tid, e0.forum_id AS foid, e0.person_id AS pid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmoderator_person e0, forum_hastag_tag e1
WHERE e0.forum_id=e1.forum_id and f0.id=e0.person_id and f1.id=e0.forum_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.foid) AS forumCount
from neo4j2, r_tag tag0, r_forum forum0, seg1
where Forum0.creationDate > $forumSince and Tag0.name <> $excludedTagName and neo4j2.tid = Tag0.id and neo4j2.foid = Forum0.id and neo4j2.pid = seg1.pid
group by Tag0.name AS tagName;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.tag_id AS parentid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Comment' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmid) AS c, neo4j1.tid
from neo4j1, r_comment comment0, r_tagclass tagclass0
where Comment0.length < $maxCommentLength and TagClass0.name = $parentClassName and neo4j1.cmid = Comment0.id and neo4j1.parentid = TagClass0.id
group by neo4j1.tid
) b1
where c > 20
),
neo4j2 AS (
SELECT e1.person_id AS pid, e0.forum_id AS foid, e0.tag_id AS tid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_person1 f1, forum_hasmember_person e1
WHERE e0.forum_id=e1.forum_id and f0.id=e0.forum_id and f1.id=e1.person_id
)
select Person0.browserUsed AS browserUsed, count(DISTINCT neo4j2.foid) AS forumCount
from neo4j2, r_person person0, r_forum forum0, seg1
where Forum0.creationDate > $forumSince and Person0.gender = $memberGender and neo4j2.pid = Person0.id and neo4j2.foid = Forum0.id and neo4j2.tid = seg1.tid
group by Person0.browserUsed AS browserUsed;
WITH neo4j1 AS (
SELECT e2.university_id AS uid, e0.message_id AS cmid, e0.replied_message_id AS pcid
FROM filter_comment2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, organisation f5, person_studyat_organisation e2
WHERE f1.type='Comment' and f3.type='Comment' and f5.type='University' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id and f5.id=e2.university_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.cmid) AS c, neo4j1.uid
from neo4j1, r_comment comment0, r_comment comment1
where Comment1.creationDate > $parentCommentSince and Comment0.length > $replyLength and neo4j1.cmid = Comment0.id and neo4j1.pcid = Comment1.id
group by neo4j1.uid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.person_id AS sid, e1.message_id AS mid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, filter_message2 f2, person_likes_message e1
WHERE f0.type='University' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.message_id
)
select Person0.gender AS gender, Message0.browserUsed AS browserUsed, count(DISTINCT neo4j2.sid) AS likerCount
from neo4j2, r_message message0, r_person person0, seg1
where Person0.birthday < $birthdayBefore and Message0.length > $likedMessageLength and neo4j2.mid = Message0.id and neo4j2.sid = Person0.id and neo4j2.uid = seg1.uid
group by Person0.gender AS gender, Message0.browserUsed AS browserUsed;
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
select Post0.browserUsed AS browserUsed, Tag0.name AS tagName, count(DISTINCT neo4j2.pid) AS likerCount
from neo4j2, r_post post0, r_tag tag0, seg1
where Post0.creationDate > $postSince and Tag0.name = $likedTagName and neo4j2.poid = Post0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid
group by Post0.browserUsed AS browserUsed, Tag0.name AS tagName;
WITH neo4j1 AS (
SELECT e0.org_id AS companyid, e0.loc_id AS countryid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select neo4j1.countryid, count(neo4j1.companyid) AS c
from neo4j1, r_company company0
where Company0.name <> $companyName and neo4j1.companyid = Company0.id
group by neo4j1.countryid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.person_id AS personid, e0.loc_id AS countryid, e0.message_id AS postid, e2.tag_id AS tagid
FROM place f0, filter_post2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, person_hasinterest_tag e2
WHERE f0.type='Country' and f2.type='Post' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select Tag0.name, Person0.firstName, Post0.content, Post0.length, Person0.lastName, Country0.name
from neo4j2, r_country country0, r_post post0, r_person person0, r_tag tag0, seg1
where Tag0.name = $tagName and Post0.creationDate > $postDate and neo4j2.countryid = Country0.id and neo4j2.postid = Post0.id and neo4j2.personid = Person0.id and neo4j2.tagid = Tag0.id and neo4j2.countryid = seg1.countryid;
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
SELECT e1.message_id AS messageid, e0.loc_id AS placeid, e2.tag_id AS tagid, e0.org_id AS companyid
FROM organisation f0, organisation_islocatedin_place e0, filter_message2 f1, message_islocatedin_place e1, message_hastag_tag e2
WHERE f0.type='Company' and e0.loc_id=e1.loc_id and e1.message_id=e2.message_id and f0.id=e0.org_id and f1.id=e1.message_id
)
select Tag0.name, Company0.name, Message0.content, Message0.length, Place0.name
from neo4j2, r_company company0, r_tag tag0, r_message message0, r_place place0, seg1
where Tag0.name = $tagName and Message0.length > $messageLength and neo4j2.companyid = Company0.id and neo4j2.tagid = Tag0.id and neo4j2.messageid = Message0.id and neo4j2.placeid = Place0.id and neo4j2.companyid = seg1.companyid;
WITH neo4j1 AS (
SELECT e0.org_id AS companyid, e0.loc_id AS placeid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='Company' and f0.id=e0.org_id
),
seg1 AS (
select * from (
select count(neo4j1.companyid) AS c, neo4j1.placeid
from neo4j1, r_company company0
where Company0.name <> $excludedCompanyName and neo4j1.companyid = Company0.id
group by neo4j1.placeid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.loc_id AS placeid, e1.forum_id AS forumid, e2.tag_id AS tagid
FROM filter_person1 f0, person_islocatedin_place e0, filter_forum2 f1, forum_hasmember_person e1, forum_hastag_tag e2
WHERE e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id
)
select Tag0.name, Person0.firstName, Forum0.title, Person0.lastName, Place0.name
from neo4j2, r_person person0, r_forum forum0, r_tag tag0, r_place place0, seg1
where Person0.gender = $gender and Tag0.name = $tagName and Forum0.creationDate > $forumDate and neo4j2.personid = Person0.id and neo4j2.forumid = Forum0.id and neo4j2.tagid = Tag0.id and neo4j2.placeid = Place0.id and neo4j2.placeid = seg1.placeid;
WITH neo4j1 AS (
SELECT e0.org_id AS companyid, e0.loc_id AS countryid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select * from (
select neo4j1.countryid, count(neo4j1.companyid) AS c
from neo4j1, r_company company0
where Company0.name = $companyName and neo4j1.companyid = Company0.id
group by neo4j1.countryid
) b1
where c > 10
),
neo4j2 AS (
SELECT e2.university_id AS universityid, e0.loc_id AS countryid, e1.person_id AS authorid, e0.message_id AS commentid
FROM place f0, filter_comment2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, organisation f4, person_studyat_organisation e2
WHERE f0.type='Country' and f2.type='Comment' and f4.type='University' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id and f4.id=e2.university_id
)
select Comment0.content, Comment0.length, Person0.firstName, University0.name, Person0.lastName, Country0.name
from neo4j2, r_university university0, r_comment comment0, r_country country0, r_person person0, seg1
where University0.name = $universityName and Comment0.creationDate < $commentDate and neo4j2.universityid = University0.id and neo4j2.commentid = Comment0.id and neo4j2.countryid = Country0.id and neo4j2.authorid = Person0.id and neo4j2.countryid = seg1.countryid;
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
from neo4j2, r_person person0, r_post post0, r_tag tag0, seg1
where Person0.gender = $gender and Post0.creationDate > $postDate and neo4j2.pid = Person0.id and neo4j2.poid = Post0.id and neo4j2.tid = Tag0.id and neo4j2.coid = seg1.coid
group by Tag0.name AS tagName;
WITH neo4j1 AS (
SELECT e0.loc_id AS coid, e0.org_id AS compid
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
SELECT e0.message_id AS cmid, e2.company_id AS orgid, e1.person_id AS pid, e0.loc_id AS coid
FROM place f0, filter_comment2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, person_workat_organisation e2
WHERE f0.type='Country' and f2.type='Comment' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select Person0.browserUsed AS browserUsed, Organisation0.name AS organisationName, count(DISTINCT neo4j2.cmid) AS commentCount
from neo4j2, r_comment comment0, r_organisation organisation0, r_person person0, seg1
where Comment0.length > $minCommentLength and Person0.browserUsed = $browser and neo4j2.cmid = Comment0.id and neo4j2.orgid = Organisation0.id and neo4j2.pid = Person0.id and neo4j2.coid = seg1.coid
group by Person0.browserUsed AS browserUsed, Organisation0.name AS organisationName;
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
select count(DISTINCT neo4j2.cmid) AS replyCount, Tag0.name AS tagName
from neo4j2, r_comment comment0, r_tag tag0, seg1
where Comment0.creationDate > $commentDate and Tag0.name <> $excludedTag and neo4j2.cmid = Comment0.id and neo4j2.tid = Tag0.id and neo4j2.coid = seg1.coid
group by Tag0.name AS tagName;
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
SELECT e2.forum_id AS fid, e0.org_id AS orgid, e1.person_id AS pid, e0.loc_id AS coid
FROM place f0, organisation_islocatedin_place e0, filter_person1 f1, person_studyat_organisation e1, filter_forum2 f2, forum_hasmember_person e2
WHERE f0.type='Country' and e0.org_id=e1.university_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e1.person_id and f2.id=e2.forum_id
)
select Forum0.title AS forumTitle, count(DISTINCT neo4j2.pid) AS studentMemberCount, Organisation0.name AS organisationName
from neo4j2, r_organisation organisation0, r_forum forum0, r_person person0, seg1
where Forum0.creationDate > $forumDate and Person0.birthday < $birthdayCutoff and neo4j2.orgid = Organisation0.id and neo4j2.fid = Forum0.id and neo4j2.pid = Person0.id and neo4j2.coid = seg1.coid
group by Forum0.title AS forumTitle, Organisation0.name AS organisationName;
WITH neo4j1 AS (
SELECT e0.subreg_id AS plid, e0.reg_id AS coid
FROM place f0, place_ispartof_place e0
WHERE f0.type='Country' and f0.id=e0.reg_id
),
seg1 AS (
select count(neo4j1.plid) AS c, neo4j1.coid
from neo4j1, r_place place0
where Place0.name <> $excludedPlace and neo4j1.plid = Place0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 56
),
neo4j2 AS (
SELECT e0.message_id AS msgid, e2.forum_id AS fid, e1.person_id AS pid, e0.loc_id AS coid
FROM place f0, filter_message2 f1, message_islocatedin_place e0, filter_person1 f2, person_likes_message e1, filter_forum2 f3, forum_hasmoderator_person e2
WHERE f0.type='Country' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.forum_id
)
select Forum0.title AS forumTitle, count(DISTINCT neo4j2.msgid) AS likedMessageCount, Person0.browserUsed AS browserUsed
from neo4j2, r_forum forum0, r_message message0, r_person person0, seg1
where Forum0.title <> $excludedForumTitle and Message0.length > $minLikedMessageLength and neo4j2.fid = Forum0.id and neo4j2.msgid = Message0.id and neo4j2.pid = Person0.id and neo4j2.coid = seg1.coid
group by Forum0.title AS forumTitle, Person0.browserUsed AS browserUsed;
TODO;
TODO;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e2.tag_id AS tid, e0.person_id AS authorid, e1.forum_id AS foid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, filter_forum2 f3, forum_hasmember_person e1, forum_hastag_tag e2
WHERE f1.type='Post' and e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.forum_id
),
seg1 AS (
select * from (
select count(neo4j1.foid) AS c, neo4j1.authorid
from neo4j1, r_tag tag0, r_post post0
where Post0.creationDate > $postDate and Tag0.name = $tagName and neo4j1.tid = Tag0.id and neo4j1.poid = Post0.id
group by neo4j1.authorid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.friend_id AS friendid, e0.person_id AS authorid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0
WHERE f0.id=e0.person_id and f1.id=e0.friend_id
)
select count(DISTINCT neo4j2.authorid) AS authorCount, Person0.browserUsed AS browser
from neo4j2, r_person person0, seg1
where Person0.gender = $gender and neo4j2.friendid = Person0.id and neo4j2.authorid = seg1.authorid
group by Person0.browserUsed AS browser
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
SELECT e0.person_id AS workerid, e0.message_id AS msgid
FROM filter_person1 f0, filter_message2 f1, person_likes_message e0
WHERE f0.id=e0.person_id and f1.id=e0.message_id
)
select count(DISTINCT neo4j2.workerid) AS workerCount, Message0.browserUsed AS browser
from neo4j2, r_message message0, seg1
where Message0.length > $likedMinLength and neo4j2.msgid = Message0.id and neo4j2.workerid = seg1.workerid
group by Message0.browserUsed AS browser
ORDER BY workerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.tagclass_id AS tcid, e1.tag_id AS tagid, e0.message_id AS comid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE f1.type='Post' and f3.type='Comment' and e0.message_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id
),
seg1 AS (
select * from (
select neo4j1.tagid, count(neo4j1.comid) AS c
from neo4j1, r_tagclass tagclass0, r_comment comment0
where TagClass0.name = $className and Comment0.creationDate > $commentDate and neo4j1.tcid = TagClass0.id and neo4j1.comid = Comment0.id
group by neo4j1.tagid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select count(DISTINCT neo4j2.tagid) AS tagCount, Person0.locationIP AS locationIP
from neo4j2, r_person person0, seg1
where Person0.birthday < $birthday and neo4j2.personid = Person0.id and neo4j2.tagid = seg1.tagid
group by Person0.locationIP AS locationIP
ORDER BY tagCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.university_id AS uniid, e0.forum_id AS foid, e0.post_id AS poid, e1.person_id AS modid
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
SELECT e0.person_id AS modid, e0.company_id AS compid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0
WHERE f1.type='Company' and f0.id=e0.person_id and f1.id=e0.company_id
)
select count(DISTINCT neo4j2.modid) AS moderatorCount, Company0.name AS company
from neo4j2, r_company company0, seg1
where Company0.name <> $companyName and neo4j2.compid = Company0.id and neo4j2.modid = seg1.modid
group by Company0.name AS company
ORDER BY moderatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.person_id AS personid, e2.loc_id AS cityid, e0.tag_id AS tagid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_person1 f2, person_hasinterest_tag e1, place f3, person_islocatedin_place e2
WHERE f1.type='Post' and f3.type='City' and e0.tag_id=e1.tag_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.loc_id
),
seg1 AS (
select * from (
select count(DISTINCT neo4j1.personid) AS c, neo4j1.cityid
from neo4j1, r_tag tag0, r_post post0
where Tag0.name = $tagName and Post0.length > $minPostLength and neo4j1.tagid = Tag0.id and neo4j1.poid = Post0.id
group by neo4j1.cityid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.subreg_id AS cityid, e0.reg_id AS countryid
FROM place f0, place f1, place_ispartof_place e0
WHERE f0.type='City' and f1.type='Country' and f0.id=e0.subreg_id and f1.id=e0.reg_id
)
select Country0.name AS country, count(DISTINCT neo4j2.cityid) AS cityCount
from neo4j2, r_country country0, seg1
where Country0.name <> $excludedCountry and neo4j2.countryid = Country0.id and neo4j2.cityid = seg1.cityid
group by Country0.name AS country
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
SELECT e1.person_id AS creatorid, e0.message_id AS p2id, e0.tag_id AS tid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_person1 f2, message_hascreator_person e1
WHERE f1.type='Post' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id
)
select count(DISTINCT neo4j2.p2id) AS postCount, Person0.gender AS gender, Person0.browserUsed AS browserUsed
from neo4j2, r_post post0, r_person person0, seg1
where Post0.length > $minPostLength and neo4j2.p2id = Post0.id and neo4j2.creatorid = Person0.id and neo4j2.tid = seg1.tid
group by Person0.gender AS gender, Person0.browserUsed AS browserUsed;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS cid
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
select count(DISTINCT neo4j2.c2id) AS commentCount, Country0.name AS countryName
from neo4j2, r_country country0, r_comment comment0, seg1
where Comment0.length > $minCommentLength and neo4j2.countryid = Country0.id and neo4j2.c2id = Comment0.id and neo4j2.tid = seg1.tid
group by Country0.name AS countryName;
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
select count(DISTINCT neo4j2.m2id) AS replyCount, Post0.browserUsed AS parentBrowser, Post0.locationIP AS parentLocationIP
from neo4j2, r_post post0, r_message message0, seg1
where Message0.length > $minMessageLength and neo4j2.parentid = Post0.id and neo4j2.m2id = Message0.id and neo4j2.tid = seg1.tid
group by Post0.browserUsed AS parentBrowser, Post0.locationIP AS parentLocationIP;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.university_id AS uid, e1.forum_id AS foid, e0.person_id AS pid
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
SELECT e0.tag_id AS tid, e0.person_id AS pid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select count(DISTINCT neo4j2.pid) AS qualifiedPersonCount, Tag0.name AS interestName
from neo4j2, r_tag tag0, seg1
where Tag0.name <> $excludedTagName and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name AS interestName
ORDER BY qualifiedPersonCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e1.company_id AS coid
FROM organisation f0, person_studyat_organisation e0, organisation f1, person_workat_organisation e1
WHERE f0.type='University' and f1.type='Company' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e1.company_id
),
seg1 AS (
select * from (
select count(neo4j1.pid) AS c, neo4j1.coid
from neo4j1, r_person person0, r_company company0
where Person0.birthday > $birthday and Company0.name <> $excludedCompanyName and neo4j1.pid = Person0.id and neo4j1.coid = Company0.id
group by neo4j1.coid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.loc_id AS countryid, e0.org_id AS coid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
)
select Country0.name AS countryName, count(DISTINCT neo4j2.coid) AS companyCount
from neo4j2, r_country country0, seg1
where Country0.name <> $excludedCountryName and neo4j2.countryid = Country0.id and neo4j2.coid = seg1.coid
group by Country0.name AS countryName
ORDER BY companyCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.org_id AS uid, e0.loc_id AS cityid, e1.org_id AS orgid
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
group by Person0.browserUsed AS browser
ORDER BY workerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e1.message_id AS cmtid, e0.university_id AS uid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, filter_comment2 f2, message f3, message_hascreator_person e1
WHERE f0.type='University' and f3.type='Comment' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(neo4j1.cmtid) AS c
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
group by Post0.browserUsed AS browser
ORDER BY likerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e1.forum_id AS fid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_forum2 f2, forum_containerof_message e1
WHERE f1.type='Post' and e0.message_id=e1.post_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.forum_id
),
seg1 AS (
select count(neo4j1.poid) AS c, neo4j1.fid
from neo4j1, r_post post0, r_tag tag0
where Tag0.name = $tag and Post0.creationDate > $postDate and neo4j1.poid = Post0.id and neo4j1.tid = Tag0.id
group by neo4j1.fid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e2.loc_id AS countryid, e1.company_id AS coid, e0.person_id AS mdid, e0.forum_id AS fid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0, organisation f2, person_workat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE f2.type='Company' and f3.type='Country' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.company_id and f3.id=e2.loc_id
)
select Person0.browserUsed AS moderatorBrowser, Country0.name AS countryName, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_company company0, r_person person0, r_country country0, seg1
where Person0.gender = $gender and Company0.name <> $companyName and neo4j2.coid = Company0.id and neo4j2.mdid = Person0.id and neo4j2.countryid = Country0.id and neo4j2.fid = seg1.fid
group by Person0.browserUsed AS moderatorBrowser, Country0.name AS countryName;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e1.message_id AS cmid, e0.person_id AS pid
FROM filter_person1 f0, person_hasinterest_tag e0, filter_comment2 f1, message f2, message_hascreator_person e1
WHERE f2.type='Comment' and e0.person_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e1.message_id
),
seg1 AS (
select neo4j1.pid, count(neo4j1.cmid) AS c
from neo4j1, r_comment comment0, r_tag tag0
where Tag0.name = $tag and Comment0.length > $minLength and neo4j1.cmid = Comment0.id and neo4j1.tid = Tag0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e2.loc_id AS coid, e0.person_id AS pid, e1.message_id AS poid, e0.friend_id AS frid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0, filter_post2 f2, message f3, person_likes_message e1, place f4, message_islocatedin_place e2
WHERE f3.type='Post' and f4.type='Country' and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.loc_id
)
select Country0.name AS countryName, Person0.browserUsed AS friendBrowser, count(DISTINCT neo4j2.pid) AS personCount
from neo4j2, r_person person0, r_post post0, r_country country0, seg1
where Person0.gender = $gender and Post0.creationDate > $likedPostDate and neo4j2.frid = Person0.id and neo4j2.poid = Post0.id and neo4j2.coid = Country0.id and neo4j2.pid = seg1.pid
group by Country0.name AS countryName, Person0.browserUsed AS friendBrowser;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.tagclass_id AS tcid, e1.tag_id AS rtid
FROM tag_hastype_tagclass e0, tag_hastype_tagclass e1
WHERE e0.tagclass_id=e1.tagclass_id
),
seg1 AS (
select neo4j1.rtid, count(neo4j1.tcid) AS c
from neo4j1, r_tag tag0, r_tag tag1
where Tag1.name = $tag and Tag0.name <> $excludedTag and neo4j1.rtid = Tag0.id and neo4j1.tid = Tag1.id
group by neo4j1.rtid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e2.loc_id AS cityid, e1.person_id AS creatorid, e0.message_id AS mid, e0.tag_id AS rtid
FROM filter_message2 f0, message_hastag_tag e0, filter_person1 f1, message_hascreator_person e1, place f2, person_islocatedin_place e2
WHERE f2.type='City' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e1.person_id and f2.id=e2.loc_id
)
select City0.name AS cityName, count(DISTINCT neo4j2.mid) AS messageCount, Person0.browserUsed AS creatorBrowser
from neo4j2, r_person person0, r_message message0, r_city city0, seg1
where Message0.length > $minMessageLength and Person0.gender = $gender and neo4j2.creatorid = Person0.id and neo4j2.mid = Message0.id and neo4j2.cityid = City0.id and neo4j2.rtid = seg1.rtid
group by City0.name AS cityName, Person0.browserUsed AS creatorBrowser;
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
SELECT e0.university_id AS uid, e1.loc_id AS cityid, e2.reg_id AS countryid, e0.person_id AS pid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE f1.type='University' and f2.type='City' and f3.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.reg_id
)
select count(DISTINCT neo4j2.pid) AS memberCount, Country0.name AS countryName, University0.name AS universityName
from neo4j2, r_city city0, r_university university0, r_country country0, seg1
where City0.name <> $cityName and University0.name <> $universityName and neo4j2.cityid = City0.id and neo4j2.uid = University0.id and neo4j2.countryid = Country0.id and neo4j2.pid = seg1.pid
group by Country0.name AS countryName, University0.name AS universityName;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS cmid, e1.replied_message_id AS poid
FROM filter_comment2 f0, message f1, message_hastag_tag e0, filter_post2 f2, message f3, message_replyof_message e1
WHERE f1.type='Comment' and f3.type='Post' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.replied_message_id and f3.id=e1.replied_message_id
),
seg1 AS (
select count(neo4j1.cmid) AS c, neo4j1.poid
from neo4j1, r_tag tag0, r_comment comment0
where Tag0.name = $tag and Comment0.creationDate > $commentDate and neo4j1.tid = Tag0.id and neo4j1.cmid = Comment0.id
group by neo4j1.poid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e2.loc_id AS plid, e0.person_id AS authorid, e1.company_id AS orgid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, person_workat_organisation e1, organisation_islocatedin_place e2
WHERE f1.type='Post' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
)
select Place0.name AS placeName, Person0.gender AS authorGender, count(DISTINCT neo4j2.poid) AS postCount
from neo4j2, r_person person0, r_organisation organisation0, r_place place0, seg1
where Organisation0.name <> $organisationName and Person0.browserUsed = $browser and neo4j2.authorid = Person0.id and neo4j2.orgid = Organisation0.id and neo4j2.plid = Place0.id and neo4j2.poid = seg1.poid
group by Place0.name AS placeName, Person0.gender AS authorGender;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e1.tagclass_id AS tcid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tid, count(neo4j1.poid) AS c
from neo4j1, r_post post0, r_tagclass tagclass0
where Post0.creationDate > $postDate and TagClass0.name = $tagClass and neo4j1.poid = Post0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.tid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e0.person_id AS personid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Tag0.name, Person0.lastName, Person0.browserUsed, Person0.firstName
from neo4j2, r_tag tag0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.tid = Tag0.id and neo4j2.personid = Person0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e2.reg_id AS countryid, e0.person_id AS authorid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, place f3, person_islocatedin_place e1, place f4, place_ispartof_place e2
WHERE f1.type='Post' and f3.type='City' and f4.type='Country' and e0.person_id=e1.person_id and e1.loc_id=e2.subreg_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.loc_id and f4.id=e2.reg_id
),
seg1 AS (
select neo4j1.authorid, count(neo4j1.poid) AS c
from neo4j1, r_post post0, r_country country0
where Post0.length > $minLength and Country0.name = $country and neo4j1.poid = Post0.id and neo4j1.countryid = Country0.id
group by neo4j1.authorid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS authorid, e0.company_id AS companyid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0
WHERE f1.type='Company' and f0.id=e0.person_id and f1.id=e0.company_id
)
select Company0.name, Person0.lastName, Person0.browserUsed, Person0.firstName
from neo4j2, r_person person0, r_company company0, seg1
where Company0.name = $companyName and neo4j2.authorid = Person0.id and neo4j2.companyid = Company0.id and neo4j2.authorid = seg1.authorid;
WITH neo4j1 AS (
SELECT e2.tag_id AS tagid, e0.post_id AS poid, e0.forum_id AS forumid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0, filter_person1 f3, forum_hasmember_person e1, person_hasinterest_tag e2
WHERE f1.type='Post' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id and f3.id=e1.person_id
),
seg1 AS (
select neo4j1.forumid, count(neo4j1.poid) AS c
from neo4j1, r_tag tag0, r_forum forum0
where Forum0.creationDate < $forumBefore and Tag0.name = $interestTag and neo4j1.tagid = Tag0.id and neo4j1.forumid = Forum0.id
group by neo4j1.forumid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.forum_id AS forumid, e0.person_id AS moderatorid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0
WHERE f0.id=e0.forum_id and f1.id=e0.person_id
)
select Forum0.creationDate, Person0.lastName, Forum0.title, Person0.firstName
from neo4j2, r_forum forum0, r_person person0, seg1
where Person0.browserUsed = $browser and neo4j2.forumid = Forum0.id and neo4j2.moderatorid = Person0.id and neo4j2.forumid = seg1.forumid;
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
SELECT e0.org_id AS orgid, e0.loc_id AS cityid
FROM place f0, organisation_islocatedin_place e0
WHERE f0.type='City' and f0.id=e0.loc_id
)
select City0.name, Organisation0.name
from neo4j2, r_organisation organisation0, r_city city0, seg1
where Organisation0.name = $organisationName and neo4j2.orgid = Organisation0.id and neo4j2.cityid = City0.id and neo4j2.cityid = seg1.cityid;
WITH neo4j1 AS (
SELECT e1.person_id AS personid, e2.university_id AS univid, e0.message_id AS commentid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, organisation f5, person_studyat_organisation e2
WHERE f1.type='Post' and f3.type='Comment' and f5.type='University' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id and f4.id=e1.person_id and f5.id=e2.university_id
),
seg1 AS (
select neo4j1.personid, count(neo4j1.commentid) AS c
from neo4j1, r_comment comment0, r_university university0
where University0.name = $university and Comment0.length > $minCommentLength and neo4j1.commentid = Comment0.id and neo4j1.univid = University0.id
group by neo4j1.personid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS personid, e0.message_id AS likedid
FROM filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0
WHERE f2.type='Post' and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Post0.length, Person0.lastName, Person0.firstName, Post0.content
from neo4j2, r_post post0, r_person person0, seg1
where Post0.creationDate > $likedAfter and neo4j2.likedid = Post0.id and neo4j2.personid = Person0.id and neo4j2.personid = seg1.personid;
WITH neo4j1 AS (
SELECT e0.loc_id AS ciid, e0.org_id AS uid, e1.person_id AS pid
FROM place f0, organisation f1, organisation_islocatedin_place e0, filter_person1 f2, person_studyat_organisation e1
WHERE f0.type='City' and f1.type='University' and e0.org_id=e1.university_id and f0.id=e0.loc_id and f1.id=e0.org_id and f2.id=e1.person_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.uid
from neo4j1, r_city city0, r_person person0
where City0.name = $cityName and Person0.gender = $gender and neo4j1.ciid = City0.id and neo4j1.pid = Person0.id
group by neo4j1.uid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.person_id AS alid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
)
select count(neo4j2.alid) AS alumniCount, Person0.browserUsed AS browser
from neo4j2, r_person person0, seg1
where Person0.birthday > $birthday and neo4j2.alid = Person0.id and neo4j2.uid = seg1.uid
group by Person0.browserUsed AS browser
ORDER BY alumniCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.reg_id AS coid, e0.subreg_id AS ciid, e1.org_id AS compid
FROM place f0, place f1, place_ispartof_place e0, organisation f2, organisation_islocatedin_place e1
WHERE f0.type='City' and f1.type='Country' and f2.type='Company' and e0.reg_id=e1.loc_id and f0.id=e0.subreg_id and f1.id=e0.reg_id and f2.id=e1.org_id
),
seg1 AS (
select neo4j1.coid, count(neo4j1.compid) AS c
from neo4j1, r_company company0, r_city city0
where Company0.name <> $excludedCompany and City0.name <> $excludedCity and neo4j1.compid = Company0.id and neo4j1.ciid = City0.id
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
group by Post0.browserUsed AS browser
ORDER BY postCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.loc_id AS ciid, e0.person_id AS pid, e1.message_id AS poid
FROM place f0, filter_person1 f1, person_islocatedin_place e0, filter_post2 f2, message f3, message_hascreator_person e1
WHERE f0.type='City' and f3.type='Post' and e0.person_id=e1.person_id and f0.id=e0.loc_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select neo4j1.pid, count(neo4j1.poid) AS c
from neo4j1, r_post post0, r_city city0
where City0.name = $cityName and Post0.creationDate > $postSince and neo4j1.poid = Post0.id and neo4j1.ciid = City0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e0.person_id AS pid
FROM filter_person1 f0, filter_comment2 f1, message f2, person_likes_message e0
WHERE f2.type='Comment' and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Comment0.browserUsed AS browser, count(neo4j2.cmid) AS likedCommentCount
from neo4j2, r_comment comment0, seg1
where Comment0.length > $commentLength and neo4j2.cmid = Comment0.id and neo4j2.pid = seg1.pid
group by Comment0.browserUsed AS browser
ORDER BY likedCommentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.forum_id AS foid, e1.person_id AS pid, e0.message_id AS poid
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
SELECT e0.person_id AS pid, e0.loc_id AS cityid, e2.org_id AS coid
FROM filter_person1 f0, place f1, person_islocatedin_place e0, place f2, place_ispartof_place e1, organisation f3, organisation_islocatedin_place e2
WHERE f1.type='City' and f2.type='Country' and f3.type='Company' and e0.loc_id=e1.subreg_id and e1.reg_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.loc_id and f2.id=e1.reg_id and f3.id=e2.org_id
)
select City0.name AS cityName, count(DISTINCT neo4j2.pid) AS creatorCount
from neo4j2, r_company company0, r_city city0, seg1
where Company0.name = $companyName and neo4j2.coid = Company0.id and neo4j2.cityid = City0.id and neo4j2.pid = seg1.pid
group by City0.name AS cityName
ORDER BY creatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.forum_id AS foid, e1.message_id AS mid
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
SELECT e2.loc_id AS coid, e1.message_id AS cmid, e0.forum_id AS foid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, filter_comment2 f2, message f3, person_likes_message e1, place f4, message_islocatedin_place e2
WHERE f3.type='Comment' and f4.type='Country' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.loc_id
)
select Country0.name AS countryName, count(DISTINCT neo4j2.foid) AS forumCount
from neo4j2, r_comment comment0, r_country country0, seg1
where Comment0.creationDate > $commentDate and neo4j2.cmid = Comment0.id and neo4j2.coid = Country0.id and neo4j2.foid = seg1.foid
group by Country0.name AS countryName
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS cmid, e2.person_id AS authorid
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
SELECT e2.reg_id AS coid, e0.university_id AS uid, e0.person_id AS authorid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE f1.type='University' and f2.type='City' and f3.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.reg_id
)
select count(DISTINCT neo4j2.authorid) AS authorCount, University0.name AS universityName
from neo4j2, r_university university0, r_country country0, seg1
where Country0.name = $countryName and neo4j2.uid = University0.id and neo4j2.coid = Country0.id and neo4j2.authorid = seg1.authorid
group by University0.name AS universityName
ORDER BY authorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.forum_id AS foid, e1.person_id AS modid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_person1 f1, forum_hasmoderator_person e1, place f2, person_islocatedin_place e2
WHERE f2.type='City' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.forum_id and f1.id=e1.person_id and f2.id=e2.loc_id
),
seg1 AS (
select neo4j1.modid, count(neo4j1.foid) AS c
from neo4j1, r_tag tag0, r_forum forum0
where Tag0.name = $tagName and Forum0.creationDate > $forumDate and neo4j1.tid = Tag0.id and neo4j1.foid = Forum0.id
group by neo4j1.modid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.message_id AS cmid, e2.tag_id AS replytagid, e0.person_id AS modid
FROM filter_person1 f0, filter_comment2 f1, message f2, message_hascreator_person e0, filter_message2 f3, message_replyof_message e1, message_hastag_tag e2
WHERE f2.type='Comment' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.replied_message_id
)
select count(DISTINCT neo4j2.modid) AS moderatorCount, Tag0.name AS tagName
from neo4j2, r_tag tag0, r_comment comment0, seg1
where Comment0.creationDate > $commentDate and neo4j2.replyTagid = Tag0.id and neo4j2.cmid = Comment0.id and neo4j2.modid = seg1.modid
group by Tag0.name AS tagName
ORDER BY moderatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.company_id AS cid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select max(Person0.birthday) AS birthdayRank, neo4j1.pid
from neo4j1, r_company company0, r_person person0
where Company0.name <> $excludedCompany and neo4j1.cid = Company0.id and neo4j1.pid = Person0.id
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
group by Person0.browserUsed AS browser
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
group by University0.name AS university
ORDER BY employeeCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.company_id AS cid, e0.person_id AS pid
FROM organisation f0, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id
),
seg1 AS (
select max(Person0.birthday) AS birthdayRank, neo4j1.pid
from neo4j1, r_person person0, r_company company0
where Company0.name <> $excludedCompany and neo4j1.pid = Person0.id and neo4j1.cid = Company0.id
group by neo4j1.pid
ORDER BY birthdayRank DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.loc_id AS ciid, e0.person_id AS pid
FROM place f0, person_islocatedin_place e0
WHERE f0.type='City' and f0.id=e0.loc_id
)
select City0.name AS city, count(DISTINCT neo4j2.pid) AS employeeCount
from neo4j2, r_city city0, seg1
where City0.name <> $excludedCity and neo4j2.ciid = City0.id and neo4j2.pid = seg1.pid
group by City0.name AS city
ORDER BY employeeCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, filter_person1 f2, message_hascreator_person e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(neo4j1.cmid) AS c
from neo4j1, r_comment comment0
where Comment0.length > $minCommentLength and neo4j1.cmid = Comment0.id
group by neo4j1.pid
) b1
where c > 10
),
neo4j2 AS (
SELECT e1.tag_id AS tid, e0.forum_id AS fid, e0.person_id AS pid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmember_person e0, forum_hastag_tag e1
WHERE e0.forum_id=e1.forum_id and f0.id=e0.person_id and f1.id=e0.forum_id
)
select Person0.firstName AS firstName, Person0.lastName AS lastName, Tag0.name AS tagName, Forum0.title AS forumTitle
from neo4j2, r_tag tag0, r_forum forum0, r_person person0, seg1
where Tag0.name = $tagName and Forum0.creationDate > $forumDate and neo4j2.tid = Tag0.id and neo4j2.fid = Forum0.id and neo4j2.pid = Person0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.replied_message_id AS poid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0
WHERE f1.type='Comment' and f3.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id
),
seg1 AS (
select * from (
select count(neo4j1.cmid) AS c, neo4j1.poid
from neo4j1, r_comment comment0
where Comment0.creationDate > $commentDate and neo4j1.cmid = Comment0.id
group by neo4j1.poid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.loc_id AS plid, e1.reg_id AS coid, e0.message_id AS poid
FROM filter_post2 f0, message f1, message_islocatedin_place e0, place f2, place_ispartof_place e1
WHERE f1.type='Post' and f2.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.reg_id
)
select Place0.name AS placeName, Country0.name AS countryName, Post0.content AS postContent
from neo4j2, r_country country0, r_place place0, r_post post0, seg1
where Post0.creationDate > $postDate and Country0.name = $countryName and neo4j2.coid = Country0.id and neo4j2.plid = Place0.id and neo4j2.poid = Post0.id and neo4j2.poid = seg1.poid;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS cmid
FROM filter_comment1 f0, message f1, message_hastag_tag e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select count(neo4j1.cmid) AS c, neo4j1.tid
from neo4j1, r_comment comment0
where Comment0.length < $maxCommentLength and neo4j1.cmid = Comment0.id
group by neo4j1.tid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e0.tagclass_id AS tcid, e1.tag_id AS parentid
FROM tag_hastype_tagclass e0, tagclass_issubclassof_tagclass e1
WHERE e0.tagclass_id=e1.subtag_id
)
select Tag0.name AS tagName, TagClass1.name AS parentClassName, TagClass0.name AS className
from neo4j2, r_tagclass tagclass0, r_tag tag0, r_tagclass tagclass1, seg1
where TagClass1.name <> $excludedParentClass and TagClass0.name = $tagClassName and neo4j2.tcid = TagClass0.id and neo4j2.tid = Tag0.id and neo4j2.parentid = TagClass1.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e0.loc_id AS plid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, message_islocatedin_place e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select count(neo4j1.cmid) AS c, neo4j1.plid
from neo4j1, r_comment comment0
where Comment0.creationDate < $beforeDate and neo4j1.cmid = Comment0.id
group by neo4j1.plid
) b1
where c > 20
),
neo4j2 AS (
SELECT e0.loc_id AS plid, e1.person_id AS workerid, e0.org_id AS compid
FROM organisation f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1
WHERE f0.type='Company' and e0.org_id=e1.company_id and f0.id=e0.org_id and f1.id=e1.person_id
)
select Person0.firstName AS firstName, Company0.name AS companyName, Place0.name AS placeName, Person0.lastName AS lastName
from neo4j2, r_place place0, r_person person0, r_company company0, seg1
where Company0.name <> $excludedCompanyName and Person0.browserUsed = $browser and neo4j2.plid = Place0.id and neo4j2.workerid = Person0.id and neo4j2.compid = Company0.id and neo4j2.plid = seg1.plid;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, filter_person1 f2, person_likes_message e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(neo4j1.cmid) AS c
from neo4j1, r_comment comment0
where Comment0.length >= $likedCommentLength and neo4j1.cmid = Comment0.id
group by neo4j1.pid
) b1
where c > 5
),
neo4j2 AS (
SELECT e0.university_id AS uid, e1.loc_id AS cityid, e0.person_id AS pid
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
select count(neo4j1.coid) AS c, neo4j1.plid
from neo4j1, r_company company0
where Company0.name <> $excludedCompanyName and neo4j1.coid = Company0.id
group by neo4j1.plid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e2.tag_id AS tid, e0.loc_id AS plid, e1.message_id AS poid, e0.person_id AS pid
FROM filter_person1 f0, person_islocatedin_place e0, filter_post2 f1, message f2, message_hascreator_person e1, message_hastag_tag e2
WHERE f2.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e1.message_id
)
select Place0.name AS placeName, Person0.firstName AS firstName, Post0.content AS postContent, Tag0.name AS tagName, Person0.lastName AS lastName
from neo4j2, r_tag tag0, r_place place0, r_person person0, r_post post0, seg1
where Person0.gender = $gender and Post0.creationDate > $postDate and neo4j2.tid = Tag0.id and neo4j2.plid = Place0.id and neo4j2.pid = Person0.id and neo4j2.poid = Post0.id and neo4j2.plid = seg1.plid;
WITH neo4j1 AS (
SELECT e0.org_id AS coid, e0.loc_id AS cnid
FROM organisation f0, place f1, organisation_islocatedin_place e0
WHERE f0.type='Company' and f1.type='Country' and f0.id=e0.org_id and f1.id=e0.loc_id
),
seg1 AS (
select count(neo4j1.coid) AS c, neo4j1.cnid
from neo4j1, r_company company0
where Company0.name <> $excludedCompanyName and neo4j1.coid = Company0.id
group by neo4j1.cnid
ORDER BY c DESC, 1, 2
LIMIT 22
),
neo4j2 AS (
SELECT e2.tag_id AS tid, e0.message_id AS cmid, e0.loc_id AS cnid, e1.person_id AS pid
FROM place f0, filter_comment2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1, person_hasinterest_tag e2
WHERE f0.type='Country' and f2.type='Comment' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select Tag0.name AS interestName, Country0.name AS countryName, Person0.firstName AS firstName, Person0.lastName AS lastName, Comment0.content AS commentContent
from neo4j2, r_comment comment0, r_country country0, r_tag tag0, r_person person0, seg1
where Comment0.length > $minCommentLength and Person0.browserUsed = $browserUsed and neo4j2.cmid = Comment0.id and neo4j2.cnid = Country0.id and neo4j2.tid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.cnid = seg1.cnid;
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
SELECT e2.tag_id AS tid, e0.person_id AS pid, e0.forum_id AS foid, e1.post_id AS mid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmember_person e0, filter_message2 f2, forum_containerof_message e1, message_hastag_tag e2
WHERE e0.forum_id=e1.forum_id and e1.post_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.forum_id and f2.id=e1.post_id
)
select Forum0.title AS forumTitle, Person0.firstName AS firstName, Tag0.name AS tagName, Message0.content AS messageContent, Person0.lastName AS lastName
from neo4j2, r_person person0, r_tag tag0, r_message message0, r_forum forum0, seg1
where Message0.length > $minMessageLength and Forum0.creationDate > $forumDate and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.mid = Message0.id and neo4j2.foid = Forum0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.company_id AS coid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.coid
from neo4j1, r_person person0
where Person0.gender = $employeeGender and neo4j1.pid = Person0.id
group by neo4j1.coid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.loc_id AS plid, e0.org_id AS coid, e2.person_id AS lpid, e1.message_id AS mid
FROM organisation f0, organisation_islocatedin_place e0, filter_message2 f1, message_islocatedin_place e1, filter_person1 f2, person_likes_message e2
WHERE f0.type='Company' and e0.loc_id=e1.loc_id and e1.message_id=e2.message_id and f0.id=e0.org_id and f1.id=e1.message_id and f2.id=e2.person_id
)
select Company0.name AS companyName, Place0.name AS placeName, Person0.firstName AS likerFirstName, Message0.content AS messageContent, Person0.lastName AS likerLastName
from neo4j2, r_company company0, r_place place0, r_person person0, r_message message0, seg1
where Person0.locationIP = $locationIP and Message0.creationDate > $messageDate and neo4j2.coid = Company0.id and neo4j2.plid = Place0.id and neo4j2.lpid = Person0.id and neo4j2.mid = Message0.id and neo4j2.coid = seg1.coid;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e0.forum_id AS foid, e0.person_id AS pid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1
WHERE e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id
),
seg1 AS (
select count(neo4j1.foid) AS c, neo4j1.pid
from neo4j1, r_tag tag0, r_forum forum0
where Tag0.name = $tagName and Forum0.creationDate > $forumDate and neo4j1.tid = Tag0.id and neo4j1.foid = Forum0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.university_id AS uid, e2.reg_id AS coid, e0.person_id AS pid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE f1.type='University' and f2.type='City' and f3.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.reg_id
)
select count(neo4j2.pid) AS personCount, Country0.name AS countryName, University0.name AS universityName
from neo4j2, r_country country0, r_university university0, seg1
where University0.name <> $excludedUniversity and Country0.name = $countryName and neo4j2.coid = Country0.id and neo4j2.uid = University0.id and neo4j2.pid = seg1.pid
group by Country0.name AS countryName, University0.name AS universityName;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e0.post_id AS poid
FROM filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, message_hastag_tag e1
WHERE f2.type='Post' and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id
),
seg1 AS (
select neo4j1.tid, count(neo4j1.poid) AS c
from neo4j1, r_tag tag0, r_post post0
where Post0.creationDate > $postDate and Tag0.name <> $excludedTag and neo4j1.tid = Tag0.id and neo4j1.poid = Post0.id
group by neo4j1.tid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e2.tag_id AS rootid, e1.tag_id AS superid
FROM tag_hastype_tagclass e0, tagclass_issubclassof_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.tagclass_id=e1.subtag_id and e1.tag_id=e2.subtag_id
)
select count(neo4j2.tid) AS tagCount, TagClass1.name AS superClassName, TagClass0.name AS rootClassName
from neo4j2, r_tagclass tagclass0, r_tagclass tagclass1, seg1
where TagClass1.name = $superClassName and neo4j2.rootid = TagClass0.id and neo4j2.superid = TagClass1.id and neo4j2.tid = seg1.tid
group by TagClass1.name AS superClassName, TagClass0.name AS rootClassName;
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
SELECT e1.org_id AS orgid, e2.person_id AS employeeid, e0.subreg_id AS cityid
FROM place f0, place f1, place_ispartof_place e0, organisation_islocatedin_place e1, filter_person1 f2, person_workat_organisation e2
WHERE f0.type='City' and f1.type='Country' and e0.reg_id=e1.loc_id and e1.org_id=e2.company_id and f0.id=e0.subreg_id and f1.id=e0.reg_id and f2.id=e2.person_id
)
select count(neo4j2.employeeid) AS employeeCount, Person0.gender AS employeeGender, Organisation0.name AS organisationName
from neo4j2, r_person person0, r_organisation organisation0, seg1
where Person0.browserUsed = $browser and neo4j2.employeeid = Person0.id and neo4j2.orgid = Organisation0.id and neo4j2.cityid = seg1.cityid
group by Person0.gender AS employeeGender, Organisation0.name AS organisationName;
WITH neo4j1 AS (
SELECT e0.post_id AS mid, e1.person_id AS pid
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
SELECT e0.message_id AS cmid, e2.tag_id AS tagid, e0.person_id AS pid, e1.replied_message_id AS poid
FROM filter_person1 f0, filter_comment2 f1, message f2, person_likes_message e0, filter_post2 f3, message f4, message_replyof_message e1, message_hastag_tag e2
WHERE f2.type='Comment' and f4.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.replied_message_id and f4.id=e1.replied_message_id
)
select Tag0.name AS tagName, Post0.browserUsed AS postBrowser, count(neo4j2.pid) AS likerCount
from neo4j2, r_comment comment0, r_tag tag0, r_post post0, seg1
where Comment0.creationDate > $commentDate and Tag0.name = $likedTag and neo4j2.cmid = Comment0.id and neo4j2.tagid = Tag0.id and neo4j2.poid = Post0.id and neo4j2.pid = seg1.pid
group by Tag0.name AS tagName, Post0.browserUsed AS postBrowser;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e1.tagclass_id AS tcid
FROM filter_forum2 f0, forum_hastag_tag e0, tag_hastype_tagclass e1
WHERE e0.tag_id=e1.tag_id and f0.id=e0.forum_id
),
seg1 AS (
select neo4j1.tcid, count(neo4j1.foid) AS c
from neo4j1, r_tagclass tagclass0, r_forum forum0
where TagClass0.name <> $excludedClass and Forum0.creationDate > $forumStartDate and neo4j1.tcid = TagClass0.id and neo4j1.foid = Forum0.id
group by neo4j1.tcid
ORDER BY c DESC, 1, 2
LIMIT 4
),
neo4j2 AS (
SELECT e1.message_id AS msgid, e2.loc_id AS plid, e0.tag_id AS tagid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1, message_islocatedin_place e2
WHERE e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id
)
select Tag0.name AS tagName, Place0.name AS placeName, count(neo4j2.msgid) AS messageCount
from neo4j2, r_message message0, r_tag tag0, r_place place0, seg1
where Message0.length >= $messageLength and Place0.name = $placeName and neo4j2.msgid = Message0.id and neo4j2.tagid = Tag0.id and neo4j2.plid = Place0.id and neo4j2.tcid = seg1.tcid
group by Tag0.name AS tagName, Place0.name AS placeName;
WITH neo4j1 AS (
SELECT e0.message_id AS pid, e0.person_id AS creatorid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select count(neo4j1.pid) AS c, neo4j1.creatorid
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
group by Person0.gender AS gender;
WITH neo4j1 AS (
SELECT e0.message_id AS pid, e0.tag_id AS tagid
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
SELECT e0.tag_id AS tagid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0
)
select TagClass0.name AS tagClassName, count(neo4j2.tagid) AS tagCount
from neo4j2, r_tagclass tagclass0, seg1
where TagClass0.name <> $excludedTagClassName and neo4j2.tcid = TagClass0.id and neo4j2.tagid = seg1.tagid
group by TagClass0.name AS tagClassName;
WITH neo4j1 AS (
SELECT e0.message_id AS pid, e0.loc_id AS countryid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0
WHERE f1.type='Post' and f2.type='Country' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id
),
seg1 AS (
select neo4j1.countryid, count(neo4j1.pid) AS c
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
group by Country0.name AS countryName;
WITH neo4j1 AS (
SELECT e0.post_id AS pid, e0.forum_id AS forumid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0
WHERE f1.type='Post' and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id
),
seg1 AS (
select neo4j1.forumid, count(neo4j1.pid) AS c
from neo4j1, r_forum forum0
where Forum0.creationDate > $forumDate and neo4j1.forumid = Forum0.id
group by neo4j1.forumid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.person_id AS memberid, e0.forum_id AS forumid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0
WHERE f0.id=e0.forum_id and f1.id=e0.person_id
)
select count(neo4j2.memberid) AS memberCount, Person0.browserUsed AS browserUsed, Forum0.title AS forumTitle
from neo4j2, r_person person0, r_forum forum0, seg1
where Person0.birthday < $birthday and neo4j2.memberid = Person0.id and neo4j2.forumid = Forum0.id and neo4j2.forumid = seg1.forumid
group by Person0.browserUsed AS browserUsed, Forum0.title AS forumTitle;
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
SELECT e0.person_id AS likerid, e0.message_id AS pid
FROM filter_post2 f0, message f1, filter_person1 f2, person_likes_message e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
)
select count(neo4j2.likerid) AS likeCount, Post0.browserUsed AS postBrowserUsed, Person0.browserUsed AS likerBrowserUsed
from neo4j2, r_post post0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.pid = Post0.id and neo4j2.likerid = Person0.id and neo4j2.pid = seg1.pid
group by Post0.browserUsed AS postBrowserUsed, Person0.browserUsed AS likerBrowserUsed;
WITH neo4j1 AS (
SELECT e0.person_id AS sid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select min(Person0.birthday) AS earliestStudentBirthday, neo4j1.uid
from neo4j1, r_person person0
where Person0.birthday < $olderThanBirthday and neo4j1.sid = Person0.id
group by neo4j1.uid
ORDER BY earliestStudentBirthday ASC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.university_id AS uid, e1.company_id AS coid, e0.person_id AS pid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, organisation f2, person_workat_organisation e1
WHERE f0.type='University' and f2.type='Company' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.company_id
)
select Company0.name AS companyName, count(DISTINCT neo4j2.pid) AS employeeStudentCount, University0.name AS universityName
from neo4j2, r_person person0, r_university university0, r_company company0, seg1
where Person0.browserUsed = $browser and Company0.name <> $excludedCompany and neo4j2.pid = Person0.id and neo4j2.uid = University0.id and neo4j2.coid = Company0.id and neo4j2.uid = seg1.uid
group by Company0.name AS companyName, University0.name AS universityName
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
SELECT e0.university_id AS uid, e0.person_id AS pid, e1.message_id AS cid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, filter_comment2 f2, message f3, message_hascreator_person e1
WHERE f0.type='University' and f3.type='Comment' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
)
select count(DISTINCT neo4j2.cid) AS commentCount, Comment0.browserUsed AS commentBrowser, University0.name AS universityName
from neo4j2, r_university university0, r_comment comment0, r_person person0, seg1
where Person0.gender = $creatorGender and Comment0.length > $minCommentLength and neo4j2.uid = University0.id and neo4j2.cid = Comment0.id and neo4j2.pid = Person0.id and neo4j2.uid = seg1.uid
group by Comment0.browserUsed AS commentBrowser, University0.name AS universityName
ORDER BY commentCount DESC, 1, 2, 3
LIMIT 20;
TODO;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.loc_id AS ciid, e0.org_id AS uid
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
select count(DISTINCT neo4j2.pid) AS studentCount, Person0.gender AS gender
from neo4j2, r_person person0, seg1
where Person0.birthday > $birthday and neo4j2.pid = Person0.id and neo4j2.uid = seg1.uid
group by Person0.gender AS gender
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
group by Country0.name AS country
ORDER BY postCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.loc_id AS ciid, e0.person_id AS pid
FROM place f0, filter_person1 f1, person_islocatedin_place e0
WHERE f0.type='City' and f0.id=e0.loc_id and f1.id=e0.person_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(neo4j1.ciid) AS c
from neo4j1, r_city city0, r_person person0
where City0.name = $city and Person0.birthday > $birthday and neo4j1.ciid = City0.id and neo4j1.pid = Person0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.forum_id AS foid
FROM filter_person1 f0, filter_forum2 f1, forum_hasmember_person e0
WHERE f0.id=e0.person_id and f1.id=e0.forum_id
)
select Forum0.title AS forumTitle, count(DISTINCT neo4j2.pid) AS memberCount
from neo4j2, r_forum forum0, seg1
where Forum0.creationDate > $forumSince and neo4j2.foid = Forum0.id and neo4j2.pid = seg1.pid
group by Forum0.title AS forumTitle
ORDER BY memberCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.loc_id AS coid, e0.message_id AS poid, e0.person_id AS authorid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, organisation f3, person_workat_organisation e1, place f4, organisation_islocatedin_place e2
WHERE f1.type='Post' and f3.type='Company' and f4.type='Country' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.company_id and f4.id=e2.loc_id
),
seg1 AS (
select avg(Post0.length) AS avgPostLength, neo4j1.authorid
from neo4j1, r_post post0, r_country country0
where Post0.creationDate > $postDate and Country0.name = $countryName and neo4j1.poid = Post0.id and neo4j1.coid = Country0.id
group by neo4j1.authorid
ORDER BY avgPostLength DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e1.tagclass_id AS tcid, e0.person_id AS authorid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1
WHERE e0.tag_id=e1.tag_id and f0.id=e0.person_id
)
select Tag0.name, Person0.lastName, TagClass0.name, Person0.firstName
from neo4j2, r_tag tag0, r_person person0, r_tagclass tagclass0, seg1
where TagClass0.name = $tagClassName and neo4j2.tagid = Tag0.id and neo4j2.authorid = Person0.id and neo4j2.tcid = TagClass0.id and neo4j2.authorid = seg1.authorid;
WITH neo4j1 AS (
SELECT e0.post_id AS poid, e0.forum_id AS foid, e2.loc_id AS cityid
FROM filter_post2 f0, message f1, filter_forum2 f2, forum_containerof_message e0, filter_person1 f3, forum_hasmember_person e1, place f4, person_islocatedin_place e2
WHERE f1.type='Post' and f4.type='City' and e0.forum_id=e1.forum_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e0.forum_id and f3.id=e1.person_id and f4.id=e2.loc_id
),
seg1 AS (
select min(Post0.creationDate) AS earliestPostDate, neo4j1.foid
from neo4j1, r_post post0, r_city city0, r_forum forum0
where Forum0.creationDate > $forumDate and City0.name = $cityName and neo4j1.poid = Post0.id and neo4j1.cityid = City0.id and neo4j1.foid = Forum0.id
group by neo4j1.foid
ORDER BY earliestPostDate ASC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e1.company_id AS orgid, e0.forum_id AS foid, e0.person_id AS modid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0, person_workat_organisation e1
WHERE e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id
)
select Organisation0.name, Person0.firstName, Person0.lastName, Forum0.title
from neo4j2, r_person person0, r_organisation organisation0, r_forum forum0, seg1
where Organisation0.name = $organisationName and Person0.gender = $gender and neo4j2.modid = Person0.id and neo4j2.orgid = Organisation0.id and neo4j2.foid = Forum0.id and neo4j2.foid = seg1.foid;
WITH neo4j1 AS (
SELECT e0.message_id AS poid, e0.tag_id AS tagid
FROM filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select neo4j1.tagid, max(Post0.creationDate) AS latestPostDate
from neo4j1, r_post post0, r_tag tag0
where Post0.length > $minLength and Tag0.name = $tagName and neo4j1.poid = Post0.id and neo4j1.tagid = Tag0.id
group by neo4j1.tagid
ORDER BY latestPostDate DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.person_id AS personid, e1.university_id AS uniid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0, organisation f1, person_studyat_organisation e1
WHERE f1.type='University' and e0.person_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.university_id
)
select Tag0.name, University0.name, Person0.firstName, Person0.lastName
from neo4j2, r_tag tag0, r_person person0, r_university university0, seg1
where Person0.birthday < $birthday and University0.name = $universityName and neo4j2.tagid = Tag0.id and neo4j2.personid = Person0.id and neo4j2.uniid = University0.id and neo4j2.tagid = seg1.tagid;
WITH neo4j1 AS (
SELECT e0.message_id AS replyid, e2.loc_id AS placeid, e1.person_id AS creatorid, e0.replied_message_id AS poid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, person_islocatedin_place e2
WHERE f1.type='Post' and f3.type='Comment' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id and f4.id=e1.person_id
),
seg1 AS (
select avg(Comment0.length) AS avgReplyLength, neo4j1.creatorid
from neo4j1, r_comment comment0, r_place place0, r_post post0
where Place0.name = $placeName and Post0.creationDate > $postDate2 and neo4j1.replyid = Comment0.id and neo4j1.placeid = Place0.id and neo4j1.poid = Post0.id
group by neo4j1.creatorid
ORDER BY avgReplyLength DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.message_id AS msgid, e1.tag_id AS tagid, e0.person_id AS creatorid
FROM filter_person1 f0, filter_message2 f1, person_likes_message e0, message_hastag_tag e1
WHERE e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id
)
select Person0.firstName, Tag0.name, Person0.lastName, Message0.content
from neo4j2, r_message message0, r_tag tag0, r_person person0, seg1
where Message0.creationDate > $messageDate and Tag0.name = $likedTagName and neo4j2.msgid = Message0.id and neo4j2.tagid = Tag0.id and neo4j2.creatorid = Person0.id and neo4j2.creatorid = seg1.creatorid;
WITH neo4j1 AS (
SELECT e0.loc_id AS coid, e2.org_id AS uniid, e0.message_id AS poid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0, place f3, place_ispartof_place e1, organisation f4, organisation_islocatedin_place e2
WHERE f1.type='Post' and f2.type='Country' and f3.type='City' and f4.type='University' and e0.loc_id=e1.reg_id and e1.subreg_id=e2.loc_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id and f3.id=e1.subreg_id and f4.id=e2.org_id
),
seg1 AS (
select min(Post0.length) AS shortestPostLength, neo4j1.coid
from neo4j1, r_post post0, r_country country0, r_university university0
where University0.name = $universityName2 and Country0.name = $countryName2 and neo4j1.poid = Post0.id and neo4j1.coid = Country0.id and neo4j1.uniid = University0.id
group by neo4j1.coid
ORDER BY shortestPostLength ASC, 1, 2
LIMIT 56
),
neo4j2 AS (
SELECT e1.person_id AS personid, e0.loc_id AS coid, e0.message_id AS commentid
FROM place f0, filter_comment2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1
WHERE f0.type='Country' and f2.type='Comment' and e0.message_id=e1.message_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
)
select Comment0.content, Person0.firstName, Person0.browserUsed, Person0.lastName, Country0.name
from neo4j2, r_person person0, r_country country0, r_comment comment0, seg1
where Comment0.length > $minCommentLength and Comment0.creationDate > $commentDate and neo4j2.personid = Person0.id and neo4j2.coid = Country0.id and neo4j2.commentid = Comment0.id and neo4j2.coid = seg1.coid;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.forum_id AS foid, e1.person_id AS pid
FROM filter_post2 f0, message f1, message_hastag_tag e0, filter_person1 f2, message_hascreator_person e1, filter_forum2 f3, forum_hasmember_person e2
WHERE f1.type='Post' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.forum_id
),
seg1 AS (
select neo4j1.pid, count(DISTINCT neo4j1.foid) AS c
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
group by Company0.name AS companyName
ORDER BY personCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e1.forum_id AS fid, e2.post_id AS mid
FROM filter_person1 f0, person_hasinterest_tag e0, filter_forum2 f1, forum_hasmoderator_person e1, filter_post2 f2, message f3, forum_containerof_message e2
WHERE f3.type='Post' and e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id and f2.id=e2.post_id and f3.id=e2.post_id
),
seg1 AS (
select count(DISTINCT neo4j1.mid) AS c, neo4j1.fid
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
group by Tag0.name AS forumTagName
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e1.tag_id AS rtid, e2.message_id AS mid
FROM tag_hastype_tagclass e0, tag_hastype_tagclass e1, filter_message1 f0, message_hastag_tag e2
WHERE e0.tagclass_id=e1.tagclass_id and e1.tag_id=e2.tag_id and f0.id=e2.message_id
),
seg1 AS (
select count(DISTINCT neo4j1.rtid) AS c, neo4j1.mid
from neo4j1, r_tag tag0
where Tag0.name = $seedTag and neo4j1.tid = Tag0.id
group by neo4j1.mid
ORDER BY c DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.message_id AS mid, e0.loc_id AS plid
FROM filter_message1 f0, message_islocatedin_place e0
WHERE f0.id=e0.message_id
)
select Place0.name AS placeName, count(DISTINCT neo4j2.mid) AS messageCount
from neo4j2, r_message message0, r_place place0, seg1
where Message0.length > $minLength and neo4j2.mid = Message0.id and neo4j2.plid = Place0.id and neo4j2.mid = seg1.mid
group by Place0.name AS placeName
ORDER BY messageCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.person_id AS pid, e0.message_id AS cmtid
FROM filter_comment2 f0, message f1, message_hastag_tag e0, filter_post2 f2, message f3, message_replyof_message e1, filter_person1 f4, message_hascreator_person e2
WHERE f1.type='Comment' and f3.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.replied_message_id and f3.id=e1.replied_message_id and f4.id=e2.person_id
),
seg1 AS (
select neo4j1.pid, count(DISTINCT neo4j1.cmtid) AS c
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
group by Person0.browserUsed AS browserUsed
ORDER BY authorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e1.person_id AS pid, e2.loc_id AS ciid
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
group by University0.name AS universityName
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
select Person0.browserUsed, Person1.firstName, Person0.firstName, Person1.locationIP, Person1.lastName, Person0.lastName
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
SELECT e0.university_id AS uid, e0.person_id AS studentid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
)
select Person0.lastName, University0.name, Person0.firstName, Person0.email
from neo4j2, r_university university0, r_person person0, seg1
where Person0.browserUsed = $browser and neo4j2.uid = University0.id and neo4j2.studentid = Person0.id and neo4j2.uid = seg1.uid;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e1.message_id AS poid
FROM place f0, filter_person1 f1, person_islocatedin_place e0, filter_post2 f2, message f3, message_hascreator_person e1
WHERE f0.type='City' and f3.type='Post' and e0.person_id=e1.person_id and f0.id=e0.loc_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select neo4j1.pid, count(neo4j1.poid) AS c
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
select Person0.lastName, Comment0.content, Person0.firstName, Comment0.length
from neo4j2, r_person person0, r_comment comment0, seg1
where Comment0.creationDate > $commentDate and neo4j2.pid = Person0.id and neo4j2.coid = Comment0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e1.message_id AS mid, e0.person_id AS pid
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
select Person0.lastName, Person0.firstName, Tag0.name, Person0.locationIP
from neo4j2, r_person person0, r_tag tag0, seg1
where Tag0.name <> $excludedTag and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.loc_id AS coid, e1.person_id AS pid, e0.message_id AS poid
FROM place f0, filter_post2 f1, message f2, message_islocatedin_place e0, filter_person1 f3, message_hascreator_person e1
WHERE f0.type='Country' and f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.person_id
),
seg1 AS (
select neo4j1.pid, count(neo4j1.poid) AS c
from neo4j1, r_post post0, r_country country0
where Post0.creationDate > $postDate and Country0.name = $countryName and neo4j1.poid = Post0.id and neo4j1.coid = Country0.id
group by neo4j1.pid
ORDER BY c DESC, 1, 2
LIMIT 1000
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e0.person_id AS pid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select count(DISTINCT neo4j2.pid) AS personCount, Tag0.name AS tagName, Person0.gender AS gender
from neo4j2, r_tag tag0, r_person person0, seg1
where Tag0.name <> $excludedTagName and neo4j2.tid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.pid = seg1.pid
group by Tag0.name AS tagName, Person0.gender AS gender;
WITH neo4j1 AS (
SELECT e1.forum_id AS fid, e0.loc_id AS coid, e0.message_id AS mid
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
SELECT e0.forum_id AS fid, e0.person_id AS mdid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0
WHERE f0.id=e0.forum_id and f1.id=e0.person_id
)
select Person0.gender AS moderatorGender, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_person person0, seg1
where Person0.browserUsed = $browserUsed and neo4j2.mdid = Person0.id and neo4j2.fid = seg1.fid
group by Person0.gender AS moderatorGender;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e0.loc_id AS coid, e0.message_id AS mid
FROM place f0, filter_message2 f1, message_islocatedin_place e0, message_hastag_tag e1
WHERE f0.type='Country' and e0.message_id=e1.message_id and f0.id=e0.loc_id and f1.id=e0.message_id
),
seg1 AS (
select count(neo4j1.mid) AS c, neo4j1.tid
from neo4j1, r_message message0, r_country country0
where Country0.name = $countryName and Message0.creationDate > $messageDate and neo4j1.mid = Message0.id and neo4j1.coid = Country0.id
group by neo4j1.tid
ORDER BY c DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0
)
select TagClass0.name AS tagClassName, count(DISTINCT neo4j2.tid) AS tagCount
from neo4j2, r_tagclass tagclass0, seg1
where TagClass0.name <> $excludedTagClassName and neo4j2.tcid = TagClass0.id and neo4j2.tid = seg1.tid
group by TagClass0.name AS tagClassName;
WITH neo4j1 AS (
SELECT e0.subreg_id AS ciid, e1.org_id AS uid, e0.reg_id AS coid
FROM place f0, place f1, place_ispartof_place e0, organisation f2, organisation_islocatedin_place e1
WHERE f0.type='Country' and f1.type='City' and f2.type='University' and e0.subreg_id=e1.loc_id and f0.id=e0.reg_id and f1.id=e0.subreg_id and f2.id=e1.org_id
),
seg1 AS (
select count(neo4j1.uid) AS c, neo4j1.ciid
from neo4j1, r_university university0, r_country country0
where University0.name <> $excludedUniversityName and Country0.name = $countryName and neo4j1.uid = University0.id and neo4j1.coid = Country0.id
group by neo4j1.ciid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.loc_id AS ciid, e0.person_id AS pid
FROM place f0, person_islocatedin_place e0
WHERE f0.type='City' and f0.id=e0.loc_id
)
select City0.name AS cityName, Person0.browserUsed AS browserUsed, count(neo4j2.pid) AS residentCount
from neo4j2, r_city city0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.ciid = City0.id and neo4j2.pid = Person0.id and neo4j2.ciid = seg1.ciid
group by City0.name AS cityName, Person0.browserUsed AS browserUsed;
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
SELECT e2.tag_id AS tid, e0.person_id AS p2id, e1.message_id AS poid, e0.company_id AS compid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0, filter_post2 f2, message f3, message_hascreator_person e1, message_hastag_tag e2
WHERE f0.type='Company' and f3.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.company_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.poid) AS postCount
from neo4j2, r_tag tag0, r_person person0, r_post post0, seg1
where Person0.gender = $gender and Post0.creationDate > $postSince and neo4j2.tid = Tag0.id and neo4j2.p2id = Person0.id and neo4j2.poid = Post0.id and neo4j2.compid = seg1.compid
group by Tag0.name AS tagName
ORDER BY postCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.loc_id AS coid, e0.org_id AS compid
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
SELECT e2.tag_id AS tid, e1.person_id AS pid, e0.message_id AS mid, e0.loc_id AS coid
FROM place f0, filter_message2 f1, message_islocatedin_place e0, filter_person1 f2, person_likes_message e1, person_hasinterest_tag e2
WHERE f0.type='Country' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.message_id and f2.id=e1.person_id
)
select Tag0.name AS interestTag, count(DISTINCT neo4j2.pid) AS likerCount
from neo4j2, r_person person0, r_tag tag0, r_message message0, seg1
where Person0.browserUsed = $browser and Message0.length > $minLength and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.mid = Message0.id and neo4j2.coid = seg1.coid
group by Tag0.name AS interestTag
ORDER BY likerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.org_id AS compid, e0.loc_id AS plid
FROM organisation f0, organisation_islocatedin_place e0
WHERE f0.type='Company' and f0.id=e0.org_id
),
seg1 AS (
select * from (
select count(neo4j1.compid) AS c, neo4j1.plid
from neo4j1, r_place place0
where Place0.name <> $excludedPlace and neo4j1.plid = Place0.id
group by neo4j1.plid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.org_id AS uid, e1.person_id AS pid, e2.friend_id AS qid, e0.loc_id AS plid
FROM organisation f0, organisation_islocatedin_place e0, filter_person1 f1, person_studyat_organisation e1, filter_person1 f2, person_knows_person e2
WHERE f0.type='University' and e0.org_id=e1.university_id and e1.person_id=e2.person_id and f0.id=e0.org_id and f1.id=e1.person_id and f2.id=e2.friend_id
)
select count(DISTINCT neo4j2.pid) AS studentCount, Person0.browserUsed AS browser
from neo4j2, r_person person0, r_university university0, seg1
where University0.name <> $excludedUniversity and Person0.gender = $gender and neo4j2.qid = Person0.id and neo4j2.uid = University0.id and neo4j2.plid = seg1.plid
group by Person0.browserUsed AS browser
ORDER BY studentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.company_id AS compid
FROM organisation f0, filter_person1 f1, person_workat_organisation e0
WHERE f0.type='Company' and f0.id=e0.company_id and f1.id=e0.person_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(neo4j1.compid) AS c
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
group by Person0.browserUsed AS authorBrowser
ORDER BY likedReplyCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.person_id AS pid
FROM person_hasinterest_tag e0
),
seg1 AS (
select * from (
select neo4j1.pid, count(neo4j1.tid) AS c
from neo4j1, r_tag tag0
where Tag0.name <> $excludedInterestName and neo4j1.tid = Tag0.id
group by neo4j1.pid
) b1
where c > 20
),
neo4j2 AS (
SELECT e1.loc_id AS countryid, e0.company_id AS coid, e0.person_id AS pid
FROM organisation f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE f0.type='Company' and f1.type='Country' and e0.company_id=e1.org_id and f0.id=e0.company_id and f1.id=e1.loc_id
)
select count(DISTINCT neo4j2.pid) AS interestedEmployeeCount, Company0.name AS companyName
from neo4j2, r_company company0, r_country country0, seg1
where Company0.name <> $excludedCompanyName and Country0.name = $countryName and neo4j2.coid = Company0.id and neo4j2.countryid = Country0.id and neo4j2.pid = seg1.pid
group by Company0.name AS companyName
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
where Forum0.creationDate > $forumCreatedAfter and Tag0.name <> $excludedTagName and neo4j1.tid = Tag0.id and neo4j1.fid = Forum0.id
group by neo4j1.fid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.message_id AS likedid, e0.person_id AS memberid, e0.forum_id AS fid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, filter_post2 f2, message f3, person_likes_message e1
WHERE f3.type='Post' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
)
select Post0.browserUsed AS browserUsed, count(DISTINCT neo4j2.memberid) AS memberCount
from neo4j2, r_post post0, r_person person0, seg1
where Person0.gender = $gender and Post0.creationDate > $postCreatedAfter and neo4j2.likedid = Post0.id and neo4j2.memberid = Person0.id and neo4j2.fid = seg1.fid
group by Post0.browserUsed AS browserUsed
ORDER BY memberCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.message_id AS cmid
FROM filter_comment2 f0, message f1, message_hastag_tag e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
),
seg1 AS (
select * from (
select neo4j1.cmid, count(neo4j1.tid) AS c
from neo4j1, r_tag tag0, r_comment comment0
where Comment0.length > $minCommentLength and Tag0.name <> $excludedTagName and neo4j1.tid = Tag0.id and neo4j1.cmid = Comment0.id
group by neo4j1.cmid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.person_id AS creatorid, e0.message_id AS cmid, e0.replied_message_id AS poid
FROM filter_comment2 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1
WHERE f1.type='Comment' and f3.type='Post' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id
)
select count(DISTINCT neo4j2.cmid) AS replyCommentCount, Person0.browserUsed AS browserUsed
from neo4j2, r_post post0, r_person person0, seg1
where Post0.length > $minPostLength and Person0.gender = $gender and neo4j2.poid = Post0.id and neo4j2.creatorid = Person0.id and neo4j2.cmid = seg1.cmid
group by Person0.browserUsed AS browserUsed
ORDER BY replyCommentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select * from (
select neo4j1.tcid, count(neo4j1.tid) AS c
from neo4j1, r_tag tag0
where Tag0.name <> $excludedTagName and neo4j1.tid = Tag0.id
group by neo4j1.tcid
) b1
where c > 20
),
neo4j2 AS (
SELECT e1.message_id AS msgid, e0.tag_id AS topicid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1
WHERE e0.tag_id=e1.tag_id and f0.id=e1.message_id
)
select count(DISTINCT neo4j2.msgid) AS messageCount, Tag0.name AS tagName
from neo4j2, r_message message0, r_tag tag0, seg1
where Message0.creationDate > $messageCreatedAfter and Message0.length > $minMessageLength and neo4j2.msgid = Message0.id and neo4j2.topicid = Tag0.id and neo4j2.tcid = seg1.tcid
group by Tag0.name AS tagName
ORDER BY messageCount DESC, 1, 2
LIMIT 20;
TODO;
TODO;
TODO;
TODO;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0
WHERE f1.type='Post' and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(neo4j1.poid) AS c
from neo4j1, r_post post0
where Post0.creationDate > $postDate and neo4j1.poid = Post0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e0.friend_id AS fid, e2.tagclass_id AS tcid, e0.person_id AS pid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id
)
select count(DISTINCT neo4j2.pid) AS creatorCount, TagClass0.name AS tagClassName
from neo4j2, r_person person0, r_tagclass tagclass0, seg1
where Person0.gender = $gender and neo4j2.fid = Person0.id and neo4j2.tcid = TagClass0.id and neo4j2.pid = seg1.pid
group by TagClass0.name AS tagClassName
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
SELECT e0.message_id AS mid, e2.loc_id AS plid, e0.tag_id AS tid
FROM filter_message2 f0, message_hastag_tag e0, filter_person1 f1, message_hascreator_person e1, person_islocatedin_place e2
WHERE e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e1.person_id
)
select Place0.name AS placeName, count(DISTINCT neo4j2.mid) AS messageCount
from neo4j2, r_message message0, r_place place0, seg1
where Message0.length > $messageLength and neo4j2.mid = Message0.id and neo4j2.plid = Place0.id and neo4j2.tid = seg1.tid
group by Place0.name AS placeName
ORDER BY messageCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.message_id AS poid, e0.loc_id AS coid
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
SELECT e0.org_id AS orgid, e1.person_id AS personid, e2.message_id AS cmid, e0.loc_id AS coid
FROM place f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, filter_comment2 f2, message f3, person_likes_message e2
WHERE f0.type='Country' and f3.type='Comment' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e1.person_id and f2.id=e2.message_id and f3.id=e2.message_id
)
select Organisation0.name AS organisationName, count(DISTINCT neo4j2.cmid) AS likedCommentCount
from neo4j2, r_person person0, r_organisation organisation0, seg1
where Person0.gender = $gender and neo4j2.personid = Person0.id and neo4j2.orgid = Organisation0.id and neo4j2.coid = seg1.coid
group by Organisation0.name AS organisationName
ORDER BY likedCommentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.post_id AS poid, e0.forum_id AS foid
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
SELECT e0.person_id AS memberid, e0.forum_id AS foid, e2.loc_id AS ciid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_studyat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE f2.type='University' and f3.type='City' and e0.person_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.university_id and f3.id=e2.loc_id
)
select City0.name AS cityName, count(DISTINCT neo4j2.foid) AS forumCount
from neo4j2, r_city city0, r_person person0, seg1
where Person0.birthday > $birthday and neo4j2.ciid = City0.id and neo4j2.memberid = Person0.id and neo4j2.foid = seg1.foid
group by City0.name AS cityName
ORDER BY forumCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.replied_message_id AS poid, e0.message_id AS cmid
FROM filter_post2 f0, message f1, filter_comment2 f2, message f3, message_replyof_message e0
WHERE f1.type='Post' and f3.type='Comment' and f0.id=e0.replied_message_id and f1.id=e0.replied_message_id and f2.id=e0.message_id and f3.id=e0.message_id
),
seg1 AS (
select * from (
select count(neo4j1.cmid) AS c, neo4j1.poid
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
group by TagClass0.name AS parentClassName
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
where Post0.creationDate > $postSince and TagClass0.name = $tagClassName and neo4j1.poid = Post0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.poid
ORDER BY avgPostLength DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e0.person_id AS pid, e1.company_id AS cid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, organisation f3, person_workat_organisation e1
WHERE f1.type='Post' and f3.type='Company' and e0.person_id=e1.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.company_id
)
select Company0.name AS companyName, count(DISTINCT neo4j2.poid) AS postCount, Person0.gender AS gender
from neo4j2, r_company company0, r_person person0, seg1
where Person0.gender = $gender and Company0.name <> $excludedCompany and neo4j2.cid = Company0.id and neo4j2.pid = Person0.id and neo4j2.poid = seg1.poid
group by Company0.name AS companyName, Person0.gender AS gender;
WITH neo4j1 AS (
SELECT e1.message_id AS cmid, e0.tagclass_id AS tcid
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
select Country0.name AS countryName, count(DISTINCT neo4j2.cmid) AS commentCount
from neo4j2, r_country country0, r_post post0, seg1
where Country0.name <> $excludedCountry and Post0.creationDate > $postSince and neo4j2.coid = Country0.id and neo4j2.poid = Post0.id and neo4j2.cmid = seg1.cmid
group by Country0.name AS countryName;
WITH neo4j1 AS (
SELECT e1.forum_id AS fid, e0.tagclass_id AS tcid
FROM tag_hastype_tagclass e0, filter_forum2 f0, forum_hastag_tag e1
WHERE e0.tag_id=e1.tag_id and f0.id=e1.forum_id
),
seg1 AS (
select max(Forum0.creationDate) AS latestForumDate, neo4j1.fid
from neo4j1, r_forum forum0, r_tagclass tagclass0
where TagClass0.name = $tagClassName and Forum0.creationDate > $forumSince and neo4j1.fid = Forum0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.fid
ORDER BY latestForumDate DESC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e1.university_id AS uid, e0.forum_id AS fid, e0.person_id AS pid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_studyat_organisation e1
WHERE f2.type='University' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.university_id
)
select count(DISTINCT neo4j2.fid) AS forumCount, Person0.browserUsed AS browserUsed, University0.name AS universityName
from neo4j2, r_university university0, r_person person0, seg1
where University0.name <> $excludedUniversity and Person0.locationIP <> $blockedIP and neo4j2.uid = University0.id and neo4j2.pid = Person0.id and neo4j2.fid = seg1.fid
group by Person0.browserUsed AS browserUsed, University0.name AS universityName;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e1.message_id AS mid
FROM tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1
WHERE e0.tag_id=e1.tag_id and f0.id=e1.message_id
),
seg1 AS (
select neo4j1.mid, avg(Message0.length) AS avgMessageLength
from neo4j1, r_message message0, r_tagclass tagclass0
where Message0.length > $minMessageLength and TagClass0.name = $tagClassName and neo4j1.mid = Message0.id and neo4j1.tcid = TagClass0.id
group by neo4j1.mid
ORDER BY avgMessageLength DESC, 1, 2
LIMIT 10000
),
neo4j2 AS (
SELECT e1.loc_id AS ciid, e0.person_id AS pid, e0.message_id AS mid
FROM filter_message2 f0, filter_person1 f1, message_hascreator_person e0, place f2, person_islocatedin_place e1
WHERE f2.type='City' and e0.person_id=e1.person_id and f0.id=e0.message_id and f1.id=e0.person_id and f2.id=e1.loc_id
)
select City0.name AS cityName, Person0.browserUsed AS browserUsed, count(DISTINCT neo4j2.mid) AS messageCount
from neo4j2, r_city city0, r_person person0, seg1
where Person0.birthday < $birthdayBefore and City0.name <> $excludedCity and neo4j2.ciid = City0.id and neo4j2.pid = Person0.id and neo4j2.mid = seg1.mid
group by City0.name AS cityName, Person0.browserUsed AS browserUsed;
WITH neo4j1 AS (
SELECT e1.person_id AS pid, e0.post_id AS poid, e0.forum_id AS foid
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
SELECT e0.tag_id AS tid, e0.person_id AS pid
FROM filter_person1 f0, person_hasinterest_tag e0
WHERE f0.id=e0.person_id
)
select Person0.lastName AS personLastName, Tag0.name AS interestName, Person0.firstName AS personFirstName
from neo4j2, r_person person0, r_tag tag0, seg1
where Tag0.name = $tagName and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.pid = seg1.pid;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e0.forum_id AS foid, e1.tagclass_id AS tcid
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
select Tag0.name AS tagName, Person0.lastName AS personLastName, Person0.firstName AS personFirstName
from neo4j2, r_tag tag0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.tid = Tag0.id and neo4j2.pid = Person0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e1.tag_id AS tid, e0.post_id AS mid
FROM filter_forum2 f0, filter_message2 f1, forum_containerof_message e0, message_hastag_tag e1
WHERE e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id
),
seg1 AS (
select * from (
select count(neo4j1.mid) AS c, neo4j1.tid
from neo4j1, r_message message0
where Message0.length > $minLength and neo4j1.mid = Message0.id
group by neo4j1.tid
) b1
where c > 3
),
neo4j2 AS (
SELECT e0.tag_id AS tid, e0.message_id AS cmtid
FROM filter_comment2 f0, message f1, message_hastag_tag e0
WHERE f1.type='Comment' and f0.id=e0.message_id and f1.id=e0.message_id
)
select Comment0.length AS commentLength, Comment0.content AS commentContent, Tag0.name AS tagName
from neo4j2, r_tag tag0, r_comment comment0, seg1
where Comment0.creationDate > $commentDate and neo4j2.tid = Tag0.id and neo4j2.cmtid = Comment0.id and neo4j2.tid = seg1.tid;
WITH neo4j1 AS (
SELECT e1.message_id AS poid, e0.person_id AS mdid
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
SELECT e0.message_id AS cmid, e0.person_id AS mdid
FROM filter_person1 f0, filter_comment2 f1, message f2, person_likes_message e0
WHERE f2.type='Comment' and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Person0.lastName AS moderatorLastName, Comment0.content AS likedCommentContent, Person0.firstName AS moderatorFirstName
from neo4j2, r_person person0, r_comment comment0, seg1
where Comment0.length < $maxLength and neo4j2.mdid = Person0.id and neo4j2.cmid = Comment0.id and neo4j2.mdid = seg1.mdid;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select neo4j1.tcid, count(neo4j1.tagid) AS c
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
group by Person0.browserUsed AS browser, Person0.gender AS gender;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select neo4j1.tcid, count(neo4j1.tagid) AS c
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
select count(DISTINCT neo4j2.pid) AS interestedWorkers, Person0.browserUsed AS browser, Company0.name AS companyName
from neo4j2, r_company company0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.companyid = Company0.id and neo4j2.pid = Person0.id and neo4j2.tcid = seg1.tcid
group by Person0.browserUsed AS browser, Company0.name AS companyName;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select neo4j1.tcid, count(neo4j1.tagid) AS c
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
select Person0.gender AS moderatorGender, Person0.browserUsed AS moderatorBrowser, count(DISTINCT neo4j2.fid) AS forumCount
from neo4j2, r_person person0, r_forum forum0, seg1
where Forum0.creationDate > $forumDate and neo4j2.modid = Person0.id and neo4j2.fid = Forum0.id and neo4j2.tcid = seg1.tcid
group by Person0.gender AS moderatorGender, Person0.browserUsed AS moderatorBrowser;
WITH neo4j1 AS (
SELECT e0.tagclass_id AS tcid, e0.tag_id AS tagid
FROM tag_hastype_tagclass e0
),
seg1 AS (
select neo4j1.tcid, count(neo4j1.tagid) AS c
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
select Country0.name AS countryName, Post0.browserUsed AS browser, count(DISTINCT neo4j2.postid) AS postCount
from neo4j2, r_country country0, r_post post0, seg1
where Post0.length > $minLength and neo4j2.countryid = Country0.id and neo4j2.postid = Post0.id and neo4j2.tcid = seg1.tcid
group by Country0.name AS countryName, Post0.browserUsed AS browser;
WITH neo4j1 AS (
SELECT e0.tag_id AS parentid, e0.subtag_id AS childid
FROM tagclass_issubclassof_tagclass e0
),
seg1 AS (
select neo4j1.childid, count(neo4j1.parentid) AS c
from neo4j1, r_tagclass tagclass0
where TagClass0.name <> $excludedParentClass and neo4j1.parentid = TagClass0.id
group by neo4j1.childid
ORDER BY c DESC, 1, 2
LIMIT 14
),
neo4j2 AS (
SELECT e2.replied_message_id AS postid, e1.message_id AS commentid, e0.tagclass_id AS childid
FROM tag_hastype_tagclass e0, filter_comment2 f0, message f1, message_hastag_tag e1, filter_post2 f2, message f3, message_replyof_message e2
WHERE f1.type='Comment' and f3.type='Post' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e1.message_id and f2.id=e2.replied_message_id and f3.id=e2.replied_message_id
)
select Post0.browserUsed AS repliedPostBrowser, Comment0.locationIP AS commenterLocationIP, count(DISTINCT neo4j2.commentid) AS replyCount
from neo4j2, r_comment comment0, r_post post0, seg1
where Comment0.creationDate > $commentDate and neo4j2.commentid = Comment0.id and neo4j2.postid = Post0.id and neo4j2.childid = seg1.childid
group by Post0.browserUsed AS repliedPostBrowser, Comment0.locationIP AS commenterLocationIP;
WITH neo4j1 AS (
SELECT e0.university_id AS uid, e0.person_id AS alid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select min(Person0.birthday) AS earliestAlumniBirthday, neo4j1.uid
from neo4j1, r_person person0
where neo4j1.alid = Person0.id
group by neo4j1.uid
ORDER BY earliestAlumniBirthday ASC, 1, 2
LIMIT 10
),
neo4j2 AS (
SELECT e1.tag_id AS tid, e0.person_id AS pid, e2.message_id AS mid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0, person_hasinterest_tag e1, filter_post2 f2, message f3, message_hastag_tag e2
WHERE f0.type='University' and f3.type='Post' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e2.message_id and f3.id=e2.message_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.mid) AS postCount
from neo4j2, r_post post0, r_person person0, r_tag tag0, seg1
where Person0.gender = $gender and Post0.creationDate > $postDate and neo4j2.mid = Post0.id and neo4j2.pid = Person0.id and neo4j2.tid = Tag0.id and neo4j2.uid = seg1.uid
group by Tag0.name AS tagName;
WITH neo4j1 AS (
SELECT e0.person_id AS pid, e0.university_id AS uid
FROM organisation f0, filter_person1 f1, person_studyat_organisation e0
WHERE f0.type='University' and f0.id=e0.university_id and f1.id=e0.person_id
),
seg1 AS (
select max(Person0.birthday) AS birthdayRank, neo4j1.pid
from neo4j1, r_person person0, r_university university0
where University0.name = $universityName and neo4j1.pid = Person0.id and neo4j1.uid = University0.id
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
from neo4j2, r_forum forum0, r_post post0, r_person person0, seg1
where Post0.length > $postLength and Forum0.creationDate > $forumDate and neo4j2.fid = Forum0.id and neo4j2.poid = Post0.id and neo4j2.mdid = Person0.id and neo4j2.pid = seg1.pid
group by Person0.browserUsed AS moderatorBrowser, Person0.gender AS moderatorGender;
WITH neo4j1 AS (
SELECT e2.tag_id AS tid, e0.forum_id AS foid, e0.person_id AS pid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, filter_post2 f2, message f3, message_hascreator_person e1, message_hastag_tag e2
WHERE f3.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(DISTINCT neo4j1.foid) AS c
from neo4j1, r_tag tag0, r_forum forum0
where Tag0.name = $tagName and Forum0.creationDate > $forumDate and neo4j1.tid = Tag0.id and neo4j1.foid = Forum0.id
group by neo4j1.pid
) b1
where c > 2
),
neo4j2 AS (
SELECT e1.loc_id AS countryid, e0.company_id AS coid, e0.person_id AS pid
FROM filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id
)
select count(DISTINCT neo4j2.pid) AS qualifyingPeople, Company0.name AS companyName
from neo4j2, r_company company0, r_country country0, seg1
where Country0.name = $countryName and neo4j2.coid = Company0.id and neo4j2.countryid = Country0.id and neo4j2.pid = seg1.pid
group by Company0.name AS companyName
ORDER BY qualifyingPeople DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e2.loc_id AS cityid, e1.person_id AS pid, e0.post_id AS mid
FROM filter_forum2 f0, filter_message2 f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1, place f3, person_islocatedin_place e2
WHERE f3.type='City' and e0.post_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e1.person_id and f3.id=e2.loc_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(DISTINCT neo4j1.mid) AS c
from neo4j1, r_message message0, r_city city0
where Message0.length > $minLength and City0.name = $cityName and neo4j1.mid = Message0.id and neo4j1.cityid = City0.id
group by neo4j1.pid
) b1
where c > 10
),
neo4j2 AS (
SELECT e0.person_id AS pid, e0.tag_id AS tagid, e1.tagclass_id AS tcid
FROM filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1
WHERE e0.tag_id=e1.tag_id and f0.id=e0.person_id
)
select count(DISTINCT neo4j2.pid) AS creatorCount, Tag0.name AS interestTag
from neo4j2, r_tagclass tagclass0, r_tag tag0, seg1
where TagClass0.name = $tagClassName and neo4j2.tcid = TagClass0.id and neo4j2.tagid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name AS interestTag
ORDER BY creatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.forum_id AS foid, e1.message_id AS cmtid, e0.person_id AS modid
FROM filter_forum2 f0, filter_person1 f1, forum_hasmoderator_person e0, filter_comment2 f2, message f3, message_hascreator_person e1, place f4, message_islocatedin_place e2
WHERE f3.type='Comment' and f4.type='Country' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.loc_id
),
seg1 AS (
select * from (
select neo4j1.modid, count(DISTINCT neo4j1.cmtid) AS c
from neo4j1, r_comment comment0, r_forum forum0
where Forum0.title = $forumTitle and Comment0.length > $minCommentLength and neo4j1.cmtid = Comment0.id and neo4j1.foid = Forum0.id
group by neo4j1.modid
) b1
where c > 10
),
neo4j2 AS (
SELECT e1.loc_id AS placeid, e0.university_id AS uniid, e0.person_id AS modid
FROM filter_person1 f0, organisation f1, person_studyat_organisation e0, organisation_islocatedin_place e1
WHERE f1.type='University' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id
)
select count(DISTINCT neo4j2.modid) AS moderatorCount, Place0.name AS universityPlace
from neo4j2, r_university university0, r_place place0, seg1
where University0.name = $universityName and neo4j2.uniid = University0.id and neo4j2.placeid = Place0.id and neo4j2.modid = seg1.modid
group by Place0.name AS universityPlace
ORDER BY moderatorCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.tag_id AS tid, e2.loc_id AS countryid, e0.forum_id AS foid, e1.message_id AS poid
FROM filter_forum2 f0, forum_hastag_tag e0, filter_post2 f1, message f2, message_hastag_tag e1, place f3, message_islocatedin_place e2
WHERE f2.type='Post' and f3.type='Country' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e1.message_id and f2.id=e1.message_id and f3.id=e2.loc_id
),
seg1 AS (
select * from (
select neo4j1.tid, count(DISTINCT neo4j1.poid) AS c
from neo4j1, r_forum forum0, r_country country0
where Forum0.creationDate < $beforeDate and Country0.name = $countryName and neo4j1.foid = Forum0.id and neo4j1.countryid = Country0.id
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
from neo4j2, r_message message0, r_person person0, seg1
where Message0.length > $minLikedLength and neo4j2.msgid = Message0.id and neo4j2.pid = Person0.id and neo4j2.tid = seg1.tid
group by Person0.browserUsed AS browser
ORDER BY likedMessageCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.post_id AS postid, e2.person_id AS pid, e1.message_id AS replyid
FROM filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, filter_comment2 f3, message f4, message_replyof_message e1, filter_person1 f5, message_hascreator_person e2
WHERE f2.type='Post' and f4.type='Comment' and e0.post_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.message_id and f4.id=e1.message_id and f5.id=e2.person_id
),
seg1 AS (
select * from (
select neo4j1.pid, count(DISTINCT neo4j1.replyid) AS c
from neo4j1, r_comment comment0, r_post post0
where Comment0.length > $replyMinLength and Post0.creationDate > $postDate and neo4j1.replyid = Comment0.id and neo4j1.postid = Post0.id
group by neo4j1.pid
) b1
where c > 5
),
neo4j2 AS (
SELECT e1.tag_id AS tagid, e0.person_id AS pid, e0.message_id AS likedid
FROM filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0, message_hastag_tag e1
WHERE f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id
)
select Tag0.name AS tagName, count(DISTINCT neo4j2.pid) AS likerCount
from neo4j2, r_post post0, r_tag tag0, seg1
where Post0.creationDate < $likedBefore and neo4j2.likedid = Post0.id and neo4j2.tagid = Tag0.id and neo4j2.pid = seg1.pid
group by Tag0.name AS tagName
ORDER BY likerCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS authorid, e2.tag_id AS tagid, e1.forum_id AS foid, e0.message_id AS poid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, filter_forum2 f3, forum_hasmember_person e1, forum_hastag_tag e2
WHERE f1.type='Post' and e0.person_id=e1.person_id and e1.forum_id=e2.forum_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.forum_id
),
seg1 AS (
select neo4j1.authorid, count(DISTINCT neo4j1.foid) AS c
from neo4j1, r_tag tag0, r_post post0
where Post0.creationDate > $postDate and Tag0.name = $tagName and neo4j1.tagid = Tag0.id and neo4j1.poid = Post0.id
group by neo4j1.authorid
ORDER BY c DESC, 1, 2
LIMIT 100
),
neo4j2 AS (
SELECT e0.friend_id AS friendid, e2.loc_id AS countryid, e0.person_id AS authorid
FROM filter_person1 f0, filter_person1 f1, person_knows_person e0, organisation f2, person_workat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE f2.type='Company' and f3.type='Country' and e0.friend_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.company_id and f3.id=e2.loc_id
)
select Country0.name AS countryName, count(DISTINCT neo4j2.friendid) AS friendCount
from neo4j2, r_country country0, r_person person0, seg1
where Person0.gender = $gender and neo4j2.countryid = Country0.id and neo4j2.friendid = Person0.id and neo4j2.authorid = seg1.authorid
group by Country0.name AS countryName
ORDER BY friendCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.message_id AS poid, e0.tag_id AS tagid
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
SELECT e0.person_id AS personid, e2.loc_id AS placeid, e0.tag_id AS tagid
FROM filter_person1 f0, person_hasinterest_tag e0, organisation f1, person_studyat_organisation e1, organisation_islocatedin_place e2
WHERE f1.type='University' and e0.person_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.person_id and f1.id=e1.university_id
)
select count(DISTINCT neo4j2.personid) AS personCount, Place0.name AS placeName
from neo4j2, r_place place0, r_person person0, seg1
where Person0.browserUsed = $browserUsed and neo4j2.placeid = Place0.id and neo4j2.personid = Person0.id and neo4j2.tagid = seg1.tagid
group by Place0.name AS placeName
ORDER BY personCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.loc_id AS countryid, e1.org_id AS coid, e2.person_id AS workerid, e0.message_id AS poid
FROM filter_post2 f0, message f1, place f2, message_islocatedin_place e0, organisation f3, organisation_islocatedin_place e1, filter_person1 f4, person_workat_organisation e2
WHERE f1.type='Post' and f2.type='Country' and f3.type='Company' and e0.loc_id=e1.loc_id and e1.org_id=e2.company_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.loc_id and f3.id=e1.org_id and f4.id=e2.person_id
),
seg1 AS (
select count(DISTINCT neo4j1.workerid) AS c, neo4j1.countryid
from neo4j1, r_post post0, r_company company0
where Post0.creationDate < $beforeDate and Company0.name <> $excludedCompany and neo4j1.poid = Post0.id and neo4j1.coid = Company0.id
group by neo4j1.countryid
ORDER BY c DESC, 1, 2
LIMIT 6
),
neo4j2 AS (
SELECT e1.person_id AS residentid, e2.message_id AS commentid, e0.reg_id AS countryid
FROM place f0, place f1, place_ispartof_place e0, filter_person1 f2, person_islocatedin_place e1, filter_comment2 f3, message f4, message_hascreator_person e2
WHERE f0.type='Country' and f1.type='City' and f4.type='Comment' and e0.subreg_id=e1.loc_id and e1.person_id=e2.person_id and f0.id=e0.reg_id and f1.id=e0.subreg_id and f2.id=e1.person_id and f3.id=e2.message_id and f4.id=e2.message_id
)
select count(DISTINCT neo4j2.commentid) AS commentCount, Person0.browserUsed AS browserUsed
from neo4j2, r_person person0, r_comment comment0, seg1
where Comment0.length > $minCommentLength and neo4j2.residentid = Person0.id and neo4j2.commentid = Comment0.id and neo4j2.countryid = seg1.countryid
group by Person0.browserUsed AS browserUsed
ORDER BY commentCount DESC, 1, 2
LIMIT 20;
WITH neo4j1 AS (
SELECT e0.person_id AS creatorid, e0.message_id AS poid, e2.message_id AS commentid
FROM filter_post2 f0, message f1, filter_person1 f2, message_hascreator_person e0, person_hasinterest_tag e1, filter_comment2 f3, message f4, message_hastag_tag e2
WHERE f1.type='Post' and f4.type='Comment' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e2.message_id and f4.id=e2.message_id
),
seg1 AS (
select neo4j1.creatorid, count(DISTINCT neo4j1.commentid) AS c
from neo4j1, r_comment comment0, r_post post0
where Comment0.length > $minCommentLength and Post0.browserUsed = $postBrowser and neo4j1.commentid = Comment0.id and neo4j1.poid = Post0.id
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
from neo4j2, r_message message0, r_person person0, seg1
where Message0.creationDate > $messageDate and Person0.gender = $moderatorGender and neo4j2.msgid = Message0.id and neo4j2.moderatorid = Person0.id and neo4j2.creatorid = seg1.creatorid
group by Person0.browserUsed AS moderatorBrowser
ORDER BY messageCount DESC, 1, 2
LIMIT 20