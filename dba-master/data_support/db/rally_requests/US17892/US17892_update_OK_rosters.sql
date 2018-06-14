--create temporary table to hold rosters
--
CREATE TEMPORARY TABLE temp_ok_rosters (
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
\COPY temp_ok_rosters FROM 'Edited OK_Roster_Extract_03152016.csv' DELIMITER ',' CSV HEADER;

--add column to hold ids
--
ALTER TABLE temp_ok_rosters ADD COLUMN gradecourseid bigint;
ALTER TABLE temp_ok_rosters ADD COLUMN gradecoursecode text;

--update temp rosters with gradecourse id
--
UPDATE temp_ok_rosters tor
SET gradecourseid = gc.id
   ,gradecoursecode=gc.abbreviatedname 
FROM gradecourse gc
WHERE tor.gradecourse = gc.abbreviatedname 
AND course IS TRUE;

--update roster with gradecourseid
--
UPDATE roster r 
SET statecoursesid = tor.gradecourseid
   ,modifieddate = now()
   ,modifieduser = 12
   ,statecoursecode=tor.gradecoursecode
FROM temp_ok_rosters tor
WHERE r.id = tor.rosterid
AND tor.gradecourseid IS NOT NULL;   

--drop temporary table
--
DROP TABLE temp_ok_rosters;
