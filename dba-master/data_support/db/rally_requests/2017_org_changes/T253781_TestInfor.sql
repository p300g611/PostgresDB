	
	SELECT stu.statestudentidentifier,
	       stu.id studentid,
		   stu.legalfirstname,
		   stu.legallastname,
           en.id enrollmentid,
           st.id AS studentstestid,
           ts.name testsessionname,
           st.startdatetime,
		   st.enddatetime,
           gc.abbreviatedname gradename,
           c.categorycode as status,
           ts.stageid as stageid,
           attsch.organizationname AS schoolname,
           str.score
     FROM studentstests st
     JOIN enrollment en ON en.id = st.enrollmentid
	 join gradecourse gc on gc.id =en.currentgradelevel
     JOIN testcollection tc ON tc.id = st.testcollectionid
	 JOIN test t on t.id =st.testid
     JOIN organization attsch ON attsch.id = en.attendanceschoolid
     JOIN contentarea ca ON ca.id = tc.contentareaid
     JOIN student stu ON stu.id = en.studentid
     JOIN testsession ts ON ts.id = st.testsessionid
     JOIN category c ON c.id = st.status
	 left outer join studentsresponses str on str.studentid =stu.id           
      where  stu.statestudentidentifier = '7197684161';
	  
