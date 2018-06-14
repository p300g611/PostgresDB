--drop table if exists tmp_organizationtreedetail;
CREATE temp TABLE  tmp_organizationtreedetail
(
  schoolid bigint NOT NULL,
  schoolname character varying(200) NOT NULL,
  schooldisplayidentifier character varying(100) NOT NULL,
  districtid bigint,
  districtname character varying(200),
  districtdisplayidentifier character varying(100),
  stateid bigint,
  statename character varying(200),
  statedisplayidentifier character varying(100),
  createddate timestamp with time zone NOT NULL DEFAULT now()
);

\COPY tmp_organizationtreedetail FROM '/srv/extracts/helpdesk/automation/stage/tmp_organizationtreedetail.csv' DELIMITER ',' CSV HEADER;


begin;
delete from organizationtreedetail;
INSERT INTO organizationtreedetail(
            schoolid, schoolname, schooldisplayidentifier, districtid, districtname, 
            districtdisplayidentifier, stateid, statename, statedisplayidentifier, 
            createddate)
select  schoolid, schoolname, schooldisplayidentifier, districtid, districtname, 
            districtdisplayidentifier, stateid, statename, statedisplayidentifier, 
            createddate from  tmp_organizationtreedetail;          
commit;
