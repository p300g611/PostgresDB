	
	SELECT distinct stu.statestudentidentifier,
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
           --str.score,
		   strp.scalescore,
		   strp.generated,strp.status
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
	-- left outer join studentsresponses str on str.studentid =stu.id
     left outer join studentreport strp on strp.studentid =stu.id and ca.id = strp.	contentareaid 
      where  ca.abbreviatedname = 'SS'AND stu.statestudentidentifier in( '4369187974',
	                                                                      '9685139482',
																		  '4019428352',
	                                                                       '3780104318',
																		   '8950259443',
																		   '2103624041',
																		   '9144112491',
																		   '6025983798 ',
																		   '9127405931');
	    
	  select distinct ts.name from studentstests st
	  join testsession ts on ts.id = st.testsessionid
	  join enrollment en on en.id = st.enrollmentid
	  join student stu on stu.id =en.studentid 
	  where stu.statestudentidentifier ='4369187974';
	  
	  
