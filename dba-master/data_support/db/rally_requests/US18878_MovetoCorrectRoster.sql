BEGIN;
--Move roster to correct roster. student ID:8746436001,4792018865,2409609854


--studentID:8746436001
--ELA
update testsession
	  set rosterid=1035126
	  ,modifieddate=now()
	  ,modifieduser=12
	  --select id from testsession
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='8746436001'
				 )
		and rosterid=943904;
		
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 1261580, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "2326002,2955633,2971902,3007501,3170042", "rosterid": 943904}')::JSON,  ('{"Reason": "As per US18878, updated rosterid:1035126"}')::JSON);


--studentID:4792018865		
--ELA
update testsession
	  set rosterid=1035126
	  ,modifieddate=now()
	  ,modifieduser=12
	  --select id from testsession
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='4792018865'
				 )
		and rosterid=943904;
		
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 1261379, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "2325828,2764895,2970501,3016539", "rosterid": 943904}')::JSON,  ('{"Reason": "As per US18878, updated rosterid:1035126"}')::JSON);

--studentID: 2409609854
--ELA
update testsession
	  set rosterid=1035126
	  ,modifieddate=now()
	  ,modifieduser=12
	  --select id from testsession
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='2409609854'
				 )
		and rosterid=943904;

		
		INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 1261340, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "2325757,2870617,2878568,2977340", "rosterid": 943904}')::JSON,  ('{"Reason": "As per US18878, updated rosterid:1035126"}')::JSON);

COMMIT;