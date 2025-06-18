MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(c:Country)
WHERE o.name = $param AND c.name = $param
RETURN p.firstName, p.lastName, o.name, c.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.title = $param AND tc.name = $param
RETURN m.content, m.creationDate, t.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:REPLY_OF]->(c:Comment)
WHERE p.speaks = $param AND t.name = $param
RETURN p.firstName, p.lastName, m.content, c.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.birthday < $param AND friend.gender = $param
RETURN friend.firstName, friend.lastName, m.content, creator.firstName, creator.lastName;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(creator:Person)-[:LIKES]->(c2:Comment)
WHERE m.creationDate > $param AND c2.content CONTAINS $param
RETURN c.content, m.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(f:Forum)
WHERE p.gender = $param AND f.title = $param
RETURN friend.firstName, friend.lastName, t.name, f.title;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)<-[:IS_LOCATED_IN]-(m:Message)
WHERE p.speaks = $param AND country.name = $param
RETURN p.firstName, p.lastName, c.name, m.content;
MATCH (p:Person)-[:KNOWS*2..4]-(friend:Person) 
WHERE p.firstName = $param AND friend.gender = $param 
RETURN friend.firstName, friend.lastName, friend.email;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass) 
WHERE tagClass.name = $param AND post.creationDate > $param 
RETURN post.id, post.content, tag.name;
MATCH (comment:Comment)-[:REPLY_OF*]->(message:Message)-[:HAS_CREATOR]->(creator:Person) 
WHERE comment.creationDate < $param AND creator.locationIP = $param 
RETURN comment.id, comment.content, creator.firstName, creator.lastName;
MATCH (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag) 
WHERE forum.title = $param AND tag.name = $param 
RETURN post.id, post.content, forum.creationDate;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass) 
WHERE person.birthday > $param AND tagClass.name = $param 
RETURN person.firstName, person.lastName, tag.name;
MATCH (person:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]->(creator:Person) 
WHERE person.browserUsed = $param AND creator.email = $param 
RETURN person.firstName, person.lastName, post.id, post.content;
MATCH (p:Person)-[:KNOWS*2..4]-(friend:Person)
WHERE p.firstName = $param AND friend.gender = $param
RETURN friend.id, friend.firstName, friend.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE p.email = $param AND f.creationDate > $param
RETURN m.content, m.creationDate, f.title;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(pl:Place)<-[:IS_LOCATED_IN]-(o:Organisation)
WHERE p.birthday < $param AND pl.name = $param
RETURN o.name, c.name, p.firstName;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_CREATOR]->(creator:Person)-[:WORK_AT]->(o:Organisation)
WHERE m.creationDate > $param AND o.name = $param
RETURN creator.firstName, creator.lastName, o.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:IS_LOCATED_IN]->(pl:Place)
WHERE m.browserUsed = $param AND pl.name = $param
RETURN p.firstName, m.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag {name: $param})
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, t.name;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass {name: $param})
RETURN c.id, c.content, m.id, m.content, t.name, tc.name;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_CREATOR]->(creator:Person {gender: $param})
RETURN p.firstName, p.lastName, m.id, creator.firstName, creator.lastName;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City {name: $param})
RETURN p.firstName, p.lastName, u.name, city.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country {name: $param})
RETURN p.firstName, p.lastName, c.name, country.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)<-[:HAS_INTEREST]-(p:Person {gender: $param})
RETURN f.title, post.id, tag.name, p.firstName, p.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(city:City {name: $param})
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, org.name, city.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:IS_SUBCLASS_OF]-(parentTc:TagClass)
WHERE tc.name = $param
RETURN p.firstName, p.lastName, t.name, parentTc.name;
MATCH (m:Message)-[:HAS_CREATOR]->(author:Person)-[:IS_LOCATED_IN]->(c:City)<-[:IS_LOCATED_IN]-(u:University)
WHERE m.creationDate > $param AND u.name = $param
RETURN m.content, author.firstName, author.lastName, c.name, u.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)<-[:REPLY_OF]-(comment:Comment)-[:HAS_CREATOR]->(c:Person)
WHERE f.title = $param AND comment.creationDate > $param
RETURN post.content, comment.content, c.firstName, c.lastName;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)<-[:IS_LOCATED_IN]-(msg:Message)
WHERE c.name = $param AND msg.browserUsed = $param
RETURN p.firstName, p.lastName, msg.content, country.name;
MATCH (p:Person)-[:KNOWS*2]-(friendOfFriend:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE p.email = $param AND tag.name = $param
RETURN friendOfFriend.firstName, friendOfFriend.lastName, tag.name;
MATCH (p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(c:Country)
WHERE p.gender = $param AND c.name = $param
RETURN p.firstName, p.lastName, comp.name, c.name;
MATCH (p:Person)-[:HAS_INTEREST]->(:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(:TagClass {name: $param})
WHERE p.birthday > datetime($param)
RETURN p.firstName, p.lastName, tc.name;
MATCH (cmt:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(place:Place)
WHERE cmt.length < $param AND place.name = $param
RETURN cmt.content, post.content, p.firstName, place.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(t:Tag)
WHERE msg.creationDate > datetime($param) AND t.name = $param
RETURN p.firstName, p.lastName, msg.content, t.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(f:Forum)-[:CONTAINER_OF]->(post:Post)
WHERE t.name = $param AND post.creationDate > datetime($param)
RETURN p.firstName, f.title, post.content;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF]-(subTagClass:TagClass)
WHERE p.birthday > $param
RETURN p.id, p.firstName, tag.name, subTagClass.name;
MATCH (msg:Message)-[:HAS_TAG]->(tag:Tag)<-[:HAS_TAG]-(relatedMsg:Message)<-[:REPLY_OF]-(cmt:Comment)
WHERE msg.creationDate > $param
RETURN msg.id, tag.name, relatedMsg.content, cmt.content;
MATCH (p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)<-[:REPLY_OF]-(cmt:Comment)
WHERE p.birthday < $param AND place.name = $param
RETURN p.id, p.firstName, uni.name, msg.content, cmt.content;
MATCH (msg:Message)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)-[:WORK_AT]->(comp:Company)
WHERE msg.locationIP = $param AND comp.name = $param
RETURN msg.id, msg.content, post.id, creator.firstName, comp.name;
MATCH (cmt:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE cmt.creationDate < $param AND creator.locationIP = $param
RETURN cmt.id, cmt.content, msg.id, msg.content, creator.id, creator.firstName, creator.lastName;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)
WHERE p.email ENDS WITH $param AND msg.creationDate > $param
RETURN p.id, p.firstName, p.lastName, u.id, u.name, place.id, place.name, msg.id, msg.content;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.title = $param AND tc.name = $param
RETURN f.id, f.title, m.content, t.name, tc.name;
MATCH (per:Person)-[:KNOWS]->(friend:Person)-[:STUDY_AT]->(u:University)
WHERE per.email = $param AND friend.gender = $param
RETURN per.id, per.firstName, friend.firstName, u.name;
MATCH (msg:Message)-[:REPLY_OF]->(origMsg:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE msg.content CONTAINS $param AND creator.birthday > $param
RETURN msg.id, msg.content, origMsg.id, creator.firstName, creator.lastName;
MATCH (org:Organisation)<-[:WORK_AT]-(p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(msg:Message)
WHERE org.name = $param AND msg.creationDate < $param
RETURN org.id, org.name, p.id, p.firstName, friend.id, friend.firstName, msg.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(message:Message)
WHERE p.locationIP = $param AND message.creationDate > $param
RETURN p.firstName, p.lastName, message.content;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(:TagClass {name: $param})
WHERE person.birthday < $param
RETURN person.firstName, person.lastName, tag.name;
MATCH (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(:Tag {name: $param})
WHERE forum.creationDate > $param
RETURN forum.title, post.content;
MATCH (person:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(:Country {name: $param})
WHERE person.gender = $param
RETURN person.firstName, person.lastName, company.name;
MATCH (msg:Message)-[:HAS_TAG]->(:Tag)<-[:HAS_TAG]-(related:Message)
WHERE msg.locationIP = $param AND related.browserUsed = $param
RETURN msg.content, related.content;
MATCH (person:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE person.gender = $param AND country.name = $param
RETURN person.firstName, person.lastName, company.name, continent.name;
MATCH (university:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(person:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE person.birthday < $param AND tag.name = $param
RETURN person.firstName, person.lastName, city.name, university.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MEMBER]->(member:Person)
WHERE comment.creationDate > $param AND forum.title = $param
RETURN comment.content, post.content, member.firstName, member.lastName;
MATCH (person:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]->(creator:Person)-[:WORK_AT]->(organisation:Organisation)-[:IS_LOCATED_IN]->(place:Place)
WHERE person.firstName = $param AND organisation.name = $param
RETURN post.content, creator.firstName, creator.lastName, place.name;
MATCH (forum:Forum)-[:CONTAINER_OF]->(message:Message)-[:HAS_TAG]->(tag:Tag)<-[:HAS_INTEREST]-(person:Person)
WHERE forum.title = $param AND message.creationDate < $param
RETURN message.content, tag.name, person.firstName, person.lastName;
MATCH (tagClass:TagClass)<-[:HAS_TYPE]-(tag:Tag)<-[:HAS_TAG]-(message:Message)<-[:REPLY_OF]-(comment:Comment)-[:HAS_CREATOR]->(creator:Person)
WHERE tagClass.name = $param AND comment.creationDate > $param
RETURN message.content, comment.content, creator.firstName, creator.lastName, tag.name;
MATCH (person:Person)-[:KNOWS]->(friend:Person)-[:STUDY_AT]->(university:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(organisation:Organisation)
WHERE person.email = $param AND city.name = $param
RETURN friend.firstName, friend.lastName, university.name, organisation.name;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF]-(parentTagClass:TagClass)
WHERE person.locationIP = $param AND parentTagClass.name = $param
RETURN person.firstName, person.lastName, tag.name, tagClass.name;
MATCH (m:Message)-[:REPLY_OF]->(p:Post)-[:HAS_CREATOR]->(c:Person)-[:WORK_AT]->(o:Company)
WHERE m.creationDate > $param AND o.name = $param
RETURN m.id, m.content, p.id, p.content, c.id, c.firstName, c.lastName, o.id, o.name;
MATCH (c1:Comment)-[:REPLY_OF]->(c2:Comment)-[:HAS_CREATOR]->(p:Person)-[:HAS_INTEREST]->(t:Tag)
WHERE c1.creationDate > $param AND t.name = $param
RETURN c1.id, c1.content, c2.id, c2.content, p.id, p.firstName, p.lastName, t.id, t.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]->(p3:Person)
WHERE p1.gender = $param AND p3.birthday > $param
RETURN p1.id, p1.firstName, p1.lastName, p2.id, p2.firstName, p2.lastName, post.id, post.content, p3.id, p3.firstName, p3.lastName;
MATCH (comment:Comment)-[:REPLY_OF]->(msg:Message)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_PART_OF]-(country:Country)
WHERE place.name = $param AND country.name = $param
RETURN comment.id, comment.content, msg.id, msg.content, place.id, place.name, country.id, country.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE u.name = $param AND country.name = $param
RETURN p.id, p.firstName, p.lastName, u.id, u.name, city.id, city.name, country.id, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE p.gender = $param AND f.title = $param
RETURN p.firstName, p.lastName, msg.content, f.title;
MATCH (f:Forum)-[:HAS_MODERATOR]->(moderator:Person)-[:WORK_AT]->(comp:Company)
WHERE f.title = $param AND moderator.creationDate < $param
RETURN f.title, moderator.firstName, comp.name;
MATCH (msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF]-(superClass:TagClass)
WHERE tagClass.name = $param AND superClass.name = $param
RETURN msg.content, tag.name, tagClass.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)<-[:HAS_INTEREST]-(interestedPerson:Person)
WHERE comment.browserUsed = $param AND interestedPerson.birthday > $param
RETURN comment.content, post.content, tag.name, interestedPerson.firstName;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_PART_OF]-(country:Country)
WHERE p.locationIP = $param AND country.name = $param
RETURN p.firstName, msg.content, place.name, country.name;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.locationIP = $param AND t.name = $param
RETURN p.firstName, p.lastName, m.content, t.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_CREATOR]->(person:Person)
WHERE f.title = $param AND person.birthday > $param
RETURN f.title, p.content, person.firstName, person.lastName;
MATCH (c:Comment)-[:REPLY_OF*]->(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE t.name = $param AND c.creationDate > $param
RETURN c.content, m.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)
WHERE p.browserUsed = $param AND t.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, t.name;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(p:Person)
WHERE org.name = $param AND city.name = $param
RETURN org.name, city.name, p.firstName, p.lastName;
MATCH (m:Message)-[:HAS_CREATOR]->(p:Person)-[:WORK_AT]->(c:Company)
WHERE m.length > $param AND c.name = $param
RETURN m.content, p.firstName, p.lastName, c.name;
MATCH (p:Person)-[:KNOWS*2]-(friend:Person)-[:LIKES]->(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE p.gender = $param AND t.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, post.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(f:Forum)
WHERE f.creationDate > $param AND t.name = $param
RETURN p.firstName, p.lastName, t.name, f.title;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE c.creationDate > $param AND p.gender = $param
RETURN c.content, m.content, p.firstName, p.lastName;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)
WHERE p.birthday > $param AND city.name = $param
RETURN p.firstName, p.lastName, u.name, city.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.email CONTAINS $param AND country.name = $param
RETURN p.firstName, p.lastName, c.name, country.name;
MATCH (f:Forum)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.creationDate < $param AND tc.name = $param
RETURN f.title, f.creationDate, t.name, tc.name;
MATCH (m:Message)-[:IS_LOCATED_IN]->(place:Place)-[:IS_PART_OF]->(country:Country)
WHERE m.browserUsed = $param AND country.name = $param
RETURN m.content, m.creationDate, place.name, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE p.speaks = $param AND m.length > $param
RETURN p.firstName, p.lastName, t.name, m.content, m.length;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE org.name = $param AND country.name = $param
RETURN org.name, city.name, country.name;
MATCH (p:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(post:Post)
WHERE p.locationIP = $param AND post.creationDate > $param
RETURN p.firstName, p.lastName, c.content, post.content, post.creationDate;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF*1..2]-(parentTagClass:TagClass)
WHERE parentTagClass.name = $param
RETURN post.id, post.content, tag.name, parentTagClass.name;
MATCH (person:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE person.birthday < $param AND country.name = $param
RETURN person.id, person.firstName, person.lastName, company.name;
MATCH (msg:Message)-[:REPLY_OF*1..3]->(post:Post)-[:HAS_CREATOR]->(author:Person)-[:IS_LOCATED_IN]->(place:Place)
WHERE msg.length > $param AND place.name = $param
RETURN msg.id, msg.content, post.id, author.firstName, author.lastName;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(forum:Forum)
WHERE p1.gender = $param AND forum.title CONTAINS $param
RETURN p1.id, p1.firstName, p2.id, p2.firstName, tag.name, forum.title;
MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(c:City)
WHERE p.firstName = $param AND c.name = $param
RETURN p.id, p.firstName, p.lastName, o.name, c.name;
MATCH (p:Person)-[:KNOWS]-(friend:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.email = $param AND tc.name = $param
RETURN p.id, p.firstName, friend.id, friend.firstName, t.name, tc.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE f.creationDate > $param AND t.name = $param
RETURN f.id, f.title, post.id, post.content, t.name;
MATCH (u:University)<-[:STUDY_AT]-(p:Person)-[:IS_LOCATED_IN]->(c:City)
WHERE u.name = $param AND c.name = $param
RETURN u.id, u.name, p.id, p.firstName, c.name;
MATCH (p:Person)-[:KNOWS*2..3]-(friend:Person)-[:LIKES]->(m:Message)
WHERE p.birthday < $param AND m.locationIP = $param
RETURN p.id, p.firstName, friend.id, friend.firstName, m.id, m.content;
MATCH (company:Company)<-[:WORK_AT]-(p:Person)-[:HAS_INTEREST]->(t:Tag)
WHERE company.name = $param AND t.name = $param
RETURN company.id, company.name, p.id, p.firstName, t.name;
MATCH (p:Person)-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.browserUsed = $param AND country.name = $param
RETURN p.id, p.firstName, m.id, m.content, country.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:WORK_AT]->(c:Company)
WHERE f.title = $param AND c.name = $param
RETURN f.id, f.title, p.id, p.firstName, c.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)<-[:IS_LOCATED_IN]-(o:Organisation)
WHERE p.birthday > $param AND c.name = $param 
RETURN p.firstName, p.lastName, u.name, c.name, o.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(place:Place)
WHERE f.title = $param AND m.length > $param 
RETURN f.title, m.content, p.firstName, place.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:LIKES]->(msg:Message)<-[:REPLY_OF]-(comment:Comment)
WHERE p1.email = $param AND comment.creationDate < $param 
RETURN p2.firstName, p2.lastName, msg.content, comment.content;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)<-[:IS_LOCATED_IN]-(msg:Message)
WHERE p.gender = $param AND country.name = $param 
RETURN p.firstName, p.lastName, c.name, msg.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:IS_SUBCLASS_OF]-(parent:TagClass)
WHERE tc.name = $param 
RETURN p.firstName, p.lastName, t.name, tc.name, parent.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(city:City)
WHERE p.birthday < $param AND city.name = $param 
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, org.name, city.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.email = $param AND creator.birthday > $param
RETURN p.firstName, p.lastName, creator.firstName, creator.lastName, m.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.gender = $param AND country.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, company.name, country.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.gender = $param AND tc.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, t.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(org:Organisation)
WHERE p.browserUsed = $param AND org.name = $param
RETURN p.firstName, p.lastName, u.name, place.name, org.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(comment:Comment)-[:REPLY_OF]->(post:Post)
WHERE p.speaks CONTAINS $param AND post.title CONTAINS $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, comment.id, post.id;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.locationIP = $param AND creator.gender = $param
RETURN p.firstName, p.lastName, t.name, m.id, creator.firstName, creator.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message)
WHERE p.birthday > $param AND friend.gender = $param
RETURN p.firstName, p.lastName, msg.content, tag.name;
MATCH (p:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]->(creator:Person)-[:IS_LOCATED_IN]->(place:Place)
WHERE post.creationDate > $param AND place.name = $param
RETURN p.firstName, p.lastName, post.content, creator.firstName, creator.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)-[:HAS_CREATOR]->(p:Person)
WHERE org.name = $param AND msg.length > $param
RETURN org.name, place.name, msg.content, p.firstName, p.lastName;
MATCH (tc:TagClass)<-[:HAS_TYPE]-(tag:Tag)<-[:HAS_TAG]-(msg:Message)-[:REPLY_OF]->(comment:Comment)
WHERE tc.name = $param AND comment.creationDate < $param
RETURN tc.name, tag.name, msg.content, comment.content;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)<-[:HAS_INTEREST]-(p:Person)
WHERE f.title = $param AND p.gender = $param
RETURN f.title, post.content, tag.name, p.firstName, p.lastName;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.gender = $param AND country.name = $param
RETURN p.firstName, p.lastName, c.name, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND p.birthday < date($param)
RETURN p.firstName, p.lastName, t.name, tc.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:KNOWS]->(p2:Person)
WHERE f.title = $param AND p.creationDate > date($param)
RETURN f.title, p.firstName, p2.firstName;
MATCH (p:Person)-[:LIKES]->(msg:Message)<-[:REPLY_OF]-(c:Comment)-[:HAS_CREATOR]->(creator:Person)
WHERE creator.gender = $param AND msg.creationDate > date($param)
RETURN p.firstName, msg.content, c.content, creator.firstName;
MATCH (org:Organisation)<-[:WORK_AT]-(p:Person)-[:IS_LOCATED_IN]->(city:City)
WHERE org.name = $param AND city.name = $param
RETURN p.firstName, p.lastName, org.name, city.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE comment.browserUsed = $param AND tag.name = $param
RETURN comment.content, post.content, tag.name;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message)-[:IS_LOCATED_IN]->(place:Place)
WHERE msg.locationIP = $param AND place.name = $param
RETURN p.firstName, tag.name, msg.content, place.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE f.title = $param AND m.creationDate > $param
RETURN f.title, p.firstName, p.lastName, t.name, m.id, m.content;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]-(creator:Person)
WHERE p1.locationIP = $param AND post.creationDate > $param
RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, post.id, post.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(place:Place)-[:IS_PART_OF]->(country:Country)
WHERE p.birthday > $param AND place.name = $param
RETURN p.firstName, p.lastName, o.name, place.name, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE t.name = $param AND p.birthday > $param
RETURN p.firstName, p.lastName, m.content, f.title;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE c.creationDate > $param AND p.browserUsed = $param
RETURN c.content, m.content, p.firstName, p.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(m:Message)<-[:CONTAINER_OF]-(f)
WHERE f.title = $param AND c.length > $param
RETURN p.firstName, p.lastName, c.content, m.content;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE c.name = $param AND country.name = $param
RETURN p.firstName, p.lastName, c.name, country.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:KNOWS]->(p3:Person)
WHERE p1.birthday < $param AND p3.gender = $param
RETURN p1.firstName, p2.firstName, p3.firstName;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(c:Country)
WHERE p1.speaks = $param AND c.name = $param
RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, o.name, c.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_TAG]->(t:Tag)<-[:HAS_TAG]-(c:Comment)
WHERE f.title = $param AND t.name = $param
RETURN f.title, p.content, c.content, t.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)<-[:REPLY_OF]-(c:Comment)
WHERE p.birthday < $param AND m.length > $param
RETURN p.firstName, p.lastName, t.name, m.content, c.content;
MATCH (c1:Comment)-[:REPLY_OF]->(c2:Comment)<-[:REPLY_OF]-(c3:Comment)-[:HAS_TAG]->(t:Tag)
WHERE c1.creationDate > $param AND t.name = $param
RETURN c1.content, c2.content, c3.content, t.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE p.birthday < $param AND t.name = $param
RETURN p.firstName, p.lastName, f.title, m.content;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE m.creationDate > $param AND tc.name = $param
RETURN m.id, m.content, t.name, tc.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:KNOWS]->(friend:Person)
WHERE f.title = $param AND friend.birthday > $param
RETURN f.title, p.firstName, p.lastName, friend.firstName, friend.lastName;
MATCH (c:Comment)-[:REPLY_OF]->(post:Post)<-[:CONTAINER_OF]-(f:Forum)
WHERE c.length > $param AND f.title = $param
RETURN c.id, c.content, post.id, post.content, f.title;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.email = $param AND creator.locationIP = $param
RETURN p.firstName, p.lastName, m.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE p.locationIP = $param AND t.name = $param
RETURN p.firstName, p.lastName, m.content, m.creationDate;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(co:Country)
WHERE p.gender = $param AND co.name = $param
RETURN p.firstName, p.lastName, u.name, c.name, co.name;
MATCH (f:Forum)-[:HAS_TAG]->(t:Tag)<-[:HAS_INTEREST]-(person:Person)-[:KNOWS]->(friend:Person)
WHERE f.title CONTAINS $param AND t.name = $param AND person.gender = $param
RETURN f.title, t.name, person.firstName, person.lastName, friend.firstName, friend.lastName;
MATCH (c:Country)<-[:IS_LOCATED_IN]-(o:Organisation)<-[:WORK_AT]-(p:Person)-[:LIKES]->(post:Post)
WHERE c.name = $param AND post.browserUsed = $param
RETURN c.name, o.name, p.firstName, p.lastName, post.content;
MATCH (forum:Forum)-[:HAS_MEMBER]->(member:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(place:Place)
WHERE forum.creationDate > $param AND company.name = $param
RETURN forum.title, member.firstName, member.lastName, company.name, place.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE p.gender = $param AND t.name = $param
RETURN p.firstName, p.lastName, m.content;
MATCH (p:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.creationDate < $param AND tc.name = $param
RETURN p.content, t.name, tc.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE f.title = $param AND p.birthday < $param
RETURN f.title, m.content, p.firstName, p.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:LIKES]->(m:Message)
WHERE f.creationDate > $param AND m.length > $param
RETURN f.title, p.firstName, p.lastName, m.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(superTc:TagClass)
WHERE superTc.name = $param
RETURN p.firstName, t.name, tc.name;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)<-[:HAS_INTEREST]-(p:Person)-[:KNOWS]->(friend:Person)
WHERE friend.lastName = $param AND m.length > $param
RETURN m.content, t.name, p.firstName;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_CREATOR]->(creator:Person)-[:IS_LOCATED_IN]->(place:Place)
WHERE place.name = $param
RETURN p.firstName, m.content, creator.firstName;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE continent.name = $param AND p.gender = $param
RETURN p.firstName, org.name, country.name;
MATCH (c1:Comment)-[:REPLY_OF]->(c2:Comment)-[:REPLY_OF]->(p:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE c1.creationDate > $param AND c2.length > $param
RETURN c1.content, c2.content, p.title, creator.firstName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)<-[:REPLY_OF]-(c:Comment)
WHERE p.birthday < $param AND t.name = $param
RETURN p.firstName, p.lastName, m.content, c.content;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)<-[:KNOWS]-(friend:Person)
WHERE f.title = $param AND creator.gender = $param
RETURN post.content, creator.firstName, creator.lastName, friend.firstName, friend.lastName;
MATCH (c:Comment)-[:REPLY_OF*1..2]->(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE c.creationDate > $param AND m.length > $param
RETURN c.content, m.content, creator.firstName, creator.lastName;
MATCH (person:Person)-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE person.locationIP = $param AND tagClass.name = $param
RETURN person.firstName, person.lastName, msg.content, tag.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(post:Post)
WHERE p.email = $param AND post.creationDate > $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, t.name, post.content;
MATCH (p:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.speaks CONTAINS $param AND creator.birthday < $param
RETURN p.firstName, p.lastName, c.content, m.content, creator.firstName, creator.lastName;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.title = $param AND tc.name = $param
RETURN f.id, f.title, m.id, m.content, t.name, tc.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:IS_LOCATED_IN]->(place:Place)
WHERE t.name = $param AND place.name = $param
RETURN p.id, p.firstName, t.name, m.id, m.content, place.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)-[:WORK_AT]->(c:Company)
WHERE msg.creationDate > $param AND c.name = $param
RETURN p.id, p.firstName, msg.id, msg.content, creator.id, creator.firstName, c.name;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)
WHERE p.gender = $param AND place.name = $param
RETURN p.id, p.firstName, org.name, place.name, msg.id, msg.content;
MATCH (f:Forum)-[:HAS_MODERATOR]->(mod:Person)-[:LIKES]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE mod.birthday < $param AND tag.name = $param
RETURN f.id, f.title, mod.id, mod.firstName, post.id, post.content, tag.name;
MATCH (forum:Forum)-[:CONTAINER_OF]->(post:Post)<-[:REPLY_OF]-(comment:Comment)-[:HAS_TAG]->(tag:Tag)
WHERE forum.creationDate > $param AND tag.name = $param
RETURN forum.title, post.content, comment.content, tag.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)<-[:REPLY_OF]-(c:Comment)
WHERE p1.birthday < $param AND t.name = $param
RETURN p1.firstName, p2.firstName, t.name, m.content, c.content;
MATCH (p:Person)-[:KNOWS*2..3]-(friend:Person)
WHERE p.locationIP = $param AND friend.gender = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName;
MATCH (p:Person)-[:STUDY_AT|:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(place:Place)
WHERE p.birthday < $param AND place.name = $param
RETURN p.firstName, p.lastName, org.name, place.name;
MATCH (post:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MEMBER]->(member:Person)
WHERE forum.title = $param AND member.speaks = $param
RETURN post.content, forum.title, member.firstName, member.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(msg:Message)
WHERE p.firstName = $param AND msg.length > $param
RETURN p.firstName, p.lastName, t.name, msg.content;
MATCH (p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.speaks = $param AND comp.name = $param
RETURN p.firstName, p.lastName, comp.name, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:REPLY_OF]->(c:Comment)-[:HAS_CREATOR]->(p2:Person)
WHERE p.firstName = $param AND m.creationDate > $param
RETURN p.id, p.firstName, t.name, m.content, c.content, p2.firstName;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:WORK_AT]->(c:Company)
WHERE f.creationDate > $param AND c.name = $param
RETURN f.title, p.firstName, p.lastName, c.name;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:IS_SUBCLASS_OF]-(tc2:TagClass)
WHERE m.length < $param AND tc2.name = $param
RETURN m.id, m.content, t.name, tc.name, tc2.name;
MATCH (p:Person)-[:KNOWS]->(p2:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(post:Post)
WHERE p.gender = $param AND p2.browserUsed = $param
RETURN p.firstName, p2.firstName, c.content, post.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.firstName = $param AND t.name = $param
RETURN p.id, p.firstName, p.lastName, m.id, m.content, t.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE f.title = $param AND creator.email = $param
RETURN f.id, f.title, p.id, p.firstName, p.lastName, m.id, m.content, t.name, creator.id, creator.firstName, creator.lastName;
MATCH (p:Person)-[:KNOWS*2..4]-(friend:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.speaks CONTAINS $param AND country.name = $param
RETURN p.id, p.firstName, p.lastName, friend.id, friend.firstName, friend.lastName, o.name, country.id, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.id = $param AND creator.gender = $param
RETURN m.id, m.content, m.creationDate;
MATCH (c:Comment)-[:REPLY_OF*2]-(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE m.creationDate > $param AND p.speaks = $param
RETURN c.id, c.content, c.creationDate;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(u:University)<-[:STUDY_AT]-(friend:Person)-[:KNOWS]-(p)
WHERE p.birthday < $param AND friend.firstName = $param
RETURN org.name, city.name, u.name;
MATCH (p:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)
WHERE p.email = $param AND msg.length > $param
RETURN company.name, place.name, msg.content;
MATCH (p:Person)-[:KNOWS*2..4]-(friend:Person)
WHERE p.firstName = $param AND friend.birthday > $param
RETURN friend.id, friend.firstName, friend.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE p.email CONTAINS $param AND m.creationDate < $param
RETURN m.id, m.content, m.creationDate;
MATCH (c:Company)<-[:WORK_AT]-(p:Person)-[:LIKES]->(msg:Message)<-[:REPLY_OF]-(comment:Comment)
WHERE c.name = $param AND comment.length > $param
RETURN comment.id, comment.content, comment.creationDate;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)<-[:REPLY_OF]-(reply:Comment)-[:HAS_CREATOR]->(p:Person)
WHERE f.title STARTS WITH $param AND p.gender = $param
RETURN reply.id, reply.content, reply.creationDate;
MATCH (msg:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:IS_SUBCLASS_OF]-(parentTc:TagClass)
WHERE msg.locationIP = $param AND parentTc.name = $param
RETURN msg.id, msg.content, t.name, tc.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.speaks = $param AND tc.name = $param
RETURN friend.firstName, friend.lastName, tag.name;
MATCH (person:Person)-[:HAS_CREATOR]-(message:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND message.length > $param
RETURN person.firstName, person.lastName, message.content;
MATCH (f:Forum)-[:HAS_MODERATOR]->(mod:Person)-[:WORK_AT]->(comp:Company)
WHERE f.title = $param AND comp.name = $param
RETURN f.title, mod.firstName, mod.lastName;
MATCH (c:Comment)-[:REPLY_OF]->(p:Post)-[:HAS_CREATOR]->(author:Person)<-[:KNOWS]-(friend:Person)
WHERE c.browserUsed = $param AND p.locationIP = $param
RETURN c.content, p.content, author.firstName, friend.firstName;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(t:Tag)<-[:HAS_TAG]-(forum:Forum)
WHERE p.email = $param AND t.name = $param
RETURN msg.content, t.name, forum.title;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)<-[:CONTAINER_OF]-(forum:Forum)
WHERE org.name = $param AND msg.length < $param
RETURN org.name, place.name, forum.title;
MATCH (org:Organisation)<-[:WORK_AT]-(p:Person)-[:KNOWS]-(friend:Person)-[:LIKES]->(msg:Message)
WHERE org.name = $param AND msg.length > $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, msg.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:KNOWS]->(fof:Person)
WHERE p.firstName = $param AND fof.gender = $param
RETURN p.firstName, friend.firstName, fof.firstName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE org.name = $param AND city.name = $param
RETURN org.name, city.name, country.name;
MATCH (u1:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(u2:University)
WHERE u1.name = $param AND u2.name <> u1.name
RETURN u1.name, city.name, u2.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(f:Forum)
WHERE p.lastName = $param AND f.creationDate < $param
RETURN p.firstName, t.name, f.title;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:WORK_AT]->(c:Company)
WHERE p1.birthday > $param AND c.name = $param
RETURN p1.firstName, p2.firstName, c.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(place:Place)
WHERE p.gender = $param AND place.name = $param
RETURN p.firstName, u.name, place.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:REPLY_OF]->(post:Post)
WHERE msg.length < $param AND p.email CONTAINS $param
RETURN p.firstName, msg.content, post.content;
MATCH (c:Comment)-[:REPLY_OF]->(msg:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE c.locationIP = $param AND f.title = $param
RETURN c.content, msg.content, f.title;
MATCH (c:Comment)-[:REPLY_OF]->(p:Post)<-[:CONTAINER_OF]-(f:Forum)-[:HAS_MEMBER]->(person:Person)
WHERE p.creationDate > datetime($param) AND f.title = $param
RETURN c.content, p.content, f.title, person.firstName;
MATCH (org:Organisation)<-[:WORK_AT]-(p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE org.name = $param AND t.name = $param AND p.gender = $param
RETURN org.name, p.firstName, m.content, t.name;
MATCH (f:Forum)-[:HAS_MODERATOR]->(person:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(comment:Comment)
WHERE f.title = $param AND person.birthday > date($param)
RETURN f.title, person.firstName, friend.firstName, comment.content;
MATCH (t:Tag)<-[:HAS_TAG]-(post:Post)<-[:REPLY_OF]-(c:Comment)-[:HAS_CREATOR]->(p:Person)
WHERE t.name = $param AND p.gender = $param
RETURN t.name, post.content, c.content, p.firstName;
MATCH (u:University)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:WORK_AT]-(person:Person)
WHERE u.name = $param AND place.name = $param
RETURN u.name, place.name, org.name, person.firstName;
MATCH (p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City)
WHERE p.birthday > $param AND city.name = $param
RETURN p.firstName, p.lastName, uni.name;
MATCH (c:Comment)-[:REPLY_OF*1..2]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND c.creationDate > $param
RETURN c.id, c.content, t.name;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.gender = $param AND org.name = $param
RETURN p.firstName, p.lastName, org.name, country.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:KNOWS]-(friend:Person)
WHERE f.title = $param AND friend.locationIP = $param
RETURN f.id, p.firstName, p.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(tc2:TagClass)
WHERE tc2.name = $param AND p.browserUsed = $param
RETURN p.firstName, p.lastName, t.name, tc.name;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)<-[:HAS_TAG]-(f:Forum)-[:HAS_MODERATOR]->(mod:Person)
WHERE t.name = $param AND mod.email = $param
RETURN m.id, m.content, mod.firstName, mod.lastName;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE creator.firstName = $param AND msg.length > $param
RETURN msg.id, msg.content, p.firstName, p.lastName;
MATCH (p:Person)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE city.name = $param AND p.gender = $param
RETURN p.firstName, p.lastName, country.name;
MATCH (person:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(company:Company)
WHERE person.locationIP = $param AND friend.browserUsed = $param
RETURN person.firstName, person.lastName, friend.firstName, friend.lastName, company.name;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)<-[:HAS_TAG]-(comment:Comment)-[:REPLY_OF]->(post)
WHERE post.creationDate < $param AND comment.length > $param
RETURN post.id, post.content, comment.id, comment.content;
MATCH (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE forum.creationDate > $param AND creator.speaks = $param
RETURN forum.title, post.id, creator.firstName, creator.lastName;
MATCH (person:Person)-[:STUDY_AT]->(university:University)-[:IS_LOCATED_IN]->(city:City)
WHERE person.birthday < $param AND city.name = $param
RETURN person.firstName, person.lastName, university.name, city.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(person:Person)
WHERE comment.browserUsed = $param AND person.gender = $param
RETURN comment.id, comment.content, post.id, person.firstName, person.lastName;
MATCH (person:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(place:Place)
WHERE company.name = $param AND place.id = $param
RETURN person.firstName, person.lastName, company.name, place.name;
MATCH (forum:Forum)-[:HAS_MEMBER]->(person:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE forum.title = $param AND tag.name = $param
RETURN forum.id, person.firstName, person.lastName, tag.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(comment:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_CREATOR]->(author:Person) 
WHERE p.birthday > $param AND author.gender = $param 
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, author.firstName, author.lastName, comment.content, msg.content;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF*]-(subClass:TagClass) 
WHERE tagClass.name = $param AND post.length > $param 
RETURN post.id, post.content, tag.name, subClass.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)<-[:HAS_INTEREST]-(person:Person)-[:IS_LOCATED_IN]->(city:City) 
WHERE f.title CONTAINS $param AND city.name = $param 
RETURN f.id, f.title, post.id, post.content, tag.name, person.firstName, person.lastName;
MATCH (person:Person)-[:STUDY_AT]->(university:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(:Person)-[:KNOWS]-(friend:Person) 
WHERE university.name = $param AND friend.gender = $param 
RETURN person.firstName, person.lastName, university.name, city.name, friend.firstName, friend.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(person:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(company:Company) 
WHERE place.name = $param AND company.name = $param 
RETURN org.name, place.name, person.firstName, person.lastName, friend.firstName, friend.lastName, company.name;
MATCH (forum:Forum)-[:HAS_MODERATOR]->(moderator:Person)-[:KNOWS]->(person:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message) 
WHERE moderator.locationIP = $param AND msg.creationDate < $param 
RETURN forum.id, forum.title, moderator.firstName, moderator.lastName, person.firstName, person.lastName, tag.name, msg.content;
MATCH (p:Person)-[:KNOWS]-(f:Person)-[:HAS_INTEREST]->(t:Tag)
WHERE p.firstName = $param AND t.name = $param
RETURN f.id, f.firstName, f.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:LIKES]->(m:Message)
WHERE f.title = $param AND p.locationIP = $param
RETURN m.id, m.content, m.creationDate;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE c.creationDate > $param AND p.email = $param
RETURN c.id, c.content, c.creationDate;
MATCH (p:Person)-[:KNOWS]->(f:Person)-[:STUDY_AT]->(u:University)
WHERE p.speaks = $param AND u.name = $param
RETURN f.id, f.firstName, f.lastName;
MATCH (f:Forum)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.creationDate < $param AND tc.name = $param
RETURN f.id, f.title, t.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(pl:Place)-[:IS_PART_OF]->(co:Country)
WHERE p.browserUsed = $param AND co.name = $param
RETURN p.id, p.firstName, p.lastName, c.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)
   WHERE p.birthday < $param AND c.name = $param
   RETURN p.firstName, p.lastName, u.name, c.name;
MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(co:Country)
   WHERE p.speaks CONTAINS $param AND co.name = $param
   RETURN p.firstName, p.lastName, o.name, co.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
   WHERE f.creationDate > $param AND tc.name = $param
   RETURN f.title, m.content, t.name, tc.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)
   WHERE p.gender = $param AND t.name = $param
   RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, t.name;
