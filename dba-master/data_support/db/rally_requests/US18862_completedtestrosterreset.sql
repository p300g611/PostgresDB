/*-- validation 
select distinct st.id,st.status,ts.rosterid,ts.status,ts.id,er.activeflag,er.rosterid
        FROM studentstests st
     JOIN enrollment en ON en.id = st.enrollmentid
     JOIN testcollection tc ON tc.id = st.testcollectionid
     JOIN organization attsch ON attsch.id = en.attendanceschoolid
     JOIN organization aypsch ON aypsch.id = en.aypschoolid
     JOIN contentarea ca ON ca.id = tc.contentareaid
     JOIN student stu ON stu.id = en.studentid
     JOIN testsession ts ON ts.id = st.testsessionid
     JOIN category c ON c.id = st.status
     JOIN testsection tstsct ON (tstsct.testid = st.testid)
     --JOIN testsectionstaskvariants tstv ON (tstv.testsectionid = tstsct.id)
     --JOIN testlet tstlet on (tstv.testletid = tstlet.id) 
     JOIN enrollmentsrosters er on er.enrollmentid=en.id
     JOIN roster r on r.id=er.rosterid 
        inner join aartuser a on r.teacherid=a.id
     WHERE stu.statestudentidentifier IN ('8459866924')  
     AND en.currentschoolyear = 2016
     --and c.categorycode ='rosterunenrolled'
     --and ts.rosterid in (917003)
     and ca.abbreviatedname='ELA'
     and r.statesubjectareaid=3
     order by ts.rosterid;
*/
BEGIN;
-- student 6223815361
	  update testsession
	  set rosterid=1038270
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='6223815361'
				  and st.status=86)
		and rosterid=916988 ;                 
-- student 3450179656
	  update testsession
	  set rosterid=1038270
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='3450179656'
				  and st.status=86)
		and rosterid=916988 ; 
-- student 8459866924
	  update testsession
	  set rosterid=1038270
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='8459866924'
				  and st.status=86)
		and rosterid=916988 ;                 
-- student 7801670397
	  update testsession
	  set rosterid=1038270
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='7801670397'
				  and st.status=86)
		and rosterid=916988 ;
COMMIT;				
		 		