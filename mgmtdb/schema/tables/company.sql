--
-- Company Table
--

CREATE TABLE company (
    id 			    uuid      NOT NULL,
    name 		    text      NOT NULL,
    active          boolean   NOT NULL DEFAULT true,
    manager_id      uuid      NOT NULL,
    public_info     jsonb,
    product_profile jsonb,
    notes 		    text,
    crt_by_id 	    uuid,
    crt_on 		    timestamp with time zone DEFAULT now(),

    PRIMARY KEY(id)
);

--
ALTER TABLE company OWNER TO whuser;