MATCH (p:Person)-[:LIKES]->(c:Comment)-[:HAS_CREATOR]->(creator:Person)
   WHERE p.locationIP = $param AND creator.locationIP = $param
   RETURN p.firstName, p.lastName, c.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:IS_LOCATED_IN]->(pl:Place)
   WHERE t.name = $param AND pl.name = $param
   RETURN p.firstName, p.lastName, m.content, t.name, pl.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(pl:Place)
    WHERE friend.gender = $param AND pl.name = $param
    RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, u.name, pl.name;
MATCH (p:Person)-[:KNOWS*1..3]-(friend:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE p.gender = $param AND t.name = $param
RETURN p.firstName, p.lastName, m.content, m.creationDate;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_CREATOR]->(p:Person)-[:STUDY_AT]->(u:University)
WHERE f.title CONTAINS $param AND u.name = $param
RETURN f.title, post.content, p.firstName, p.lastName;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF*]->(parent:TagClass)
WHERE m.creationDate > $param AND parent.name = $param
RETURN m.content, m.creationDate, t.name, tc.name;
MATCH (p:Person)-[:LIKES]->(c:Comment)<-[:REPLY_OF]-(r:Comment)-[:HAS_CREATOR]->(other:Person)
WHERE p.email ENDS WITH $param AND other.firstName = $param
RETURN p.firstName, p.lastName, c.content, r.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(f:Forum)-[:HAS_MODERATOR]->(mod:Person)
WHERE mod.gender = $param AND t.name = $param
RETURN p.firstName, p.lastName, f.title, mod.firstName, mod.lastName;
MATCH (c:Comment)-[:REPLY_OF*]->(p:Post)-[:HAS_CREATOR]->(creator:Person)-[:IS_LOCATED_IN]->(place:Place)
WHERE place.name = $param AND creator.gender = $param
RETURN c.content, p.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(msg:Message)
   WHERE p.gender = $param AND friend.birthday > date($param)
   RETURN msg.content, msg.creationDate, friend.firstName, friend.lastName;
