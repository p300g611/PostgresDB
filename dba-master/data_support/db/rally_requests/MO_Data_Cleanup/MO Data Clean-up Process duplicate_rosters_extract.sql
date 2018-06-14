\f ','
\a
\pset expanded off
\o 'MO_dual_rosters_03072016.csv'

WITH dup_roster
 AS 
(       SELECT e.studentid
	      ,r.statesubjectareaid
	      ,r.statecoursesid
	      ,count(*)
	FROM enrollment e
        INNER JOIN student s ON e.studentid = s.id	
	INNER JOIN enrollmentsrosters er ON e.id=er.enrollmentid
	INNER JOIN roster r ON er.rosterid=r.id
	WHERE r.currentschoolyear = 2016
	AND r.activeflag=true 
	AND e.activeflag=true
        AND s.stateid = (SELECT id 
                         FROM   organization 
                         WHERE  displayidentifier = 'MO'
                         AND    organizationtypeid = 2) 	                  
	GROUP BY e.studentid
	        ,r.statesubjectareaid
	        ,r.statecoursesid
	HAVING count(*) > 1 
 )  
SELECT
 s.id as studentid
,s.legallastname 
,s.legalfirstname
,s.statestudentidentifier
,s.stateid
,e.id enrollmentid
,e.currentschoolyear
,e.attendanceschoolid
,o.organizationname as schoolname
,o.displayidentifier as schoolnumber
,po.organizationname as districtname
,er.id as enrollmentsrostersid
,r.id as rosterid
,r.coursesectionname
,r.teacherid
,au.surname as teachersurname
,au.firstname as teacherfirstname
,r.statesubjectareaid
,ca.name as contentareaname
,r.statecoursesid
,gc.name as gradecoursename
,r.createddate as rostercreateddate
,r.attendanceschoolid as rosterattendanceschoolid
,ro.organizationname as rosterschoolname
FROM student s
INNER JOIN enrollment e ON s.id=e.studentid 
INNER JOIN enrollmentsrosters er ON e.id=er.enrollmentid
INNER JOIN roster r ON er.rosterid=r.id
INNER JOIN aartuser au ON au.id = r.teacherid
INNER JOIN organization o ON e.attendanceschoolid = o.id
INNER JOIN organizationrelation por ON o.id = por.organizationid
INNER JOIN organization po ON por.parentorganizationid = po.id
INNER JOIN organization ro ON r.attendanceschoolid = ro.id
INNER JOIN contentarea ca ON r.statesubjectareaid=ca.id
INNER JOIN gradecourse gc ON r.statecoursesid=gc.id
INNER JOIN dup_roster dup ON  dup.studentid=s.id
   AND dup.statecoursesid = r.statecoursesid
WHERE r.currentschoolyear = 2016
AND r.activeflag=true 
AND e.activeflag=true
AND s.stateid = (SELECT id 
                 FROM organization 
                 WHERE  displayidentifier = 'MO'
                 AND organizationtypeid = 2)               
ORDER BY s.id
        ,s.stateid
        ,r.statesubjectareaid
        ,r.statecoursesid
;
	
