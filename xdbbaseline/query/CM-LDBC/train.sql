TODO;
SELECT person0.firstname, message0.content, person0.lastname, comment0.content
FROM r_person person0, r_message message0, r_comment comment0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message1 f1, message_hastag_tag e1, filter_comment2 f2, message f3, message_replyof_message e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.replied_message_id = comment0.id and e0.tag_id = tag0.id and f3.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.replied_message_id and f3.id=e2.replied_message_id;
SELECT message0.content, tag0.name, message0.creationdate
FROM r_tagclass tagclass0, r_message message0, r_forum forum0, r_tag tag0, filter_forum2 f0, filter_message2 f1, forum_containerof_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e0.post_id = message0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.post_id;
SELECT message0.content, person1.lastname, person1.firstname, person2.firstname, person2.lastname
FROM r_person person0, r_person person1, r_message message0, r_person person2, filter_person1 f0, filter_person1 f1, person_knows_person e0, filter_message1 f2, person_likes_message e1, message_hascreator_person e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e0.friend_id = person1.id and e2.person_id = person2.id and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.message_id;
SELECT person0.firstname, comment1.content, message0.content, person0.lastname
FROM r_person person0, r_message message0, r_comment comment0, r_comment comment1, filter_comment1 f0, message f1, filter_message1 f2, message_replyof_message e0, message_hascreator_person e1, filter_comment2 f3, message f4, person_likes_message e2
WHERE e0.replied_message_id = message0.id and e0.message_id = comment1.id and e2.message_id = comment0.id and e1.person_id = person0.id and f1.type='Comment' and f4.type='Comment' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e2.message_id and f4.id=e2.message_id;
SELECT post0.content, e0.post_id, forum0.creationdate
FROM r_post post0, r_tag tag0, r_forum forum0, filter_post1 f0, message f1, forum_containerof_message e0, message_hastag_tag e1
WHERE e0.post_id = post0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and f1.type='Post' and e0.post_id=e1.message_id and f0.id=e0.post_id and f1.id=e0.post_id;
SELECT person0.firstname, person0.lastname, tag0.name, person1.lastname, person1.firstname
FROM r_person person1, r_tag tag0, r_person person0, filter_person1 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1
WHERE e0.friend_id = person0.id and e1.tag_id = tag0.id and e0.person_id = person1.id and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id;
SELECT tagclass0.name, message0.content, tag0.name, e0.message_id, comment0.content, e0.replied_message_id
FROM r_tagclass tagclass0, r_message message0, r_comment comment0, r_tag tag0, filter_comment2 f0, message f1, filter_message1 f2, message_replyof_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e0.replied_message_id = message0.id and e0.message_id = comment0.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and f1.type='Comment' and e0.replied_message_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id;
SELECT person0.firstname, person0.lastname, organisation0.name
FROM r_organisation organisation0, r_person person0, r_message message0, filter_person1 f0, filter_message2 f1, person_likes_message e0, message_hascreator_person e1, person_workat_organisation e2
WHERE e0.message_id = message0.id and e2.company_id = organisation0.id and e1.person_id = person0.id and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.person_id and f1.id=e0.message_id;
SELECT person0.firstname, company0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_place place0, r_company company0, filter_person1 f0, organisation f1, person_workat_organisation e0, organisation_islocatedin_place e1, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.org_id = organisation0.id and e0.company_id = company0.id and e1.loc_id = place0.id and f1.type='Company' and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.company_id;
SELECT forum0.title, message0.content, message0.creationdate
FROM r_forum forum0, r_person person0, r_message message0, filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, message_hastag_tag e1, filter_forum1 f2, forum_containerof_message e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.forum_id = forum0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.post_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.forum_id;
SELECT person0.firstname, person0.lastname, person1.lastname, person1.firstname, organisation0.name, city0.name
FROM r_organisation organisation0, r_person person0, r_person person1, r_city city0, filter_person1 f0, person_knows_person e0, person_workat_organisation e1, place f1, organisation_islocatedin_place e2
WHERE e2.loc_id = city0.id and e0.person_id = person0.id and e1.company_id = organisation0.id and e0.friend_id = person1.id and f1.type='City' and e0.friend_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.friend_id and f1.id=e2.loc_id;
SELECT person0.firstname, person0.lastname, tag0.name, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_tagclass tagclass0, r_tag tag0, filter_person1 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE e0.person_id = person1.id and e0.friend_id = person0.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id;
SELECT person0.firstname, e1.message_id, person0.lastname, e2.replied_message_id, person1.lastname, person1.firstname
FROM r_person person1, r_person person0, filter_person1 f0, filter_person1 f1, person_knows_person e0, filter_comment2 f2, message f3, person_likes_message e1, filter_post1 f4, message f5, message_replyof_message e2
WHERE e0.person_id = person1.id and e0.friend_id = person0.id and f3.type='Comment' and f5.type='Post' and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.replied_message_id and f5.id=e2.replied_message_id;
SELECT person0.firstname, person0.lastname, message0.content, place0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_message message0, r_place place0, organisation_islocatedin_place e0, filter_message2 f0, message_islocatedin_place e1, filter_person1 f1, message_hascreator_person e2
WHERE e2.person_id = person0.id and e0.org_id = organisation0.id and e1.message_id = message0.id and e0.loc_id = place0.id and e0.loc_id=e1.loc_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e2.person_id;
SELECT comment0.content, message0.content, tag0.name, tagclass0.name
FROM r_tagclass tagclass0, r_message message0, r_comment comment0, r_tag tag0, tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1, filter_comment2 f1, message f2, message_replyof_message e2
WHERE e2.replied_message_id = comment0.id and e1.message_id = message0.id and e0.tag_id = tag0.id and e0.tagclass_id = tagclass0.id and f2.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e2.replied_message_id and f2.id=e2.replied_message_id;
SELECT person0.firstname, person1.firstname, message0.content, comment0.content
FROM r_person person0, r_person person1, r_message message0, r_comment comment0, filter_person1 f0, filter_message1 f1, person_likes_message e0, filter_comment1 f2, message f3, message_replyof_message e1, message_hascreator_person e2
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.message_id = comment0.id and e2.person_id = person1.id and f3.type='Comment' and e0.message_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e1.message_id and f3.id=e1.message_id;
SELECT person0.firstname, person0.lastname, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_person person0, person_workat_organisation e0, place f0, person_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.company_id = organisation0.id and f0.type='City' and e0.person_id=e1.person_id and f0.id=e1.loc_id;
SELECT person0.firstname, tag0.name, person0.lastname, tagclass0.name
FROM r_tagclass tagclass0, r_tag tag0, r_person person0, filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1
WHERE e0.person_id = person0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and f0.id=e0.person_id;
SELECT person0.firstname, person0.lastname, company0.name, country0.name
FROM r_company company0, r_person person0, r_country country0, organisation f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f0.type='Company' and f1.type='Country' and e0.company_id=e1.org_id and f0.id=e0.company_id and f1.id=e1.loc_id;
SELECT forum0.title, tag0.name, comment0.content, post0.content
FROM r_post post0, r_comment comment0, r_forum forum0, r_tag tag0, filter_forum1 f0, filter_post1 f1, message f2, forum_containerof_message e0, message_hastag_tag e1, filter_comment1 f3, message f4, message_hastag_tag e2
WHERE e0.forum_id = forum0.id and e2.message_id = comment0.id and e0.post_id = post0.id and e1.tag_id = tag0.id and f2.type='Post' and f4.type='Comment' and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e2.message_id and f4.id=e2.message_id;
SELECT person0.firstname, message0.content, person0.lastname, comment0.content
FROM r_comment comment0, r_person person0, r_message message0, filter_comment1 f0, message f1, filter_message1 f2, message_replyof_message e0, filter_person1 f3, message_hascreator_person e1
WHERE e1.person_id = person0.id and e0.replied_message_id = message0.id and e0.message_id = comment0.id and f1.type='Comment' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e1.person_id;
SELECT person0.firstname, forum0.title, message0.content, person0.lastname
FROM r_person person0, r_message message0, r_forum forum0, r_tag tag0, person_hasinterest_tag e0, filter_message2 f0, message_hastag_tag e1, forum_containerof_message e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.forum_id = forum0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.post_id and f0.id=e1.message_id;
SELECT person0.firstname, message0.content, person0.lastname, comment0.content
FROM r_person person0, r_message message0, r_comment comment0, r_forum forum0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, filter_comment1 f2, message f3, person_likes_message e1, filter_message1 f4, message_replyof_message e2, forum_containerof_message e3
WHERE e0.person_id = person0.id and e2.replied_message_id = message0.id and e0.forum_id = forum0.id and e1.message_id = comment0.id and f3.type='Comment' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and e0.forum_id=e3.forum_id and e2.replied_message_id=e3.post_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.replied_message_id;
SELECT person0.firstname, person0.lastname, message0.content, tag0.name, comment0.content
FROM r_person person0, r_message message0, r_comment comment0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, message_hastag_tag e1, filter_comment2 f2, message f3, message_replyof_message e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.message_id = comment0.id and e0.tag_id = tag0.id and f3.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.replied_message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.message_id and f3.id=e2.message_id;
SELECT person0.firstname, person0.lastname, country0.name, person1.lastname, person1.firstname, organisation0.name
FROM r_organisation organisation0, r_person person0, r_person person1, r_country country0, filter_person1 f0, person_knows_person e0, person_workat_organisation e1, place f1, organisation_islocatedin_place e2
WHERE e0.person_id = person1.id and e1.company_id = organisation0.id and e2.loc_id = country0.id and e0.friend_id = person0.id and f1.type='Country' and e0.friend_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.person_id and f1.id=e2.loc_id;
SELECT person0.firstname, person0.lastname, country0.name, place0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_country country0, r_place place0, filter_person1 f0, person_workat_organisation e0, organisation_islocatedin_place e1, place f1, place_ispartof_place e2
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e1.loc_id = place0.id and e2.reg_id = country0.id and f1.type='Country' and e0.company_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e2.reg_id;
SELECT message0.content, tag0.name, e0.message_id, tagclass0.name
FROM r_tagclass tagclass0, r_tag tag0, r_message message0, filter_message2 f0, message_hastag_tag e0, tag_hastype_tagclass e1
WHERE e0.message_id = message0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and f0.id=e0.message_id;
SELECT comment2.content, tag0.name, comment1.content, comment0.content
FROM r_comment comment2, r_comment comment0, r_tag tag0, r_comment comment1, filter_comment2 f0, message f1, filter_comment1 f2, message f3, message_replyof_message e0, filter_comment1 f4, message f5, message_replyof_message e1, message_hastag_tag e2
WHERE e0.message_id = comment2.id and e0.replied_message_id = comment1.id and e2.tag_id = tag0.id and e1.message_id = comment0.id and f1.type='Comment' and f3.type='Comment' and f5.type='Comment' and e0.replied_message_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.message_id and f5.id=e1.message_id;
SELECT person0.firstname, person0.lastname, post0.content, country0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_post post0, r_country country0, place f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, filter_post2 f2, message f3, person_likes_message e2
WHERE e1.person_id = person0.id and e2.message_id = post0.id and e0.org_id = organisation0.id and e0.loc_id = country0.id and f0.type='Country' and f3.type='Post' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e1.person_id and f2.id=e2.message_id and f3.id=e2.message_id;
SELECT person0.firstname, person0.lastname, country0.name, university0.name, city0.name
FROM r_person person0, r_country country0, r_city city0, r_university university0, organisation f0, person_studyat_organisation e0, place f1, organisation_islocatedin_place e1, place f2, place_ispartof_place e2
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and e2.reg_id = country0.id and f0.type='University' and f1.type='City' and f2.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.university_id and f1.id=e1.loc_id and f2.id=e2.reg_id;
SELECT tag0.name, tagclass0.name, post0.content
FROM r_post post0, r_tagclass tagclass0, r_tag tag0, filter_post1 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1
WHERE e0.message_id = post0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and f1.type='Post' and e0.tag_id=e1.tag_id and f0.id=e0.message_id and f1.id=e0.message_id;
SELECT person0.firstname, country0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_country country0, r_continent continent0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1, place f2, place_ispartof_place e2
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e2.reg_id = continent0.id and e1.loc_id = country0.id and f1.type='Country' and f2.type='Continent' and e0.company_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e1.loc_id and f2.id=e2.reg_id;
SELECT person0.firstname, person1.firstname, message0.content
FROM r_person person0, r_person person1, r_message message0, r_place place0, filter_person1 f0, filter_message2 f1, person_likes_message e0, filter_person1 f2, message_hascreator_person e1, person_islocatedin_place e2
WHERE e0.message_id = message0.id and e0.person_id = person1.id and e2.loc_id = place0.id and e1.person_id = person0.id and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e1.person_id;
SELECT person0.firstname, message0.content, person0.lastname
FROM r_tag tag0, r_message message0, r_person person0, filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, message_hastag_tag e1
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, forum0.title, message0.content, person0.lastname
FROM r_forum forum0, r_person person0, r_message message0, filter_forum2 f0, filter_message1 f1, forum_containerof_message e0, message_hascreator_person e1
WHERE e1.person_id = person0.id and e0.post_id = message0.id and e0.forum_id = forum0.id and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id;
SELECT person0.firstname, forum0.title, person0.lastname, company0.name, place0.name
FROM r_person person0, r_place place0, r_forum forum0, r_company company0, filter_forum2 f0, forum_hasmember_person e0, organisation f1, person_workat_organisation e1, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.loc_id = place0.id and e0.forum_id = forum0.id and e1.company_id = company0.id and f1.type='Company' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.forum_id and f1.id=e1.company_id;
SELECT person0.firstname, forum0.title, message0.content, person0.lastname
FROM r_forum forum0, r_person person0, r_message message0, filter_forum1 f0, forum_hasmember_person e0, filter_message2 f1, person_likes_message e1
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e0.forum_id = forum0.id and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e1.message_id;
SELECT person0.firstname, message0.content, tag0.name, e0.person_id, e1.message_id, place0.name
FROM r_person person0, r_message message0, r_place place0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, message_hastag_tag e1, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.loc_id = place0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id;
TODO;
SELECT person0.firstname, message0.content, person0.lastname, comment0.content
FROM r_person person0, r_message message0, r_comment comment0, r_tag tag0, person_hasinterest_tag e0, filter_message2 f0, message_hastag_tag e1, filter_comment2 f1, message f2, message_replyof_message e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.message_id = comment0.id and e0.tag_id = tag0.id and f2.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.replied_message_id and f0.id=e1.message_id and f1.id=e2.message_id and f2.id=e2.message_id;
SELECT person0.firstname, person0.lastname, post0.content, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_post post0, r_forum forum0, filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, filter_person1 f3, message_hascreator_person e1, person_knows_person e2
WHERE e0.forum_id = forum0.id and e0.post_id = post0.id and e2.person_id = person1.id and e1.person_id = person0.id and f2.type='Post' and e0.post_id=e1.message_id and e1.person_id=e2.friend_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.person_id;
SELECT e1.person_id, person0.firstname, message0.content, e0.person_id, company0.name, e0.message_id, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_company company0, filter_message1 f0, person_likes_message e0, message_hascreator_person e1, organisation f1, person_workat_organisation e2
WHERE e0.person_id = person1.id and e0.message_id = message0.id and e2.company_id = company0.id and e1.person_id = person0.id and f1.type='Company' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e2.company_id;
SELECT forum0.title, tagclass0.name, message0.content, e0.forum_id, tag0.name, e0.post_id
FROM r_tagclass tagclass0, r_message message0, r_forum forum0, r_tag tag0, filter_forum1 f0, filter_message2 f1, forum_containerof_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e0.post_id = message0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.post_id;
SELECT person0.firstname, forum0.title, person0.lastname, post0.content
FROM r_forum forum0, r_person person0, r_post post0, filter_post1 f0, message f1, forum_containerof_message e0, forum_hasmember_person e1
WHERE e1.person_id = person0.id and e0.post_id = post0.id and e0.forum_id = forum0.id and f1.type='Post' and e0.forum_id=e1.forum_id and f0.id=e0.post_id and f1.id=e0.post_id;
TODO;
SELECT forum0.title, tag0.name, comment0.content, post0.content
FROM r_post post0, r_comment comment0, r_forum forum0, r_tag tag0, filter_post2 f0, message f1, forum_containerof_message e0, filter_comment2 f2, message f3, message_replyof_message e1, message_hastag_tag e2
WHERE e1.message_id = comment0.id and e0.post_id = post0.id and e0.forum_id = forum0.id and e2.tag_id = tag0.id and f1.type='Post' and f3.type='Comment' and e0.post_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e1.message_id and f3.id=e1.message_id;
SELECT person0.firstname, forum0.title, e0.person_id, e1.message_id, post0.content, e0.forum_id, tag0.name
FROM r_person person0, r_post post0, r_forum forum0, r_tag tag0, filter_forum2 f0, forum_hasmoderator_person e0, filter_post2 f1, message f2, person_likes_message e1, message_hastag_tag e2
WHERE e0.forum_id = forum0.id and e0.person_id = person0.id and e1.message_id = post0.id and e2.tag_id = tag0.id and f2.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e1.message_id and f2.id=e1.message_id;
SELECT person0.firstname, person0.lastname, company0.name, country0.name
FROM r_person person0, r_company company0, r_country country0, organisation f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f0.type='Company' and f1.type='Country' and e0.company_id=e1.org_id and f0.id=e0.company_id and f1.id=e1.loc_id;
TODO;
SELECT tagclass0.name, message0.content, tag0.name, e0.message_id, tagclass1.name
FROM r_tagclass tagclass1, r_tagclass tagclass0, r_message message0, r_tag tag0, filter_message2 f0, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e1.tagclass_id = tagclass1.id and e0.message_id = message0.id and e2.subtag_id = tagclass0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.message_id;
SELECT person0.firstname, person0.lastname, message0.content, tag0.name, e0.person_id, e1.message_id
FROM r_tag tag0, r_person person0, r_message message0, filter_person1 f0, person_knows_person e0, filter_message1 f1, person_likes_message e1, message_hastag_tag e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.tag_id = tag0.id and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT university0.name, organisation0.name, city0.name
FROM r_organisation organisation0, r_person person0, r_person person1, r_city city0, r_university university0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1, organisation f2, organisation_islocatedin_place e2, person_studyat_organisation e3, person_knows_person e4
WHERE e1.loc_id = city0.id and e0.company_id = organisation0.id and e0.person_id = person1.id and e3.person_id = person0.id and e2.org_id = university0.id and f1.type='City' and f2.type='University' and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and e2.org_id=e3.university_id and e0.person_id=e4.person_id and e3.person_id=e4.friend_id and f0.id=e0.person_id and f1.id=e1.loc_id and f2.id=e2.org_id;
SELECT message0.content, tag0.name, e0.message_id, tagclass0.name
FROM r_tagclass tagclass1, r_tagclass tagclass0, r_message message0, r_tag tag0, filter_message2 f0, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.message_id = message0.id and e2.subtag_id = tagclass1.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.message_id;
SELECT person0.firstname, person0.lastname, message0.content, person1.lastname, person1.firstname
FROM r_organisation organisation0, r_person person0, r_person person1, r_message message0, filter_person1 f0, person_workat_organisation e0, filter_person1 f1, person_knows_person e1, filter_message1 f2, person_likes_message e2
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e2.message_id = message0.id and e1.person_id = person1.id and e0.person_id=e1.friend_id and e1.person_id=e2.person_id and f0.id=e0.person_id and f1.id=e1.person_id and f2.id=e2.message_id;
SELECT person0.firstname, forum0.title, person0.lastname
FROM r_forum forum0, r_person person0, r_company company0, filter_forum1 f0, forum_hasmoderator_person e0, organisation f1, person_workat_organisation e1
WHERE e0.forum_id = forum0.id and e0.person_id = person0.id and e1.company_id = company0.id and f1.type='Company' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e1.company_id;
SELECT person0.firstname, message0.content, person0.lastname
FROM r_tagclass tagclass0, r_message message0, r_person person0, filter_message2 f0, message_hascreator_person e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e0.message_id = message0.id and e0.person_id = person0.id and e2.tagclass_id = tagclass0.id and e0.message_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.message_id;
SELECT forum0.title, organisation0.name, place0.name
FROM r_organisation organisation0, r_message message0, r_place place0, r_forum forum0, organisation_islocatedin_place e0, filter_message1 f0, message_islocatedin_place e1, filter_forum2 f1, forum_containerof_message e2
WHERE e0.org_id = organisation0.id and e1.message_id = message0.id and e2.forum_id = forum0.id and e0.loc_id = place0.id and e0.loc_id=e1.loc_id and e1.message_id=e2.post_id and f0.id=e1.message_id and f1.id=e2.forum_id;
SELECT country0.name, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_country country0, place f0, organisation_islocatedin_place e0, place f1, place_ispartof_place e1
WHERE e0.loc_id = city0.id and e0.org_id = organisation0.id and e1.reg_id = country0.id and f0.type='City' and f1.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.loc_id and f1.id=e1.reg_id;
SELECT person0.firstname, forum0.title, comment0.content, post0.content
FROM r_person person0, r_post post0, r_comment comment0, r_forum forum0, filter_comment1 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0, filter_forum1 f4, forum_containerof_message e1, filter_person1 f5, forum_hasmember_person e2
WHERE e1.forum_id = forum0.id and e2.person_id = person0.id and e0.message_id = comment0.id and e0.replied_message_id = post0.id and f1.type='Comment' and f3.type='Post' and e0.replied_message_id=e1.post_id and e1.forum_id=e2.forum_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.forum_id and f5.id=e2.person_id;
SELECT university0.name, person0.firstname, place0.name
FROM r_place place0, r_university university0, r_person person0, filter_person1 f0, organisation f1, person_studyat_organisation e0, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.university_id = university0.id and e1.loc_id = place0.id and f1.type='University' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id;
SELECT person0.firstname, message0.content, post0.content
FROM r_post post0, r_message message0, r_person person0, filter_message1 f0, person_likes_message e0, filter_post1 f1, message f2, message_replyof_message e1
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.replied_message_id = post0.id and f2.type='Post' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e1.replied_message_id and f2.id=e1.replied_message_id;
SELECT person0.firstname, person1.firstname, person2.firstname
FROM r_person person2, r_person person1, r_person person0, filter_person1 f0, filter_person1 f1, person_knows_person e0, filter_person1 f2, person_knows_person e1
WHERE e0.person_id = person0.id and e1.friend_id = person2.id and e0.friend_id = person1.id and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.friend_id;
SELECT university0.name, university1.name, city0.name
FROM r_city city0, r_university university0, r_university university1, organisation f0, place f1, organisation_islocatedin_place e0, organisation f2, organisation_islocatedin_place e1
WHERE e0.loc_id = city0.id and university0.name <> u1.name and e0.org_id = university1.id and e1.org_id = university0.id and f0.type='University' and f1.type='City' and f2.type='University' and e0.loc_id=e1.loc_id and f0.id=e0.org_id and f1.id=e0.loc_id and f2.id=e1.org_id;
SELECT person0.firstname, person0.lastname, person1.lastname, e0.message_id, person1.firstname
FROM r_person person1, r_person person0, filter_person1 f0, filter_message2 f1, person_likes_message e0, message_hascreator_person e1
WHERE e0.person_id = person0.id and e1.person_id = person1.id and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id;
SELECT person0.firstname, person0.lastname, comment0.content, post0.content
FROM r_person person0, r_post post0, r_comment comment0, r_forum forum0, filter_forum1 f0, filter_post1 f1, message f2, forum_containerof_message e0, filter_comment1 f3, message f4, message_replyof_message e1, filter_person1 f5, message_hascreator_person e2
WHERE e1.message_id = comment0.id and e0.forum_id = forum0.id and e0.post_id = post0.id and e2.person_id = person0.id and f2.type='Post' and f4.type='Comment' and e0.post_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.message_id and f4.id=e1.message_id and f5.id=e2.person_id;
SELECT person0.firstname, person0.lastname, person1.lastname, person1.firstname, organisation0.name, city0.name
FROM r_organisation organisation0, r_person person0, r_person person1, r_city city0, filter_person1 f0, person_knows_person e0, person_workat_organisation e1, place f1, organisation_islocatedin_place e2
WHERE e2.loc_id = city0.id and e1.company_id = organisation0.id and e0.person_id = person1.id and e0.friend_id = person0.id and f1.type='City' and e0.friend_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.friend_id and f1.id=e2.loc_id;
SELECT person0.firstname, person0.lastname, message0.content, university0.name, city0.name
FROM r_person person0, r_message message0, r_city city0, r_university university0, filter_message1 f0, filter_person1 f1, message_hascreator_person e0, place f2, person_islocatedin_place e1, organisation f3, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.loc_id = city0.id and e2.org_id = university0.id and f2.type='City' and f3.type='University' and e0.person_id=e1.person_id and e1.loc_id=e2.loc_id and f0.id=e0.message_id and f1.id=e0.person_id and f2.id=e1.loc_id and f3.id=e2.org_id;
SELECT person0.firstname, forum0.title, person0.lastname, e0.post_id, tag0.name
FROM r_forum forum0, r_person person0, r_tag tag0, filter_forum1 f0, filter_post2 f1, message f2, forum_containerof_message e0, message_hastag_tag e1, filter_person1 f3, person_hasinterest_tag e2
WHERE e2.person_id = person0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and f2.type='Post' and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e2.person_id;
SELECT person0.firstname, tag0.name, person0.lastname, tagclass0.name
FROM r_person person0, r_tagclass tagclass1, r_tagclass tagclass0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.person_id = person0.id and e1.tagclass_id = tagclass1.id and e0.tag_id = tag0.id and e2.subtag_id = tagclass0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.person_id;
SELECT person0.firstname, tag0.name, comment0.content, post0.content
FROM r_person person0, r_post post0, r_comment comment0, r_tag tag0, filter_post2 f0, message f1, message_hastag_tag e0, filter_comment1 f2, message f3, message_replyof_message e1, message_hascreator_person e2
WHERE e2.person_id = person0.id and e0.message_id = post0.id and e1.message_id = comment0.id and e0.tag_id = tag0.id and f1.type='Post' and f3.type='Comment' and e0.message_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.message_id and f3.id=e1.message_id;
SELECT person0.firstname, person0.lastname, country0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_country country0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e1.loc_id = country0.id and f1.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e1.loc_id;
SELECT person0.firstname, tag0.name, person0.lastname, tagclass1.name
FROM r_person person0, r_tagclass tagclass1, r_tagclass tagclass0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.person_id = person0.id and e1.tagclass_id = tagclass1.id and e2.tag_id = tagclass0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.person_id;
SELECT university0.name, person0.firstname, organisation0.name, place0.name
FROM r_person person0, r_organisation organisation0, r_place place0, r_university university0, organisation f0, organisation_islocatedin_place e0, organisation_islocatedin_place e1, person_workat_organisation e2
WHERE e1.org_id = organisation0.id and e2.person_id = person0.id and e0.org_id = university0.id and e0.loc_id = place0.id and f0.type='University' and e0.loc_id=e1.loc_id and e1.org_id=e2.company_id and f0.id=e0.org_id;
SELECT person1.firstname, message0.content, person1.lastname, e0.message_id
FROM r_person person1, r_person person0, r_message message0, filter_person1 f0, filter_message2 f1, person_likes_message e0, message_hascreator_person e1
WHERE e0.person_id = person1.id and e0.message_id = message0.id and e1.person_id = person0.id and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id;
TODO;
SELECT person0.firstname, person0.lastname, tag0.name, e0.forum_id
FROM r_forum forum0, r_tag tag0, r_person person0, filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id;
SELECT person0.firstname, person0.lastname, person1.lastname, company0.name, person1.firstname
FROM r_person person1, r_person person0, r_company company0, filter_person1 f0, filter_person1 f1, person_knows_person e0, organisation f2, person_workat_organisation e1
WHERE e0.person_id = person0.id and e0.friend_id = person1.id and e1.company_id = company0.id and f2.type='Company' and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.company_id;
SELECT person0.firstname, person0.lastname, country0.name
FROM r_city city0, r_person person0, r_country country0, filter_person1 f0, place f1, person_islocatedin_place e0, place f2, place_ispartof_place e1
WHERE e0.loc_id = city0.id and e0.person_id = person0.id and e1.reg_id = country0.id and f1.type='City' and f2.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.person_id and f1.id=e0.loc_id and f2.id=e1.reg_id;
SELECT post0.content, e1.message_id, comment0.content, e0.message_id
FROM r_comment comment0, r_post post0, filter_post2 f0, message f1, message_hastag_tag e0, filter_comment2 f2, message f3, message_hastag_tag e1, message_replyof_message e2
WHERE e0.message_id = post0.id and e1.message_id = comment0.id and f1.type='Post' and f3.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and e0.message_id=e2.replied_message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.message_id and f3.id=e1.message_id;
SELECT person0.firstname, forum0.title, person0.lastname, e0.post_id
FROM r_forum forum0, r_person person0, filter_post1 f0, message f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1
WHERE e0.forum_id = forum0.id and e1.person_id = person0.id and f1.type='Post' and e0.post_id=e1.message_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e1.person_id;
SELECT person0.firstname, company0.name, person0.lastname, place0.name
FROM r_place place0, r_person person0, r_company company0, organisation f0, person_workat_organisation e0, organisation_islocatedin_place e1
WHERE e1.loc_id = place0.id and e0.person_id = person0.id and e0.company_id = company0.id and f0.type='Company' and e0.company_id=e1.org_id and f0.id=e0.company_id;
SELECT person0.firstname, person0.lastname, message0.content, comment0.content, person1.lastname, person1.firstname, person2.firstname, person2.lastname
FROM r_person person0, r_person person1, r_message message0, r_comment comment0, r_person person2, filter_person1 f0, filter_person1 f1, person_knows_person e0, filter_comment1 f2, message f3, person_likes_message e1, filter_message1 f4, message_replyof_message e2, message_hascreator_person e3
WHERE e0.person_id = person0.id and e1.message_id = comment0.id and e0.friend_id = person1.id and e2.replied_message_id = message0.id and e3.person_id = person2.id and f3.type='Comment' and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and e2.replied_message_id=e3.message_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.replied_message_id;
SELECT person0.firstname, person0.lastname, e0.message_id, e0.replied_message_id, comment0.content
FROM r_comment comment0, r_person person0, filter_comment1 f0, message f1, filter_post2 f2, message f3, message_replyof_message e0, message_hascreator_person e1
WHERE e1.person_id = person0.id and e0.message_id = comment0.id and f1.type='Comment' and f3.type='Post' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id;
SELECT e0.forum_id, tag0.name, forum0.title
FROM r_forum forum0, r_tagclass tagclass0, r_tag tag0, filter_forum2 f0, forum_hastag_tag e0, tag_hastype_tagclass e1
WHERE e0.forum_id = forum0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and f0.id=e0.forum_id;
SELECT message0.content, e1.message_id, message0.creationdate
FROM r_forum forum0, r_person person0, r_message message0, filter_person1 f0, forum_hasmember_person e0, filter_message2 f1, person_likes_message e1
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e0.forum_id = forum0.id and e0.person_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, forum0.title, person0.lastname, e0.post_id, post0.content, e0.forum_id, tag0.name
FROM r_person person0, r_post post0, r_city city0, r_forum forum0, r_tag tag0, filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, message_hastag_tag e1, filter_person1 f3, person_hasinterest_tag e2, place f4, person_islocatedin_place e3
WHERE e3.loc_id = city0.id and e0.forum_id = forum0.id and e2.person_id = person0.id and e0.post_id = post0.id and e1.tag_id = tag0.id and f2.type='Post' and f4.type='City' and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and e2.person_id=e3.person_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e2.person_id and f4.id=e3.loc_id;
SELECT person1.firstname, e0.friend_id, person1.lastname
FROM r_person person1, r_university university0, r_person person0, filter_person1 f0, person_knows_person e0, organisation f1, person_studyat_organisation e1
WHERE e0.person_id = person0.id and e0.friend_id = person1.id and e1.university_id = university0.id and f1.type='University' and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.university_id;
SELECT person0.firstname, company0.name, person0.lastname, e0.person_id
FROM r_company company0, r_person person0, r_country country0, organisation f0, person_workat_organisation e0, organisation_islocatedin_place e1, place f1, place_ispartof_place e2
WHERE e0.person_id = person0.id and e0.company_id = company0.id and e2.reg_id = country0.id and f0.type='Company' and f1.type='Country' and e0.company_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.company_id and f1.id=e2.reg_id;
TODO;
SELECT person0.firstname, person0.lastname, person1.lastname, place0.name, university0.name, person1.firstname
FROM r_person person0, r_person person1, r_place place0, r_university university0, filter_person1 f0, person_knows_person e0, organisation f1, person_studyat_organisation e1, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e0.friend_id = person1.id and e1.university_id = university0.id and e2.loc_id = place0.id and f1.type='University' and e0.friend_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.friend_id and f1.id=e1.university_id;
SELECT person0.firstname, person0.lastname, country0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_country country0, person_workat_organisation e0, place f0, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e1.loc_id = country0.id and f0.type='Country' and e0.company_id=e1.org_id and f0.id=e1.loc_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_city city0, r_university university0, r_person person0, organisation f0, person_studyat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and f0.type='University' and f1.type='City' and e0.university_id=e1.org_id and f0.id=e0.university_id and f1.id=e1.loc_id;
SELECT person0.firstname, forum0.title, person0.lastname, post0.content
FROM r_person person0, r_post post0, r_forum forum0, r_university university0, filter_forum1 f0, filter_post1 f1, message f2, forum_containerof_message e0, filter_person1 f3, message_hascreator_person e1, organisation f4, person_studyat_organisation e2
WHERE e1.person_id = person0.id and e0.forum_id = forum0.id and e0.post_id = post0.id and e2.university_id = university0.id and f2.type='Post' and f4.type='University' and e0.post_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.person_id and f4.id=e2.university_id;
SELECT person0.firstname, e0.message_id, person0.lastname, message0.content, tag0.name, comment0.content, e0.replied_message_id
FROM r_person person0, r_message message0, r_comment comment0, r_tag tag0, filter_comment1 f0, message f1, filter_message2 f2, message_replyof_message e0, message_hascreator_person e1, person_hasinterest_tag e2
WHERE e0.replied_message_id = message0.id and e0.message_id = comment0.id and e2.tag_id = tag0.id and e1.person_id = person0.id and f1.type='Comment' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id;
SELECT person0.firstname, person0.lastname, e0.message_id, post0.content, university0.name, city0.name
FROM r_person person0, r_post post0, r_city city0, r_university university0, filter_post1 f0, message f1, message_hascreator_person e0, organisation f2, person_studyat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE e2.loc_id = city0.id and e0.person_id = person0.id and e0.message_id = post0.id and e1.university_id = university0.id and f1.type='Post' and f2.type='University' and f3.type='City' and e0.person_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.university_id and f3.id=e2.loc_id;
SELECT tag0.name, tagclass0.name, tagclass1.name, e0.tag_id
FROM r_tagclass tagclass1, r_tagclass tagclass0, r_tag tag0, tag_hastype_tagclass e0, tagclass_issubclassof_tagclass e1
WHERE e0.tagclass_id = tagclass1.id and e0.tag_id = tag0.id and e1.tag_id = tagclass0.id and e0.tagclass_id=e1.subtag_id;
TODO;
SELECT university0.name, person0.firstname, person0.lastname, organisation0.name
FROM r_organisation organisation0, r_person person0, r_city city0, r_university university0, place f0, organisation_islocatedin_place e0, organisation f1, organisation_islocatedin_place e1, filter_person1 f2, person_studyat_organisation e2
WHERE e0.loc_id = city0.id and e2.person_id = person0.id and e0.org_id = organisation0.id and e1.org_id = university0.id and f0.type='City' and f1.type='University' and e0.loc_id=e1.loc_id and e1.org_id=e2.university_id and f0.id=e0.loc_id and f1.id=e1.org_id and f2.id=e2.person_id;
SELECT person0.firstname, forum0.title, person0.lastname, post0.content, tag0.name, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_post post0, r_forum forum0, r_tag tag0, filter_post2 f0, message f1, forum_containerof_message e0, message_hastag_tag e1, filter_person1 f2, person_hasinterest_tag e2, filter_person1 f3, person_knows_person e3
WHERE e3.friend_id = person1.id and e0.forum_id = forum0.id and e2.person_id = person0.id and e0.post_id = post0.id and e1.tag_id = tag0.id and f1.type='Post' and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and e2.person_id=e3.person_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e2.person_id and f3.id=e3.friend_id;
SELECT message0.content, tag0.name, tagclass0.name, tagclass1.name
FROM r_tagclass tagclass1, r_tagclass tagclass0, r_message message0, r_tag tag0, filter_message2 f0, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.message_id = message0.id and e2.subtag_id = tagclass1.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.message_id;
SELECT forum0.title, tag0.name, post0.content
FROM r_post post0, r_tagclass tagclass0, r_forum forum0, r_tag tag0, tag_hastype_tagclass e0, filter_post2 f0, message f1, message_hastag_tag e1, forum_containerof_message e2
WHERE e2.forum_id = forum0.id and e1.message_id = post0.id and e0.tag_id = tag0.id and e0.tagclass_id = tagclass0.id and f1.type='Post' and e0.tag_id=e1.tag_id and e1.message_id=e2.post_id and f0.id=e1.message_id and f1.id=e1.message_id;
SELECT person0.firstname, message0.content, person0.lastname, message0.creationdate
FROM r_person person0, r_message message0, r_place place0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, message_hastag_tag e1, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.loc_id = place0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_person person0, r_city city0, r_university university0, r_tag tag0, place f0, organisation f1, organisation_islocatedin_place e0, person_studyat_organisation e1, person_hasinterest_tag e2
WHERE e1.person_id = person0.id and e0.loc_id = city0.id and e0.org_id = university0.id and e2.tag_id = tag0.id and f0.type='City' and f1.type='University' and e0.org_id=e1.university_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e0.org_id;
SELECT person0.firstname, person0.lastname, message0.content, comment0.content, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_comment comment0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message1 f1, message_hastag_tag e1, filter_comment2 f2, message f3, message_replyof_message e2, message_hascreator_person e3
WHERE e1.message_id = message0.id and e0.person_id = person1.id and e2.replied_message_id = comment0.id and e0.tag_id = tag0.id and e3.person_id = person0.id and f3.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and e2.replied_message_id=e3.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.replied_message_id and f3.id=e2.replied_message_id;
SELECT university0.name, message0.content, person0.lastname, person0.firstname
FROM r_university university0, r_person person0, r_message message0, filter_person1 f0, organisation f1, person_studyat_organisation e0, organisation_islocatedin_place e1, filter_message2 f2, message_islocatedin_place e2
WHERE e2.message_id = message0.id and e0.person_id = person0.id and e0.university_id = university0.id and f1.type='University' and e0.university_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e2.message_id;
SELECT person0.email, forum0.title, tag0.name, e0.post_id
FROM r_forum forum0, r_person person0, r_tag tag0, filter_post1 f0, message f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1, person_hasinterest_tag e2
WHERE e0.forum_id = forum0.id and e2.tag_id = tag0.id and e1.person_id = person0.id and f1.type='Post' and e0.post_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e1.person_id;
SELECT person0.firstname, tag0.name, message0.content, person1.lastname
FROM r_person person0, r_person person1, r_message message0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, message_hastag_tag e1, filter_forum2 f2, forum_containerof_message e2, forum_hasmoderator_person e3
WHERE e0.person_id = person0.id and e3.person_id = person1.id and e1.message_id = message0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.post_id and e2.forum_id=e3.forum_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.forum_id;
SELECT university0.name, person0.firstname, person1.lastname, company0.name
FROM r_person person0, r_person person1, r_university university0, r_company company0, organisation f0, filter_person1 f1, person_studyat_organisation e0, person_knows_person e1, organisation f2, person_workat_organisation e2
WHERE e0.person_id = person0.id and e1.friend_id = person1.id and e0.university_id = university0.id and e2.company_id = company0.id and f0.type='University' and f2.type='Company' and e0.person_id=e1.person_id and e1.friend_id=e2.person_id and f0.id=e0.university_id and f1.id=e0.person_id and f2.id=e2.company_id;
SELECT person0.firstname, person0.lastname, comment0.content, post0.content
FROM r_comment comment0, r_post post0, r_person person0, filter_comment1 f0, message f1, filter_post1 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, filter_post2 f5, message f6, person_likes_message e2
WHERE e0.replied_message_id = post0.id and e0.message_id = comment0.id and e1.person_id = person0.id and f1.type='Comment' and f3.type='Post' and f6.type='Post' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id and f5.id=e2.message_id and f6.id=e2.message_id;
SELECT person0.firstname, forum0.title, tag0.name, person0.lastname
FROM r_person person0, r_tagclass tagclass0, r_forum forum0, r_tag tag0, filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE e2.tagclass_id = tagclass0.id and e0.person_id = person0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.person_id;
TODO;
SELECT person0.firstname, forum0.title, person0.lastname, university0.name, city0.name
FROM r_person person0, r_city city0, r_forum forum0, r_university university0, filter_forum2 f0, forum_hasmember_person e0, organisation f1, person_studyat_organisation e1, place f2, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e2.loc_id = city0.id and e1.university_id = university0.id and f1.type='University' and f2.type='City' and e0.person_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.forum_id and f1.id=e1.university_id and f2.id=e2.loc_id;
TODO;
SELECT person0.firstname, person0.lastname, company0.name, country0.name
FROM r_company company0, r_person person0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = country0.id and e0.company_id = company0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id;
SELECT person0.firstname, message0.content, person0.lastname, post0.content
FROM r_person person0, r_post post0, r_message message0, r_tag tag0, filter_message2 f0, person_likes_message e0, filter_post1 f1, message f2, message_replyof_message e1, message_hastag_tag e2
WHERE e0.person_id = person0.id and e1.replied_message_id = post0.id and e0.message_id = message0.id and e2.tag_id = tag0.id and f2.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.message_id and f1.id=e1.replied_message_id and f2.id=e1.replied_message_id;
SELECT message0.content, message1.content
FROM r_message message1, r_message message0, filter_message1 f0, message_hastag_tag e0, filter_message2 f1, message_hastag_tag e1
WHERE e1.message_id = message1.id and e0.message_id = message0.id and e0.tag_id=e1.tag_id and f0.id=e0.message_id and f1.id=e1.message_id;
SELECT person0.firstname, person0.lastname, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_person person0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.company_id = organisation0.id and f1.type='City' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e1.loc_id;
SELECT person0.firstname, person0.lastname, comment0.content, person1.lastname, person1.firstname
FROM r_person person1, r_comment comment0, r_person person0, person_knows_person e0, filter_comment1 f0, message f1, person_likes_message e1
WHERE e0.person_id = person1.id and e1.message_id = comment0.id and e0.friend_id = person0.id and f1.type='Comment' and e0.friend_id=e1.person_id and f0.id=e1.message_id and f1.id=e1.message_id;
SELECT e2.message_id, e3.tag_id, e0.message_id, e1.person_id, e0.replied_message_id
FROM r_tag tag0, r_message message0, filter_message2 f0, filter_comment1 f1, message f2, message_replyof_message e0, message_hascreator_person e1, filter_post1 f3, message f4, person_likes_message e2, message_hastag_tag e3
WHERE e0.replied_message_id = message0.id and e3.tag_id = tag0.id and f2.type='Comment' and f4.type='Post' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and e2.message_id=e3.message_id and f0.id=e0.replied_message_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e2.message_id and f4.id=e2.message_id;
SELECT person0.firstname, person0.lastname, message0.content, tag0.name, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_tag tag0, person_hasinterest_tag e0, filter_message2 f0, message_hastag_tag e1, filter_comment2 f1, message f2, message_replyof_message e2, message_hascreator_person e3
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e3.person_id = person1.id and e0.tag_id = tag0.id and f2.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and e2.replied_message_id=e3.message_id and f0.id=e1.message_id and f1.id=e2.replied_message_id and f2.id=e2.replied_message_id;
SELECT person0.firstname, forum0.title, person0.lastname, post0.content, university0.name, city0.name
FROM r_person person0, r_post post0, r_city city0, r_forum forum0, r_university university0, filter_forum1 f0, filter_post2 f1, message f2, forum_containerof_message e0, message_hascreator_person e1, organisation f3, person_studyat_organisation e2, place f4, organisation_islocatedin_place e3
WHERE e1.person_id = person0.id and e0.forum_id = forum0.id and e3.loc_id = city0.id and e0.post_id = post0.id and e2.university_id = university0.id and f2.type='Post' and f3.type='University' and f4.type='City' and e0.post_id=e1.message_id and e1.person_id=e2.person_id and e2.university_id=e3.org_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e2.university_id and f4.id=e3.loc_id;
SELECT e1.loc_id, e2.subreg_id, e0.company_id, e0.person_id
FROM r_person person0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, organisation_islocatedin_place e1, place f2, place_ispartof_place e2
WHERE e0.person_id = person0.id and e2.subreg_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and e1.loc_id=e2.reg_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e2.subreg_id;
SELECT person0.firstname, person0.lastname, person1.lastname, university0.name, person1.firstname, organisation0.name, city0.name
FROM r_organisation organisation0, r_person person0, r_person person1, r_city city0, r_university university0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1, organisation f2, organisation_islocatedin_place e2, filter_person1 f3, person_studyat_organisation e3
WHERE e1.loc_id = city0.id and e3.person_id = person0.id and e0.person_id = person1.id and e0.company_id = organisation0.id and e2.org_id = university0.id and f1.type='City' and f2.type='University' and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and e2.org_id=e3.university_id and f0.id=e0.person_id and f1.id=e1.loc_id and f2.id=e2.org_id and f3.id=e3.person_id;
SELECT person0.firstname, person0.lastname, post0.content, person1.lastname, person1.firstname
FROM r_person person1, r_person person0, r_post post0, filter_person1 f0, person_knows_person e0, filter_post2 f1, message f2, person_likes_message e1
WHERE e0.person_id = person1.id and e1.message_id = post0.id and e0.friend_id = person0.id and f2.type='Post' and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e1.message_id;
SELECT person1.firstname, person1.email, post0.content
FROM r_person person0, r_person person1, r_post post0, r_tag tag0, filter_person1 f0, forum_hasmoderator_person e0, filter_post2 f1, message f2, person_likes_message e1, message_hascreator_person e2, person_hasinterest_tag e3
WHERE e1.message_id = post0.id and e2.person_id = person1.id and e3.tag_id = tag0.id and e0.person_id = person0.id and f2.type='Post' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and e2.person_id=e3.person_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e1.message_id;
SELECT person0.firstname, forum0.title, message0.content, person0.lastname
FROM r_forum forum0, r_person person0, r_message message0, filter_forum2 f0, filter_message2 f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1
WHERE e1.person_id = person0.id and e0.post_id = message0.id and e0.forum_id = forum0.id and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e1.person_id;
SELECT person0.firstname, message0.content, person0.lastname, comment0.content
FROM r_comment comment0, r_person person0, r_message message0, filter_comment1 f0, message f1, filter_message2 f2, message_replyof_message e0, filter_person1 f3, message_hascreator_person e1
WHERE e1.person_id = person0.id and e0.replied_message_id = message0.id and e0.message_id = comment0.id and f1.type='Comment' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e1.person_id;
SELECT person0.firstname, e0.message_id, person0.lastname, comment0.content
FROM r_person person0, r_message message0, r_city city0, r_comment comment0, filter_comment1 f0, message f1, filter_message1 f2, message_replyof_message e0, message_hascreator_person e1, place f3, person_islocatedin_place e2
WHERE e1.person_id = person0.id and e0.replied_message_id = message0.id and e0.message_id = comment0.id and e2.loc_id = city0.id and f1.type='Comment' and f3.type='City' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e2.loc_id;
SELECT person0.firstname, person0.lastname, company0.name, country0.name
FROM r_person person0, r_company company0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id;
SELECT person0.firstname, company0.name, person0.lastname, country0.name
FROM r_person person0, r_company company0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = country0.id and e0.company_id = company0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id;
SELECT place0.name, person0.firstname, comment0.content, post0.content
FROM r_person person0, r_post post0, r_comment comment0, r_place place0, filter_comment1 f0, message f1, filter_post1 f2, message f3, message_replyof_message e0, message_hascreator_person e1, person_islocatedin_place e2
WHERE e1.person_id = person0.id and e0.replied_message_id = post0.id and e0.message_id = comment0.id and e2.loc_id = place0.id and f1.type='Comment' and f3.type='Post' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id;
SELECT person0.firstname, forum0.title, post0.content
FROM r_person person0, r_post post0, r_forum forum0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_forum2 f1, forum_hastag_tag e1, filter_post1 f2, message f3, forum_containerof_message e2
WHERE e0.person_id = person0.id and e1.forum_id = forum0.id and e2.post_id = post0.id and e0.tag_id = tag0.id and f3.type='Post' and e0.tag_id=e1.tag_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id and f2.id=e2.post_id and f3.id=e2.post_id;
SELECT e1.person_id, person0.firstname, e0.message_id, person0.lastname, message0.content, comment0.content, e0.replied_message_id
FROM r_comment comment0, r_person person0, r_message message0, filter_comment1 f0, message f1, filter_message2 f2, message_replyof_message e0, message_hascreator_person e1
WHERE e0.replied_message_id = message0.id and e0.message_id = comment0.id and e1.person_id = person0.id and f1.type='Comment' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id;
SELECT person0.firstname, message0.content, e0.person_id, comment0.content, university0.name
FROM r_person person0, r_message message0, r_comment comment0, r_place place0, r_university university0, organisation f0, person_studyat_organisation e0, organisation_islocatedin_place e1, filter_message1 f1, message_islocatedin_place e2, filter_comment1 f2, message f3, message_replyof_message e3
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.university_id = university0.id and e3.message_id = comment0.id and e1.loc_id = place0.id and f0.type='University' and f3.type='Comment' and e0.university_id=e1.org_id and e1.loc_id=e2.loc_id and e2.message_id=e3.replied_message_id and f0.id=e0.university_id and f1.id=e2.message_id and f2.id=e3.message_id and f3.id=e3.message_id;
SELECT person0.firstname, e0.replied_message_id, message0.content, company0.name, e0.message_id
FROM r_message message0, r_person person0, r_company company0, filter_message1 f0, filter_post1 f1, message f2, message_replyof_message e0, message_hascreator_person e1, organisation f3, person_workat_organisation e2
WHERE e0.message_id = message0.id and e1.person_id = person0.id and e2.company_id = company0.id and f2.type='Post' and f3.type='Company' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.replied_message_id and f2.id=e0.replied_message_id and f3.id=e2.company_id;
SELECT person0.firstname, message0.content, tag0.name, person0.lastname
FROM r_tag tag0, r_person person0, r_message message0, filter_person1 f0, filter_message1 f1, person_likes_message e0, message_hastag_tag e1
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.tag_id = tag0.id and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id;
SELECT tag0.name, message0.content, tag1.name, comment0.content
FROM r_message message0, r_comment comment0, r_tag tag1, r_tag tag0, filter_comment2 f0, message f1, message_hastag_tag e0, filter_message1 f2, message_replyof_message e1, message_hastag_tag e2
WHERE e0.message_id = comment0.id and e2.tag_id = tag0.id and e1.replied_message_id = message0.id and e0.tag_id = tag1.id and f1.type='Comment' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.replied_message_id;
SELECT person0.firstname, tag0.name, person0.lastname, post0.content
FROM r_person person0, r_post post0, r_tagclass tagclass0, r_tag tag0, tag_hastype_tagclass e0, filter_post2 f0, message f1, message_hastag_tag e1, filter_person1 f2, message_hascreator_person e2
WHERE e2.person_id = person0.id and e1.message_id = post0.id and e0.tag_id = tag0.id and e0.tagclass_id = tagclass0.id and f1.type='Post' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e1.message_id and f2.id=e2.person_id;
SELECT person0.firstname, forum0.title, e0.forum_id, e2.message_id, comment0.content, e1.person_id
FROM r_forum forum0, r_comment comment0, r_person person0, filter_message2 f0, forum_containerof_message e0, message_hascreator_person e1, filter_comment2 f1, message f2, person_likes_message e2
WHERE e1.person_id = person0.id and e0.forum_id = forum0.id and e2.message_id = comment0.id and f2.type='Comment' and e0.post_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e2.message_id and f2.id=e2.message_id;
SELECT person0.firstname, tag0.name, person0.lastname, organisation0.name
FROM r_organisation organisation0, r_person person0, r_city city0, r_tag tag0, place f0, organisation_islocatedin_place e0, person_studyat_organisation e1, person_hasinterest_tag e2
WHERE e0.loc_id = city0.id and e0.org_id = organisation0.id and e1.person_id = person0.id and e2.tag_id = tag0.id and f0.type='City' and e0.org_id=e1.university_id and e1.person_id=e2.person_id and f0.id=e0.loc_id;
SELECT person0.firstname, person0.lastname, comment0.content, post0.content
FROM r_post post0, r_comment comment0, r_person person0, filter_comment2 f0, message f1, filter_post1 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1
WHERE e0.message_id = comment0.id and e0.replied_message_id = post0.id and e1.person_id = person0.id and f1.type='Comment' and f3.type='Post' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id;
SELECT person0.firstname, forum0.title, company0.name, person0.lastname
FROM r_forum forum0, r_person person0, r_company company0, filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_workat_organisation e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.company_id = company0.id and f2.type='Company' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.company_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_person person0, r_country country0, r_city city0, r_university university0, filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and e2.reg_id = country0.id and f1.type='University' and f2.type='City' and f3.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.reg_id;
SELECT person0.firstname, person0.lastname, city0.name
FROM r_city city0, r_university university0, r_person person0, organisation f0, place f1, organisation_islocatedin_place e0, filter_person1 f2, person_islocatedin_place e1
WHERE e0.loc_id = city0.id and e1.person_id = person0.id and e0.org_id = university0.id and f0.type='University' and f1.type='City' and e0.loc_id=e1.loc_id and f0.id=e0.org_id and f1.id=e0.loc_id and f2.id=e1.person_id;
SELECT person0.firstname, tagclass0.name, person0.lastname, tagclass1.name
FROM r_tagclass tagclass1, r_tagclass tagclass0, r_person person0, person_hasinterest_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.person_id = person0.id and e1.tagclass_id = tagclass1.id and e2.tag_id = tagclass0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id;
SELECT message0.locationip, message0.content, tag0.name
FROM r_tag tag0, r_tagclass tagclass0, r_message message0, filter_message1 f0, message_hastag_tag e0, tag_hastype_tagclass e1
WHERE e1.tagclass_id = tagclass0.id and e0.message_id = message0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and f0.id=e0.message_id;
SELECT person0.firstname, forum0.title, message0.content, city0.name
FROM r_person person0, r_message message0, r_city city0, r_forum forum0, filter_forum1 f0, filter_message2 f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1, place f3, person_islocatedin_place e2, place f4, place_ispartof_place e3
WHERE e1.person_id = person0.id and e0.post_id = message0.id and e0.forum_id = forum0.id and e2.loc_id = city0.id and f3.type='City' and f4.type='Country' and e0.post_id=e1.message_id and e1.person_id=e2.person_id and e2.loc_id=e3.subreg_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e1.person_id and f3.id=e2.loc_id and f4.id=e3.reg_id;
SELECT person0.firstname, e0.friend_id, message0.content, tag0.name
FROM r_person person0, r_person person1, r_tagclass tagclass0, r_message message0, r_tag tag0, filter_person1 f0, filter_person1 f1, person_knows_person e0, filter_message2 f2, person_likes_message e1, message_hastag_tag e2, tag_hastype_tagclass e3
WHERE e1.message_id = message0.id and e0.person_id = person1.id and e2.tag_id = tag0.id and e0.friend_id = person0.id and e3.tagclass_id = tagclass0.id and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and e2.tag_id=e3.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.message_id;
SELECT person0.firstname, company0.name, person0.lastname, place0.name
FROM r_place place0, r_person person0, r_company company0, organisation f0, person_workat_organisation e0, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = company0.id and e1.loc_id = place0.id and f0.type='Company' and e0.company_id=e1.org_id and f0.id=e0.company_id;
SELECT person0.firstname, person0.lastname, person1.lastname, university0.name, person1.firstname
FROM r_person person1, r_university university0, r_person person0, filter_person1 f0, person_knows_person e0, organisation f1, person_studyat_organisation e1
WHERE e0.person_id = person0.id and e0.friend_id = person1.id and e1.university_id = university0.id and f1.type='University' and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e1.university_id;
SELECT message0.content, tag0.name, e0.message_id, tagclass0.name
FROM r_tag tag0, r_tagclass tagclass0, r_message message0, filter_message2 f0, message_hastag_tag e0, tag_hastype_tagclass e1
WHERE e0.message_id = message0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and f0.id=e0.message_id;
SELECT person0.firstname, person0.lastname, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_person person0, person_workat_organisation e0, place f0, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e1.loc_id = city0.id and f0.type='City' and e0.company_id=e1.org_id and f0.id=e1.loc_id;
SELECT person0.firstname, tag0.name, person0.lastname, tagclass0.name
FROM r_tagclass tagclass0, r_person person0, r_tag tag0, person_hasinterest_tag e0, tag_hastype_tagclass e1
WHERE e0.person_id = person0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id;
SELECT person0.firstname, forum0.title, person0.lastname, city0.name
FROM r_city city0, r_person person0, r_forum forum0, filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, place f2, person_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.loc_id = city0.id and f2.type='City' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.loc_id;
SELECT person0.firstname, person0.lastname, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_person person0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e1.loc_id = city0.id and f1.type='City' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e1.loc_id;
SELECT person0.firstname, message0.content, person0.lastname, post0.content
FROM r_post post0, r_person person0, r_message message0, filter_message1 f0, filter_post1 f1, message f2, message_replyof_message e0, filter_person1 f3, message_hascreator_person e1
WHERE e0.replied_message_id = post0.id and e0.message_id = message0.id and e1.person_id = person0.id and f2.type='Post' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.replied_message_id and f2.id=e0.replied_message_id and f3.id=e1.person_id;
SELECT tagclass1.name, tag0.name, tagclass0.name, post0.content
FROM r_post post0, r_tagclass tagclass1, r_tagclass tagclass0, r_tag tag0, filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e1.tagclass_id = tagclass0.id and e2.tag_id = tagclass1.id and e0.message_id = post0.id and e0.tag_id = tag0.id and f1.type='Post' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.message_id and f1.id=e0.message_id;
SELECT person0.firstname, person0.lastname, person1.lastname, person1.firstname, organisation0.name, city0.name
FROM r_person person0, r_organisation organisation0, r_person person1, r_city city0, person_knows_person e0, person_workat_organisation e1, place f0, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.loc_id = city0.id and e1.company_id = organisation0.id and e0.friend_id = person1.id and f0.type='City' and e0.friend_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e2.loc_id;
SELECT person0.firstname, person0.lastname, e1.person_id
FROM r_city city0, r_tag tag0, r_person person0, place f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, person_hasinterest_tag e2
WHERE e1.person_id = person0.id and e0.loc_id = city0.id and e2.tag_id = tag0.id and f0.type='City' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.loc_id and f1.id=e1.person_id;
SELECT person0.firstname, person0.lastname, company0.name, country0.name
FROM r_person person0, r_company company0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id;
SELECT university0.name, forum0.title, person0.lastname, person0.firstname
FROM r_forum forum0, r_university university0, r_person person0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_studyat_organisation e1
WHERE e0.person_id = person0.id and e1.university_id = university0.id and e0.forum_id = forum0.id and f2.type='University' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.university_id;
SELECT forum0.title, tag0.name, post0.content
FROM r_forum forum0, r_post post0, r_tag tag0, filter_forum1 f0, filter_post2 f1, message f2, forum_containerof_message e0, message_hastag_tag e1
WHERE e0.post_id = post0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and f2.type='Post' and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id;
SELECT person2.firstname, person2.lastname, post0.content
FROM r_person person0, r_person person1, r_post post0, r_person person2, person_knows_person e0, filter_post2 f0, message f1, person_likes_message e1, message_hascreator_person e2
WHERE e0.friend_id = person2.id and e1.message_id = post0.id and e0.person_id = person0.id and e2.person_id = person1.id and f1.type='Post' and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e1.message_id;
SELECT comment0.content, e1.message_id
FROM r_comment comment0, r_person person0, r_tag tag0, filter_message2 f0, person_likes_message e0, filter_comment2 f1, message f2, message_replyof_message e1, message_hastag_tag e2
WHERE e0.person_id = person0.id and e1.message_id = comment0.id and e2.tag_id = tag0.id and f2.type='Comment' and e0.message_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.message_id and f1.id=e1.message_id and f2.id=e1.message_id;
TODO;
SELECT person0.firstname, message0.content, person0.lastname, e0.message_id
FROM r_city city0, r_person person0, r_message message0, filter_message1 f0, message_hascreator_person e0, place f1, person_islocatedin_place e1
WHERE e1.loc_id = city0.id and e0.message_id = message0.id and e0.person_id = person0.id and f1.type='City' and e0.person_id=e1.person_id and f0.id=e0.message_id and f1.id=e1.loc_id;
SELECT country0.name, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_country country0, place f0, organisation_islocatedin_place e0, place f1, place_ispartof_place e1
WHERE e0.loc_id = city0.id and e0.org_id = organisation0.id and e1.reg_id = country0.id and f0.type='City' and f1.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.loc_id and f1.id=e1.reg_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_city city0, r_university university0, r_person person0, filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e1.loc_id = city0.id and e0.person_id = person0.id and e0.university_id = university0.id and f1.type='University' and f2.type='City' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_city city0, r_university university0, r_person person0, organisation f0, place f1, organisation_islocatedin_place e0, filter_person1 f2, person_islocatedin_place e1
WHERE e0.loc_id = city0.id and e1.person_id = person0.id and e0.org_id = university0.id and f0.type='University' and f1.type='City' and e0.loc_id=e1.loc_id and f0.id=e0.org_id and f1.id=e0.loc_id and f2.id=e1.person_id;
SELECT person0.firstname, person0.lastname, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_person person0, filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e2.org_id = organisation0.id and f1.type='University' and f2.type='City' and e0.university_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id;
SELECT tag0.name, comment0.content, post0.content
FROM r_comment comment0, r_post post0, r_tag tag0, filter_comment2 f0, message f1, message_hastag_tag e0, filter_post1 f2, message f3, message_hastag_tag e1
WHERE e1.message_id = post0.id and e0.message_id = comment0.id and e0.tag_id = tag0.id and f1.type='Comment' and f3.type='Post' and e0.tag_id=e1.tag_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.message_id and f3.id=e1.message_id;
Invalid query TODO;
SELECT post0.content, tag0.name, e0.message_id
FROM r_tagclass tagclass0, r_post post0, r_tag tag0, filter_post2 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1
WHERE e1.tagclass_id = tagclass0.id and e0.message_id = post0.id and e0.tag_id = tag0.id and f1.type='Post' and e0.tag_id=e1.tag_id and f0.id=e0.message_id and f1.id=e0.message_id;
SELECT country0.name, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_country country0, place f0, organisation_islocatedin_place e0, place f1, place_ispartof_place e1
WHERE e0.loc_id = city0.id and e0.org_id = organisation0.id and e1.reg_id = country0.id and f0.type='City' and f1.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.loc_id and f1.id=e1.reg_id;
TODO;
SELECT person0.lastname, message0.content, forum0.title, person0.firstname
FROM r_forum forum0, r_person person0, r_message message0, filter_forum1 f0, filter_message2 f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1
WHERE e0.post_id = message0.id and e0.forum_id = forum0.id and e1.person_id = person0.id and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e1.person_id;
SELECT person0.firstname, person0.lastname, place0.name
FROM r_place place0, r_university university0, r_person person0, filter_person1 f0, organisation f1, person_studyat_organisation e0, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.university_id = university0.id and e1.loc_id = place0.id and f1.type='University' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id;
SELECT university0.name, person0.firstname, person0.lastname, place0.name
FROM r_place place0, r_university university0, r_person person0, filter_person1 f0, organisation f1, person_studyat_organisation e0, organisation_islocatedin_place e1
WHERE e1.loc_id = place0.id and e0.university_id = university0.id and e0.person_id = person0.id and f1.type='University' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id;
SELECT message0.content, tag0.name, tagclass0.name
FROM r_tag tag0, r_tagclass tagclass0, r_message message0, filter_message1 f0, message_hastag_tag e0, tag_hastype_tagclass e1
WHERE e1.tagclass_id = tagclass0.id and e0.message_id = message0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and f0.id=e0.message_id;
SELECT person0.firstname, person1.firstname, person1.lastname, person0.lastname
FROM r_person person1, r_city city0, r_person person0, filter_person1 f0, person_knows_person e0, organisation f1, person_studyat_organisation e1, place f2, organisation_islocatedin_place e2
WHERE e2.loc_id = city0.id and e0.person_id = person1.id and e0.friend_id = person0.id and f1.type='University' and f2.type='City' and e0.friend_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.friend_id and f1.id=e1.university_id and f2.id=e2.loc_id;
SELECT company1.name, company0.name
FROM r_company company1, r_company company0, r_country country0, organisation f0, place f1, organisation_islocatedin_place e0, organisation f2, organisation_islocatedin_place e1
WHERE e0.org_id = company0.id and e1.org_id = company1.id and e0.loc_id = country0.id and f0.type='Company' and f1.type='Country' and f2.type='Company' and e0.loc_id=e1.loc_id and f0.id=e0.org_id and f1.id=e0.loc_id and f2.id=e1.org_id;
TODO;
TODO;
SELECT place0.name, message0.content, message0.length
FROM r_place place0, r_person person0, r_message message0, organisation f0, person_studyat_organisation e0, organisation_islocatedin_place e1, filter_message2 f1, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e1.loc_id = place0.id and f0.type='University' and e0.university_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.university_id and f1.id=e2.message_id;
SELECT person0.firstname, forum0.title, person0.lastname, message0.content, place0.name
FROM r_person person0, r_message message0, r_place place0, r_forum forum0, filter_message2 f0, forum_containerof_message e0, message_hascreator_person e1, person_islocatedin_place e2
WHERE e1.person_id = person0.id and e0.forum_id = forum0.id and e0.post_id = message0.id and e2.loc_id = place0.id and e0.post_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.post_id;
SELECT person0.email, person0.firstname, person0.lastname
FROM r_university university0, r_person person0, r_company company0, organisation f0, place f1, organisation_islocatedin_place e0, filter_person1 f2, person_islocatedin_place e1, organisation f3, person_workat_organisation e2
WHERE e1.person_id = person0.id and e2.company_id = company0.id and e0.org_id = university0.id and f0.type='University' and f1.type='City' and f3.type='Company' and e0.loc_id=e1.loc_id and e1.person_id=e2.person_id and f0.id=e0.org_id and f1.id=e0.loc_id and f2.id=e1.person_id and f3.id=e2.company_id;
SELECT message0.content, country0.name, organisation0.name
FROM r_organisation organisation0, r_country country0, r_message message0, place f0, organisation_islocatedin_place e0, filter_message1 f1, message_islocatedin_place e1
WHERE e0.org_id = organisation0.id and e1.message_id = message0.id and e0.loc_id = country0.id and f0.type='Country' and e0.loc_id=e1.loc_id and f0.id=e0.loc_id and f1.id=e1.message_id;
SELECT person0.firstname, person0.lastname, post0.content
FROM r_person person0, r_post post0, r_comment comment0, r_forum forum0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1, filter_comment2 f2, message f3, message_hastag_tag e2, filter_post2 f4, message f5, message_replyof_message e3
WHERE e2.message_id = comment0.id and e0.person_id = person0.id and e3.replied_message_id = post0.id and e0.forum_id = forum0.id and f3.type='Comment' and f5.type='Post' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and e2.message_id=e3.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e2.message_id and f3.id=e2.message_id and f4.id=e3.replied_message_id and f5.id=e3.replied_message_id;
SELECT message0.content, tag0.name, comment0.content
FROM r_comment comment0, r_tag tag0, r_message message0, filter_comment1 f0, message f1, filter_message1 f2, message_replyof_message e0, message_hastag_tag e1
WHERE e0.replied_message_id = message0.id and e0.message_id = comment0.id and e1.tag_id = tag0.id and f1.type='Comment' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id;
SELECT person0.firstname, e2.person_id, person0.lastname
FROM r_organisation organisation0, r_person person0, place f0, organisation_islocatedin_place e0, organisation f1, organisation_islocatedin_place e1, filter_person1 f2, person_studyat_organisation e2
WHERE e0.org_id = organisation0.id and e2.person_id = person0.id and f0.type='City' and f1.type='University' and e0.loc_id=e1.loc_id and e1.org_id=e2.university_id and f0.id=e0.loc_id and f1.id=e1.org_id and f2.id=e2.person_id;
SELECT e0.post_id, post0.creationdate, post0.content
FROM r_forum forum0, r_post post0, r_tag tag0, filter_post2 f0, message f1, forum_containerof_message e0, message_hastag_tag e1, filter_person1 f2, person_hasinterest_tag e2
WHERE e1.tag_id = tag0.id and e0.forum_id = forum0.id and e0.post_id = post0.id and f1.type='Post' and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e2.person_id;
TODO;
SELECT message0.content, e0.message_id, message0.creationdate
FROM r_message message0, r_country country0, filter_message2 f0, message_islocatedin_place e0, place f1, place_ispartof_place e1
WHERE e0.message_id = message0.id and e1.subreg_id = country0.id and f1.type='Country' and e0.loc_id=e1.reg_id and f0.id=e0.message_id and f1.id=e1.subreg_id;
SELECT comment0.creationdate, e0.message_id, comment0.content
FROM r_comment comment0, r_tagclass tagclass0, filter_comment1 f0, message f1, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e1.tagclass_id = tagclass0.id and e0.message_id = comment0.id and f1.type='Comment' and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id;
SELECT person0.firstname, person0.lastname, country0.name, university0.name, city0.name
FROM r_person person0, r_country country0, r_city city0, r_university university0, filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE e1.loc_id = city0.id and e0.person_id = person0.id and e0.university_id = university0.id and e2.reg_id = country0.id and f1.type='University' and f2.type='City' and f3.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.reg_id;
TODO;
SELECT message0.content, tag0.name, e0.message_id, tagclass0.name
FROM r_message message0, r_tagclass tagclass0, r_tag tag0, filter_message1 f0, message_hastag_tag e0, tag_hastype_tagclass e1
WHERE e0.message_id = message0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and f0.id=e0.message_id;
TODO;
SELECT e2.org_id, organisation0.name
FROM r_organisation organisation0, r_city city0, r_person person0, organisation f0, person_studyat_organisation e0, place f1, organisation_islocatedin_place e1, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e2.org_id = organisation0.id and f0.type='University' and f1.type='City' and e0.university_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.university_id and f1.id=e1.loc_id;
SELECT person0.firstname, person0.lastname, e0.person_id
FROM r_person person0, r_country country0, organisation f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = country0.id and f0.type='Company' and f1.type='Country' and e0.company_id=e1.org_id and f0.id=e0.company_id and f1.id=e1.loc_id;
SELECT continent0.name, person0.firstname, company0.name, person0.lastname
FROM r_person person0, r_country country0, r_continent continent0, r_company company0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE e0.person_id = person0.id and e2.reg_id = continent0.id and e1.loc_id = country0.id and e0.company_id = company0.id and f1.type='Company' and f2.type='Country' and f3.type='Continent' and e0.company_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id and f3.id=e2.reg_id;
SELECT message0.content, message1.content
FROM r_message message1, r_message message0, filter_message1 f0, message_hastag_tag e0, filter_message1 f1, message_hastag_tag e1
WHERE e0.message_id = message0.id and e1.message_id = message1.id and e0.tag_id=e1.tag_id and f0.id=e0.message_id and f1.id=e1.message_id;
SELECT forum0.title, post0.content
FROM r_post post0, r_tag tag0, r_forum forum0, filter_forum1 f0, filter_post1 f1, message f2, forum_containerof_message e0, message_hastag_tag e1
WHERE e0.post_id = post0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and f2.type='Post' and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id;
SELECT person0.firstname, tag0.name, person0.lastname
FROM r_tagclass tagclass0, r_tag tag0, r_person person0, person_hasinterest_tag e0, tag_hastype_tagclass e1
WHERE e0.person_id = person0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id;
SELECT person0.firstname, company0.name, person0.lastname
FROM r_company company0, r_person person0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e1.loc_id = country0.id and e0.person_id = person0.id and e0.company_id = company0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id;
SELECT forum0.title, tagclass0.name, message0.content, e0.forum_id, tag0.name
FROM r_tagclass tagclass0, r_message message0, r_forum forum0, r_tag tag0, filter_forum1 f0, filter_message1 f1, forum_containerof_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e0.post_id = message0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.post_id;
SELECT person0.firstname, person0.lastname, message0.content, e0.replied_message_id, e0.message_id
FROM r_person person0, r_message message0, filter_message2 f0, filter_post2 f1, message f2, message_replyof_message e0, message_hascreator_person e1
WHERE e0.message_id = message0.id and e1.person_id = person0.id and f2.type='Post' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.replied_message_id and f2.id=e0.replied_message_id;
SELECT person0.firstname, person1.firstname, university0.name, e0.person_id
FROM r_person person1, r_university university0, r_person person0, person_knows_person e0, organisation f0, person_studyat_organisation e1
WHERE e0.friend_id = person0.id and e1.university_id = university0.id and e0.person_id = person1.id and f0.type='University' and e0.friend_id=e1.person_id and f0.id=e1.university_id;
SELECT person0.firstname, person0.lastname, person1.lastname, company0.name, university0.name, person1.firstname
FROM r_person person0, r_person person1, r_university university0, r_company company0, organisation f0, filter_person1 f1, person_workat_organisation e0, filter_person1 f2, person_knows_person e1, organisation f3, person_studyat_organisation e2
WHERE e2.university_id = university0.id and e1.person_id = person0.id and e0.person_id = person1.id and e0.company_id = company0.id and f0.type='Company' and f3.type='University' and e0.person_id=e1.friend_id and e1.person_id=e2.person_id and f0.id=e0.company_id and f1.id=e0.person_id and f2.id=e1.person_id and f3.id=e2.university_id;
SELECT person0.firstname, forum0.title, person0.lastname, place0.name, university0.name
FROM r_person person0, r_place place0, r_forum forum0, r_university university0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_studyat_organisation e1, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.university_id = university0.id and e2.loc_id = place0.id and f2.type='University' and e0.person_id=e1.person_id and e1.university_id=e2.org_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.university_id;
SELECT person0.firstname, person0.lastname, e1.message_id, tag0.name, e0.message_id
FROM r_tag tag0, r_message message0, r_person person0, filter_message1 f0, message_hastag_tag e0, filter_comment2 f1, message f2, message_replyof_message e1, message_hascreator_person e2
WHERE e2.person_id = person0.id and e0.message_id = message0.id and e0.tag_id = tag0.id and f2.type='Comment' and e0.message_id=e1.replied_message_id and e1.message_id=e2.message_id and f0.id=e0.message_id and f1.id=e1.message_id and f2.id=e1.message_id;
SELECT person0.firstname, person0.lastname, tagclass0.name, message0.content, tag0.name
FROM r_person person0, r_tagclass tagclass0, r_message message0, r_tag tag0, filter_person1 f0, filter_message1 f1, person_likes_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e2.tagclass_id = tagclass0.id and e0.person_id = person0.id and e0.message_id = message0.id and e1.tag_id = tag0.id and e0.message_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.message_id;
SELECT person0.firstname, e1.company_id, e0.person_id, company0.name, person1.firstname, e0.friend_id
FROM r_person person1, r_person person0, r_company company0, filter_person1 f0, filter_person1 f1, person_knows_person e0, organisation f2, person_workat_organisation e1
WHERE e0.person_id = person1.id and e0.friend_id = person0.id and e1.company_id = company0.id and f2.type='Company' and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.company_id;
SELECT person0.lastname, message0.content, country0.name, person0.firstname
FROM r_person person0, r_message message0, r_country country0, filter_message1 f0, message_hascreator_person e0, place f1, message_islocatedin_place e1
WHERE e0.message_id = message0.id and e0.person_id = person0.id and e1.loc_id = country0.id and f1.type='Country' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e1.loc_id;
TODO;
SELECT person0.firstname, country0.name, e0.person_id, e0.company_id, e1.loc_id, organisation0.name
FROM r_organisation organisation0, r_person person0, r_country country0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e1.loc_id = country0.id and f1.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e1.loc_id;
TODO;
SELECT person0.firstname, forum0.title, e0.person_id, e0.forum_id, person1.firstname, e1.friend_id
FROM r_person person1, r_forum forum0, r_person person0, filter_person1 f0, forum_hasmoderator_person e0, person_knows_person e1
WHERE e0.person_id = person0.id and e1.friend_id = person1.id and e0.forum_id = forum0.id and e0.person_id=e1.person_id and f0.id=e0.person_id;
SELECT person0.firstname, e0.company_id, e1.loc_id, e0.person_id, company0.name, place0.name
FROM r_place place0, r_person person0, r_company company0, filter_person1 f0, organisation f1, person_workat_organisation e0, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = place0.id and e0.company_id = company0.id and f1.type='Company' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id;
SELECT person0.firstname, message0.content, tag0.name, e0.person_id, e0.message_id, e1.tag_id
FROM r_message message0, r_person person0, r_tag tag0, filter_person1 f0, filter_message1 f1, person_likes_message e0, message_hastag_tag e1
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.tag_id = tag0.id and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id;
SELECT tag0.name, forum0.title, message0.content
FROM r_tagclass tagclass0, r_message message0, r_forum forum0, r_tag tag0, filter_forum2 f0, filter_message1 f1, forum_containerof_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e0.post_id = message0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.post_id;
SELECT person0.firstname, person0.lastname, person1.lastname, company0.name, person1.firstname
FROM r_person person1, r_person person0, r_company company0, filter_person1 f0, filter_person1 f1, person_knows_person e0, organisation f2, person_workat_organisation e1
WHERE e0.friend_id = person1.id and e0.person_id = person0.id and e1.company_id = company0.id and f2.type='Company' and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.company_id;
SELECT person0.firstname, person0.lastname, tagclass0.name, tag0.name, tagclass1.name
FROM r_person person0, r_tagclass tagclass1, r_tagclass tagclass0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.person_id = person0.id and e1.tagclass_id = tagclass1.id and e2.tag_id = tagclass0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.subtag_id and f0.id=e0.person_id;
SELECT person0.firstname, person0.lastname, country0.name, organisation0.name, city0.name
FROM r_organisation organisation0, r_person person0, r_country country0, r_city city0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1, place f2, place_ispartof_place e2
WHERE e1.loc_id = city0.id and e0.person_id = person0.id and e0.company_id = organisation0.id and e2.reg_id = country0.id and f1.type='City' and f2.type='Country' and e0.company_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.person_id and f1.id=e1.loc_id and f2.id=e2.reg_id;
SELECT person0.lastname, message0.content, forum0.title, person0.firstname
FROM r_forum forum0, r_person person0, r_message message0, filter_forum1 f0, filter_message1 f1, forum_containerof_message e0, message_hascreator_person e1
WHERE e0.forum_id = forum0.id and e0.post_id = message0.id and e1.person_id = person0.id and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id;
SELECT message0.content, tag0.name, comment0.content
FROM r_tagclass tagclass0, r_message message0, r_comment comment0, r_tag tag0, tag_hastype_tagclass e0, filter_message2 f0, message_hastag_tag e1, filter_comment2 f1, message f2, message_replyof_message e2
WHERE e1.message_id = message0.id and e2.message_id = comment0.id and e0.tag_id = tag0.id and e0.tagclass_id = tagclass0.id and f2.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.replied_message_id and f0.id=e1.message_id and f1.id=e2.message_id and f2.id=e2.message_id;
SELECT person0.firstname, person0.lastname, post0.content, person1.lastname, person1.firstname
FROM r_organisation organisation0, r_person person0, r_person person1, r_post post0, filter_person1 f0, person_workat_organisation e0, person_knows_person e1, filter_post1 f1, message f2, person_likes_message e2
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e1.friend_id = person1.id and e2.message_id = post0.id and f2.type='Post' and e0.person_id=e1.person_id and e1.friend_id=e2.person_id and f0.id=e0.person_id and f1.id=e2.message_id and f2.id=e2.message_id;
SELECT person0.firstname, person0.lastname, message0.content, person1.lastname, place0.name, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_place place0, filter_message1 f0, person_likes_message e0, filter_person1 f1, message_hascreator_person e1, person_islocatedin_place e2
WHERE e0.person_id = person1.id and e0.message_id = message0.id and e2.loc_id = place0.id and e1.person_id = person0.id and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e1.person_id;
SELECT person0.firstname, forum0.title, person0.lastname, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_forum forum0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_forum2 f1, forum_hastag_tag e1, forum_hasmoderator_person e2
WHERE e0.person_id = person1.id and e1.forum_id = forum0.id and e0.tag_id = tag0.id and e2.person_id = person0.id and e0.tag_id=e1.tag_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id;
SELECT person0.firstname, person0.lastname, person1.lastname, company0.name, person1.firstname
FROM r_person person0, r_person person1, r_country country0, r_company company0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1, filter_person1 f3, person_knows_person e2
WHERE e0.person_id = person0.id and e2.friend_id = person1.id and e0.company_id = company0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and e0.person_id=e2.person_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id and f3.id=e2.friend_id;
SELECT person0.firstname, person0.lastname, comment0.content
FROM r_comment comment0, r_person person0, r_message message0, person_hasinterest_tag e0, filter_message1 f0, message_hastag_tag e1, filter_comment2 f1, message f2, message_replyof_message e2
WHERE e0.person_id = person0.id and e2.replied_message_id = comment0.id and e1.message_id = message0.id and f2.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e1.message_id and f1.id=e2.replied_message_id and f2.id=e2.replied_message_id;
SELECT person0.firstname, person0.lastname, organisation0.name
FROM r_organisation organisation0, r_city city0, r_person person0, place f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1
WHERE e1.person_id = person0.id and e0.loc_id = city0.id and e0.org_id = organisation0.id and f0.type='City' and e0.org_id=e1.company_id and f0.id=e0.loc_id and f1.id=e1.person_id;
SELECT person0.firstname, tag0.name, person0.lastname, post0.content
FROM r_person person0, r_post post0, r_tagclass tagclass0, r_tag tag0, filter_post2 f0, message f1, person_likes_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e0.person_id = person0.id and e0.message_id = post0.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and f1.type='Post' and e0.message_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id;
SELECT person0.firstname, message0.content, person0.lastname, message0.creationdate
FROM r_tag tag0, r_message message0, r_person person0, filter_message2 f0, message_hastag_tag e0, filter_message2 f1, message_hastag_tag e1, filter_person1 f2, message_hascreator_person e2
WHERE e0.message_id = message0.id and e0.tag_id = tag0.id and e2.person_id = person0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.message_id and f1.id=e1.message_id and f2.id=e2.person_id;
TODO;
TODO;
SELECT message0.content, company0.name, country0.name, message0.creationdate
FROM r_company company0, r_message message0, r_country country0, filter_message2 f0, filter_person1 f1, message_hascreator_person e0, organisation f2, person_workat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE e1.company_id = company0.id and e0.message_id = message0.id and e2.loc_id = country0.id and f2.type='Company' and f3.type='Country' and e0.person_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.message_id and f1.id=e0.person_id and f2.id=e1.company_id and f3.id=e2.loc_id;
SELECT person0.firstname, person0.lastname, comment0.creationdate, comment0.content, university0.name
FROM r_comment comment0, r_university university0, r_person person0, filter_comment1 f0, message f1, filter_message1 f2, message_replyof_message e0, message_hascreator_person e1, organisation f3, person_studyat_organisation e2
WHERE e0.message_id = comment0.id and e2.university_id = university0.id and e1.person_id = person0.id and f1.type='Comment' and f3.type='University' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e2.university_id;
SELECT person0.email, person0.firstname, person0.lastname, organisation0.name
FROM r_organisation organisation0, r_city city0, r_person person0, filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e2.org_id = organisation0.id and f1.type='University' and f2.type='City' and e0.university_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id;
SELECT e1.message_id, comment0.content
FROM r_person person1, r_comment comment0, r_person person0, filter_person1 f0, person_hasinterest_tag e0, filter_message1 f1, message_hastag_tag e1, filter_comment1 f2, message f3, message_replyof_message e2, filter_person1 f4, message_hascreator_person e3
WHERE e0.person_id = person0.id and e2.replied_message_id = comment0.id and e3.person_id = person1.id and f3.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and e2.replied_message_id=e3.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.replied_message_id and f3.id=e2.replied_message_id and f4.id=e3.person_id;
SELECT forum0.title, e0.message_id
FROM r_forum forum0, r_person person0, r_tag tag0, filter_post2 f0, message f1, message_hastag_tag e0, filter_forum1 f2, forum_containerof_message e1, filter_person1 f3, forum_hasmember_person e2
WHERE e1.forum_id = forum0.id and e2.person_id = person0.id and e0.tag_id = tag0.id and f1.type='Post' and e0.message_id=e1.post_id and e1.forum_id=e2.forum_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.forum_id and f3.id=e2.person_id;
SELECT person0.firstname, person0.lastname, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_person person0, place f0, organisation_islocatedin_place e0, filter_person1 f1, person_islocatedin_place e1
WHERE e0.loc_id = city0.id and e0.org_id = organisation0.id and e1.person_id = person0.id and f0.type='City' and e0.loc_id=e1.loc_id and f0.id=e0.loc_id and f1.id=e1.person_id;
SELECT e0.person_id, message0.content
FROM r_message message0, r_post post0, r_tag tag0, filter_post2 f0, message f1, message_hascreator_person e0, person_hasinterest_tag e1, filter_message2 f2, message_hastag_tag e2
WHERE e2.message_id = message0.id and e0.message_id = post0.id and e1.tag_id = tag0.id and f1.type='Post' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e2.message_id;
SELECT person0.firstname, post0.content, person0.lastname, e0.post_id
FROM r_forum forum0, r_post post0, r_person person0, filter_forum1 f0, filter_post1 f1, message f2, forum_containerof_message e0, filter_person1 f3, message_hascreator_person e1
WHERE e0.post_id = post0.id and e0.forum_id = forum0.id and e1.person_id = person0.id and f2.type='Post' and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e1.person_id;
SELECT person0.firstname, person0.lastname, tagclass0.name, tag0.name, tagclass1.name
FROM r_person person0, r_tagclass tagclass1, r_tagclass tagclass0, r_tag tag0, person_hasinterest_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.person_id = person0.id and e0.tag_id = tag0.id and e2.subtag_id = tagclass0.id and e1.tagclass_id = tagclass1.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id;
SELECT person0.firstname, person0.lastname, post0.content, message0.content, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_post post0, r_message message0, filter_person1 f0, filter_message2 f1, person_likes_message e0, filter_post1 f2, message f3, message_replyof_message e1, filter_person1 f4, message_hascreator_person e2
WHERE e0.person_id = person0.id and e1.replied_message_id = post0.id and e0.message_id = message0.id and e2.person_id = person1.id and f3.type='Post' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e1.replied_message_id and f3.id=e1.replied_message_id and f4.id=e2.person_id;
SELECT person0.firstname, university0.name, person0.lastname
FROM r_organisation organisation0, r_person person0, r_city city0, r_university university0, place f0, organisation_islocatedin_place e0, organisation f1, organisation_islocatedin_place e1, filter_person1 f2, person_studyat_organisation e2
WHERE e0.loc_id = city0.id and e2.person_id = person0.id and e0.org_id = organisation0.id and e1.org_id = university0.id and f0.type='City' and f1.type='University' and e0.loc_id=e1.loc_id and e1.org_id=e2.university_id and f0.id=e0.loc_id and f1.id=e1.org_id and f2.id=e2.person_id;
SELECT person0.firstname, person0.lastname, post0.content, e0.post_id, post0.creationdate
FROM r_forum forum0, r_post post0, r_person person0, filter_post2 f0, message f1, forum_containerof_message e0, filter_person1 f2, message_hascreator_person e1
WHERE e0.forum_id = forum0.id and e0.post_id = post0.id and e1.person_id = person0.id and f1.type='Post' and e0.post_id=e1.message_id and f0.id=e0.post_id and f1.id=e0.post_id and f2.id=e1.person_id;
SELECT e0.message_id, comment0.content, e0.replied_message_id
FROM r_comment comment0, r_tag tag0, filter_comment2 f0, message f1, filter_post1 f2, message f3, message_replyof_message e0, message_hastag_tag e1
WHERE e1.tag_id = tag0.id and e0.message_id = comment0.id and f1.type='Comment' and f3.type='Post' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id;
SELECT person0.firstname, e0.company_id, person0.lastname, comment0.content, e0.person_id, company0.name, e2.replied_message_id
FROM r_comment comment0, r_person person0, r_company company0, organisation f0, person_workat_organisation e0, filter_comment2 f1, message f2, message_hascreator_person e1, filter_message2 f3, message_replyof_message e2
WHERE e0.person_id = person0.id and e1.message_id = comment0.id and e0.company_id = company0.id and f0.type='Company' and f2.type='Comment' and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.company_id and f1.id=e1.message_id and f2.id=e1.message_id and f3.id=e2.replied_message_id;
SELECT e1.replied_message_id, person0.firstname, person0.lastname, e0.message_id
FROM r_person person1, r_comment comment0, r_person person0, filter_person1 f0, filter_message1 f1, person_likes_message e0, filter_comment2 f2, message f3, message_replyof_message e1, message_hascreator_person e2
WHERE e1.replied_message_id = comment0.id and e2.person_id = person0.id and e0.person_id = person1.id and f3.type='Comment' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e1.replied_message_id and f3.id=e1.replied_message_id;
SELECT e1.org_id, university0.name, e0.org_id, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_university university0, organisation f0, place f1, organisation_islocatedin_place e0, organisation_islocatedin_place e1
WHERE e0.loc_id = city0.id and e1.org_id = organisation0.id and e0.org_id = university0.id and f0.type='University' and f1.type='City' and e0.loc_id=e1.loc_id and f0.id=e0.org_id and f1.id=e0.loc_id;
SELECT e2.replied_message_id, comment0.content, person1.lastname, person1.firstname, e0.friend_id
FROM r_person person0, r_person person1, r_post post0, r_comment comment0, filter_person1 f0, filter_person1 f1, person_knows_person e0, filter_comment2 f2, message f3, person_likes_message e1, filter_post2 f4, message f5, message_replyof_message e2
WHERE e0.friend_id = person1.id and e0.person_id = person0.id and e2.replied_message_id = post0.id and e1.message_id = comment0.id and f3.type='Comment' and f5.type='Post' and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.message_id and f3.id=e1.message_id and f4.id=e2.replied_message_id and f5.id=e2.replied_message_id;
SELECT person0.firstname, company0.name, person0.lastname
FROM r_person person0, r_company company0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = country0.id and e0.company_id = company0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id;
SELECT person0.firstname, person0.lastname, tagclass0.name, tag0.name, e0.person_id
FROM r_tagclass tagclass0, r_tag tag0, r_person person0, filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1
WHERE e0.person_id = person0.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and f0.id=e0.person_id;
SELECT person0.firstname, person0.lastname, message0.length, message0.content, tag0.name, e1.person_id
FROM r_tag tag0, r_message message0, r_person person0, filter_message2 f0, message_hastag_tag e0, message_hascreator_person e1
WHERE e1.person_id = person0.id and e0.message_id = message0.id and e0.tag_id = tag0.id and e0.message_id=e1.message_id and f0.id=e0.message_id;
SELECT person0.firstname, person0.lastname, organisation0.name, place0.name
FROM r_organisation organisation0, r_place place0, r_person person0, person_workat_organisation e0, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = place0.id and e0.company_id = organisation0.id and e0.company_id=e1.org_id;
SELECT person0.firstname, person1.firstname, person1.lastname, person0.lastname
FROM r_person person1, r_forum forum0, r_person person0, filter_forum1 f0, forum_hasmember_person e0, person_knows_person e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.friend_id = person1.id and e0.person_id=e1.person_id and f0.id=e0.forum_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_city city0, r_university university0, r_person person0, organisation f0, person_studyat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and f0.type='University' and f1.type='City' and e0.university_id=e1.org_id and f0.id=e0.university_id and f1.id=e1.loc_id;
SELECT forum0.title, e0.post_id, post0.content, e0.forum_id, tag0.name
FROM r_post post0, r_tag tag0, r_forum forum0, filter_post1 f0, message f1, forum_containerof_message e0, message_hastag_tag e1
WHERE e0.forum_id = forum0.id and e0.post_id = post0.id and e1.tag_id = tag0.id and f1.type='Post' and e0.post_id=e1.message_id and f0.id=e0.post_id and f1.id=e0.post_id;
SELECT person0.firstname, forum0.title, person0.lastname, e0.forum_id, e0.person_id, university0.name
FROM r_forum forum0, r_university university0, r_person person0, filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_studyat_organisation e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.university_id = university0.id and f2.type='University' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.university_id;
SELECT person0.firstname, person0.lastname, comment0.creationdate, e0.message_id, message0.content, comment0.content, e1.person_id, e0.replied_message_id
FROM r_comment comment0, r_person person0, r_message message0, filter_comment1 f0, message f1, filter_message2 f2, message_replyof_message e0, message_hascreator_person e1
WHERE e1.person_id = person0.id and e0.replied_message_id = message0.id and e0.message_id = comment0.id and f1.type='Comment' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id;
SELECT person0.firstname, person0.lastname, post0.content, comment0.content, organisation0.name
FROM r_organisation organisation0, r_person person0, r_post post0, r_comment comment0, filter_comment1 f0, message f1, filter_post1 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, person_workat_organisation e2
WHERE e0.message_id = comment0.id and e2.company_id = organisation0.id and e0.replied_message_id = post0.id and e1.person_id = person0.id and f1.type='Comment' and f3.type='Post' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id;
SELECT person0.firstname, person0.lastname, message0.content, tag0.name, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message2 f1, message_hastag_tag e1, message_hascreator_person e2
WHERE e0.person_id = person1.id and e1.message_id = message0.id and e2.person_id = person0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, person0.lastname, country0.name, e0.person_id, place0.name
FROM r_place place0, r_person person0, r_country country0, filter_person1 f0, person_islocatedin_place e0, place f1, place_ispartof_place e1
WHERE e0.person_id = person0.id and e1.reg_id = country0.id and e0.loc_id = place0.id and f1.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.person_id and f1.id=e1.reg_id;
SELECT person0.firstname, person0.lastname, message0.content, tag0.name, e0.person_id, e0.message_id
FROM r_tag tag0, r_message message0, r_person person0, filter_message2 f0, person_likes_message e0, message_hastag_tag e1
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.tag_id = tag0.id and e0.message_id=e1.message_id and f0.id=e0.message_id;
SELECT person0.firstname, person0.lastname, message0.content, comment0.content, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_comment comment0, filter_person1 f0, filter_comment2 f1, message f2, person_likes_message e0, filter_message1 f3, message_replyof_message e1, message_hascreator_person e2
WHERE e0.person_id = person0.id and e1.replied_message_id = message0.id and e0.message_id = comment0.id and e2.person_id = person1.id and f2.type='Comment' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id and f3.id=e1.replied_message_id;
SELECT person0.firstname, person0.lastname, organisation0.name, city0.name
FROM r_organisation organisation0, r_person person0, r_city city0, r_tag tag0, place f0, organisation_islocatedin_place e0, person_workat_organisation e1, person_hasinterest_tag e2
WHERE e1.person_id = person0.id and e0.loc_id = city0.id and e0.org_id = organisation0.id and e2.tag_id = tag0.id and f0.type='City' and e0.org_id=e1.company_id and e1.person_id=e2.person_id and f0.id=e0.loc_id;
SELECT person0.firstname, forum0.title, person0.lastname, message0.content, tag0.name, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_forum forum0, r_tag tag0, person_hasinterest_tag e0, filter_message1 f0, message_hastag_tag e1, forum_containerof_message e2, filter_person1 f1, forum_hasmoderator_person e3
WHERE e1.message_id = message0.id and e2.forum_id = forum0.id and e3.person_id = person0.id and e0.person_id = person1.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.post_id and e2.forum_id=e3.forum_id and f0.id=e1.message_id and f1.id=e3.person_id;
SELECT person0.firstname, forum0.title, person0.lastname, post0.content, tag0.name, university0.name
FROM r_person person0, r_post post0, r_forum forum0, r_university university0, r_tag tag0, filter_forum1 f0, filter_post1 f1, message f2, forum_containerof_message e0, message_hascreator_person e1, organisation f3, person_studyat_organisation e2, message_hastag_tag e3
WHERE e0.forum_id = forum0.id and e1.person_id = person0.id and e2.university_id = university0.id and e0.post_id = post0.id and e3.tag_id = tag0.id and f2.type='Post' and f3.type='University' and e0.post_id=e1.message_id and e1.person_id=e2.person_id and e0.post_id=e3.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id and f3.id=e2.university_id;
SELECT person0.firstname, person0.lastname, country0.name, university0.name, city0.name
FROM r_person person0, r_country country0, r_city city0, r_university university0, organisation f0, person_studyat_organisation e0, place f1, organisation_islocatedin_place e1, place f2, place_ispartof_place e2
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and e2.reg_id = country0.id and f0.type='University' and f1.type='City' and f2.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.university_id and f1.id=e1.loc_id and f2.id=e2.reg_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_city city0, r_university university0, r_person person0, filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and f1.type='University' and f2.type='City' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id;
SELECT place0.name, person0.firstname, person0.lastname, post0.content
FROM r_organisation organisation0, r_person person0, r_person person1, r_post post0, r_place place0, filter_person1 f0, filter_post2 f1, message f2, person_likes_message e0, message_hascreator_person e1, person_workat_organisation e2, organisation_islocatedin_place e3
WHERE e0.message_id = post0.id and e3.loc_id = place0.id and e1.person_id = person0.id and e0.person_id = person1.id and e2.company_id = organisation0.id and f2.type='Post' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and e2.company_id=e3.org_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e0.message_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_person person0, r_city city0, r_university university0, r_tag tag0, organisation f0, place f1, organisation_islocatedin_place e0, filter_person1 f2, person_islocatedin_place e1, person_hasinterest_tag e2
WHERE e0.loc_id = city0.id and e1.person_id = person0.id and e2.tag_id = tag0.id and e0.org_id = university0.id and f0.type='University' and f1.type='City' and e0.loc_id=e1.loc_id and e1.person_id=e2.person_id and f0.id=e0.org_id and f1.id=e0.loc_id and f2.id=e1.person_id;
SELECT person0.firstname, person0.lastname, post0.content, message0.content, e1.person_id, e0.replied_message_id, e2.company_id, company0.name, e0.message_id
FROM r_person person0, r_post post0, r_message message0, r_company company0, filter_message2 f0, filter_post1 f1, message f2, message_replyof_message e0, message_hascreator_person e1, organisation f3, person_workat_organisation e2
WHERE e0.message_id = message0.id and e2.company_id = company0.id and e0.replied_message_id = post0.id and e1.person_id = person0.id and f2.type='Post' and f3.type='Company' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.replied_message_id and f2.id=e0.replied_message_id and f3.id=e2.company_id;
SELECT person0.firstname, person0.lastname, e2.tag_id, tag0.name, comment0.content, e0.message_id, e1.person_id, e0.replied_message_id, comment1.content
FROM r_person person0, r_comment comment0, r_tag tag0, r_comment comment1, filter_comment1 f0, message f1, filter_comment1 f2, message f3, message_replyof_message e0, filter_person1 f4, message_hascreator_person e1, person_hasinterest_tag e2
WHERE e1.person_id = person0.id and e0.replied_message_id = comment1.id and e2.tag_id = tag0.id and e0.message_id = comment0.id and f1.type='Comment' and f3.type='Comment' and e0.replied_message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e0.replied_message_id and f4.id=e1.person_id;
SELECT person0.firstname, person0.lastname, message0.content, tag0.name, comment0.content
FROM r_person person0, r_tagclass tagclass0, r_message message0, r_comment comment0, r_tag tag0, tag_hastype_tagclass e0, filter_message1 f0, message_hastag_tag e1, filter_comment2 f1, message f2, message_replyof_message e2, message_hascreator_person e3
WHERE e0.tagclass_id = tagclass0.id and e2.message_id = comment0.id and e1.message_id = message0.id and e0.tag_id = tag0.id and e3.person_id = person0.id and f2.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.replied_message_id and e2.message_id=e3.message_id and f0.id=e1.message_id and f1.id=e2.message_id and f2.id=e2.message_id;
SELECT person0.firstname, e0.friend_id, person0.lastname, e2.person_id, e1.message_id, post0.content, person1.lastname, e0.person_id, person1.firstname, person2.firstname, person2.lastname
FROM r_person person0, r_person person1, r_post post0, r_person person2, filter_person1 f0, person_knows_person e0, filter_post1 f1, message f2, person_likes_message e1, message_hascreator_person e2
WHERE e0.person_id = person0.id and e1.message_id = post0.id and e2.person_id = person1.id and e0.friend_id = person2.id and f2.type='Post' and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e1.message_id;
SELECT university0.name, person1.firstname, person1.lastname, organisation0.name
FROM r_person person0, r_organisation organisation0, r_person person1, r_city city0, r_university university0, filter_person1 f0, person_knows_person e0, organisation f1, person_studyat_organisation e1, place f2, organisation_islocatedin_place e2, organisation_islocatedin_place e3
WHERE e2.loc_id = city0.id and e0.person_id = person0.id and e0.friend_id = person1.id and e1.university_id = university0.id and e3.org_id = organisation0.id and f1.type='University' and f2.type='City' and e0.friend_id=e1.person_id and e1.university_id=e2.org_id and e2.loc_id=e3.loc_id and f0.id=e0.person_id and f1.id=e1.university_id and f2.id=e2.loc_id;
SELECT person0.firstname, message0.content, tag0.name, person0.lastname
FROM r_person person0, r_message message0, r_forum forum0, r_tag tag0, filter_message2 f0, forum_containerof_message e0, message_hastag_tag e1, person_hasinterest_tag e2
WHERE e0.post_id = message0.id and e2.person_id = person0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.post_id;
SELECT person0.firstname, person0.lastname, person1.lastname, person1.firstname, organisation0.name, city0.name
FROM r_organisation organisation0, r_person person0, r_person person1, r_city city0, place f0, organisation_islocatedin_place e0, filter_person1 f1, person_workat_organisation e1, person_knows_person e2
WHERE e0.loc_id = city0.id and e0.org_id = organisation0.id and e1.person_id = person1.id and e2.person_id = person0.id and f0.type='City' and e0.org_id=e1.company_id and e1.person_id=e2.friend_id and f0.id=e0.loc_id and f1.id=e1.person_id;
SELECT forum0.title, tag0.name, post0.content
FROM r_post post0, r_tagclass tagclass0, r_forum forum0, r_tag tag0, filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, message_hastag_tag e1, tag_hastype_tagclass e2
WHERE e0.forum_id = forum0.id and e0.post_id = post0.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and f2.type='Post' and e0.post_id=e1.message_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id;
SELECT person0.firstname, person0.lastname, comment0.content, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_comment comment0, filter_message1 f0, message_hascreator_person e0, filter_comment2 f1, message f2, message_replyof_message e1, filter_person1 f3, message_hascreator_person e2
WHERE e1.replied_message_id = comment0.id and e0.message_id = message0.id and e0.person_id = person1.id and e2.person_id = person0.id and f2.type='Comment' and e0.message_id=e1.message_id and e1.replied_message_id=e2.message_id and f0.id=e0.message_id and f1.id=e1.replied_message_id and f2.id=e1.replied_message_id and f3.id=e2.person_id;
SELECT person0.firstname, message0.content, person0.lastname, comment0.content
FROM r_comment comment0, r_person person0, r_message message0, filter_comment1 f0, message f1, filter_message2 f2, message_replyof_message e0, filter_person1 f3, message_hascreator_person e1
WHERE e1.person_id = person0.id and e0.replied_message_id = message0.id and e0.message_id = comment0.id and f1.type='Comment' and e0.replied_message_id=e1.message_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e1.person_id;
SELECT person0.firstname, tag0.name, person0.lastname, tagclass0.name
FROM r_person person0, r_tagclass tagclass1, r_tagclass tagclass0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.person_id = person0.id and e2.subtag_id = tagclass1.id and e0.tag_id = tag0.id and e1.tagclass_id = tagclass0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.person_id;
SELECT person0.firstname, person0.lastname, message0.content, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_city city0, filter_person1 f0, filter_message2 f1, person_likes_message e0, filter_person1 f2, message_hascreator_person e1, place f3, person_islocatedin_place e2
WHERE e2.loc_id = city0.id and e0.message_id = message0.id and e0.person_id = person0.id and e1.person_id = person1.id and f3.type='City' and e0.message_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.person_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.loc_id;
SELECT message0.content, tag0.name, tagclass1.name
FROM r_tagclass tagclass1, r_tagclass tagclass0, r_message message0, r_tag tag0, filter_message2 f0, message_hastag_tag e0, tag_hastype_tagclass e1, tagclass_issubclassof_tagclass e2
WHERE e0.message_id = message0.id and e0.tag_id = tag0.id and e2.subtag_id = tagclass0.id and e1.tagclass_id = tagclass1.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tag_id and f0.id=e0.message_id;
SELECT person0.firstname, message0.content, tag0.name, person0.lastname
FROM r_tag tag0, r_person person0, r_message message0, filter_person1 f0, filter_message1 f1, person_likes_message e0, message_hastag_tag e1
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.tag_id = tag0.id and e0.message_id=e1.message_id and f0.id=e0.person_id and f1.id=e0.message_id;
SELECT person0.firstname, person0.lastname, e2.reg_id, country0.name, e0.person_id, e1.loc_id, university0.name, e0.university_id, city0.name
FROM r_person person0, r_country country0, r_city city0, r_university university0, organisation f0, person_studyat_organisation e0, place f1, organisation_islocatedin_place e1, place f2, place_ispartof_place e2
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and e2.reg_id = country0.id and f0.type='University' and f1.type='City' and f2.type='Country' and e0.university_id=e1.org_id and e1.loc_id=e2.subreg_id and f0.id=e0.university_id and f1.id=e1.loc_id and f2.id=e2.reg_id;
SELECT person0.firstname, forum0.title, person0.lastname, post0.content
FROM r_forum forum0, r_person person0, r_post post0, filter_forum2 f0, filter_post2 f1, message f2, forum_containerof_message e0, message_hascreator_person e1
WHERE e0.forum_id = forum0.id and e1.person_id = person0.id and e0.post_id = post0.id and f2.type='Post' and e0.post_id=e1.message_id and f0.id=e0.forum_id and f1.id=e0.post_id and f2.id=e0.post_id;
TODO;
SELECT person0.firstname, forum0.title, company0.name
FROM r_forum forum0, r_person person0, r_company company0, filter_forum1 f0, forum_hasmoderator_person e0, organisation f1, person_workat_organisation e1
WHERE e0.forum_id = forum0.id and e0.person_id = person0.id and e1.company_id = company0.id and f1.type='Company' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e1.company_id;
SELECT person0.lastname, message0.content, forum0.title, person0.firstname
FROM r_forum forum0, r_person person0, r_message message0, person_hasinterest_tag e0, filter_message2 f0, message_hastag_tag e1, filter_forum1 f1, forum_containerof_message e2
WHERE e0.person_id = person0.id and e2.forum_id = forum0.id and e1.message_id = message0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.post_id and f0.id=e1.message_id and f1.id=e2.forum_id;
SELECT e1.loc_id, e0.message_id, message0.content, country0.name, comment0.content, e0.replied_message_id, place0.name, e2.subreg_id
FROM r_message message0, r_country country0, r_comment comment0, r_place place0, filter_comment1 f0, message f1, filter_message2 f2, message_replyof_message e0, message_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE e0.message_id = comment0.id and e0.replied_message_id = message0.id and e1.loc_id = place0.id and e2.subreg_id = country0.id and f1.type='Comment' and f3.type='Country' and e0.replied_message_id=e1.message_id and e1.loc_id=e2.reg_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.replied_message_id and f3.id=e2.subreg_id;
SELECT message0.content, message0.creationdate, country0.name, place0.name
FROM r_message message0, r_place place0, r_country country0, filter_message2 f0, message_islocatedin_place e0, place f1, place_ispartof_place e1
WHERE e0.message_id = message0.id and e0.loc_id = place0.id and e1.reg_id = country0.id and f1.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.message_id and f1.id=e1.reg_id;
SELECT person0.firstname, message0.content, company0.name, person0.lastname
FROM r_company company0, r_person person0, r_message message0, filter_message1 f0, message_hascreator_person e0, organisation f1, person_workat_organisation e1
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.company_id = company0.id and f1.type='Company' and e0.person_id=e1.person_id and f0.id=e0.message_id and f1.id=e1.company_id;
SELECT person0.firstname, person0.lastname, company0.name, country0.name
FROM r_person person0, r_company company0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id;
SELECT university0.name, person0.firstname, person0.lastname, city0.name
FROM r_city city0, r_university university0, r_person person0, filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and f1.type='University' and f2.type='City' and e0.university_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id;
SELECT person0.firstname, person0.lastname, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_person person0, place f0, organisation_islocatedin_place e0, filter_person1 f1, person_islocatedin_place e1
WHERE e1.person_id = person0.id and e0.loc_id = city0.id and e0.org_id = organisation0.id and f0.type='City' and e0.loc_id=e1.loc_id and f0.id=e0.loc_id and f1.id=e1.person_id;
SELECT person0.firstname, company0.name, person0.lastname, e0.person_id
FROM r_person person0, r_company company0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = country0.id and e0.company_id = company0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id;
SELECT country0.name, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_country country0, place f0, organisation_islocatedin_place e0, place f1, place_ispartof_place e1
WHERE e0.loc_id = city0.id and e0.org_id = organisation0.id and e1.reg_id = country0.id and f0.type='City' and f1.type='Country' and e0.loc_id=e1.subreg_id and f0.id=e0.loc_id and f1.id=e1.reg_id;
TODO;
SELECT person0.firstname, person0.lastname, e0.person_id, organisation0.name, city0.name
FROM r_organisation organisation0, r_city city0, r_person person0, filter_person1 f0, person_workat_organisation e0, place f1, organisation_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.company_id = organisation0.id and f1.type='City' and e0.company_id=e1.org_id and f0.id=e0.person_id and f1.id=e1.loc_id;
SELECT forum0.title, post0.content, e0.post_id, e0.forum_id, tag0.name
FROM r_forum forum0, r_post post0, r_tag tag0, filter_post1 f0, message f1, forum_containerof_message e0, message_hastag_tag e1
WHERE e0.forum_id = forum0.id and e0.post_id = post0.id and e1.tag_id = tag0.id and f1.type='Post' and e0.post_id=e1.message_id and f0.id=e0.post_id and f1.id=e0.post_id;
SELECT person0.firstname, forum0.title, message0.content, place0.name
FROM r_person person0, r_message message0, r_place place0, r_forum forum0, filter_message2 f0, forum_containerof_message e0, filter_person1 f1, message_hascreator_person e1, person_islocatedin_place e2
WHERE e1.person_id = person0.id and e0.post_id = message0.id and e0.forum_id = forum0.id and e2.loc_id = place0.id and e0.post_id=e1.message_id and e1.person_id=e2.person_id and f0.id=e0.post_id and f1.id=e1.person_id;
SELECT person0.firstname, message0.content, country0.name, e0.person_id, e0.message_id
FROM r_message message0, r_person person0, r_country country0, filter_message2 f0, message_hascreator_person e0, place f1, message_islocatedin_place e1
WHERE e0.person_id = person0.id and e0.message_id = message0.id and e1.loc_id = country0.id and f1.type='Country' and e0.message_id=e1.message_id and f0.id=e0.message_id and f1.id=e1.loc_id;
SELECT person0.firstname, e0.company_id, tag0.name, e0.person_id, company0.name
FROM r_tag tag0, r_company company0, r_person person0, organisation f0, filter_person1 f1, person_workat_organisation e0, person_hasinterest_tag e1
WHERE e0.person_id = person0.id and e1.tag_id = tag0.id and e0.company_id = company0.id and f0.type='Company' and e0.person_id=e1.person_id and f0.id=e0.company_id and f1.id=e0.person_id;
SELECT person0.firstname, e0.person_id, university0.name, e0.university_id, city0.name
FROM r_city city0, r_university university0, r_person person0, organisation f0, person_studyat_organisation e0, place f1, person_islocatedin_place e1
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e0.university_id = university0.id and f0.type='University' and f1.type='City' and e0.person_id=e1.person_id and f0.id=e0.university_id and f1.id=e1.loc_id;
SELECT person0.firstname, message0.content, person0.lastname, comment0.content
FROM r_person person0, r_person person1, r_message message0, r_comment comment0, person_knows_person e0, filter_message1 f0, person_likes_message e1, filter_comment1 f1, message f2, message_replyof_message e2
WHERE e2.message_id = comment0.id and e0.person_id = person1.id and e1.message_id = message0.id and e0.friend_id = person0.id and f2.type='Comment' and e0.friend_id=e1.person_id and e1.message_id=e2.replied_message_id and f0.id=e1.message_id and f1.id=e2.message_id and f2.id=e2.message_id;
SELECT person0.firstname, person0.lastname, university0.name, organisation0.name, city0.name
FROM r_organisation organisation0, r_person person0, r_city city0, r_university university0, organisation f0, person_studyat_organisation e0, place f1, organisation_islocatedin_place e1, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e1.loc_id = city0.id and e2.org_id = organisation0.id and e0.university_id = university0.id and f0.type='University' and f1.type='City' and e0.university_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.university_id and f1.id=e1.loc_id;
SELECT person0.firstname, forum0.title, person0.lastname
FROM r_forum forum0, r_person person0, r_tag tag0, filter_forum1 f0, filter_person2 f1, forum_hasmember_person e0, person_hasinterest_tag e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id;
SELECT person0.firstname, message0.content, tag0.name, place0.name
FROM r_person person0, r_message message0, r_place place0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.loc_id = place0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, message0.content, tag0.name, person0.lastname
FROM r_tag tag0, r_person person0, r_message message0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, message0.content, tag0.name, person0.lastname
FROM r_person person0, r_person person1, r_message message0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, filter_person2 f2, message_hascreator_person e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.person_id = person1.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.person_id;
SELECT person0.firstname, person0.lastname, tag0.name, person1.lastname, person1.firstname
FROM r_person person1, r_person person0, r_tag tag0, filter_person1 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1
WHERE e0.person_id = person1.id and e0.friend_id = person0.id and e1.tag_id = tag0.id and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id;
SELECT person0.firstname, person0.lastname, tag0.name, person1.lastname, person1.firstname
FROM r_person person1, r_person person0, r_tag tag0, filter_person2 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1
WHERE e0.person_id = person1.id and e0.friend_id = person0.id and e1.tag_id = tag0.id and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id;
SELECT e2.person_id, person0.firstname, post0.content, e1.message_id, e0.person_id, person1.firstname
FROM r_person person1, r_post post0, r_person person0, filter_person1 f0, person_hasinterest_tag e0, filter_post3 f1, message f2, message_hastag_tag e1, filter_person3 f3, message_hascreator_person e2
WHERE e0.person_id = person1.id and e1.message_id = post0.id and e2.person_id = person0.id and f2.type='Post' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e1.message_id and f3.id=e2.person_id;
TODO;
SELECT person0.firstname, forum0.title, company0.name, person0.lastname
FROM r_forum forum0, r_person person0, r_company company0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_workat_organisation e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.company_id = company0.id and f2.type='Company' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.company_id;
TODO;
SELECT person1.firstname, tag0.name, person1.lastname
FROM r_person person0, r_person person1, r_tagclass tagclass0, r_tag tag0, filter_person2 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE e0.person_id = person0.id and e0.friend_id = person1.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id;
SELECT person0.firstname, person0.lastname, message0.content, e0.person_id, company0.name, place0.name
FROM r_person person0, r_message message0, r_place place0, r_company company0, filter_person1 f0, organisation f1, person_workat_organisation e0, organisation_islocatedin_place e1, filter_message3 f2, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e1.loc_id = place0.id and e0.company_id = company0.id and f1.type='Company' and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e2.message_id;
SELECT person0.firstname, forum0.title, person0.lastname, message0.content, tag0.name
FROM r_person person0, r_message message0, r_forum forum0, r_tag tag0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1, filter_message3 f2, message_hastag_tag e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e2.message_id;
SELECT person0.firstname, forum0.title, person0.lastname, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_forum forum0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_forum1 f1, forum_hastag_tag e1, filter_person2 f2, forum_hasmoderator_person e2
WHERE e1.forum_id = forum0.id and e2.person_id = person0.id and e0.person_id = person1.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id and f2.id=e2.person_id;
SELECT person0.firstname, forum0.title, person0.lastname, person1.lastname, person1.firstname
FROM r_person person1, r_forum forum0, r_person person0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, filter_person1 f2, person_knows_person e1
WHERE e0.forum_id = forum0.id and e0.person_id = person1.id and e1.friend_id = person0.id and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.friend_id;
SELECT person0.lastname, message0.content, country0.name, person0.firstname
FROM r_person person0, r_message message0, r_country country0, r_company company0, filter_person2 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1, filter_message3 f3, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id and f3.id=e2.message_id;
SELECT person0.firstname, person0.lastname, tag0.name, person1.lastname, person1.firstname
FROM r_person person1, r_tag tag0, r_person person0, filter_person2 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1
WHERE e0.person_id = person1.id and e1.tag_id = tag0.id and e0.friend_id = person0.id and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id;
SELECT person0.firstname, person1.firstname, forum0.title
FROM r_person person1, r_forum forum0, r_person person0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, filter_person2 f2, person_knows_person e1
WHERE e0.forum_id = forum0.id and e0.person_id = person0.id and e1.friend_id = person1.id and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.friend_id;
SELECT person0.firstname, message0.content, forum0.title
FROM r_person person0, r_message message0, r_forum forum0, r_tag tag0, filter_forum1 f0, filter_person3 f1, forum_hasmember_person e0, filter_message3 f2, person_likes_message e1, message_hastag_tag e2
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.message_id = message0.id and e2.tag_id = tag0.id and e0.person_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id;
SELECT person0.firstname, person1.firstname, person2.firstname
FROM r_person person2, r_person person1, r_person person0, filter_person2 f0, filter_person1 f1, person_knows_person e0, filter_person2 f2, person_knows_person e1
WHERE e1.friend_id = person2.id and e0.friend_id = person1.id and e0.person_id = person0.id and e0.friend_id=e1.person_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.friend_id;
SELECT person0.firstname, person0.lastname, post0.content, tag0.name, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_post post0, r_tag tag0, filter_person1 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1, filter_post3 f2, message f3, message_hastag_tag e2
WHERE e0.person_id = person0.id and e0.friend_id = person1.id and e2.message_id = post0.id and e1.tag_id = tag0.id and f3.type='Post' and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e2.message_id and f3.id=e2.message_id;
SELECT person0.firstname, message0.content, company0.name, person0.lastname
FROM r_person person0, r_message message0, r_country country0, r_company company0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1, filter_message3 f3, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id and f3.id=e2.message_id;
SELECT person1.firstname, message0.content, person1.lastname, message0.creationdate
FROM r_person person1, r_person person0, r_message message0, filter_person1 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1, filter_message3 f2, message_hastag_tag e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.friend_id = person1.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e2.message_id;
SELECT person0.firstname, message0.content, person0.lastname, place0.name
FROM r_place place0, r_person person0, r_message message0, filter_person2 f0, filter_person1 f1, person_knows_person e0, filter_message3 f2, person_likes_message e1, message_islocatedin_place e2
WHERE e1.message_id = message0.id and e2.loc_id = place0.id and e0.friend_id = person0.id and e0.friend_id=e1.person_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.message_id;
SELECT person0.firstname, person0.lastname, tagclass0.name, tag0.name, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_tagclass tagclass0, r_tag tag0, filter_person2 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE e2.tagclass_id = tagclass0.id and e0.person_id = person1.id and e0.friend_id = person0.id and e1.tag_id = tag0.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id;
SELECT message0.content, e1.message_id, message0.creationdate
FROM r_person person0, r_message message0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, filter_person3 f2, message_hascreator_person e2
WHERE e1.message_id = message0.id and e2.person_id = person0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.person_id;
TODO;
SELECT person0.firstname, message0.content, e0.person_id, e2.message_id, place0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_message message0, r_place place0, filter_person2 f0, person_workat_organisation e0, organisation_islocatedin_place e1, filter_message3 f1, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e2.message_id = message0.id and e1.loc_id = place0.id and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e2.message_id;
SELECT post0.content, post0.creationdate, e2.message_id
FROM r_forum forum0, r_post post0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1, filter_post3 f2, message f3, message_hastag_tag e2
WHERE e0.forum_id = forum0.id and e2.message_id = post0.id and f3.type='Post' and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e2.message_id and f3.id=e2.message_id;
SELECT person1.firstname, e0.forum_id, person1.lastname
FROM r_person person1, r_forum forum0, r_person person0, filter_forum2 f0, filter_person1 f1, forum_hasmember_person e0, filter_person1 f2, person_knows_person e1
WHERE e0.forum_id = forum0.id and e0.person_id = person1.id and e1.person_id = person0.id and e0.person_id=e1.friend_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.person_id;
SELECT person0.firstname, message0.content, tag0.name, comment0.content, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_comment comment0, r_tag tag0, filter_person2 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1, filter_message3 f2, message_hastag_tag e2, filter_comment3 f3, message f4, message_replyof_message e3
WHERE e2.message_id = message0.id and e0.person_id = person1.id and e3.message_id = comment0.id and e1.tag_id = tag0.id and e0.friend_id = person0.id and f4.type='Comment' and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and e2.message_id=e3.replied_message_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e2.message_id and f3.id=e3.message_id and f4.id=e3.message_id;
SELECT person0.firstname, message0.content, person0.lastname, e0.message_id
FROM r_tag tag0, r_message message0, r_person person0, filter_message3 f0, message_hastag_tag e0, filter_forum1 f1, forum_hastag_tag e1, filter_person2 f2, forum_hasmoderator_person e2
WHERE e0.message_id = message0.id and e2.person_id = person0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.forum_id=e2.forum_id and f0.id=e0.message_id and f1.id=e1.forum_id and f2.id=e2.person_id;
SELECT person0.firstname, forum0.title, person0.lastname, message0.length, message0.content, tag0.name
FROM r_person person0, r_message message0, r_forum forum0, r_tag tag0, filter_person2 f0, person_hasinterest_tag e0, filter_forum2 f1, forum_hastag_tag e1, filter_message3 f2, forum_containerof_message e2
WHERE e0.person_id = person0.id and e2.post_id = message0.id and e1.forum_id = forum0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id and f2.id=e2.post_id;
TODO;
SELECT person0.firstname, forum0.title, tag0.name, person0.lastname
FROM r_person person0, r_person person1, r_forum forum0, r_tag tag0, filter_person2 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1, filter_forum2 f2, forum_hastag_tag e2
WHERE e2.forum_id = forum0.id and e0.person_id = person1.id and e0.friend_id = person0.id and e1.tag_id = tag0.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e2.forum_id;
SELECT person0.firstname, person0.lastname, message0.content, person1.lastname, person1.firstname
FROM r_person person1, r_person person0, r_message message0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, filter_person1 f2, message_hascreator_person e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.person_id = person1.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.person_id;
SELECT person0.firstname, person0.lastname, message0.content, place0.name, organisation0.name
FROM r_organisation organisation0, r_person person0, r_message message0, r_place place0, filter_person1 f0, person_workat_organisation e0, organisation_islocatedin_place e1, filter_message3 f1, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.company_id = organisation0.id and e1.loc_id = place0.id and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e2.message_id;
SELECT person0.firstname, message0.content, company0.name, person0.lastname
FROM r_person person0, r_message message0, r_country country0, r_company company0, filter_person2 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1, filter_message3 f3, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id and f3.id=e2.message_id;
TODO;
TODO;
SELECT person0.firstname, person0.lastname, message0.content, e0.person_id, person1.lastname, person1.firstname, e2.person_id
FROM r_person person0, r_person person1, r_message message0, r_tag tag0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, filter_person1 f2, message_hascreator_person e2
WHERE e1.message_id = message0.id and e0.person_id = person1.id and e0.tag_id = tag0.id and e2.person_id = person0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.person_id;
SELECT person1.firstname, person1.lastname, tagclass0.name
FROM r_tagclass tagclass0, r_person person1, r_person person0, filter_person2 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE e0.person_id = person1.id and e0.friend_id = person0.id and e2.tagclass_id = tagclass0.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id;
SELECT message0.content, message0.length, place0.name
FROM r_organisation organisation0, r_place place0, r_message message0, organisation_islocatedin_place e0, filter_message3 f0, message_islocatedin_place e1
WHERE e0.org_id = organisation0.id and e1.message_id = message0.id and e0.loc_id = place0.id and e0.loc_id=e1.loc_id and f0.id=e1.message_id;
SELECT person0.firstname, tagclass0.name, tag0.name, e0.friend_id, person1.firstname, e0.person_id
FROM r_person person0, r_person person1, r_tagclass tagclass0, r_tag tag0, filter_person2 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1, tag_hastype_tagclass e2
WHERE e0.friend_id = person0.id and e0.person_id = person1.id and e1.tag_id = tag0.id and e2.tagclass_id = tagclass0.id and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.friend_id and f1.id=e0.person_id;
SELECT person0.firstname, tag0.name, e0.person_id, person1.firstname, e2.person_id
FROM r_person person0, r_person person1, r_forum forum0, r_tag tag0, filter_person2 f0, person_hasinterest_tag e0, filter_forum1 f1, forum_hastag_tag e1, filter_person1 f2, forum_hasmember_person e2
WHERE e0.person_id = person0.id and e2.person_id = person1.id and e1.forum_id = forum0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.forum_id=e2.forum_id and f0.id=e0.person_id and f1.id=e1.forum_id and f2.id=e2.person_id;
SELECT university0.name, person0.lastname, person0.firstname, post0.content
FROM r_person person0, r_post post0, r_city city0, r_university university0, r_tag tag0, filter_post3 f0, message f1, message_hastag_tag e0, filter_person2 f2, person_hasinterest_tag e1, organisation f3, person_studyat_organisation e2, place f4, organisation_islocatedin_place e3
WHERE e3.loc_id = city0.id and e1.person_id = person0.id and e2.university_id = university0.id and e0.message_id = post0.id and e0.tag_id = tag0.id and f1.type='Post' and f3.type='University' and f4.type='City' and e0.tag_id=e1.tag_id and e1.person_id=e2.person_id and e2.university_id=e3.org_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e1.person_id and f3.id=e2.university_id and f4.id=e3.loc_id;
SELECT person0.firstname, country0.name, e0.person_id, city0.name
FROM r_person person0, r_country country0, r_city city0, r_company company0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1, place f3, place_ispartof_place e2
WHERE e0.person_id = person0.id and e2.subreg_id = city0.id and e0.company_id = company0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and f3.type='City' and e0.company_id=e1.org_id and e1.loc_id=e2.reg_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id and f3.id=e2.subreg_id;
SELECT person0.firstname, message0.content, person0.lastname, message0.creationdate
FROM r_tag tag0, r_message message0, r_person person0, filter_person1 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1, filter_message3 f2, message_hastag_tag e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e1.tag_id = tag0.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e2.message_id;
SELECT person0.firstname, forum0.title, tag0.name
FROM r_forum forum0, r_person person0, r_tag tag0, filter_person2 f0, person_hasinterest_tag e0, filter_forum1 f1, forum_hastag_tag e1
WHERE e0.person_id = person0.id and e1.forum_id = forum0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and f0.id=e0.person_id and f1.id=e1.forum_id;
SELECT person0.firstname, message0.content, person0.lastname, message0.creationdate
FROM r_tag tag0, r_message message0, r_person person0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, forum0.title, person0.lastname, message0.content, tag0.name, e0.forum_id, person1.lastname, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_forum forum0, r_tag tag0, filter_forum1 f0, filter_person1 f1, forum_hasmoderator_person e0, filter_person1 f2, person_knows_person e1, person_hasinterest_tag e2, filter_message3 f3, message_hastag_tag e3
WHERE e1.friend_id = person0.id and e3.message_id = message0.id and e0.person_id = person1.id and e0.forum_id = forum0.id and e2.tag_id = tag0.id and e0.person_id=e1.person_id and e1.friend_id=e2.person_id and e2.tag_id=e3.tag_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.friend_id and f3.id=e3.message_id;
SELECT person0.firstname, person0.lastname, comment0.content
FROM r_comment comment0, r_person person0, r_tag tag0, filter_person1 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, filter_comment3 f2, message f3, message_replyof_message e2
WHERE e2.message_id = comment0.id and e0.person_id = person0.id and e0.tag_id = tag0.id and f3.type='Comment' and e0.tag_id=e1.tag_id and e1.message_id=e2.replied_message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.message_id and f3.id=e2.message_id;
SELECT person0.firstname, e0.person_id, person0.lastname
FROM r_person person1, r_person person0, r_tag tag0, filter_person1 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1
WHERE e0.friend_id = person1.id and e0.person_id = person0.id and e1.tag_id = tag0.id and e0.person_id=e1.person_id and f0.id=e0.friend_id and f1.id=e0.person_id;
SELECT person0.firstname, forum0.title, tag0.name, e0.person_id, person1.firstname, e0.friend_id
FROM r_person person0, r_person person1, r_forum forum0, r_tag tag0, filter_person1 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1, filter_forum1 f2, forum_hastag_tag e2
WHERE e0.person_id = person1.id and e2.forum_id = forum0.id and e1.tag_id = tag0.id and e0.friend_id = person0.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e2.forum_id;
SELECT message0.content, message1.content
FROM r_message message1, r_message message0, filter_message3 f0, message_hastag_tag e0, filter_message3 f1, message_hastag_tag e1
WHERE e0.message_id = message0.id and e1.message_id = message1.id and e0.tag_id=e1.tag_id and f0.id=e0.message_id and f1.id=e1.message_id;
SELECT person0.firstname, message0.content, person0.lastname
FROM r_message message0, r_person person0, r_country country0, filter_person1 f0, organisation f1, person_workat_organisation e0, place f2, organisation_islocatedin_place e1, filter_message3 f3, message_islocatedin_place e2, filter_person3 f4, message_hascreator_person e3
WHERE e2.message_id = message0.id and e3.person_id = person0.id and e1.loc_id = country0.id and f1.type='Company' and f2.type='Country' and e0.company_id=e1.org_id and e1.loc_id=e2.loc_id and e2.message_id=e3.message_id and f0.id=e0.person_id and f1.id=e0.company_id and f2.id=e1.loc_id and f3.id=e2.message_id and f4.id=e3.person_id;
SELECT e3.person_id, person0.firstname, forum0.title, person0.lastname, e0.forum_id, tag0.name, message0.content, e0.person_id, person1.lastname, e2.message_id, person1.firstname
FROM r_person person0, r_person person1, r_message message0, r_forum forum0, r_tag tag0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1, filter_message3 f2, message_hastag_tag e2, filter_person3 f3, message_hascreator_person e3
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.forum_id = forum0.id and e3.person_id = person1.id and e1.tag_id = tag0.id and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and e2.message_id=e3.message_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e2.message_id and f3.id=e3.person_id;
SELECT person0.firstname, forum0.title, person0.lastname, message0.content, tag0.name, e2.message_id
FROM r_person person0, r_message message0, r_forum forum0, r_tag tag0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1, filter_message3 f2, message_hastag_tag e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e0.person_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e2.message_id;
SELECT person0.firstname, person0.lastname, tag0.name, person1.lastname, company0.name, person1.firstname
FROM r_person person0, r_person person1, r_tag tag0, r_company company0, filter_person2 f0, filter_person2 f1, person_knows_person e0, organisation f2, person_workat_organisation e1, person_hasinterest_tag e2
WHERE e0.person_id = person0.id and e0.friend_id = person1.id and e1.company_id = company0.id and e2.tag_id = tag0.id and f2.type='Company' and e0.friend_id=e1.person_id and e0.friend_id=e2.person_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.company_id;
SELECT person0.firstname, person0.lastname, e0.message_id, person1.lastname, person1.firstname
FROM r_person person1, r_person person0, r_post post0, filter_post3 f0, message f1, filter_person2 f2, message_hascreator_person e0, filter_person2 f3, person_knows_person e1
WHERE e1.friend_id = person1.id and e0.message_id = post0.id and e0.person_id = person0.id and f1.type='Post' and e0.person_id=e1.person_id and f0.id=e0.message_id and f1.id=e0.message_id and f2.id=e0.person_id and f3.id=e1.friend_id;
SELECT person0.lastname, message0.content, forum0.title, person0.firstname
FROM r_forum forum0, r_person person0, r_message message0, filter_forum1 f0, filter_person2 f1, forum_hasmember_person e0, filter_message3 f2, person_likes_message e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.message_id = message0.id and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.message_id;
SELECT person0.email, person0.firstname, person0.lastname
FROM r_forum forum0, r_university university0, r_person person0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, organisation f2, person_studyat_organisation e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.university_id = university0.id and f2.type='University' and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id and f2.id=e1.university_id;
SELECT tag0.name, message1.content, e0.message_id
FROM r_message message1, r_tag tag0, r_message message0, filter_message3 f0, message_hastag_tag e0, tag_hastype_tagclass e1, tag_hastype_tagclass e2, filter_message3 f1, message_hastag_tag e3
WHERE e0.message_id = message0.id and e3.message_id = message1.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.tagclass_id=e2.tagclass_id and e2.tag_id=e3.tag_id and f0.id=e0.message_id and f1.id=e3.message_id;
TODO;
SELECT person0.firstname, forum0.title, tag0.name, person0.lastname
FROM r_forum forum0, r_tag tag0, r_person person0, filter_forum1 f0, filter_person1 f1, forum_hasmember_person e0, person_hasinterest_tag e1
WHERE e0.person_id = person0.id and e0.forum_id = forum0.id and e1.tag_id = tag0.id and e0.person_id=e1.person_id and f0.id=e0.forum_id and f1.id=e0.person_id;
SELECT person0.firstname, person0.lastname, post0.content
FROM r_person person0, r_person person1, r_post post0, r_tag tag0, filter_person2 f0, filter_person2 f1, person_knows_person e0, person_hasinterest_tag e1, filter_post3 f2, message f3, message_hastag_tag e2
WHERE e0.person_id = person1.id and e2.message_id = post0.id and e0.friend_id = person0.id and e1.tag_id = tag0.id and f3.type='Post' and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e2.message_id and f3.id=e2.message_id;
SELECT message0.content, e1.message_id, message0.creationdate
FROM r_person person0, r_message message0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e0.tag_id=e1.tag_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, message0.content, tag0.name, person0.lastname
FROM r_person person0, r_person person1, r_message message0, r_tag tag0, filter_person1 f0, filter_person1 f1, person_knows_person e0, person_hasinterest_tag e1, filter_message3 f2, message_hastag_tag e2
WHERE e0.person_id = person0.id and e2.message_id = message0.id and e0.friend_id = person1.id and e1.tag_id = tag0.id and e0.friend_id=e1.person_id and e1.tag_id=e2.tag_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e2.message_id;
SELECT person0.firstname, message0.content, tag0.name
FROM r_person person0, r_message message0, r_place place0, r_tag tag0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, message_islocatedin_place e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.loc_id = place0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, person0.lastname, e2.replied_message_id, e1.message_id
FROM r_person person0, r_tag tag0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, filter_post3 f2, message f3, message_replyof_message e2
WHERE e0.person_id = person0.id and e0.tag_id = tag0.id and f3.type='Post' and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.replied_message_id and f3.id=e2.replied_message_id;
SELECT person0.firstname, person0.lastname, person1.lastname, university0.name, person1.firstname, city0.name
FROM r_person person0, r_person person1, r_city city0, r_university university0, filter_person1 f0, organisation f1, person_studyat_organisation e0, place f2, organisation_islocatedin_place e1, filter_person2 f3, person_islocatedin_place e2, filter_person1 f4, person_knows_person e3
WHERE e1.loc_id = city0.id and e3.person_id = person0.id and e0.person_id = person1.id and e0.university_id = university0.id and f1.type='University' and f2.type='City' and e0.university_id=e1.org_id and e1.loc_id=e2.loc_id and e2.person_id=e3.friend_id and f0.id=e0.person_id and f1.id=e0.university_id and f2.id=e1.loc_id and f3.id=e2.person_id and f4.id=e3.person_id;
SELECT person0.firstname, person0.lastname, message0.length, message0.content, tag0.name
FROM r_tag tag0, r_message message0, r_person person0, filter_person1 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and f0.id=e0.person_id and f1.id=e1.message_id;
SELECT person0.firstname, forum0.title, message0.content, person0.lastname
FROM r_person person0, r_message message0, r_forum forum0, r_tag tag0, filter_person2 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, filter_forum1 f2, forum_containerof_message e2
WHERE e0.person_id = person0.id and e1.message_id = message0.id and e2.forum_id = forum0.id and e0.tag_id = tag0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.post_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.forum_id;
SELECT person0.firstname, person0.lastname, country0.name, person1.lastname, company0.name, person1.firstname
FROM r_person person0, r_person person1, r_country country0, r_company company0, filter_person2 f0, filter_person2 f1, person_knows_person e0, organisation f2, person_workat_organisation e1, place f3, organisation_islocatedin_place e2
WHERE e0.person_id = person0.id and e0.friend_id = person1.id and e2.loc_id = country0.id and e1.company_id = company0.id and f2.type='Company' and f3.type='Country' and e0.friend_id=e1.person_id and e1.company_id=e2.org_id and f0.id=e0.person_id and f1.id=e0.friend_id and f2.id=e1.company_id and f3.id=e2.loc_id;
TODO;
SELECT person0.firstname, message0.content, person0.lastname
FROM r_person person1, r_person person0, r_message message0, filter_person1 f0, person_hasinterest_tag e0, filter_message3 f1, message_hastag_tag e1, filter_person3 f2, message_hascreator_person e2
WHERE e0.person_id = person1.id and e1.message_id = message0.id and e2.person_id = person0.id and e0.tag_id=e1.tag_id and e1.message_id=e2.message_id and f0.id=e0.person_id and f1.id=e1.message_id and f2.id=e2.person_id;
SELECT person0.firstname, person0.lastname, tag0.name, person1.lastname, person1.firstname
FROM r_organisation organisation0, r_person person0, r_person person1, r_tag tag0, filter_person1 f0, person_workat_organisation e0, filter_person1 f1, person_knows_person e1, person_hasinterest_tag e2
WHERE e0.person_id = person0.id and e0.company_id = organisation0.id and e1.friend_id = person1.id and e2.tag_id = tag0.id and e0.person_id=e1.person_id and e1.friend_id=e2.person_id and f0.id=e0.person_id and f1.id=e1.friend_id