MATCH (p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)
   WHERE p.firstName = $param AND msg.creationDate > date($param)
   RETURN p.id, p.firstName, p.lastName, comp.name, place.name, msg.content;
MATCH (post:Post)-[:HAS_CREATOR]->(p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City)
   WHERE post.length > $param AND p.email = $param
   RETURN post.id, post.content, p.firstName, p.lastName, uni.name, city.name;
MATCH (tag:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(parentTc:TagClass)
   WHERE tag.name = $param AND tc.name = $param
   RETURN tag.id, tag.name, tc.name, parentTc.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)
   WHERE p.birthday < date($param) AND msg.length > $param
   RETURN p.id, p.firstName, p.lastName, msg.content, tag.name, tc.name;
MATCH (cmt:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)-[:HAS_INTEREST]->(tag:Tag)
   WHERE cmt.length < $param AND creator.locationIP = $param
   RETURN cmt.id, cmt.content, msg.id, msg.content, creator.firstName, creator.lastName, tag.name;
MATCH (p:Person)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)<-[:IS_LOCATED_IN]-(org:Organisation)
   WHERE p.speaks = $param AND org.name = $param
   RETURN p.id, p.firstName, p.lastName, city.name, country.name, org.id, org.name;
MATCH (msg:Message)-[:HAS_TAG]->(tag:Tag)<-[:HAS_TAG]-(forum:Forum)-[:HAS_MODERATOR]->(mod:Person)
    WHERE msg.browserUsed = $param AND tag.name = $param
    RETURN msg.id, msg.content, forum.title, mod.id, mod.firstName, mod.lastName;
MATCH (c:City)<-[:IS_LOCATED_IN]-(u:University)<-[:STUDY_AT]-(p:Person)-[:HAS_INTEREST]->(t:Tag) 
WHERE c.name = $param AND t.name = $param 
RETURN p.firstName, p.lastName, u.name, c.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:REPLY_OF]->(c:Comment)-[:HAS_CREATOR]->(p2:Person) 
WHERE p2.gender = $param AND t.name = $param 
RETURN p.firstName, p.lastName, p2.firstName, p2.lastName, m.content, c.content;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:IS_SUBCLASS_OF]-(tc2:TagClass) 
WHERE tc2.name = $param AND m.length > $param 
RETURN m.content, t.name, tc.name, tc2.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_TAG]->(t:Tag)<-[:HAS_INTEREST]-(person:Person)-[:KNOWS]->(p2:Person) 
WHERE f.title = $param AND person.email CONTAINS $param 
RETURN f.title, p.content, t.name, person.firstName, person.lastName, p2.firstName, p2.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(msg:Message)-[:IS_LOCATED_IN]->(place:Place) WHERE t.name = $param AND place.name = $param RETURN msg.content, msg.creationDate, p.firstName, p.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(univ:University)<-[:STUDY_AT]-(p:Person) WHERE city.name = $param AND org.name = $param RETURN org.name, univ.name, p.firstName, p.lastName;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country) WHERE p.birthday < $param AND country.name = $param RETURN p.firstName, p.lastName, c.name;
MATCH (tc:TagClass)<-[:HAS_TYPE]-(t:Tag)<-[:HAS_TAG]-(post:Post)<-[:CONTAINER_OF]-(f:Forum) WHERE tc.name = $param AND f.creationDate < $param RETURN f.title, post.content, t.name;
MATCH (p1:Person)-[:KNOWS]-(p2:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(place:Place) WHERE p1.gender = $param AND place.name = $param RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, u.name;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:HAS_TYPE]-(otherTag:Tag)<-[:HAS_TAG]-(otherMessage:Message)
WHERE m.creationDate > $param AND otherMessage.length > $param
RETURN m.id, t.name, otherMessage.content;
MATCH (c:Comment)-[:REPLY_OF*2]->(originalPost:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE c.creationDate > $param AND creator.speaks CONTAINS $param
RETURN c.id, originalPost.title, creator.firstName;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_CREATOR]->(creator:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE f.title = $param AND creator.locationIP = $param
RETURN f.title, p.id, creator.email, tag.name;
MATCH (u:University)<-[:STUDY_AT]-(p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(c:Company)
WHERE u.name = $param AND friend.birthday > $param
RETURN u.name, p.firstName, friend.lastName, c.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(member:Person)-[:LIKES]->(likedMessage:Message)-[:HAS_TAG]->(tag:Tag)
WHERE f.creationDate > $param AND tag.name = $param
RETURN f.title, member.firstName, likedMessage.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)<-[:CONTAINER_OF]-(f:Forum)-[:HAS_MODERATOR]->(mod:Person)
WHERE p.gender = $param AND t.name = $param
RETURN p.firstName, t.name, m.content, mod.lastName;
MATCH (forum:Forum)-[:HAS_MEMBER]->(person:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $param}) 
WHERE forum.creationDate < datetime($param) 
RETURN forum.title, person.firstName, person.lastName, tag.name;
MATCH (country:Country)<-[:IS_LOCATED_IN]-(organisation:Organisation)<-[:WORK_AT]-(person:Person)-[:KNOWS]->(friend:Person) 
WHERE organisation.name = $param AND friend.birthday < date($param) 
RETURN country.name, organisation.name, person.firstName, person.lastName;
MATCH (person:Person)-[:STUDY_AT]->(university:University)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(message:Message) 
WHERE university.name = $param AND message.creationDate < datetime($param) 
RETURN person.firstName, person.lastName, university.name, message.content;
MATCH (message:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF]-(parentTagClass:TagClass {name: $param}) 
RETURN message.content, tag.name, tagClass.name, parentTagClass.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)-[:LIKES]->(likedPost:Post) 
WHERE creator.birthday > date($param) AND likedPost.id = $param 
RETURN comment.content, post.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(c:Comment)
WHERE p.id = $param AND c.creationDate > datetime($param)
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, c.content;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)
WHERE c.name = $param AND f.creationDate > datetime($param)
RETURN f.title, p.firstName, p.lastName, u.name, c.name;
MATCH (p:Person)-[:WORK_AT]->(co:Company)-[:IS_LOCATED_IN]->(c:Country)
WHERE c.name = $param AND p.gender = $param
RETURN p.firstName, p.lastName, co.name, c.name;
MATCH (p:Person)-[:HAS_INTEREST]->(:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(parent:TagClass)
WHERE parent.name = $param
RETURN p.firstName, p.lastName, tc.name, parent.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE t.name = $param AND msg.creationDate < datetime($param)
RETURN p.firstName, p.lastName, msg.content, post.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass) WHERE friend.firstName = $param RETURN p.firstName, p.lastName, tc.name;
MATCH (c:Comment)-[:REPLY_OF*]->(origPost:Post)<-[:CONTAINER_OF]-(f:Forum) WHERE f.title = $param RETURN c.content, c.creationDate;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(city:City) WHERE org.name = $param AND city.name = $param RETURN p.firstName, p.lastName, org.name, city.name;
MATCH (msg:Message)-[:HAS_TAG]->(tag:Tag)<-[:HAS_TAG]-(relatedMsg:Message) WHERE msg.creationDate > $param RETURN msg.content, relatedMsg.content;
MATCH (p:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]->(author:Person) WHERE author.gender = $param RETURN p.firstName, p.lastName, post.content, author.firstName, author.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:HAS_INTEREST]->(t:Tag) WHERE f.title = $param RETURN p.firstName, p.lastName, t.name;
MATCH (c:Company)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message) WHERE c.name = $param RETURN msg.content, msg.creationDate, place.name;
MATCH (p:Person)-[:KNOWS]-(friend:Person)-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.firstName = $param AND tc.name = $param
RETURN p, friend, m, t, tc;
MATCH (p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_PART_OF]-(country:Country)
WHERE p.speaks = $param AND country.name = $param
RETURN p, comp, place, country;
MATCH (m:Message)<-[:REPLY_OF]-(c:Comment)-[:HAS_CREATOR]->(p:Person)-[:LIKES]->(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE m.browserUsed = $param AND t.name = $param
RETURN m, c, p, post, t;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:REPLY_OF]->(c:Comment)-[:HAS_CREATOR]->(person:Person) 
WHERE m.creationDate > $param AND person.birthday < $param 
RETURN p.firstName, p.lastName, t.name, m.content, person.firstName, person.lastName;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_CREATOR]->(p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City) 
WHERE f.title CONTAINS $param AND c.name = $param 
RETURN f.title, post.content, p.firstName, p.lastName, u.name, c.name;
MATCH (m:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(parent:TagClass) 
WHERE tc.name = $param AND parent.id = $param 
RETURN m.content, tag.name, tc.name, parent.name;
MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(univ:University)<-[:STUDY_AT]-(student:Person) 
WHERE o.name = $param AND student.gender = $param 
RETURN p.firstName, p.lastName, o.name, city.name, univ.name, student.firstName, student.lastName;
MATCH (p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(country:Country)<-[:IS_LOCATED_IN]-(msg:Message)-[:HAS_CREATOR]->(creator:Person)
   WHERE country.name = $param AND msg.creationDate < $param
   RETURN msg.content, creator.firstName, creator.lastName;
MATCH (forum:Forum)-[:HAS_MODERATOR]->(moderator:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]->(creator:Person)-[:HAS_INTEREST]->(tag:Tag)
   WHERE moderator.gender = $param AND tag.name = $param
   RETURN post.content, creator.firstName, creator.email;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City) WHERE p.speaks CONTAINS $param AND c.name = $param RETURN p.firstName, p.lastName, u.name, c.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country) WHERE p.birthday < $param AND country.name = $param RETURN p.firstName, p.lastName, c.name, country.name;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass) WHERE tc.name = $param RETURN m.content, m.creationDate, t.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person) WHERE f.title = $param AND p.gender = $param RETURN f.title, m.content, p.firstName, p.lastName;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person) WHERE c.creationDate > $param RETURN c.content, m.content, p.firstName, p.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message) WHERE p.locationIP = $param AND m.length < $param RETURN p.firstName, p.lastName, t.name, m.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(post:Post) WHERE post.creationDate > $param RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, post.content;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(place:City)
