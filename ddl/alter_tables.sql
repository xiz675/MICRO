ALTER TABLE person_studyat_university RENAME TO person_studyat_organisation;
ALTER TABLE person_workat_company RENAME TO person_workat_organisation;
ALTER TABLE person_islocatedin_city RENAME TO person_islocatedin_place;
ALTER TABLE forum_containerof_post RENAME TO forum_containerof_message;

CREATE TABLE message (
    id bigint NOT NULL,
    creationDate timestamp with time zone NOT NULL,
    locationIP text NOT NULL,
    browserUsed text NOT NULL,
    content text NOT NULL,
    length bigint NOT NULL,
    type VARCHAR(10) NOT NULL
);

INSERT INTO message (id, creationDate, locationIP, browserUsed, content, length, type)
SELECT id, creationDate, locationIP, browserUsed, content, length, 'Comment' FROM Comment;

INSERT INTO message (id, creationDate, locationIP, browserUsed, content, length, type)
SELECT id, creationDate, locationIP, browserUsed, content, length, 'Post' FROM Post;

CREATE TABLE message_hascreator_person AS
SELECT * FROM comment_hascreator_person
UNION
SELECT * FROM post_hascreator_person;

CREATE TABLE person_likes_message AS
SELECT * FROM person_likes_post
UNION
SELECT * FROM person_likes_comment;

CREATE TABLE  message_hastag_tag AS
SELECT * FROM post_hastag_tag
UNION
SELECT * FROM comment_hastag_tag;

CREATE TABLE message_islocatedin_place AS
SELECT * FROM comment_islocatedin_country
UNION
SELECT * FROM post_islocatedin_country;

CREATE TABLE message_replyof_message AS
SELECT * FROM comment_replyof_comment
UNION
SELECT * FROM comment_replyof_post;



ALTER TABLE "Organisation_10000_0.8" RENAME TO r_organisation;
ALTER TABLE "Place_5000_0.8" RENAME TO r_place;
ALTER TABLE "Tag_50000_0.5" RENAME TO r_tag;
ALTER TABLE "TagClass_1000_0.8" RENAME TO r_tagClass;
ALTER TABLE "Comment_1000000_0.001" RENAME TO r_comment;
ALTER TABLE "Forum_500000_0.05" RENAME TO r_forum;
ALTER TABLE "Person_50000_0.3" RENAME TO r_person;
ALTER TABLE "Post_1000000_0.001" RENAME TO r_post;
ALTER TABLE "Message_1000000_0.001" RENAME TO r_message;
ALTER TABLE "Country_5000_0.8" RENAME TO r_country;
ALTER TABLE "City_5000_0.8" RENAME TO r_city;
ALTER TABLE "Company_10000_0.8" RENAME TO r_company;
ALTER TABLE "University_10000_0.8" RENAME TO r_university;