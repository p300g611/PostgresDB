--create temporary table to hold rosters
--
CREATE TEMPORARY TABLE temp_ms_rosters (
       statedisplayidentifier  character varying
     , districtdisplayidentifier  character varying
     , districtname  character varying
     , schooldisplayidentifier  character varying    
     , schoolname  character varying
     , rosterid bigint
     , coursesectionname  character varying
     , educatorid character varying
     , firstname  character varying
     , surname  character varying
     , contentarea  character varying
     , gradecourse  character varying
     );

--import csv file
--
\COPY temp_ms_rosters FROM 'MS Roster Updates_03-15-16_Updated.csv' DELIMITER ',' CSV HEADER;

--add column to hold ids
--
ALTER TABLE temp_ms_rosters ADD COLUMN gradecourseid bigint;
ALTER TABLE temp_ms_rosters ADD COLUMN gradecoursecode text;

--update temp rosters with gradecourse id
--
UPDATE temp_ms_rosters mor
SET gradecourseid = gc.id,
    gradecoursecode=gc.abbreviatedname 
FROM gradecourse gc
WHERE mor.gradecourse = gc.abbreviatedname 
AND course IS TRUE;

--update roster with gradecourseid
--
UPDATE roster r 
SET --statecoursesid = mor.gradecourseid
    modifieddate = now()
   ,modifieduser = 12
   ,statecoursecode=mor.gradecoursecode
FROM temp_ms_rosters mor
WHERE r.id = mor.rosterid
AND mor.gradecourseid IS NOT NULL and mor.gradecoursecode is not null and statecoursecode is null;   

--drop temporary table
--
DROP TABLE temp_ms_rosters;