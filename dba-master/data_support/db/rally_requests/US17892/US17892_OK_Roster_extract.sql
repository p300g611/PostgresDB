drop table if exists tmp_list;
SELECT odt.statedisplayidentifier
     , odt.districtdisplayidentifier
     , odt.districtname
     , odt.schooldisplayidentifier     
     , odt.schoolname
     , r.id AS rosterid
     , r.coursesectionname
     , au.uniquecommonidentifier AS educatorid
     , au.firstname
     , au.surname
     , ca.abbreviatedname AS contentarea
     , gc.abbreviatedname AS gradecourse
into temp tmp_list     
FROM roster r
INNER JOIN aartuser au ON (r.teacherid = au.id)
INNER JOIN organizationtreedetail odt ON (r.attendanceschoolid = odt.schoolid)
INNER JOIN contentarea ca ON (r.statesubjectareaid = ca.id)
LEFT JOIN gradecourse gc ON (r.statecoursesid = gc.id)
WHERE r.currentschoolyear=2016
AND r.activeflag IS TRUE    
AND odt.statedisplayidentifier = 'OK';

\COPY (select * from tmp_list) To 'OK_Roster_Extract_03152016.csv' DELIMITER ',' CSV HEADER;

drop table if exists tmp_list;