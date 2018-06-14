BEGIN;
--Move to correct roster. StudentID: 6277981442

--M
update testsession
	  set activeflag=false
	  ,modifieddate=now()
	  ,modifieduser=12
	  --select id from testsession
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='6277981442'
				 )
		and rosterid in(951981,1054655)
		and activeflag is true;
		
 update 	enrollmentsrosters 
      set  activeflag=false
      ,modifieddate=now()
	  ,modifieduser=12
	  where id in (14533995,14456448,14465387,14320851,14320860)
	  and activeflag is true;
		
		
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT', 1287231, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "2355371,2520742", "rosterid":"951981,1054655"}')::JSON,  ('{"Reason": "As per US188921, updated rosterid:1065215"}')::JSON);


COMMIT;

