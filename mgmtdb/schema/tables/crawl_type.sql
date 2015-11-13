--
-- Crawl Site Type Table
--

CREATE TABLE crawl_type (
    id 			    integer   NOT NULL,
    type            text      NOT NULL,
    active          boolean   NOT NULL DEFAULT true,
    data            jsonb,
    notes 		    text,
    crt_on 		    timestamp with time zone DEFAULT now(),

    PRIMARY KEY (id)
);

ALTER TABLE crawl_type OWNER TO whuser;
