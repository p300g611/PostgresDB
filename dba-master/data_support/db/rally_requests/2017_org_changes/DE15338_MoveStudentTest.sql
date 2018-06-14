
/*
   id    │ activeflag │
├─────────┼────────────┤
│ 2886276 │ t          │
│ 2649346 │ f 



select ts.id, ts.name,st.id studentstestid, ts.rosterid 
from studentstests st
inner join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on tc.id =st.testcollectionid
where tc.contentareaid =440 and st.enrollmentid = 2649346


select id, rosterid from ititestsessionhistory
where studentid =1350338 and rosterid=1072040

*/
BEGIN;

update studentstests 
set    enrollmentid = 2886276,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where enrollmentid =2649346 and status=86 and activeflag is true and studentid= 1350338;

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        SELECT 'DATA_SUPPORT', 'STUDENT', 1350338, 12, now(), 'REST_ST_ENROLLMENTID', '{"STUDNETTESTID": "14846125,14845782,14845783,14846039,14846118,14845876,14846120,14845780,14846121,14846127,14846123"," enrollmentid": "2649346"}'::JSON,  '{"Reason": "As per":"DE15338,updated enrollmentid":2886276"}'::JSON;
		
		
update testsession 
set    rosterid =1095766,
        modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where id in (select ts.id
from studentstests st
inner join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on tc.id =st.testcollectionid
where tc.contentareaid =3 and st.enrollmentid = 2649346);


INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        select 'DATA_SUPPORT', 'STUDENT', 1350338, 12, now(), 'REST_TS_ROSTERID', '{"TestSessionIds": "3988818,3988819,3988863,3988823,3988816", "rosterid": 1072072}'::JSON,  '{"Reason": "As per":"As per:DE15338","updated rosterid":"1095766"}'::JSON;
		
		
update testsession 
set    rosterid =1095767,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where id in (select ts.id
from studentstests st
inner join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on tc.id =st.testcollectionid
where tc.contentareaid =440 and st.enrollmentid = 2649346);	

INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
        select 'DATA_SUPPORT', 'STUDENT', 1350338, 12, now(), 'REST_TS_ROSTERID', '{"TestSessionIds": "3988925,3988918,3988920,3988921,3988927,3988923", "rosterid": "1072040"})::JSON,  '{"Reason": "As per:As per":"DE15338,updated rosterid":"1095767"}::JSON;
		
		
		
update ititestsessionhistory
set    rosterid=1095766,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where studentid =1350338 and rosterid=1072072;

  
update ititestsessionhistory
set    rosterid=1095767,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where studentid =1350338 and rosterid=1072040;

COMMIT;