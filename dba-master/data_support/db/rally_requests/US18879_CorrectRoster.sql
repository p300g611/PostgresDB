BEGIN;

-- Update student rosterid. student ID:4320974948

--M
	  update testsession
	  set rosterid=889505
	  ,modifieddate=now()
	  ,modifieduser=12
	 where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='4320974948'
				  and st.status=86)
		and rosterid=912887;
		
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT','STUDENT',854693,12,now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "2580394,2639505,2552086", "rosterid": 912887}')::JSON,  ('{"Reason": "As per US18879, updated rosterid:889505"}')::JSON);
		
		
COMMIT;