-- static tables
CREATE TABLE Organisation (
    id bigint PRIMARY KEY,
    type text NOT NULL,
    name text NOT NULL
) WITH (storage = paged);

CREATE TABLE Place (
    id bigint PRIMARY KEY,
    name text NOT NULL,
    type text NOT NULL
) WITH (storage = paged);

CREATE TABLE Tag (
    id bigint PRIMARY KEY,
    name text NOT NULL
) WITH (storage = paged);

CREATE TABLE TagClass (
    id bigint PRIMARY KEY,
    name text NOT NULL
) WITH (storage = paged);

-- dynamic tables
CREATE TABLE Comment (
    id bigint NOT NULL,
    creationDate timestamp with time zone NOT NULL,
    locationIP text NOT NULL,
    browserUsed text NOT NULL,
    content text NOT NULL,
    length bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Forum (
    id bigint PRIMARY KEY,
    creationDate timestamp with time zone NOT NULL,
    title text NOT NULL
) WITH (storage = paged);

CREATE TABLE Post (
    id bigint NOT NULL,
    creationDate timestamp with time zone NOT NULL,
    locationIP text NOT NULL,
    browserUsed text NOT NULL,
    content text NOT NULL,
    length bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Person (
    id bigint PRIMARY KEY,
    creationDate timestamp with time zone NOT NULL,
    firstName text NOT NULL,
    lastName text NOT NULL,
    gender text NOT NULL,
    birthday date NOT NULL,
    locationIP text NOT NULL,
    browserUsed text NOT NULL,
    speaks text NOT NULL,
    email text NOT NULL
) WITH (storage = paged);

-- edges
CREATE TABLE Place_isPartOf_Place (
    subreg_id bigint NOT NULL,
    reg_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE TagClass_isSubclassOf_TagClass (
    subtag_id bigint NOT NULL,
    tag_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Organisation_isLocatedIn_Place (
    org_id bigint NOT NULL,
    loc_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Comment_isLocatedIn_Country (
    message_id bigint NOT NULL,
    loc_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Post_isLocatedIn_Country (
    message_id bigint NOT NULL,
    loc_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Person_isLocatedIn_City (
    person_id bigint NOT NULL,
    loc_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Tag_hasType_TagClass (
    tag_id bigint NOT NULL,
    tagclass_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Forum_containerOf_Post (
    forum_id bigint NOT NULL,
    post_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Forum_hasModerator_Person (
    forum_id bigint NOT NULL,
    person_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Comment_hasCreator_Person(
    message_id bigint NOT NULL,
    person_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE  Post_hasCreator_Person(
    message_id bigint NOT NULL,
    person_id bigint NOT NULL
) WITH (storage = paged);


CREATE TABLE Comment_replyOf_Comment(
    message_id bigint NOT NULL,
    replied_message_id bigint NOT NULL
) WITH (storage = paged);


CREATE TABLE Comment_replyOf_Post(
    message_id bigint NOT NULL,
    replied_message_id bigint NOT NULL
) WITH (storage = paged);


CREATE TABLE Comment_hasTag_Tag (
    message_id bigint NOT NULL,
    tag_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Post_hasTag_Tag (
    message_id bigint NOT NULL,
    tag_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Forum_hasMember_Person (
    forum_id bigint NOT NULL,
    person_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Forum_hasTag_Tag (
    forum_id bigint NOT NULL,
    tag_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Person_hasInterest_Tag (
    person_id bigint NOT NULL,
    tag_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Person_likes_Comment (
    person_id bigint NOT NULL,
    message_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Person_likes_Post (
    person_id bigint NOT NULL,
    message_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Person_studyAt_University (
    person_id bigint NOT NULL,
    university_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Person_workAt_Company (
    person_id bigint NOT NULL,
    company_id bigint NOT NULL
) WITH (storage = paged);

CREATE TABLE Person_knows_Person (
    person_id bigint NOT NULL,
    friend_id bigint NOT NULL
) WITH (storage = paged);
