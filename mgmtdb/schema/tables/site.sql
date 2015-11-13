--
-- Crawl Site Table
--

CREATE TABLE site (
    id 			        uuid      NOT NULL,
    name                text      NOT NULL,
    active              boolean   NOT NULL DEFAULT true,
    crawl_type_id       integer   NOT NULL DEFAULT 1,
    conn_type_id        integer   NOT NULL DEFAULT 1,
    content_type_id     integer[],
    crawl_data          jsonb,
    crt_on 		        timestamp with time zone DEFAULT now(),

    PRIMARY KEY (id)
);

ALTER TABLE site OWNER TO whuser;
