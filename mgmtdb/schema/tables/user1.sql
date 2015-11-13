--
-- User Table
--

CREATE TABLE user1 (
    id 			uuid      NOT NULL,
    active      boolean   NOT NULL DEFAULT true,
    first_name 	text,
    last_name 	text,
    title 		text,
    email 		text      NOT NULL,
    phone 		text,
    company_id 	uuid,
    notes 		text,
    crt_by_id 	uuid,
    crt_on 		timestamp with time zone DEFAULT now(),

    PRIMARY KEY (id)
);

ALTER TABLE user1 OWNER TO whuser;
