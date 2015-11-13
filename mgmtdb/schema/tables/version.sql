--
-- Version Table
--

CREATE TABLE version (
    id 			        serial,
    db_version          integer     NOT NULL,
    git_commit          text        NOT NULL,
    server_info         text        NOT NULL,
    install_user        text        NOT NULL,
    crt_on 		        timestamp with time zone,

    PRIMARY KEY(id)
);

--
ALTER TABLE version OWNER TO whuser;
