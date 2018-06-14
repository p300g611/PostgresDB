/*--validation
--ELA
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
     WHERE stu.statestudentidentifier IN ('7147073681')  
     AND en.currentschoolyear = 2016
     --and c.categorycode ='rosterunenrolled'
     --and ts.rosterid in (917003)
     and ca.abbreviatedname='ELA'
     and r.statesubjectareaid=3
     order by ts.rosterid;
--M
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
     WHERE stu.statestudentidentifier IN ('7147073681')  
     AND en.currentschoolyear = 2016
     --and c.categorycode ='rosterunenrolled'
     --and ts.rosterid in (917003)
     and ca.abbreviatedname='M'
     and r.statesubjectareaid=440
      order by ts.rosterid;     

*/

--Student 7147073681
BEGIN;
-- Update student rosterid. student ID:7147073681
--ELA
	  update testsession
	  set rosterid=919766
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='7147073681'
				  --and st.status=86
				  )
		and rosterid=1035389;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 7147073681, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "3627294,3627295,3627293,2707637,3627296", "rosterid": 1035389}')::JSON,  ('{"Reason": "As per US18889, updated rosterid:919766"}')::JSON);
		
--M
	  update testsession
	  set rosterid=919767
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='7147073681'
				  --and st.status=86
				  )
		and rosterid=1035391;
		
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 7147073681, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "2707638,3699132,3699133,3699134", "rosterid": 1035391}')::JSON,  ('{"Reason": "As per US18889, updated rosterid:919767"}')::JSON);
		
COMMIT;	



    