WHERE place.name = $param AND m.creationDate > $param
RETURN c.id, c.content, p.firstName, p.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(f:Forum)-[:HAS_MEMBER]->(p2:Person)
WHERE p.gender = $param AND f.title CONTAINS $param
RETURN p.id, p.firstName, p2.id, p2.firstName, t.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)<-[:IS_PART_OF]-(city:City)
WHERE c.name = $param AND city.name = $param
RETURN p.id, p.firstName, country.name, city.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)-[:LIKES]->(c:Comment)
WHERE f.title = $param AND c.length > $param
RETURN f.id, f.title, p.id, p.firstName, c.id, c.content;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message)<-[:CONTAINER_OF]-(forum:Forum)
WHERE p.email ENDS WITH $param AND forum.creationDate > $param
RETURN p.id, p.firstName, tag.name, msg.id, msg.content;
MATCH (city:City)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:STUDY_AT]-(person:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE city.name = $param AND tag.name = $param
RETURN person.firstName, person.lastName, org.name, tag.name;
MATCH (country:Country)<-[:IS_PART_OF]-(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)<-[:CONTAINER_OF]-(forum:Forum)
WHERE country.name = $param AND forum.creationDate < $param
RETURN place.name, msg.content, forum.title, forum.creationDate;
MATCH (tc:TagClass)<-[:HAS_TYPE]-(tag:Tag)<-[:HAS_TAG]-(post:Post)-[:HAS_CREATOR]->(person:Person)
WHERE tc.name = $param AND person.gender = $param
RETURN tag.name, post.content, person.firstName, person.lastName;
MATCH (forum:Forum)-[:HAS_MEMBER]->(member:Person)-[:WORK_AT]->(company:Company)
WHERE forum.title = $param AND company.name = $param
RETURN member.firstName, member.lastName, forum.title, company.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE comment.creationDate > $param AND creator.birthday < $param
RETURN comment.content, post.content, creator.firstName, creator.lastName;
MATCH (univ:University)<-[:STUDY_AT]-(student:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(msg:Message)
WHERE univ.name = $param AND msg.length > $param
RETURN student.firstName, student.lastName, friend.firstName, friend.lastName, msg.content;
MATCH (tag:Tag)<-[:HAS_TAG]-(comment:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_TAG]->(relatedTag:Tag)
WHERE tag.name = $param AND relatedTag.name = $param
RETURN comment.content, msg.content, tag.name, relatedTag.name;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.gender = $param AND creator.birthday < $param
RETURN msg.content, creator.firstName, creator.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(msg:Message)
WHERE org.name = $param AND msg.creationDate < $param
RETURN msg.content, msg.length, place.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(member:Person)-[:STUDY_AT]->(uni:University)
WHERE f.title = $param AND uni.name = $param
RETURN member.firstName, member.lastName, member.email;
MATCH (msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE msg.length > $param AND tagClass.name = $param
RETURN msg.content, msg.locationIP, tag.name;
MATCH (uni:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(person:Person)
WHERE uni.name = $param AND person.gender = $param
RETURN city.name, person.firstName, person.lastName;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:LIKES]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass) WHERE p1.firstName = $param AND tc.name = $param RETURN p2.id, p2.firstName, m.content, t.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(co:Country) WHERE p.birthday < $param AND co.name = $param RETURN p.firstName, p.lastName, u.name, c.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(pl:Place)-[:IS_PART_OF]->(co:Country) WHERE p.speaks = $param AND co.name = $param RETURN p.firstName, p.lastName, c.name, pl.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(ci:City)-[:IS_PART_OF]->(co:Country) WHERE f.creationDate > $param AND p.gender = $param RETURN f.title, m.content, p.firstName, ci.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(tc2:TagClass) WHERE p.email = $param AND tc2.name = $param RETURN p.firstName, p.lastName, tc.name, tc2.name;
MATCH (c:Comment)-[:HAS_CREATOR]->(p:Person)-[:LIKES]->(m:Message)-[:HAS_TAG]->(t:Tag) WHERE c.creationDate < $param AND t.name = $param RETURN c.content, p.firstName, m.content, t.name;
MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(ci:City) WHERE p.browserUsed = $param AND ci.name = $param RETURN p.firstName, p.lastName, o.name, ci.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:HAS_INTEREST]->(t:Tag) WHERE f.title = $param AND t.name = $param RETURN f.title, p.firstName, p.lastName, t.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(pl:Place)
WHERE p.firstName = $param AND pl.name = $param
RETURN p.firstName, p.lastName, c.name, pl.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND p.gender = $param
RETURN p.firstName, p.lastName, t.name, tc.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:IS_LOCATED_IN]->(ct:City)
WHERE f.title = $param AND ct.name = $param
RETURN f.title, p.firstName, p.lastName, ct.name;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE m.content CONTAINS $param AND tc.name = $param
RETURN m.id, m.content, t.name, tc.name;
MATCH (p:Person)-[:KNOWS]->(p2:Person)-[:STUDY_AT]->(u:University)
WHERE p.birthday < $param AND u.name = $param
RETURN p.firstName, p.lastName, p2.firstName, p2.lastName, u.name;
MATCH (m:Message)-[:REPLY_OF]->(po:Post)-[:HAS_CREATOR]->(p:Person)
WHERE m.length > $param AND p.locationIP = $param
RETURN m.id, po.id, p.firstName, p.lastName;
MATCH (p:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(m:Message)
WHERE p.email = $param AND m.length < $param
RETURN p.firstName, p.lastName, c.id, m.id;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(ct:City)
WHERE org.name = $param AND p.gender = $param
RETURN p.firstName, p.lastName, org.name, ct.name;
MATCH (p:Person)-[:KNOWS]->(p2:Person)-[:HAS_INTEREST]->(t:Tag)
WHERE p2.birthday > $param AND t.name = $param
RETURN p.firstName, p.lastName, p2.firstName, p2.lastName, t.name;
MATCH (p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(country:Country {name: $param})
WHERE p.speaks CONTAINS $param AND p.browserUsed = $param
RETURN p.firstName, p.lastName, comp.name, country.name;
MATCH (msg:Message)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE msg.creationDate > $param AND post.locationIP = $param
RETURN msg.content, post.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $param})
WHERE p.email ENDS WITH $param
RETURN p.firstName, p.lastName, tag.name, tagClass.name;
MATCH (forum:Forum)-[:HAS_MEMBER]->(member:Person)-[:STUDY_AT]->(uni:University)
WHERE forum.creationDate > $param AND uni.name = $param
RETURN forum.title, member.firstName, member.lastName, uni.name;
MATCH (comment:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_TAG]->(tag:Tag)
WHERE comment.creationDate > $param AND msg.browserUsed = $param
RETURN comment.content, msg.content, tag.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(city:City)
WHERE friend.birthday < $param AND city.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, org.name, city.name;
MATCH (msg:Message)-[:HAS_CREATOR]->(creator:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(place:Place)
WHERE msg.length > $param AND place.name = $param
RETURN msg.content, creator.firstName, creator.lastName, uni.name, place.name;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)-[:IS_SUBCLASS_OF]->(superClass:TagClass)
WHERE post.creationDate > $param AND tagClass.name = $param
RETURN post.content, tag.name, tagClass.name, superClass.name;
MATCH (c:City)<-[:IS_LOCATED_IN]-(o:Organisation)<-[:WORK_AT]-(p:Person)-[:HAS_INTEREST]->(t:Tag) WHERE c.name = $param AND t.name = $param RETURN p.id, p.firstName, p.lastName;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(co:Country) WHERE p1.locationIP = $param AND co.name = $param RETURN c.id, c.name;
MATCH (p:Person)-[:LIKES]->(m:Message)<-[:REPLY_OF]-(cm:Comment)-[:HAS_TAG]->(t:Tag) WHERE p.email = $param AND t.name = $param RETURN cm.id, cm.content;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE city.name = $param AND country.name = $param
RETURN org.name, city.name, country.name;
MATCH (msg:Message)-[:HAS_CREATOR]->(creator:Person)-[:IS_LOCATED_IN]->(city:City)
WHERE msg.creationDate > $param AND city.name = $param
RETURN msg.id, msg.content, creator.firstName, creator.lastName;
MATCH (person:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE person.gender = $param AND country.name = $param
RETURN person.firstName, person.lastName, company.name, country.name;
MATCH (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE forum.title = $param AND tag.name = $param
RETURN forum.title, post.content, tag.name;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message)<-[:REPLY_OF]-(comment:Comment)
WHERE person.birthday < $param AND tag.name = $param
RETURN person.firstName, person.lastName, comment.content;
MATCH (person:Person)-[:STUDY_AT]->(univ:University)-[:IS_LOCATED_IN]->(city:City)
WHERE person.speaks = $param AND city.name = $param
RETURN person.firstName, person.lastName, univ.name, city.name;
MATCH (comment:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE comment.length > $param AND creator.gender = $param
RETURN comment.id, comment.content, creator.firstName, creator.lastName;
MATCH (person:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE person.email = $param AND creator.locationIP = $param
RETURN friend.firstName, friend.lastName, post.content;
MATCH (p:Person)-[:HAS_INTEREST]->(:Tag)<-[:HAS_TAG]-(msg:Message)-[:REPLY_OF*1..2]->(post:Post)
WHERE p.speaks = $param 
AND msg.length < $param 
RETURN p.firstName, p.lastName, post.title, msg.content;
MATCH (p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(org:Organisation)
WHERE p.birthday < $param 
AND org.name = $param 
RETURN p.firstName, p.lastName, city.name, org.name;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE post.creationDate > $param 
AND tagClass.name = $param 
RETURN post.id, post.content, tag.name;
MATCH (p:Person)-[:LIKES]->(comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE p.email = $param 
AND creator.birthday > $param 
RETURN p.firstName, p.lastName, comment.content, post.title;
MATCH (t:Tag)<-[:HAS_TAG]-(post:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MODERATOR]->(moderator:Person)
WHERE t.name = $param 
AND forum.creationDate < $param 
RETURN moderator.firstName, moderator.lastName, post.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $param})
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, tag.name, tagClass.name;
MATCH (msg:Message)-[:REPLY_OF*2]->(post:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE msg.creationDate > $param
RETURN msg.content, post.title, creator.firstName, creator.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country {name: $param})
RETURN org.name, city.name, country.name;
MATCH (cmt:Comment)-[:HAS_TAG]->(tag:Tag)<-[:HAS_TAG]-(post:Post)
WHERE cmt.creationDate < $param AND post.length > $param
RETURN cmt.content, post.content, tag.name;
MATCH (p:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.birthday < $param AND country.name = $param
RETURN p.firstName, p.lastName, company.name, country.name;
MATCH (univ:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(person:Person)
WHERE person.gender = $param
RETURN univ.name, city.name, person.firstName, person.lastName;
MATCH (forum:Forum)-[:CONTAINER_OF]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE msg.browserUsed = $param AND creator.speaks CONTAINS $param
RETURN forum.title, msg.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:STUDY_AT]->(univ:University)-[:IS_LOCATED_IN]->(place:Place)
WHERE p.email CONTAINS $param
RETURN p.firstName, p.lastName, univ.name, place.name;
MATCH (msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE msg.locationIP = $param
RETURN msg.content, tag.name, tagClass.name;
MATCH (person:Person)-[:HAS_CREATOR]-(msg:Message)<-[:REPLY_OF*]-(cmt:Comment)
WHERE person.gender = $param AND cmt.length < $param
RETURN person.firstName, person.lastName, msg.content, cmt.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $param})
WHERE p.gender = $param AND p.birthday > $param
RETURN p.firstName, p.lastName, post.content;
MATCH (c:Comment)-[:REPLY_OF*]->(m:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE c.creationDate > $param AND f.title = $param
RETURN c.content, m.content, f.title;
MATCH (p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(place:Place)
WHERE p.email CONTAINS $param AND uni.name = $param
RETURN p.firstName, p.lastName, place.name;
MATCH (comp1:Company)-[:IS_LOCATED_IN]->(country:Country)<-[:IS_LOCATED_IN]-(comp2:Company)
WHERE comp1.name = $param AND country.name = $param
RETURN comp1.name, comp2.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City)
WHERE p.locationIP = $param AND city.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE f.title = $param AND tag.name = $param
RETURN f.title, p.firstName, p.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(country:Country)<-[:IS_LOCATED_IN]-(msg:Message)
WHERE org.name = $param AND msg.length < $param
RETURN org.name, country.name, msg.content;
MATCH (p:Person)-[:KNOWS*2..3]-(friend:Person) 
WHERE p.firstName = $param AND friend.gender = $param 
RETURN friend.firstName, friend.lastName, friend.email;
MATCH (univ:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(p:Person)-[:WORK_AT]->(comp:Company) 
WHERE univ.name = $param AND comp.name = $param 
RETURN p.firstName, p.lastName, p.email;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(m:Message) 
WHERE p.speaks CONTAINS $param AND m.browserUsed = $param 
RETURN m.content, m.length, place.name;
MATCH (forum:Forum)-[:HAS_MEMBER]->(person:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(comment:Comment)-[:REPLY_OF]->(post:Post) 
WHERE forum.title = $param AND comment.length > $param 
RETURN person.firstName, person.lastName, post.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass {name: $param})
WHERE p.gender = $param
RETURN p.firstName, p.lastName, t.name, tc.name;
MATCH (fo:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(place:Place)
WHERE fo.creationDate > $param
RETURN fo.title, m.content, p.firstName, p.lastName, place.name;
MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(country:Country)<-[:IS_PART_OF]-(city:City)
WHERE o.name = $param
RETURN p.firstName, p.lastName, o.name, city.name, country.name;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_TAG]->(t:Tag {name: $param})
WHERE m.creationDate > $param
RETURN c.content, m.content, t.name;
MATCH (p:Person)-[:LIKES]->(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param
RETURN p.firstName, p.lastName, post.content, tag.name, tc.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE p.birthday > $param
RETURN p.firstName, p.lastName, u.name, city.name, country.name;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(uni:University)<-[:STUDY_AT]-(student:Person)
WHERE org.name = $param AND student.birthday < $param
RETURN student.id, student.firstName, student.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(member:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(post:Post)
WHERE f.title = $param AND post.creationDate < $param
RETURN post.id, post.content, post.creationDate;
MATCH (person:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE person.gender = $param AND country.name = $param
RETURN person.id, person.firstName, person.lastName;
MATCH (comment:Comment)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF]-(parentClass:TagClass)
WHERE tagClass.name = $param
RETURN comment.id, comment.content, comment.creationDate;
MATCH (p:Person)-[:LIKES]->(c:Comment)<-[:REPLY_OF*1..2]-(m:Message)
WHERE p.birthday > $param AND m.length > $param
RETURN c.id, c.content, c.creationDate;
MATCH (msg:Message)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_PART_OF]-(country:Country)
WHERE msg.browserUsed = $param AND country.name = $param
RETURN msg.id, msg.content, msg.creationDate;
MATCH (p:Person)-[:KNOWS*2..3]-(friend:Person)-[:WORK_AT]->(org:Organisation) WHERE p.firstName = $param AND org.name = $param RETURN friend.id, friend.firstName, friend.lastName;
MATCH (c:Comment)-[:REPLY_OF*1..2]->(m:Message)-[:HAS_CREATOR]->(p:Person) WHERE c.creationDate > $param AND p.locationIP = $param RETURN c.id, c.content, c.creationDate;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_TAG]->(:Tag {name: $param})<-[:HAS_INTEREST]-(person:Person) WHERE f.creationDate > $param RETURN p.id, p.content, p.creationDate;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(:City {name: $param})<-[:IS_LOCATED_IN]-(org:Organisation) WHERE p.speaks = $param RETURN org.id, org.name;
MATCH (person:Person)-[:HAS_INTEREST]->(:Tag)<-[:HAS_TAG]-(c:Comment)-[:REPLY_OF*1..]->(m:Message)-[:HAS_CREATOR]->(creator:Person) WHERE person.firstName = $param RETURN creator.id, creator.firstName, creator.lastName;
MATCH (tc:TagClass)-[:IS_SUBCLASS_OF*1..]->(:TagClass)-[:HAS_TYPE]-(tag:Tag)<-[:HAS_TAG]-(post:Post)-[:HAS_CREATOR]->(p:Person) WHERE p.gender = $param RETURN post.id, post.content, post.creationDate;
MATCH (p:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(:Country {name: $param}) WHERE p.browserUsed = $param RETURN p.id, p.firstName, p.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(f:Forum)-[:CONTAINER_OF]->(m:Message)
WHERE p.email = $param AND m.length > $param
RETURN p.firstName, p.lastName, t.name, f.title, m.content, m.length;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(pl:Place)<-[:IS_LOCATED_IN]-(m:Message)
WHERE p.speaks = $param AND m.browserUsed = $param
RETURN p.firstName, p.lastName, c.name, pl.name, m.content, m.browserUsed;
MATCH (p:Person)-[:LIKES]->(po:Post)-[:HAS_CREATOR]->(f:Person)-[:WORK_AT]->(o:Organisation)
WHERE p.birthday < $param AND o.name = $param
RETURN p.firstName, p.lastName, po.content, f.firstName, f.lastName, o.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(f:Person)
WHERE f.email = $param AND m.locationIP = $param
RETURN p.firstName, p.lastName, t.name, m.content, f.firstName, f.lastName;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass) 
WHERE m.creationDate > $param AND tc.name = $param 
RETURN m.id, m.content, t.name, tc.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(post:Post)<-[:CONTAINER_OF]-(f:Forum) 
WHERE p.email ENDS WITH $param AND f.title CONTAINS $param 
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, post.id, f.title;
MATCH (p1:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:REPLY_OF]->(original:Post) 
WHERE p1.locationIP = $param AND t.name = $param 
RETURN p1.firstName, p1.lastName, m.id, original.id;
MATCH (t:Tag)<-[:HAS_TAG]-(m:Message)<-[:REPLY_OF]-(comment:Comment)-[:HAS_CREATOR]->(p:Person) 
WHERE m.creationDate < $param AND t.name = $param 
RETURN t.name, m.id, comment.id, p.firstName, p.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(place:Place) 
WHERE f.creationDate > $param AND place.name = $param 
RETURN f.title, p.firstName, p.lastName, u.name, place.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass) 
WHERE p.browserUsed = $param AND tc.name = $param 
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, tag.name, tc.name;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(person:Person)
WHERE org.name = $param AND city.name = $param AND person.gender = $param
RETURN org.name, city.name, person.firstName, person.lastName;
MATCH (msg:Message)-[:REPLY_OF*]->(original:Post)<-[:CONTAINER_OF]-(forum:Forum)
WHERE msg.creationDate > $param AND forum.title = $param
RETURN msg.content, original.content, forum.title;
MATCH (forum:Forum)-[:HAS_MEMBER]->(member:Person)-[:WORK_AT]->(company:Company)
WHERE forum.title = $param AND company.name = $param AND member.locationIP = $param
RETURN forum.title, member.firstName, member.lastName, company.name;
MATCH (person:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE person.gender = $param AND tagClass.name = $param
RETURN person.firstName, person.lastName, msg.content, tag.name, tagClass.name;
MATCH (person:Person)-[:HAS_CREATOR]-(msg:Message)-[:IS_LOCATED_IN]->(country:Country)
WHERE person.email = $param AND country.name = $param
RETURN person.firstName, person.lastName, msg.content, country.name;
MATCH (company:Company)<-[:WORK_AT]-(person:Person)-[:KNOWS]-(friend:Person)-[:STUDY_AT]->(uni:University)
WHERE company.name = $param AND uni.name = $param
RETURN company.name, person.firstName, person.lastName, friend.firstName, friend.lastName, uni.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(company:Company) 
WHERE p.firstName = $param AND friend.gender = $param 
RETURN p.id, p.firstName, friend.id, friend.firstName, company.id, company.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(tag:Tag) 
WHERE p.birthday > $param AND tag.name = $param 
RETURN p.id, p.firstName, msg.id, msg.content, tag.id, tag.name;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(post:Post)-[:HAS_CREATOR]->(creator:Person) 
WHERE p.id = $param AND post.creationDate > $param 
RETURN p.id, p.firstName, post.id, post.content, creator.id, creator.firstName;
MATCH (p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City) 
WHERE p.speaks = $param AND city.name = $param 
RETURN p.id, p.firstName, uni.id, uni.name, city.id, city.name;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(country:Country) 
WHERE p.gender = $param AND country.name = $param 
RETURN p.id, p.firstName, org.id, org.name, country.id, country.name;
MATCH (forum:Forum)-[:HAS_MODERATOR]->(mod:Person)-[:KNOWS]->(friend:Person) 
WHERE forum.title = $param AND mod.gender = $param 
RETURN forum.id, forum.title, mod.id, mod.firstName, friend.id, friend.firstName;
MATCH (cmt:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_CREATOR]->(creator:Person) 
WHERE cmt.creationDate < $param AND creator.speaks = $param 
RETURN cmt.id, cmt.content, msg.id, msg.content, creator.id, creator.firstName;
MATCH (p:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(place:Place) 
WHERE p.browserUsed = $param AND company.name = $param 
RETURN p.id, p.firstName, company.id, company.name, place.id, place.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass) WHERE p.speaks = $param AND tc.name = $param RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, t.name;
MATCH (c:Comment)-[:REPLY_OF*1..3]->(root:Post)-[:HAS_CREATOR]->(creator:Person) WHERE c.creationDate > $param AND creator.birthday < $param RETURN c.content, root.title, creator.firstName, creator.lastName;
MATCH (p:Post)-[:HAS_TAG]->(t:Tag)<-[:HAS_INTEREST]-(person:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City) WHERE t.name = $param AND city.name = $param RETURN p.content, person.firstName, person.lastName, u.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass) WHERE f.creationDate > $param AND tc.name = $param RETURN f.title, m.content, t.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)-[:IS_LOCATED_IN]->(place:Place) WHERE p.locationIP = $param AND msg.length > $param RETURN p.firstName, p.lastName, msg.content, creator.firstName, creator.lastName, place.name;
MATCH (org:Organisation)<-[:WORK_AT]-(p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(post:Post) WHERE org.name = $param AND post.creationDate > $param RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, post.content;
MATCH (tc:TagClass)<-[:HAS_TYPE]-(t:Tag)<-[:HAS_TAG]-(msg:Message)<-[:REPLY_OF]-(c:Comment) WHERE c.creationDate > $param AND tc.name = $param RETURN t.name, msg.content, c.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE m.creationDate > $param AND creator.gender = $param
RETURN p.firstName, p.lastName, m.content, creator.firstName, creator.lastName;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:WORK_AT]->(c:Company)
WHERE p1.speaks = $param AND c.name = $param
RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, c.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE f.creationDate < $param AND creator.email CONTAINS $param
RETURN f.title, msg.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:HAS_CREATOR]-(msg:Message)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE msg.length > $param AND tag.name = $param
RETURN p.firstName, p.lastName, msg.content, post.content, tag.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(super:TagClass)
WHERE tc.name = $param AND super.name = $param
RETURN p.firstName, p.lastName, t.name, tc.name, super.name;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE city.name = $param AND p.gender = $param
RETURN p.firstName, p.lastName, org.name, city.name, country.name;
MATCH (c:City)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:WORK_AT]-(p:Person)
WHERE c.name = $param AND org.name = $param
RETURN p.firstName, p.lastName, org.name;
MATCH (p:Person)-[:HAS_INTEREST]->(:Tag)<-[:HAS_TAG]-(msg:Message)-[:REPLY_OF]->(comment:Comment)
WHERE p.speaks CONTAINS $param AND msg.length > $param
RETURN p.firstName, p.lastName, comment.content;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE f.title = $param AND m.length > $param
RETURN f.title, p.firstName, p.lastName, t.name, m.content;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:LIKES]->(msg:Message)-[:HAS_CREATOR]->(p3:Person)
WHERE p1.birthday < $param AND msg.creationDate > $param
RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, msg.content, p3.firstName, p3.lastName;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(m:Message)
WHERE org.name = $param AND place.name = $param
RETURN p.firstName, p.lastName, org.name, place.name, m.content;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(forum:Forum)-[:HAS_MODERATOR]->(moderator:Person)
WHERE p.locationIP = $param AND tag.name = $param
RETURN p.firstName, p.lastName, forum.title, moderator.firstName, moderator.lastName;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City {name: $param}), (p)-[:HAS_INTEREST]->(t:Tag) RETURN p.firstName, p.lastName, u.name, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(c:Company {name: $param}), (friend)-[:HAS_INTEREST]->(t:Tag) RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, c.name, t.name;
MATCH (p:Person)-[:LIKES]->(post:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass {name: $param}) RETURN p.firstName, p.lastName, post.content, t.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country {name: $param}), (p)-[:KNOWS]->(friend:Person) RETURN p.firstName, p.lastName, c.name, friend.firstName, friend.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(parentTC:TagClass {name: $param}) RETURN p.firstName, p.lastName, tag.name, tc.name, parentTC.name;
MATCH (p:Person)-[:KNOWS]->(:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)
WHERE t.name = $param AND m.creationDate > $param
RETURN p.firstName, p.lastName, m.content, m.creationDate;
MATCH (c:Comment)-[:REPLY_OF*]->(p:Post)<-[:CONTAINER_OF]-(f:Forum)-[:HAS_MEMBER]->(person:Person)
WHERE f.title = $param AND person.gender = $param
RETURN c.content, c.creationDate, person.firstName, person.lastName;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(org:Organisation)
WHERE city.name = $param AND org.name = $param
RETURN p.firstName, p.lastName, p.email, org.name;
MATCH (msg:Message)-[:HAS_CREATOR]->(p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE comp.name = $param AND msg.locationIP = $param
RETURN msg.content, msg.creationDate, comp.name, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:IS_SUBCLASS_OF*]-(subTc:TagClass)
WHERE tc.name = $param AND subTc.name = $param
RETURN p.firstName, p.lastName, t.name, subTc.name;
MATCH (m:Message)-[:HAS_TAG]->(tag:Tag)<-[:HAS_TAG]-(:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE tag.name = $param AND creator.birthday < $param
RETURN m.content, m.creationDate, creator.firstName, creator.lastName;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(creator:Person)-[:STUDY_AT]->(uni:University)
WHERE uni.name = $param AND c.browserUsed = $param
RETURN c.content, c.creationDate, creator.firstName, creator.lastName, uni.name;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(m:Message)-[:REPLY_OF]->(c:Comment)-[:HAS_CREATOR]->(author:Person) WHERE p.gender = $param AND author.birthday > $param RETURN m.id, c.content;
MATCH (u:University)<-[:STUDY_AT]-(p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(c:Company) WHERE u.name = $param AND c.name = $param RETURN p.firstName, friend.firstName, c.id;
MATCH (p:Post)-[:HAS_CREATOR]->(author:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(m:Message) WHERE p.creationDate < $param AND tag.name = $param RETURN author.id, m.content;
MATCH (t:Tag)<-[:HAS_TAG]-(p:Post)<-[:CONTAINER_OF]-(f:Forum)-[:HAS_MEMBER]->(person:Person) WHERE t.name = $param AND person.email CONTAINS $param RETURN p.id, f.title;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City {name: $param})<-[:IS_LOCATED_IN]-(person:Person) 
WHERE person.speaks CONTAINS $param 
RETURN org.name, person.firstName, person.lastName, city.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)<-[:REPLY_OF]-(c:Comment)-[:HAS_CREATOR]->(person:Person) 
WHERE f.title = $param AND person.gender = $param 
RETURN f.title, post.content, c.content, person.firstName, person.lastName;
MATCH (msg:Message)-[:HAS_CREATOR]->(p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(place:Place) 
WHERE place.name = $param AND comp.name = $param 
RETURN msg.content, p.firstName, p.lastName, comp.name, place.name;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $param})<-[:IS_SUBCLASS_OF]-(subClass:TagClass) 
RETURN p.firstName, p.lastName, tag.name, tagClass.name, subClass.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:REPLY_OF]->(orig:Post)-[:HAS_CREATOR]->(creator:Person) 
WHERE creator.email = $param 
RETURN p.firstName, p.lastName, msg.content, orig.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE p.firstName = $param AND p.lastName = $param
RETURN friend.firstName, friend.lastName, tag.name;
MATCH (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE forum.title = $param AND creator.gender = $param
RETURN post.id, post.content, creator.firstName, creator.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(uni:University)<-[:STUDY_AT]-(student:Person)
WHERE org.name = $param AND city.name = $param
RETURN student.firstName, student.lastName, uni.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE comment.creationDate > $param AND tag.name = $param
RETURN comment.id, comment.content, post.id;
MATCH (person:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE person.birthday < $param AND country.name = $param
RETURN person.firstName, person.lastName, company.name;
MATCH (post:Post)-[:HAS_CREATOR]->(creator:Person)-[:KNOWS]->(friend:Person)
WHERE post.creationDate > $param AND friend.speaks = $param
RETURN post.id, creator.firstName, creator.lastName, friend.firstName, friend.lastName;
MATCH (tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)-[:IS_SUBCLASS_OF]->(superClass:TagClass)
WHERE tag.name = $param AND superClass.name = $param
RETURN tagClass.name, superClass.name;
MATCH (person:Person)-[:LIKES]->(msg:Message)-[:REPLY_OF]->(comment:Comment)-[:HAS_CREATOR]->(creator:Person)
WHERE person.gender = $param AND comment.creationDate < $param
RETURN msg.id, comment.id, creator.firstName, creator.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(parentTC:TagClass)
WHERE p.birthday < date($param) AND parentTC.name = $param
RETURN p.id, p.firstName, p.lastName, t.name, tc.name;
MATCH (u:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(o:Organisation)
WHERE u.name = $param AND city.name = $param
RETURN u.id, u.name, o.id, o.name, city.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE f.title = $param AND creator.gender = $param
RETURN p.id, p.content, p.creationDate, creator.firstName, creator.lastName;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(post:Post)
WHERE p1.gender = $param AND post.creationDate > datetime($param)
RETURN p2.id, p2.firstName, p2.lastName, c.content, post.id;
MATCH (company:Company)<-[:WORK_AT]-(p:Person)<-[:HAS_CREATOR]-(comment:Comment)-[:REPLY_OF]->(m:Message)
WHERE company.name = $param AND comment.length > $param
RETURN company.id, company.name, p.id, p.firstName, p.lastName, comment.content, m.id;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(p2:Person)
WHERE t.name = $param AND p2.birthday > date($param)
RETURN p.id, p.firstName, p.lastName, m.content, p2.id, p2.firstName, p2.lastName;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)-[:REPLY_OF]->(c:Comment)-[:HAS_CREATOR]->(p:Person) 
WHERE f.title = $param AND m.creationDate < $param 
RETURN p.firstName, p.lastName, c.content, f.title;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(msg:Message)-[:IS_LOCATED_IN]->(pl:Place) 
WHERE p.id = $param AND pl.name = $param 
RETURN friend.firstName, friend.lastName, msg.content, pl.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City) 
WHERE c.name = $param AND p.birthday > $param 
RETURN p.firstName, p.lastName, u.name, c.name;
MATCH (p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(country:Country) 
WHERE comp.name = $param AND country.name = $param 
RETURN p.firstName, p.lastName, comp.name, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(creator:Person) 
WHERE creator.gender = $param AND m.length > $param 
RETURN p.firstName, p.lastName, t.name, m.content;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:KNOWS]->(friend:Person) 
WHERE f.title = $param AND friend.speaks = $param 
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(pl:Place) 
WHERE org.name = $param AND pl.id = $param 
RETURN p.firstName, p.lastName, org.name, pl.name;
MATCH (t:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE t.name = $param AND m.length < $param
RETURN p.id, p.firstName, p.lastName, m.content, m.length, t.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND p.gender = $param
RETURN p.id, p.firstName, p.lastName, t.name, tc.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:STUDY_AT]->(u:University)
WHERE f.title = $param AND u.name = $param
RETURN f.id, f.title, p.id, p.firstName, p.lastName, u.name;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE c.length > $param AND p.locationIP = $param
RETURN c.id, c.content, c.creationDate, m.id, m.content, p.id, p.firstName, p.lastName;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE m.creationDate < $param AND t.name = $param
RETURN p.id, p.firstName, p.lastName, m.id, m.content, t.name;
MATCH (p:Person)-[:IS_LOCATED_IN]->(pl:Place)-[:IS_PART_OF]->(co:Country)
WHERE co.name = $param AND pl.name = $param
RETURN p.id, p.firstName, p.lastName, pl.name, co.name;
MATCH (p:Person)-[:KNOWS]->(p2:Person)-[:WORK_AT]->(o:Organisation)
WHERE p.speaks = $param AND o.name = $param
RETURN p.id, p.firstName, p.lastName, p2.id, p2.firstName, p2.lastName, o.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(po:Post)-[:HAS_TAG]->(t:Tag)
WHERE f.creationDate > $param AND t.name = $param
RETURN f.id, f.title, po.id, po.content, t.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(m:Message)
WHERE p.speaks CONTAINS $param AND m.creationDate > $param
RETURN p.firstName, p.lastName, u.name, place.name, m.content;
MATCH (org:Organisation)<-[:WORK_AT]-(p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(t:Tag)
WHERE org.name = $param AND t.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, t.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(creator:Person)-[:WORK_AT]->(org:Organisation)
WHERE comment.creationDate > $param AND org.name = $param
RETURN comment.content, post.content, creator.firstName, creator.lastName, org.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.locationIP = $param AND msg.length < $param
RETURN p.firstName, p.lastName, t.name, msg.content, creator.firstName, creator.lastName;
MATCH (c:City)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:WORK_AT]-(p:Person)-[:HAS_INTEREST]->(t:Tag)
WHERE org.name = $param AND t.name = $param
RETURN p.firstName, p.lastName, org.name, c.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)
WHERE p.birthday < $param AND city.name = $param
RETURN p.firstName, p.lastName, u.name, city.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(msg:Message)-[:REPLY_OF]->(original:Post)
WHERE friend.gender = $param AND original.creationDate < $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, msg.content;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE p.speaks = $param AND country.name = $param
RETURN p.firstName, p.lastName, u.name, city.name, country.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)<-[:CONTAINER_OF]-(f:Forum {title: $param})-[:HAS_MODERATOR]->(mod:Person) WHERE p.locationIP = $param RETURN p.firstName, p.lastName, t.name, m.content, f.title, mod.firstName, mod.lastName;
MATCH (p:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(creator:Person) WHERE p.browserUsed = $param AND m.creationDate > $param RETURN p.firstName, p.lastName, c.content, m.content, creator.firstName, creator.lastName;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_CREATOR]->(person:Person)-[:STUDY_AT]->(u:University), (p)-[:HAS_TAG]->(t:Tag {name: $param}) WHERE person.gender = $param RETURN f.title, p.content, person.firstName, person.lastName, u.name, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(c:Company), (friend)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass {name: $param}) WHERE p.speaks CONTAINS $param RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, c.name, tag.name, tc.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(post:Post)
WHERE p.firstName = $param AND tag.name = $param
RETURN friend.firstName, friend.lastName, post.content;
MATCH (forum:Forum)-[:CONTAINER_OF]->(message:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE forum.title =~ $param AND tagClass.name = $param
RETURN forum.id, forum.title, message.content;
MATCH (person:Person)-[:HAS_CREATOR]-(msg:Message)-[:REPLY_OF]->(comment:Comment)-[:HAS_CREATOR]->(otherPerson:Person)
WHERE person.gender = $param AND msg.creationDate > $param
RETURN person.firstName, person.lastName, otherPerson.firstName, otherPerson.lastName, comment.content;
MATCH (company:Company)<-[:WORK_AT]-(person:Person)-[:KNOWS]->(friend:Person)-[:LIKES]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE company.name = $param AND tag.name = $param
RETURN person.firstName, person.lastName, friend.firstName, friend.lastName, post.content;
MATCH (person:Person)-[:LIKES]->(message:Message)-[:HAS_CREATOR]->(creator:Person)-[:IS_LOCATED_IN]->(city:City)
WHERE person.locationIP = $param AND city.name = $param
RETURN person.firstName, person.lastName, creator.firstName, creator.lastName, message.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_PART_OF]-(country:Country)
WHERE p.email = $param AND country.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, company.name, place.name;
MATCH (p:Person)-[:KNOWS]-(friend:Person)-[:WORK_AT]->(c:Company)
WHERE p.birthday > $param AND c.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, c.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.creationDate < $param AND tc.name = $param
RETURN f.title, post.content, t.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:IS_SUBCLASS_OF]-(tc2:TagClass)
WHERE tc2.name = $param AND p.browserUsed = $param
RETURN p.firstName, p.lastName, t.name, tc.name;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE c.creationDate > $param AND p.speaks CONTAINS $param
RETURN c.content, m.content, p.firstName, p.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(member:Person)-[:LIKES]->(msg:Message)
WHERE f.creationDate > $param AND member.locationIP = $param
RETURN f.title, member.firstName, member.lastName, msg.content;
MATCH (c:City)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:WORK_AT]-(p:Person)-[:KNOWS]-(friend:Person)
WHERE c.name = $param AND friend.email CONTAINS $param
RETURN c.name, org.name, p.firstName, p.lastName, friend.firstName, friend.lastName;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(co:Country)
   WHERE p.speaks = $param AND co.name = $param
   RETURN p.firstName, p.lastName, u.name, c.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
   WHERE p1.birthday > $param AND tc.name = $param
   RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, t.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(pl:Place)
   WHERE c.name = $param AND pl.name = $param
   RETURN p.firstName, p.lastName, c.name, pl.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
   WHERE f.title = $param AND tc.name = $param
   RETURN f.title, p.content, t.name;
