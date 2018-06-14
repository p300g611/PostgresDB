SELECT stu.statestudentidentifier SSID,
       attsch.organizationname SchoolName,
	   aypsch.id  AYPSchool,
	   stu.legalfirstname Firstname,
	   stu.legallastname Lastname,
	   ts.name TestsessionName,
	   c.categorycode  TestStatus,
	   st.startdatetime TestStartTime,
	   st.enddatetime  TestEndTime
	   into temp tmp_table
     FROM studentstests st
     JOIN enrollment en ON en.id = st.enrollmentid
	 join gradecourse gc on gc.id = en.currentgradelevel
     JOIN testcollection tc ON tc.id = st.testcollectionid
	 JOIN test t on t.id =st.testid
     JOIN organization attsch ON attsch.id = en.attendanceschoolid
     JOIN organization aypsch ON aypsch.id = en.aypschoolid
     JOIN contentarea ca ON ca.id = tc.contentareaid
     JOIN student stu ON stu.id = en.studentid
     JOIN testsession ts ON ts.id = st.testsessionid
     JOIN category c ON c.id = st.status     
     JOIN studentassessmentprogram sap on sap.studentid =stu.id	 
 where en.currentschoolyear = 2016 and stu.activeflag is true and en.activeflag is true
	  AND ca.abbreviatedname = 'SS' and stu.stateid =51
	  and attsch.id = 5860  and gc.abbreviatedname ='6' and sap.assessmentprogramid = 12
	  order by stu.statestudentidentifier;
	  
	  
\copy (select * from tmp_table) to 'T861296_extract.csv'DELIMITER ',' CSV HEANDER;