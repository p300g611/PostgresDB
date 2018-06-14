\f ','
\a
\pset expanded off
\o 'MO_ayp_attend_school_difs.csv'

WITH diff_school_ids AS (
SELECT studentid
     , aypschoolid
     , attendanceschoolid 
FROM enrollment 
WHERE aypschoolid <> attendanceschoolid 
AND studentid IN (SELECT id 
                  FROM student 
                  WHERE stateid = (SELECT id 
                                   FROM organization 
                                   WHERE displayidentifier = 'MO'))
                          )
SELECT  s.id as studentid
       ,s.legallastname
       ,s.legalfirstname
       ,e.aypschoolid
       ,aypo.organizationname as aypschoolname
       ,e.attendanceschoolid
       ,attndo.organizationname as attendanceschoolname
       ,e.id as enrollmentid
       ,e.activeflag enrollmentactive
FROM student s 
JOIN diff_school_ids dsi ON (dsi.studentid = s.id)
JOIN enrollment e ON (e.studentid = s.id
  AND dsi.aypschoolid = e.aypschoolid
  AND dsi.attendanceschoolid = e.attendanceschoolid)
JOIN organization aypo ON (e.aypschoolid = aypo.id)
JOIN organization attndo ON (e.attendanceschoolid = attndo.id);