MATCH (p:Person)-[:LIKES]->(c:Comment)-[:HAS_TAG]->(t:Tag)
   WHERE c.creationDate > $param AND t.name = $param
   RETURN p.firstName, p.lastName, c.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(pl:Place)
   WHERE friend.gender = $param AND pl.name = $param
   RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, u.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(place:Place) WHERE p.firstName = $param AND c.name = $param RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, c.name, place.name;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)-[:IS_SUBCLASS_OF]->(parentTagClass:TagClass) WHERE tagClass.name = $param RETURN post.content, tag.name, parentTagClass.name;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(message:Message)-[:HAS_CREATOR]->(creator:Person) WHERE person.gender = $param AND creator.birthday < $param RETURN person.firstName, person.lastName, message.content, creator.firstName, creator.lastName;
MATCH (person:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country) WHERE uni.name = $param AND country.name = $param RETURN person.firstName, person.lastName, city.name;
MATCH (comment:Comment)-[:REPLY_OF]->(message:Message)-[:HAS_CREATOR]->(creator:Person) WHERE comment.creationDate > $param RETURN comment.content, message.content, creator.firstName, creator.lastName;
MATCH (person:Person)-[:LIKES]->(post:Post)-[:HAS_CREATOR]->(creator:Person)-[:WORK_AT]->(company:Company) WHERE person.birthday > $param AND company.name = $param RETURN person.firstName, person.lastName, post.content, creator.firstName, creator.lastName, company.name;
MATCH (forum:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass) WHERE forum.creationDate < $param AND tagClass.name = $param RETURN forum.title, post.content, tag.name;
MATCH (person:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(country:Country) WHERE person.speaks CONTAINS $param AND country.name = $param RETURN person.firstName, person.lastName, org.name, country.name;
MATCH (comment:Comment)-[:REPLY_OF]->(otherComment:Comment)<-[:REPLY_OF]-(otherComment2:Comment)-[:HAS_CREATOR]->(creator:Person) WHERE otherComment2.creationDate > $param RETURN comment.content, otherComment.content, otherComment2.content, creator.firstName, creator.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(c:City)<-[:IS_LOCATED_IN]-(u:University)<-[:STUDY_AT]-(student:Person)
WHERE org.name = $param AND c.name = $param
RETURN org.id, org.name, student.id, student.firstName, student.lastName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(pl:Place)<-[:IS_LOCATED_IN]-(msg:Message)
WHERE org.name = $param AND pl.name = $param
RETURN org.id, org.name, msg.id, msg.content, msg.locationIP;
MATCH (tc1:TagClass)-[:IS_SUBCLASS_OF]->(tc2:TagClass)<-[:HAS_TYPE]-(t:Tag)<-[:HAS_TAG]-(msg:Message)
WHERE tc1.name = $param AND msg.length > $param
RETURN tc1.id, tc1.name, msg.id, msg.content, msg.creationDate;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(msg:Message)<-[:REPLY_OF]-(reply:Comment)
WHERE p1.email = $param AND t.name = $param
RETURN p2.id, p2.firstName, p2.lastName, msg.content, reply.content, reply.creationDate;
MATCH (msg:Message)-[:HAS_TAG]->(t:Tag)<-[:HAS_INTEREST]-(p:Person)<-[:KNOWS]-(friend:Person)
WHERE msg.browserUsed = $param AND friend.locationIP = $param
RETURN msg.id, msg.content, t.name, p.id, p.firstName, friend.id, friend.firstName;
MATCH (p:Person)-[:KNOWS]-(friend:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(post:Post)
WHERE p.id = $param AND post.creationDate > $param
RETURN friend.firstName, friend.lastName, post.content;
MATCH (person:Person)-[:KNOWS*2..3]-(friend:Person)-[:WORK_AT]->(company:Company)
WHERE person.locationIP = $param AND company.name = $param
RETURN friend.firstName, friend.lastName, company.name;
MATCH (forum:Forum)-[:HAS_MEMBER]->(member:Person)-[:STUDY_AT]->(university:University)-[:IS_LOCATED_IN]->(city:City)
WHERE forum.title = $param AND member.birthday < $param
RETURN member.firstName, member.lastName, university.name, city.name;
MATCH (company:Company)<-[:WORK_AT]-(employee:Person)-[:HAS_INTEREST]->(tag:Tag)
WHERE company.id = $param AND tag.name = $param
RETURN employee.firstName, employee.lastName, tag.name;
MATCH (person:Person)-[:LIKES]->(post:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MODERATOR]->(moderator:Person)
WHERE forum.title = $param AND post.locationIP = $param
RETURN person.firstName, person.lastName, moderator.firstName, moderator.lastName;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(o:Organisation)
WHERE p.browserUsed = $param AND place.name = $param
RETURN p.firstName, p.lastName, m.content, o.name;
MATCH (person:Person)-[:STUDY_AT]->(university:University)-[:IS_LOCATED_IN]->(city:City) 
WHERE person.gender = $param AND city.name = $param 
RETURN person.firstName, person.lastName, university.name;
MATCH (person:Person)-[:KNOWS*3..5]-(acquaintance:Person)<-[:HAS_CREATOR]-(msg:Message) 
WHERE acquaintance.birthday > $param AND msg.locationIP = $param 
RETURN acquaintance.firstName, acquaintance.lastName, msg.id, msg.content;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(ci:City)-[:IS_PART_OF]->(co:Country)
WHERE p.locationIP = $param AND co.name = $param
RETURN u.name, ci.name, p.lastName;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:KNOWS]-(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE f.title = $param AND m.content CONTAINS $param
RETURN p.id, friend.firstName, m.creationDate;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE c.browserUsed = $param AND tc.name = $param
RETURN c.id, c.content, m.id, t.name;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(m:Message)<-[:REPLY_OF]-(reply:Comment)
WHERE p.gender = $param AND reply.locationIP = $param
RETURN f.title, m.id, reply.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(place:Place)-[:IS_PART_OF]->(continent:Continent {name: $param})
RETURN p.firstName, p.lastName, m.id, place.name, continent.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag {name: $param})
RETURN p.firstName, p.lastName, msg.id, post.id, tag.name;
MATCH (p:Person)<-[:HAS_MEMBER]-(forum:Forum)-[:HAS_MODERATOR]->(moderator:Person {firstName: $param})
RETURN p.firstName, p.lastName, forum.title, moderator.firstName, moderator.lastName;
MATCH (p:Person)-[:KNOWS]-(friend:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(co:Country)
WHERE p.firstName = $param AND co.name = $param
RETURN friend.firstName, friend.lastName, org.name, c.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE p.birthday < $param AND country.name = $param
RETURN p.firstName, p.lastName, u.name, city.name, country.name;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE t.name = $param AND p.gender = $param
RETURN p.firstName, p.lastName, m.content, tc.name;
MATCH (m:Message)-[:REPLY_OF*2]-(originalMsg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE m.locationIP = $param AND creator.speaks CONTAINS $param
RETURN m.content, originalMsg.content, creator.firstName, creator.lastName;
MATCH (person:Person)<-[:HAS_MEMBER]-(f:Forum)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE person.browserUsed = $param AND tc.name = $param
RETURN f.title, person.firstName, person.lastName, tag.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE f.creationDate > datetime($param) AND m.length > $param
RETURN f.title, p.firstName, p2.firstName, m.content;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(cmt:Comment)-[:REPLY_OF]->(:Post)-[:HAS_CREATOR]->(p3:Person)
WHERE p1.gender = $param AND p3.gender = $param
RETURN p1.firstName, p2.firstName, cmt.content, p3.firstName;
MATCH (p:Person)-[:WORK_AT]->(:Organisation)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE continent.name = $param AND p.birthday < datetime($param)
RETURN p.firstName, p.lastName, country.name, continent.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE p.firstName = $param AND friend.gender = $param
RETURN friend.id, friend.firstName, msg.content;
MATCH (f:Forum)-[:HAS_MEMBER]->(member:Person)<-[:HAS_CREATOR]-(msg:Message)<-[:CONTAINER_OF]-(f2:Forum)
WHERE f.creationDate < $param AND f2.title = $param
RETURN f.id, f.title, member.firstName, msg.content, f2.id, f2.title;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(tag:Tag)<-[:HAS_TAG]-(relatedMsg:Message)
WHERE p.email CONTAINS $param
RETURN p.id, p.firstName, msg.content, tag.name, relatedMsg.content;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE p1.gender = $param AND tagClass.name = $param
RETURN p1.id, p1.firstName, p2.id, p2.firstName, tag.name, tagClass.name;
MATCH (p:Person)-[:HAS_INTEREST]->(:Tag)<-[:HAS_TAG]-(m:Message)-[:REPLY_OF]->(orig:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE p.birthday < $param AND creator.birthday > $param
RETURN p.id, p.firstName, p.lastName, m.id, orig.id, creator.id, creator.firstName, creator.lastName;
MATCH (org:Organisation)<-[:WORK_AT]-(p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE org.name = $param AND msg.length > $param
RETURN org.id, org.name, p.id, p.firstName, friend.id, friend.firstName, friend.lastName, msg.id, msg.content;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE p.speaks CONTAINS $param AND tag.name = $param
RETURN p.id, p.firstName, p.lastName, f.id, f.title, post.id, post.content, tag.id, tag.name;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.browserUsed = $param AND tc.name = $param
RETURN p.id, p.firstName, p.lastName, msg.id, msg.content, tag.id, tag.name, tc.id, tc.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p1.birthday > $param AND tc.name = $param
RETURN p1.id, p1.firstName, p1.lastName, p2.id, p2.firstName, p2.lastName, post.id, post.content, tc.id, tc.name;
MATCH (p1:Person)-[:LIKES]->(cmt:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_CREATOR]->(p2:Person)
WHERE p1.gender = $param AND p2.locationIP = $param
RETURN p1.id, p1.firstName, cmt.content, msg.content, p2.id, p2.firstName;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(pl:Place)<-[:IS_LOCATED_IN]-(msg:Message)-[:HAS_CREATOR]->(p:Person)
WHERE org.name = $param AND msg.length > $param
RETURN org.id, org.name, pl.name, msg.content, p.firstName, p.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(post:Post)<-[:CONTAINER_OF]-(forum:Forum)
WHERE p.speaks = $param AND forum.creationDate > $param
RETURN p.id, p.firstName, t.name, post.content, forum.title;
MATCH (comment:Comment)-[:REPLY_OF*]->(post:Post)-[:HAS_CREATOR]->(person:Person)
WHERE comment.creationDate > $param AND person.speaks CONTAINS $param
RETURN comment.content, post.content, person.firstName, person.lastName;
MATCH (person:Person)-[:STUDY_AT]->(univ:University)-[:IS_LOCATED_IN]->(:City {name: $param})
WHERE person.browserUsed = $param
RETURN person.firstName, person.lastName, univ.name;
MATCH (person:Person)-[:KNOWS*2..3]-(other:Person)<-[:HAS_MODERATOR]-(forum:Forum)
WHERE other.gender = $param AND forum.title CONTAINS $param
RETURN person.firstName, person.lastName, forum.title;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE p.firstName = $param AND tagClass.name = $param
RETURN friend.firstName, post.content, tag.name;
MATCH (p:Person)-[:KNOWS]-(f:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.firstName = $param AND t.name = $param
RETURN f.id, f.firstName, f.lastName, m.id, m.content, t.id, t.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.title = $param AND tc.name = $param
RETURN f.id, f.title, post.id, post.content, t.id, t.name, tc.id, tc.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE c.name = $param AND continent.name = $param
RETURN p.id, p.firstName, p.lastName, c.id, c.name, country.id, country.name, continent.id, continent.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.speaks = $param AND tc.name = $param
RETURN p.id, p.firstName, p.lastName, msg.id, msg.content, t.id, t.name, tc.id, tc.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(tag:Tag)
WHERE p.firstName = $param AND tag.name = $param
RETURN friend.firstName, friend.lastName, msg.content, tag.name;
MATCH (c:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_CREATOR]->(p:Person)-[:KNOWS]->(friend:Person)
WHERE c.creationDate > $param AND p.gender = $param
RETURN c.content, msg.content, p.firstName, friend.firstName;
MATCH (p:Person)<-[:HAS_CREATOR]-(post:Post)<-[:CONTAINER_OF]-(f:Forum)-[:HAS_MEMBER]->(member:Person)
WHERE post.length > $param AND member.email = $param
RETURN p.firstName, post.content, f.title, member.email;
MATCH (c:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_CREATOR]->(p:Person)
WHERE c.locationIP = $param AND msg.length > $param
RETURN c.content, msg.content, p.firstName, p.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p.firstName = $param AND friend.birthday < $param
RETURN friend.firstName, m.content, m.creationDate;
MATCH (p:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE p.browserUsed CONTAINS $param AND t.name = $param
RETURN p.firstName, p.lastName, post.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.firstName = $param AND friend.gender = $param
RETURN friend.id, friend.firstName, msg.content, t.name;
MATCH (c:Comment)-[:REPLY_OF*1..3]->(m:Message)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(city:City)
WHERE m.creationDate > $param AND city.name = $param
RETURN c.id, c.content, p.firstName, p.lastName;
MATCH (forum:Forum)-[:CONTAINER_OF]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)-[:STUDY_AT]->(uni:University)
WHERE forum.creationDate > $param AND uni.name = $param
RETURN forum.id, forum.title, msg.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.email = $param AND creator.locationIP = $param
RETURN p.id, p.firstName, tag.name, msg.content, creator.firstName, creator.lastName;
MATCH (org:Organisation)<-[:WORK_AT]-(person:Person)-[:KNOWS*1..2]-(friend:Person)<-[:HAS_CREATOR]-(c:Comment)
WHERE org.name = $param AND c.creationDate < $param
RETURN org.id, org.name, person.firstName, friend.firstName, c.content;
MATCH (m:Message)<-[:REPLY_OF]-(c:Comment)-[:HAS_CREATOR]->(p:Person)
WHERE m.creationDate < $param AND p.gender = $param
RETURN m.id, m.content, c.id, c.content, p.firstName, p.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(t:Tag) 
WHERE p.firstName = $param AND friend.gender = $param 
RETURN msg.content, msg.creationDate, t.name;
MATCH (forum:Forum)-[:HAS_MEMBER]->(p:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE forum.title = $param AND post.creationDate > $param 
RETURN forum.title, p.firstName, p.lastName, post.content, tag.name;
MATCH (person:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(tag:Tag)<-[:HAS_TAG]-(otherMsg:Message)
WHERE person.locationIP = $param 
RETURN person.firstName, person.lastName, msg.content, otherMsg.content, tag.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_PART_OF]-(country:Country)
WHERE p.speaks = $param AND msg.browserUsed = $param 
RETURN p.firstName, p.lastName, msg.content, place.name, country.name;
MATCH (p:Person)-[:KNOWS*2..3]-(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.locationIP = $param AND t.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, m.content;
MATCH (c:Comment)-[:REPLY_OF*2]->(orig:Message)-[:HAS_CREATOR]->(p:Person)
WHERE c.creationDate > $param AND p.speaks = $param
RETURN c.content, orig.content, p.firstName, p.lastName;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.birthday < $param AND creator.firstName = $param
RETURN p.firstName, p.lastName, u.name, place.name, m.content;
MATCH (co:Country)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:WORK_AT]-(p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE t.name = $param AND p.gender = $param
RETURN co.name, org.name, p.firstName, p.lastName, m.content;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_CREATOR]->(creator:Person)-[:KNOWS]->(friend:Person)
WHERE m.creationDate > $param AND friend.locationIP = $param
RETURN p.firstName, p.lastName, m.content, creator.firstName, creator.lastName;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE f.title = $param AND t.name = $param
RETURN p.firstName, p.lastName, f.title, m.content;
MATCH (p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE p.speaks = $param AND country.name = $param
RETURN p.firstName, p.lastName, uni.name, city.name, country.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE m.creationDate > $param AND t.name = $param
RETURN f.title, f.creationDate, p.firstName, p.lastName, m.content, t.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE m.creationDate < $param AND tc.name = $param
RETURN p.firstName, p.lastName, m.content, t.name, tc.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)-[:LIKES]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p1.locationIP = $param AND creator.birthday < $param
RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, msg.content;
MATCH (u:University)<-[:STUDY_AT]-(p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE u.name = $param AND t.name = $param
RETURN p.firstName, u.name, m.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(post:Post)<-[:CONTAINER_OF]-(forum:Forum)
WHERE p.speaks = $param AND forum.creationDate < date($param)
RETURN p.firstName, friend.firstName, post.content, forum.title;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(post:Post)
WHERE p.birthday < $param AND friend.gender = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, post.id, post.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND m.browserUsed CONTAINS $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, m.id, m.content, t.name, tc.name;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE f.title = $param AND post.locationIP = $param
RETURN p.firstName, p.lastName, f.title, post.id, post.content, t.name;
MATCH (m:Message)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE m.creationDate > $param AND country.name = $param
RETURN m.content, p.firstName, p.lastName, city.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE m.creationDate > $param AND t.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, m.content;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE f.title = $param AND p.gender = $param
RETURN p.firstName, p.lastName, f.title, m.content, t.name;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND p.locationIP = $param
RETURN p.firstName, p.lastName, m.content, t.name, tc.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.title CONTAINS $param AND tc.name = $param
RETURN f.title, p.content, t.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(ci:City)-[:IS_PART_OF]->(co:Country)
WHERE p.speaks = $param AND ci.name = $param
RETURN p.firstName, u.name, ci.name, co.name;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)-[:IS_SUBCLASS_OF]->(tc2:TagClass)
WHERE m.browserUsed CONTAINS $param AND tc2.name = $param
RETURN m.content, t.name, tc.name, tc2.name;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:CONTAINER_OF]->(m:Message)<-[:REPLY_OF]-(c:Comment)
WHERE f.creationDate > $param AND c.length < $param
RETURN p.firstName, f.title, m.content, c.content;
MATCH (p:Person)-[:LIKES]->(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.birthday > $param AND t.name = $param
RETURN p.firstName, m.content, t.name, tc.name;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE f.title STARTS WITH $param AND post.creationDate < $param
RETURN p.firstName, f.title, post.content, t.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.firstName = $param AND tc.name = $param
RETURN p.firstName, p.lastName, m.content, t.name, tc.name;
MATCH (p:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE p.email = $param AND m.creationDate < $param
RETURN p.firstName, p.lastName, c.content, m.content, creator.firstName, creator.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.browserUsed = $param AND t.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, m.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p.locationIP = $param AND friend.gender = $param
RETURN friend.firstName, friend.lastName, m.content, m.creationDate;
MATCH (u:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE u.name = $param AND country.name = $param
RETURN u.id, u.name, city.name, country.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)
WHERE p.speaks = $param AND city.name = $param
RETURN p.firstName, p.lastName, u.name, city.name;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)
WHERE p.gender = $param AND c.name = $param
RETURN p.firstName, p.lastName, c.name, country.name;
MATCH (p:Person)-[:KNOWS*2]-(friend:Person)<-[:HAS_CREATOR]-(c:Comment)
WHERE p.birthday < $param AND c.creationDate > $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, c.content;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(c:City)<-[:IS_LOCATED_IN]-(p:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE org.name = $param AND p.gender = $param
RETURN org.name, c.name, p.firstName, p.lastName, m.content;
MATCH (p1:Person)-[:LIKES]->(m:Message)-[:HAS_CREATOR]->(p2:Person)-[:WORK_AT]->(comp:Company)
WHERE p1.speaks = $param AND comp.name = $param
RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, m.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF*2]->(original:Post)-[:HAS_TAG]->(t:Tag)
WHERE p.birthday > $param AND t.name = $param
RETURN p.firstName, p.lastName, original.content, c.content;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:CONTAINER_OF]->(m:Message)
WHERE f.title = $param AND m.length < $param
RETURN p.firstName, p.lastName, m.content, f.title;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE friend.locationIP = $param AND t.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, m.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:REPLY_OF]->(original:Comment)-[:HAS_CREATOR]->(creator:Person)
WHERE m.creationDate > $param AND creator.email = $param
RETURN p.firstName, p.lastName, m.content, original.content;
MATCH (person:Person)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF]->(p:Post)<-[:CONTAINER_OF]-(f:Forum)
WHERE person.email ENDS WITH $param AND f.title = $param
RETURN person.firstName, person.lastName, c.content, p.content, f.title;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p1.speaks = $param AND tc.name = $param
RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, m.content, t.name, tc.name;
MATCH (city:City)<-[:IS_LOCATED_IN]-(u:University)<-[:STUDY_AT]-(p:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE p.locationIP = $param AND u.name = $param
RETURN city.name, u.name, p.firstName, p.lastName, post.content, tag.name;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(m:Message)-[:REPLY_OF]->(comment:Comment)-[:HAS_CREATOR]->(creator:Person)
WHERE t.name = $param AND creator.birthday > $param
RETURN p.firstName, p.lastName, t.name, m.content, comment.content, creator.firstName, creator.lastName;
MATCH (person:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(comment:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_TAG]->(tag:Tag)
WHERE person.gender = $param AND tag.name CONTAINS $param
RETURN person.firstName, person.lastName, friend.firstName, friend.lastName, comment.content, msg.content, tag.name;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE c.creationDate > $param 
RETURN c.content, m.content, p.firstName, p.lastName;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p1.locationIP = $param AND p2.browserUsed = $param
RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, m.content;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:HAS_TAG]->(t:Tag)
WHERE p.gender = $param AND t.name = $param
RETURN p.firstName, p.lastName, f.title, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(post:Post)
WHERE friend.birthday > $param AND post.locationIP = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, post.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p.firstName = $param AND m.creationDate > $param
RETURN friend.firstName, m.content;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Post)<-[:REPLY_OF]-(c:Comment)
WHERE f.title = $param AND m.creationDate < $param
RETURN m.title, c.content;
MATCH (org:Company)<-[:WORK_AT]-(person:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(tag:Tag)
WHERE org.name = $param AND tag.name = $param
RETURN person.firstName, person.lastName, msg.content, tag.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message)-[:REPLY_OF]->(c:Comment)
WHERE p1.email = $param AND m.length > $param
RETURN p1.id, p1.firstName, p2.id, p2.firstName, m.id, c.id, c.content;
MATCH (o:Organisation)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE o.name = $param AND continent.name = $param
RETURN o.id, o.name, country.name, continent.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_MEMBER]-(forum:Forum)-[:CONTAINER_OF]->(post:Post)
WHERE p.speaks CONTAINS $param AND forum.title = $param
RETURN p.id, p.firstName, friend.id, friend.firstName, forum.id, forum.title, post.id, post.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:REPLY_OF]->(c:Comment)-[:HAS_CREATOR]->(creator:Person)
WHERE p.locationIP = $param AND creator.browserUsed = $param
RETURN p.id, p.firstName, msg.id, msg.content, c.id, creator.id, creator.firstName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.firstName = $param AND t.name = $param
RETURN friend.firstName, friend.lastName, m.content, t.name;
MATCH (c:City)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:WORK_AT]-(p:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE c.name = $param AND p.gender = $param
RETURN org.name, p.firstName, p.lastName, msg.content;
MATCH (u:University)<-[:STUDY_AT]-(p:Person)-[:HAS_INTEREST]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE u.name = $param AND tc.name = $param
RETURN p.firstName, p.lastName, t.name, tc.name;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE post.length > $param AND tagClass.name = $param
RETURN post.content, tag.name, tagClass.name;
MATCH (person:Person)-[:LIKES]->(post:Post)<-[:REPLY_OF]-(comment:Comment)-[:HAS_CREATOR]->(commenter:Person)
WHERE person.locationIP = $param AND commenter.birthday > $param
RETURN person.firstName, post.content, commenter.firstName, commenter.lastName;
MATCH (c:Country)<-[:IS_LOCATED_IN]-(msg:Message)-[:HAS_CREATOR]->(person:Person)-[:WORK_AT]->(company:Company)
WHERE c.name = $param AND company.name = $param
RETURN msg.content, person.firstName, person.lastName, company.name;
MATCH (forum:Forum)-[:HAS_MEMBER]->(person:Person)-[:KNOWS]->(friend:Person)<-[:HAS_MODERATOR]-(moderatedForum:Forum)
WHERE forum.title = $param AND moderatedForum.title = $param
RETURN person.firstName, friend.firstName, forum.title, moderatedForum.title;
MATCH (m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE m.creationDate > $param AND tc.name = $param
RETURN m.content, m.creationDate, t.name, tc.name;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(country:Country)
WHERE org.name = $param AND country.name = $param
RETURN org.name, c.name, country.name;
MATCH (c:Comment)-[:REPLY_OF*1..2]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE c.creationDate < $param AND creator.email ENDS WITH $param
RETURN c.content, msg.content, creator.firstName, creator.lastName;
MATCH (p1:Person)-[:LIKES]->(msg:Message)-[:HAS_CREATOR]->(p2:Person)
WHERE p1.gender = $param AND p2.birthday > $param
RETURN p1.firstName, p1.lastName, msg.content, p2.firstName, p2.lastName;
MATCH (p:Person)-[:KNOWS*1..2]-(:Person)<-[:HAS_CREATOR]-(msg:Message)-[:IS_LOCATED_IN]->(place:Place)
WHERE p.browserUsed = $param AND place.name = $param
RETURN p.firstName, p.lastName, msg.content, place.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE p.birthday < $param AND country.name = $param
RETURN p.firstName, p.lastName, u.name, city.name, country.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_PART_OF]-(country:Country)
WHERE p.email = $param AND country.name = $param
RETURN p.firstName, m.content, place.name, country.name;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(m:Message)<-[:REPLY_OF]-(c:Comment)
WHERE p.browserUsed = $param AND f.creationDate > $param
RETURN p.firstName, f.title, m.content, c.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)<-[:HAS_TAG]-(f:Forum)
WHERE p.gender = $param AND f.title = $param
RETURN p.firstName, m.content, t.name, f.title;
MATCH (p:Person)-[:HAS_CREATOR]-(m:Message)-[:REPLY_OF*1..3]->(original:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.birthday < $param AND tc.name = $param
RETURN p.id, p.firstName, p.lastName, m.id, m.content, original.id, original.content, t.name, tc.name;
MATCH (c1:City)<-[:IS_LOCATED_IN]-(o:Organisation)-[:IS_LOCATED_IN]->(c2:City)<-[:IS_LOCATED_IN]-(p:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE c1.name = $param AND c2.name = $param AND m.creationDate > $param
RETURN c1.id, c1.name, o.id, o.name, c2.id, c2.name, p.id, p.firstName, p.lastName, m.id, m.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)<-[:CONTAINER_OF]-(f:Forum)-[:HAS_MODERATOR]->(mod:Person)
WHERE m.locationIP = $param AND f.title = $param
RETURN p.id, p.firstName, p.lastName, m.id, m.content, f.id, f.title, mod.id, mod.firstName, mod.lastName;
MATCH (p:Person)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF*1..2]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)-[:KNOWS]->(p)
WHERE c.creationDate > $param AND creator.locationIP = $param
RETURN p.id, p.firstName, p.lastName, c.id, c.content, msg.id, msg.content, creator.id, creator.firstName, creator.lastName;
MATCH (p:Person)-[:KNOWS*2]-(friend:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE msg.browserUsed = $param AND tc.name = $param
RETURN friend.firstName, friend.lastName, msg.content;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.creationDate > $param AND tc.name = $param
RETURN post.id, post.content, tag.name;
MATCH (u:University)<-[:STUDY_AT]-(p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(t:Tag)
WHERE u.name = $param AND t.name = $param
RETURN msg.id, msg.content, msg.creationDate;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:HAS_MODERATOR]->(moderator:Person)
WHERE p.birthday < $param AND moderator.gender = $param
RETURN f.id, f.title, moderator.firstName, moderator.lastName;
MATCH (msg:Message)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(p:Person)
WHERE msg.browserUsed = $param AND post.creationDate > $param
RETURN post.id, post.content, p.firstName, p.lastName;
MATCH (p:Person)-[:KNOWS*1..3]-(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag) 
WHERE p.firstName = $param AND t.name = $param 
RETURN friend.firstName, friend.lastName, m.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(post:Post)<-[:CONTAINER_OF]-(forum:Forum) 
WHERE p.gender = $param AND forum.title = $param 
RETURN p.firstName, p.lastName, post.content, forum.title;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:REPLY_OF*1..2]->(orig:Post)
WHERE f.title = $param AND orig.creationDate > $param
RETURN p.firstName, p.lastName, msg.content, orig.content;
MATCH (c:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(:City)-[:IS_PART_OF]->(country:Country)
WHERE post.title = $param AND country.name = $param
RETURN c.content, post.content, p.firstName, p.lastName;
MATCH (p:Person)<-[:HAS_CREATOR]-(comment:Comment)-[:REPLY_OF]->(msg:Message)<-[:CONTAINER_OF]-(f:Forum)-[:HAS_TAG]->(:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND msg.creationDate < $param
RETURN p.firstName, p.lastName, comment.content, f.title;
MATCH (person:Person)<-[:HAS_CREATOR]-(msg:Message)-[:IS_LOCATED_IN]->(place:Place)<-[:IS_LOCATED_IN]-(org:Organisation)
WHERE person.birthday < $param AND org.name = $param
RETURN person.firstName, person.lastName, msg.content, place.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND m.creationDate > $param
RETURN p.firstName, m.content, t.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:IS_LOCATED_IN]->(c:Country)
WHERE p.speaks = $param AND c.name = $param
RETURN p.firstName, msg.content, c.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.firstName = $param AND tc.name = $param
RETURN p.firstName, p.lastName, m.content, t.name, tc.name;
MATCH (u:University)-[:IS_LOCATED_IN]->(c:City)<-[:IS_LOCATED_IN]-(p:Person)<-[:HAS_CREATOR]-(post:Post)
WHERE u.name = $param AND post.creationDate < datetime($param)
RETURN u.name, c.name, p.firstName, post.content;
MATCH (p:Person)-[:KNOWS*2..3]-(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p.firstName = $param AND friend.speaks = $param
RETURN m.id, m.content, m.creationDate;
MATCH (f:Forum)-[:CONTAINER_OF]->(post:Post)<-[:REPLY_OF]-(comment:Comment)<-[:LIKES]-(p:Person)
WHERE f.title = $param AND post.creationDate < $param
RETURN f.id, post.id, comment.id, p.firstName, p.lastName;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE tagClass.name = $param AND person.birthday > $param
RETURN person.firstName, person.lastName, tag.name;
MATCH (message:Message)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE message.length = $param AND continent.name = $param
RETURN message.id, message.content, country.name, continent.name;
MATCH (comment:Comment)-[:REPLY_OF*]->(post:Post)-[:HAS_CREATOR]->(author:Person)-[:LIKES]->(:Comment)-[:HAS_CREATOR]->(anotherPerson:Person) 
WHERE anotherPerson.gender = $param AND post.creationDate > $param 
RETURN comment.id, comment.content, post.id, post.content, author.firstName, author.lastName, anotherPerson.firstName, anotherPerson.lastName;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(msg:Message)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MEMBER]->(member:Person) 
WHERE forum.title STARTS WITH $param AND member.email ENDS WITH $param 
RETURN person.firstName, person.lastName, tag.name, msg.content, forum.title, member.firstName, member.lastName;
MATCH (msg:Message)-[:HAS_CREATOR]->(person:Person)-[:STUDY_AT]->(:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country) 
WHERE msg.length < $param AND country.name = $param 
RETURN msg.id, msg.content, person.firstName, person.lastName, city.name, country.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE t.name = $param AND m.creationDate > $param
RETURN p.id, p.firstName, p.lastName, m.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(pl:Place)
WHERE m.browserUsed = $param AND pl.name = $param
RETURN m.id, m.content, m.creationDate;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)<-[:REPLY_OF]-(c:Comment)-[:HAS_TAG]->(t:Tag)
   WHERE m.length > $param AND t.name = $param
   RETURN p.firstName, p.lastName, m.content, c.content, t.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF]->(m:Message)<-[:CONTAINER_OF]-(f:Forum)
   WHERE p.browserUsed = $param AND f.title CONTAINS $param
   RETURN p.firstName, p.lastName, c.content, m.content, f.title;
