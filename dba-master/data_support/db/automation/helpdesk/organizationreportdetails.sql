select count(*) from organizationtreedetail ;

\copy (select * from organizationtreedetail) to 'tmp_organizationtreedetail.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 

drop table if exists tmp_organizationtreedetail;
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

\COPY tmp_organizationtreedetail FROM 'tmp_organizationtreedetail.csv' DELIMITER ',' CSV HEADER ;

select count(*) from tmp_organizationtreedetail ;
begin;
truncate table organizationtreedetail;
INSERT INTO organizationtreedetail(
            schoolid, schoolname, schooldisplayidentifier, districtid, districtname, 
            districtdisplayidentifier, stateid, statename, statedisplayidentifier, 
            createddate)
select  schoolid, schoolname, schooldisplayidentifier, districtid, districtname, 
            districtdisplayidentifier, stateid, statename, statedisplayidentifier, 
            createddate from  tmp_organizationtreedetail;          
commit;
