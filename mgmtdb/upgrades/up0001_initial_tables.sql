-- Initial set of tables

-- Cleanup existing tables
DROP TABLE IF EXISTS site;
DROP TABLE IF EXISTS content_type;
DROP TABLE IF EXISTS conn_type;
DROP TABLE IF EXISTS crawl_type;
DROP TABLE IF EXISTS company;
DROP TABLE IF EXISTS user1;

-- Tables
\ir ../schema/tables/user1.sql
\ir ../schema/tables/company.sql
\ir ../schema/tables/crawl_type.sql
\ir ../schema/tables/conn_type.sql
\ir ../schema/tables/content_type.sql
\ir ../schema/tables/site.sql

-- Initial data: crawl_site
INSERT INTO crawl_type (id, active, type) VALUES (1,  true,  'HTML site with robots');
INSERT INTO crawl_type (id, active, type) VALUES (2,  true,  'HTML site without robots');
INSERT INTO crawl_type (id, active, type) VALUES (3,  true,  'Javascript dynamic site');
INSERT INTO crawl_type (id, active, type) VALUES (4,  true,  'Pastebin web service');
INSERT INTO crawl_type (id, active, type) VALUES (5,  false, 'Search site');
INSERT INTO crawl_type (id, active, type) VALUES (6,  false, 'Deep web');
INSERT INTO crawl_type (id, active, type) VALUES (7,  false, 'Websocket stream media');
INSERT INTO crawl_type (id, active, type) VALUES (8,  false, 'Common Crawl Service');
INSERT INTO crawl_type (id, active, type) VALUES (9,  false, 'Local file system');
INSERT INTO crawl_type (id, active, type) VALUES (10, true,  'AWS S3 storage');
INSERT INTO crawl_type (id, active, type) VALUES (11, true,  'FTP server');
INSERT INTO crawl_type (id, active, type) VALUES (12, true,  'Public dataset');

INSERT INTO conn_type (id, active, type) VALUES (1,  true, 'Public web');
INSERT INTO conn_type (id, active, type) VALUES (2,  true, 'Internal network');
INSERT INTO conn_type (id, active, type) VALUES (3,  true, 'Tor netork');

INSERT INTO content_type (id, active, type) VALUES (1,  true, 'Public company web');
INSERT INTO content_type (id, active, type) VALUES (2,  true, 'Anonymous paste sites');
INSERT INTO content_type (id, active, type) VALUES (3,  true, 'News sites');
INSERT INTO content_type (id, active, type) VALUES (4,  true, 'Torrent network');
INSERT INTO content_type (id, active, type) VALUES (5,  true, 'Tor network');
