BEGIN;
--move student testlets to new district. student ID: 1781392

--update rosterid
--ELA
update testsession
	  set rosterid=890761
	  ,modifieddate=now()
	  ,modifieduser=12
	  where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1781392'
				  and st.status=86
				  )
		and rosterid=880107;

		
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT',927558, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "2312411,2016719,2016726,2628938,2016710,2016691,2016698,2016704,2016715", "rosterid": 880107}')::JSON,  ('{"Reason": "As per US18902, updated rosterid:890761"}')::JSON);		
--M

update testsession
	  set rosterid=890762
	  ,modifieddate=now()
	  ,modifieduser=12
	  where id in (select testsessionid from student s
			    inner join enrollment e on e.studentid=s.id
			    inner join studentstests st on s.id=st.studentid and e.id=st.enrollmentid 
			    where s.statestudentidentifier='1781392'
				  and st.status=86
				  )
		and rosterid=880108;
		
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT',927558, 12, now(), 'REST_TS_ROSTERID', ('{"TestSessionIds": "2015264,2015248,2312455,2015273,2015256,2639232,2015242,2015251,2015268,2015261", "rosterid": 880108}')::JSON,  ('{"Reason": "As per US18902, updated rosterid:890762"}')::JSON);

update studentstests
set enrollmentid = 2395392, modifieduser = 12, modifieddate = now()
where id in (12650789,12640495,10928164,10928120,8098446,8098441,8098415,8098421,8098429,8098437,8098434,8098424,8099889,8099870,8099898,8099894,8099883,8099877,8099905);

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
VALUES('DATA_SUPPORT', 'STUDENT',927558, 12, now(), 'REST_ST_ID', ('{"STUDENTTestIds": "12650789,12640495,10928164,10928120,8098446,8098441,8098415,8098421,8098429,8098437,8098434,8098424,8099889,8099870,8099898,8099894,8099883,8099877,8099905", "enrollmentid":2395392}')::JSON,  ('{"Reason": "As per US18902, updated enrollmentid:1789143"}')::JSON);

COMMIT;