MATCH (c:Comment)-[:REPLY_OF*1..3]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE p.birthday > $param AND c.creationDate < $param
RETURN c.content, c.creationDate, p.firstName, p.lastName;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE org.name = $param AND continent.name = $param
RETURN p.firstName, p.lastName, org.name, country.name;
MATCH (p1:Person)-[:KNOWS]-(p2:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(t:Tag)
WHERE p1.speaks CONTAINS $param AND t.name = $param
RETURN p1.firstName, p2.firstName, msg.content, t.name;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
   WHERE org.name = $param AND country.name = $param
   RETURN org.id, org.name, city.name, continent.name;
MATCH (forum:Forum)-[:HAS_MEMBER]->(p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(cmt:Comment)
   WHERE forum.title = $param AND cmt.creationDate > date($param)
   RETURN forum.id, forum.title, p.firstName, p.lastName, friend.firstName, friend.lastName, cmt.content;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(ct:Country)-[:IS_PART_OF]->(co:Continent) 
WHERE co.name = $param AND p.birthday > $param 
RETURN p.firstName, p.lastName, c.name, ct.name, co.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)<-[:REPLY_OF]-(c:Comment)-[:HAS_TAG]->(t:Tag) 
WHERE t.name = $param AND m.creationDate > $param 
RETURN p.firstName, p.lastName, m.content, c.content, t.name;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message) 
WHERE f.title = $param AND p.speaks CONTAINS $param 
RETURN p.firstName, p.lastName, p2.firstName, p2.lastName, m.content;
MATCH (p:Person)-[:KNOWS]-(friend:Person)<-[:HAS_CREATOR]-(m:Message) WHERE p.gender = $param AND friend.birthday > $param RETURN friend.firstName, friend.lastName, m.content;
MATCH (c:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass) WHERE c.length > $param AND tc.name = $param RETURN post.content, c.content, tag.name;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(m:Message)<-[:REPLY_OF]-(c:Comment) WHERE p.email ENDS WITH $param AND m.creationDate > $param RETURN f.title, m.content, c.content;
MATCH (p:Person)-[:KNOWS]->(f:Person)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF]->(m:Message)
WHERE p.firstName = $param AND f.gender = $param
RETURN p.id, f.firstName, c.content, m.id;
MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(country:Country)
WHERE p.birthday < $param AND o.name = $param
RETURN p.firstName, o.name, country.name;
MATCH (p1:Person)-[:KNOWS*2..3]-(p2:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p1.gender = $param AND m.browserUsed = $param
RETURN p1.firstName, p2.lastName, m.content;
MATCH (message:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF*1..2]-(superTagClass:TagClass)
WHERE message.locationIP = $param AND tagClass.name = $param
RETURN message.id, tag.name, superTagClass.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $param}) 
RETURN p.firstName, p.lastName, post.content, tag.name;
MATCH (message:Message)-[:HAS_CREATOR]->(creator:Person)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country) 
WHERE country.name = $param AND message.length > $param 
RETURN message.content, creator.firstName, creator.lastName, city.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND m.creationDate < datetime($param)
RETURN p.firstName, p.lastName, m.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(pl:Place)-[:IS_PART_OF]->(c:Country)
WHERE c.id = $param AND m.length > $param
RETURN p.firstName, p.lastName, m.content, c.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE m.creationDate > datetime($param) AND friend.email = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, m.content;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(msg:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE f.title = $param AND msg.creationDate > datetime($param)
RETURN p.firstName, p.lastName, t.name, msg.content, f.title;
MATCH (c:City)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:WORK_AT]-(p:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE c.name = $param AND msg.creationDate > $param
RETURN c, org, p, msg;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(country:Country)
WHERE p.birthday < $param AND country.name = $param
RETURN p, u, c, country;
MATCH (t:Tag)<-[:HAS_TAG]-(m:Message)<-[:REPLY_OF]-(c:Comment)-[:HAS_CREATOR]->(p:Person)
WHERE t.name = $param AND p.gender = $param
RETURN t, m, c, p;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE f.title = $param AND m.content CONTAINS $param
RETURN f, p, m, t;
MATCH (c1:Country)<-[:IS_PART_OF]-(c2:City)<-[:IS_LOCATED_IN]-(p:Person)-[:LIKES]->(msg:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE c1.name = $param AND msg.length > $param
RETURN c1, c2, p, msg, f;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)<-[:CONTAINER_OF]-(f:Forum)
WHERE friend.locationIP = $param AND f.creationDate < $param
RETURN p, friend, msg, f;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p2:Person) 
WHERE p.id = $param AND p2.gender = $param 
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, c.content;
MATCH (p:Person)-[:WORK_AT]->(comp:Company)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(cont:Continent) 
WHERE comp.name = $param AND cont.name = $param 
RETURN p.firstName, p.lastName, comp.name, country.name, cont.name;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_CREATOR]->(p:Person)-[:LIKES]->(c:Comment) 
WHERE comment.creationDate > $param AND p.locationIP = $param 
RETURN comment.content, post.content, p.firstName, p.lastName, c.content;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:HAS_MODERATOR]->(mod:Person)-[:KNOWS]->(k:Person) 
WHERE f.creationDate > $param AND k.birthday < $param 
RETURN p.firstName, p.lastName, f.title, mod.firstName, mod.lastName, k.firstName, k.lastName;
MATCH (p:Person)<-[:HAS_CREATOR]-(comment:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_TAG]->(tag:Tag) 
WHERE p.speaks CONTAINS $param AND tag.name = $param 
RETURN p.firstName, p.lastName, comment.content, msg.content, tag.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
   WHERE p.firstName = $param AND tc.name = $param
   RETURN post.content, post.creationDate;
