\f ','
\a
\pset expanded off
\o 'US17809_all_KS_KAP_dup_tests_03112016_full.csv'

SELECT distinct
       st.id AS studenttestid
      ,s.id AS studentid
      ,s.statestudentidentifier
      ,ts.name AS testsessionname
      ,t.createdate testcreatedate
      ,st.startdatetime
      ,st.enddatetime      
      ,st.status 
      ,c.categoryname AS teststatus
      ,otd.districtname
      ,ts.attendanceschoolid   
      ,otd.schoolname AS testsessionschoolname
      ,otd.schooldisplayidentifier
FROM (
	SELECT e.studentid
	FROM enrollment e
	INNER JOIN student s ON (e.studentid = s.id)
	WHERE e.activeflag = true 
	AND s.activeflag = true
	AND s.stateid = (SELECT id 
	                 FROM organization 
	                 WHERE displayidentifier = 'KS')
	GROUP BY e.studentid
	HAVING COUNT(distinct e.attendanceschoolid) > 1	
     )  students_mult_enrls
INNER JOIN studentstests st ON (students_mult_enrls.studentid = st.studentid)  
INNER JOIN student s ON st.studentid = s.id
INNER JOIN testsession ts ON st.testsessionid=ts.id
INNER JOIN test t ON (st.testid = t.id)
INNER JOIN category c ON (st.status = c.id)
INNER JOIN organizationtreedetail otd ON ts.attendanceschoolid=otd.schoolid
INNER JOIN enrollment e ON (students_mult_enrls.studentid = e.studentid)
INNER JOIN enrollment e2 ON (students_mult_enrls.studentid = e2.studentid)
   AND e2.id > e.id
INNER JOIN enrollmenttesttypesubjectarea ettsa ON (e.id = ettsa.enrollmentid)
INNER JOIN enrollmenttesttypesubjectarea ettsa2 ON (ettsa2.enrollmentid = e2.id)
   AND ettsa.testtypeid = ettsa2.testtypeid
   AND ettsa.subjectareaid = ettsa2.subjectareaid
WHERE e.activeflag = true and e2.activeflag = true
AND ettsa.testtypeid in (
	SELECT tt.id
	FROM testtype tt
	INNER JOIN assessment a ON (tt.assessmentid = a.id) 
	   AND tt.activeflag = TRUE AND a.activeflag = TRUE
	INNER JOIN testingprogram tp ON (a.testingprogramid = tp.id)
	   AND tp.activeflag = TRUE
	WHERE tp.assessmentprogramid = (SELECT id 
	                                FROM assessmentprogram 
	                                WHERE abbreviatedname = 'KAP')
                         )
AND ts.operationaltestwindowid=10131 
ORDER BY s.statestudentidentifier
        ,ts.name;