MATCH (p:Person)-[:HAS_INTEREST]->(t:Tag)<-[:HAS_TAG]-(post:Post)<-[:CONTAINER_OF]-(forum:Forum)
   WHERE p.gender = $param AND forum.creationDate > $param
   RETURN forum.title, post.content;
MATCH (p:Person)-[:LIKES]->(post:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MEMBER]->(member:Person)<-[:HAS_CREATOR]-(comment:Comment)
   WHERE p.gender = $param AND forum.title = $param
   RETURN member.firstName, member.lastName, comment.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:REPLY_OF]->(com:Comment)-[:HAS_CREATOR]->(creator:Person)-[:STUDY_AT]->(uni:University)
   WHERE p.speaks = $param AND uni.name = $param
   RETURN com.content, creator.firstName, creator.lastName;
MATCH (post:Post)-[:HAS_TAG]->(t:Tag)<-[:HAS_INTEREST]-(person:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(comment:Comment)
   WHERE t.name = $param AND comment.length > $param
   RETURN comment.content, friend.firstName, friend.lastName;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:REPLY_OF]->(orig:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_TAG]->(tag:Tag)
    WHERE p.birthday > $param AND tag.name = $param
    RETURN orig.content, forum.title, msg.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message) WHERE p.id = $param AND m.creationDate > $param RETURN friend.firstName, friend.lastName, m.content, m.creationDate;
MATCH (p:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p.firstName = $param AND p2.gender = $param
RETURN p2.id, p2.firstName, m.content;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE p.birthday < $param AND tc.name = $param
RETURN p.id, p.firstName, f.id, f.title, t.name;
MATCH (p:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE p2.speaks CONTAINS $param AND tag.name = $param
RETURN p.id, p.firstName, p2.id, p2.firstName, post.id, post.content;
MATCH (post:Post)<-[:REPLY_OF]-(c:Comment)-[:HAS_CREATOR]->(p:Person)-[:IS_LOCATED_IN]->(place:Place)
WHERE post.length > $param AND place.name = $param
RETURN post.id, post.content, c.id, c.content, p.id, p.firstName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE p.id = $param AND msg.creationDate > $param
RETURN friend.firstName, friend.lastName, msg.content, msg.creationDate;
MATCH (org:Organisation)<-[:WORK_AT]-(person:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE org.name = $param AND msg.browserUsed = $param
RETURN person.firstName, person.lastName, msg.content, msg.creationDate;
MATCH (city:City)<-[:IS_LOCATED_IN]-(org:Organisation)<-[:WORK_AT]-(employee:Person)<-[:HAS_CREATOR]-(comment:Comment)
WHERE city.name = $param AND comment.locationIP = $param
RETURN org.name, employee.firstName, employee.lastName, comment.content, comment.creationDate;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE p.firstName = $param AND msg.creationDate > $param
RETURN friend.firstName, friend.lastName, msg.content;
MATCH (person:Person)-[:LIKES]->(post:Post)<-[:CONTAINER_OF]-(forum:Forum)
WHERE person.locationIP = $param AND forum.creationDate < $param
RETURN person.firstName, person.lastName, post.content;
MATCH (comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE comment.browserUsed = $param AND tag.name = $param
RETURN post.title, comment.content, comment.creationDate;
MATCH (person:Person)<-[:HAS_CREATOR]-(msg:Message)-[:IS_LOCATED_IN]->(country:Country)
WHERE person.birthday > $param AND country.name = $param
RETURN person.firstName, person.lastName, msg.content;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(pl:Place) WHERE p1.locationIP = $param AND pl.name = $param RETURN p1.firstName, p2.firstName, m.content, pl.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(co:Country)
WHERE p.speaks CONTAINS $param AND co.name = $param
RETURN p.firstName, p.lastName, m.id, co.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(tag:Tag {name: $param})
WHERE p.gender = $param AND friend.birthday < $param
RETURN p.firstName, p.lastName, msg.content, tag.name;
MATCH (person:Person)-[:LIKES]->(post:Post)<-[:CONTAINER_OF]-(forum:Forum {title: $param})
WHERE person.gender = $param AND post.length > $param
RETURN person.firstName, person.lastName, post.content, forum.title;
MATCH (p:Person)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF*2]->(m:Message)-[:HAS_TAG]->(t:Tag) WHERE p.gender = $param AND t.name = $param RETURN c.id, c.content, c.creationDate;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(co:Country) WHERE co.name = $param AND p.speaks = $param RETURN u.id, u.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(m:Message)<-[:REPLY_OF*2]-(cm:Comment)-[:HAS_CREATOR]->(p:Person) WHERE f.title = $param AND p.birthday < $param RETURN m.id, m.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass) WHERE tc.name = $param AND p.gender = $param RETURN m.id, m.content, m.creationDate;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:REPLY_OF]->(po:Post)-[:HAS_TAG]->(t:Tag) WHERE p.browserUsed = $param AND t.name = $param RETURN m.id, m.content;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:HAS_MODERATOR]->(mp:Person)-[:WORK_AT]->(o:Organisation) WHERE mp.birthday > $param AND f.title = $param RETURN o.id, o.name;
MATCH (p:Person)-[:KNOWS]-(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(tag:Tag)
WHERE p.firstName = $param AND tag.name = $param
RETURN friend.firstName, friend.lastName, msg.content;
MATCH (person:Person)<-[:HAS_CREATOR]-(comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE person.browserUsed = $param AND tag.name = $param
RETURN person.firstName, person.lastName, comment.content, post.content;
MATCH (p:Person)-[:KNOWS*2..3]-(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p.gender = $param 
AND friend.birthday > $param 
RETURN friend.firstName, friend.lastName, m.content, m.creationDate;
MATCH (c:Comment)-[:REPLY_OF*1..3]->(:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE c.creationDate > $param
AND creator.locationIP = $param 
RETURN creator.firstName, creator.lastName, c.content;
MATCH (f:Forum)-[:HAS_MEMBER]->(member:Person)-[:WORK_AT]->(company:Company)-[:IS_LOCATED_IN]->(place:Place)
WHERE f.creationDate < $param 
AND member.gender = $param 
RETURN f.title, member.firstName, member.lastName, company.name, place.name;
MATCH (msg:Message)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE msg.browserUsed = $param 
RETURN msg.content, msg.locationIP, country.name, continent.name;
MATCH (p:Person)-[:KNOWS*1..2]->(friend:Person)<-[:HAS_CREATOR]-(comment:Comment)-[:HAS_TAG]->(tag:Tag)
WHERE p.speaks = $param 
AND tag.name = $param 
RETURN friend.firstName, friend.lastName, comment.content, comment.creationDate;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE creator.gender = $param AND m.creationDate > $param
RETURN p.firstName, p.lastName, m.content;
MATCH (p:Person)-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE tagClass.name = $param AND m.length > $param
RETURN p.firstName, p.lastName, m.content;
MATCH (p:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(m:Message)-[:HAS_CREATOR]->(creator:Person) 
WHERE p.birthday < $param AND tag.name = $param 
RETURN creator.firstName, creator.lastName, m.content;
MATCH (c1:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)<-[:HAS_MEMBER]-(f:Forum) 
WHERE c1.creationDate > $param AND f.title = $param 
RETURN p.firstName, p.lastName, c1.content;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tc:TagClass)<-[:IS_SUBCLASS_OF*1..2]-(parent:TagClass) 
WHERE post.locationIP = $param AND parent.name = $param 
RETURN post.content, post.length, tag.name;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)<-[:IS_PART_OF]-(place:Place) 
WHERE org.name = $param AND place.name = $param 
RETURN org.name, country.name, continent.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(message:Message)-[:HAS_TAG]->(tag:Tag) 
WHERE p1.birthday > $param AND tag.name = $param 
RETURN p2.firstName, p2.lastName, message.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(c:Comment)
WHERE c.length > $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, c.content;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:HAS_MODERATOR]->(moderator:Person)
WHERE moderator.email = $param
RETURN p.firstName, p.lastName, f.title, moderator.firstName, moderator.lastName;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE p.firstName = $param AND msg.creationDate > $param
RETURN msg.id, msg.content, msg.creationDate;
MATCH (p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE p.speaks = $param AND country.name = $param
RETURN city.id, city.name;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE p1.email = $param AND tag.name = $param
RETURN post.id, post.content, post.creationDate;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(:TagClass {name: $param}) WHERE p.gender = $param AND p.birthday < $param RETURN m.id, m.content, m.creationDate;
MATCH (org:Organisation)<-[:WORK_AT]-(p:Person)-[:KNOWS*1..2]-(friend:Person)<-[:HAS_CREATOR]-(post:Post) WHERE post.creationDate > $param AND org.name = $param RETURN friend.id, friend.firstName, friend.lastName;
MATCH (p:Person)-[:LIKES]->(message:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(:TagClass {name: $param}) WHERE message.length > $param RETURN message.id, message.content, message.creationDate;
MATCH (p:Person)-[:KNOWS]-(f:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.gender = $param AND t.name = $param
RETURN p.firstName, p.lastName, f.firstName, f.lastName, m.content, t.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(f:Person)
WHERE p.birthday > $param AND f.birthday < $param
RETURN p.firstName, p.lastName, c.content, f.firstName, f.lastName, m.content;
MATCH (p:Person)-[:KNOWS]-(f:Person)<-[:HAS_MEMBER]-(fo:Forum)-[:CONTAINER_OF]->(m:Message)
WHERE p.gender = $param AND fo.creationDate > $param
RETURN p.firstName, p.lastName, f.firstName, f.lastName, fo.title, m.content;
MATCH (p:Person)-[:KNOWS]-(f:Person)<-[:HAS_MODERATOR]-(fo:Forum)-[:CONTAINER_OF]->(po:Post)
WHERE f.speaks = $param AND po.length < $param
RETURN p.firstName, p.lastName, f.firstName, f.lastName, fo.title, po.content, po.length;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_CREATOR]->(person:Person) 
WHERE f.title = $param AND person.birthday < $param 
RETURN f.title, p.id, person.firstName, person.lastName;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent) 
WHERE p.gender = $param AND continent.name = $param 
RETURN p.firstName, p.lastName, org.name, country.name, continent.name;
MATCH (p:Person)-[:KNOWS]-(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(tag:Tag)
WHERE p.firstName = $param AND tag.name = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, msg.content;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(post:Post)-[:HAS_CREATOR]->(creator:Person)
WHERE person.birthday > $param AND tag.name = $param
RETURN person.firstName, person.lastName, post.content, creator.firstName, creator.lastName;
MATCH (comment:Comment)-[:REPLY_OF*]->(msg:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE comment.creationDate < $param AND msg.locationIP = $param
RETURN comment.content, msg.content, creator.firstName, creator.lastName;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass) 
WHERE msg.length < $param AND tagClass.name = $param 
RETURN p.id, p.firstName, msg.id, msg.content, tag.id, tag.name, tagClass.id, tagClass.name;
MATCH (post:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_TAG]->(tag:Tag) 
WHERE post.locationIP = $param AND tag.name = $param 
RETURN post.id, post.content, forum.id, forum.title, tag.id, tag.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:IS_LOCATED_IN]->(place:Place)-[:IS_PART_OF]->(country:Country) WHERE p.browserUsed = $param AND country.name = $param RETURN p.firstName, p.lastName, msg.content, place.name;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(t:Tag) WHERE p.gender = $param AND t.name = $param RETURN p.firstName, p.lastName, f.title, post.content, t.name;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(c:City)-[:IS_PART_OF]->(country:Country)
WHERE p.birthday < $param AND country.name = $param
RETURN p.firstName, p.lastName, u.name, c.name, country.name;
MATCH (p:Person)-[:LIKES]->(c:Comment)-[:REPLY_OF]->(msg:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.locationIP = $param AND t.name = $param
RETURN p.firstName, p.lastName, c.content, msg.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p.gender = $param AND friend.birthday > $param
RETURN p.firstName, p.lastName, m.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:REPLY_OF]->(post:Post)<-[:CONTAINER_OF]-(f:Forum)
WHERE p.locationIP = $param AND m.browserUsed = $param
RETURN p.firstName, p.lastName, f.title, post.content;
MATCH (p:Person)-[:WORK_AT]->(:Company)-[:IS_LOCATED_IN]->(:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE p.birthday < $param AND continent.name = $param
RETURN p.firstName, p.lastName, continent.name;
MATCH (u:University)<-[:STUDY_AT]-(p:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE u.name = $param AND post.creationDate > $param
RETURN p.firstName, p.lastName, tag.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(:Comment)-[:REPLY_OF]->(m:Message)
WHERE p.email CONTAINS $param AND m.locationIP = $param
RETURN p.firstName, p.lastName, m.content;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE p.browserUsed = $param AND tagClass.name = $param
RETURN p.firstName, p.lastName, msg.content;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)<-[:HAS_CREATOR]-(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE f.title = $param AND post.creationDate < $param
RETURN p.firstName, p.lastName, tag.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.locationIP = $param AND t.name = $param
RETURN p.firstName, p.lastName, m.content, t.name;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(p:Person)
WHERE p.birthday > $param AND m.locationIP = $param
RETURN c.content, p.firstName, p.lastName, m.content;
MATCH (p:Person)-[:STUDY_AT]->(u:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE p.speaks CONTAINS $param AND country.name = $param
RETURN p.firstName, p.lastName, u.name, city.name, country.name;
MATCH (person:Person)<-[:HAS_CREATOR]-(:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag)
WHERE person.gender = $param AND tag.name = $param
RETURN person.firstName, person.lastName, post.content, tag.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(:Tag)-[:HAS_TYPE]->(tagClass:TagClass)
WHERE friend.browserUsed = $param AND tagClass.name = $param
RETURN p.firstName, p.lastName, msg.content, tagClass.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:IS_LOCATED_IN]->(place:Place {name: $param}) RETURN p.firstName, p.lastName, msg.content, place.name;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(tag:Tag {name: $param}) RETURN p.firstName, p.lastName, f.title, post.id;
MATCH (p:Person)-[:LIKES]->(msg:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND p.speaks = $param
RETURN p.firstName, p.lastName, msg.content, t.name;
MATCH (comp:Company)<-[:WORK_AT]-(p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE comp.name = $param AND friend.gender = $param
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, msg.content;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE f.title = $param AND t.name = $param
RETURN p.firstName, p.lastName, post.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(tag:Tag) WHERE p.firstName = $param AND tag.name = $param RETURN friend.id, m.content;
MATCH (org:Organisation)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country) WHERE org.name = $param AND country.name = $param RETURN city.id, city.name;
MATCH (f:Forum)-[:CONTAINER_OF]->(p:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass) WHERE f.title CONTAINS $param AND tagClass.name = $param RETURN p.id, p.content;
MATCH (c:Comment)-[:REPLY_OF]->(m:Message)-[:HAS_CREATOR]->(author:Person)-[:IS_LOCATED_IN]->(place:Place) WHERE c.creationDate > $param AND place.name = $param RETURN m.id, author.firstName;
MATCH (f:Forum)-[:HAS_MODERATOR]->(mod:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(tag:Tag) WHERE mod.gender = $param AND tag.name = $param RETURN m.id, f.title;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(t:Tag {name: $param}) 
WHERE msg.creationDate > $param 
RETURN p.firstName, p.lastName, msg.content, t.name;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent) 
WHERE continent.name = $param 
RETURN p.firstName, p.lastName, org.name, country.name, continent.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_MEMBER]-(f:Forum)-[:HAS_MODERATOR]->(moderator:Person) 
WHERE moderator.gender = $param 
RETURN p.firstName, p.lastName, friend.firstName, friend.lastName, f.title, moderator.firstName, moderator.lastName;
MATCH (p:Person)-[:STUDY_AT]->(uni:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country {name: $param}) 
RETURN p.firstName, p.lastName, uni.name, city.name, country.name;
MATCH (person:Person)<-[:HAS_MEMBER]-(forum:Forum)-[:CONTAINER_OF]->(post:Post)
WHERE person.email = $param AND forum.creationDate < $param
RETURN forum.title, post.id, post.content;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p.firstName = $param AND m.creationDate > datetime($param)
RETURN friend.id, friend.firstName, friend.lastName, m.content, m.creationDate;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass) 
WHERE tc.name = $param AND m.creationDate > $param 
RETURN p.firstName, p.lastName, m.content, t.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(post:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MODERATOR]->(moderator:Person) 
WHERE forum.title = $param AND moderator.email = $param 
RETURN p.firstName, p.lastName, post.content, forum.title;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE p1.firstName = $param AND m.creationDate > $param
RETURN p2.id, p2.firstName, p2.lastName, m.content, m.creationDate;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)
WHERE p.id = $param AND t.name = $param
RETURN m.creationDate, m.content, m.length, t.name;
MATCH (p:Person)<-[:HAS_MODERATOR]-(f:Forum)-[:CONTAINER_OF]->(post:Post)-[:HAS_TAG]->(t:Tag)
WHERE p.speaks CONTAINS $param AND t.name = $param
RETURN p.firstName, p.lastName, f.title, post.content, t.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass {name: $param})
WHERE p.gender = $param AND msg.creationDate > $param
RETURN p.firstName, p.lastName, msg.content, t.name;
MATCH (p:Person)-[:HAS_CREATOR]-(msg:Post)<-[:CONTAINER_OF]-(f:Forum)-[:HAS_MEMBER]->(member:Person)
WHERE f.title = $param AND member.gender = $param
RETURN p.firstName, p.lastName, msg.content, member.firstName, member.lastName;
MATCH (p:Person)-[:WORK_AT]->(c:Company)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE c.name = $param AND continent.name = $param
RETURN p.firstName, p.lastName, c.name, country.name, continent.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Comment)-[:REPLY_OF]->(original:Post)-[:HAS_TAG]->(t:Tag)
WHERE t.name = $param AND msg.creationDate > $param
RETURN p.firstName, p.lastName, msg.content, original.content, t.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)<-[:REPLY_OF]-(reply:Comment)-[:HAS_CREATOR]->(replier:Person)
WHERE replier.gender = $param AND msg.creationDate < $param
RETURN p.firstName, p.lastName, msg.content, reply.content, replier.firstName, replier.lastName;
MATCH (p1:Person)-[:KNOWS]->(p2:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass {name: $param}) WHERE p1.gender = $param AND m.creationDate > $param RETURN p1.firstName, p1.lastName, p2.firstName, p2.lastName, m.content, m.creationDate, tc.name;
MATCH (u:University)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)-[:IS_PART_OF]->(continent:Continent {name: $param}), (p:Person)-[:STUDY_AT]->(u) WHERE p.gender = $param AND p.creationDate > $param RETURN u.name, city.name, country.name, continent.name, p.firstName, p.lastName;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(place:Place)-[:IS_PART_OF]->(country:Country {name: $param}), (m)-[:HAS_TAG]->(tag:Tag) WHERE p.email = $param RETURN p.firstName, p.lastName, m.content, place.name, country.name, tag.name;
MATCH (p:Person)-[:WORK_AT]->(org:Organisation)-[:IS_LOCATED_IN]->(city:City), (p)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message) WHERE city.name = $param AND msg.creationDate > $param RETURN p.firstName, p.lastName, org.name, city.name, friend.firstName, friend.lastName, msg.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(msg:Message)<-[:REPLY_OF]-(reply:Comment)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass {name: $param}) WHERE p.browserUsed = $param RETURN p.firstName, p.lastName, msg.content, reply.content, tag.name, tagClass.name;
MATCH (person:Person)-[:HAS_INTEREST]->(tag:Tag)<-[:HAS_TAG]-(comment:Comment)-[:REPLY_OF]->(post:Post)-[:HAS_TAG]->(relatedTag:Tag)
WHERE tag.name = $param
RETURN person.firstName, person.lastName, comment.content, post.content;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE tc.name = $param AND p.gender = $param
RETURN p.firstName, p.lastName, m.content, t.name;
MATCH (u:University)-[:IS_LOCATED_IN]->(city:City)<-[:IS_LOCATED_IN]-(p:Person)<-[:HAS_CREATOR]-(m:Message)
WHERE u.name = $param AND city.name = $param
RETURN u.name, city.name, p.firstName, p.lastName, m.content;
MATCH (p:Person)-[:WORK_AT]->(o:Organisation)-[:IS_LOCATED_IN]->(country:Country)-[:IS_PART_OF]->(continent:Continent)
WHERE o.name = $param AND continent.name = $param
RETURN p.firstName, p.lastName, o.name, country.name, continent.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
   WHERE p.gender = $param AND tc.name = $param
   RETURN p.firstName, p.lastName, m.content, t.name;
MATCH (p:Person)<-[:HAS_MEMBER]-(f:Forum)-[:HAS_MODERATOR]->(mod:Person)
   WHERE p.email CONTAINS $param AND mod.gender = $param
   RETURN p.firstName, p.lastName, f.title, mod.firstName, mod.lastName;
MATCH (p:Person)<-[:HAS_CREATOR]-(m:Message)-[:IS_LOCATED_IN]->(pl:Place)-[:IS_PART_OF]->(co:Country)
    WHERE m.browserUsed = $param AND co.name = $param
    RETURN p.firstName, p.lastName, m.content, pl.name, co.name;
MATCH (person:Person)<-[:HAS_MODERATOR]-(forum:Forum)-[:CONTAINER_OF]->(message:Message)-[:IS_LOCATED_IN]->(place:Place) WHERE person.gender = $param AND place.name = $param RETURN person.firstName, person.lastName, forum.title, message.content, place.name;
MATCH (p:Person)-[:KNOWS]->(friend:Person)<-[:HAS_CREATOR]-(msg:Message)
WHERE p.firstName = $param AND msg.creationDate > datetime($param)
RETURN friend.id, friend.firstName, friend.lastName, msg.content, msg.creationDate;
MATCH (f:Forum)-[:HAS_MEMBER]->(p:Person)<-[:HAS_CREATOR]-(msg:Message)-[:HAS_TAG]->(t:Tag)-[:HAS_TYPE]->(tc:TagClass)
WHERE f.title = $param AND tc.name = $param
RETURN f.id, f.title, p.id, p.firstName, p.lastName, msg.content, t.name;
MATCH (p:Person)<-[:HAS_CREATOR]-(post:Post)<-[:CONTAINER_OF]-(forum:Forum)-[:HAS_MODERATOR]->(mod:Person)
WHERE p.gender = $param AND forum.creationDate < datetime($param)
RETURN p.id, p.firstName, p.lastName, post.content, forum.title, mod.id, mod.firstName;
MATCH (post:Post)-[:HAS_CREATOR]->(author:Person)-[:IS_LOCATED_IN]->(city:City)-[:IS_PART_OF]->(country:Country)
WHERE post.length > $param AND country.name = $param
RETURN author.firstName, author.lastName, city.name;
MATCH (message:Message)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)-[:IS_SUBCLASS_OF*1..2]->(parentTagClass:TagClass)
WHERE message.browserUsed = $param AND parentTagClass.name = $param
RETURN message.content, tag.name, parentTagClass.name;
MATCH (comment:Comment)-[:REPLY_OF*1..2]-(originalMessage:Message)-[:HAS_CREATOR]->(creator:Person)
WHERE comment.creationDate > $param AND creator.gender = $param
RETURN originalMessage.content, creator.firstName, creator.lastName;
MATCH (post:Post)-[:HAS_TAG]->(tag:Tag)-[:HAS_TYPE]->(tagClass:TagClass)<-[:IS_SUBCLASS_OF*0..1]-(superTagClass:TagClass)
WHERE post.creationDate < $param AND superTagClass.name = $param
RETURN post.content, tag.name, superTagClass.name