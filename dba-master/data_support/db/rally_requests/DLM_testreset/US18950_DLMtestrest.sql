/* validation
select st.id as stid, ts.id as tsid, ts.name as testsessionname, stb.activeflag as A, t.testname,
 (select categorycode as status from category where id = sts.status)
from student stud
join studenttracker st on st.studentid = stud.id
join studenttrackerband stb on stb.studenttrackerid = st.id
join testsession ts on ts.id = stb.testsessionid
join studentstests sts on sts.testsessionid = ts.id and sts.studentid = stud.id
join test t on t.id = sts.testid
where stud.statestudentidentifier = '720026738'
and st.contentareaid =441
order by stb.createddate asc;

--only for SS ( no need to deactivate studenttracker)
select id, name,activeflag from testsession where id in (select testsessionid from studentstests where studentid = (select id from student where statestudentidentifier ='1021788481'));

--if do not have tests and testsession not assigning
--UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
   --  WHERE id in (st);
*/
BEGIN;
/*
-- student:720026738--M
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (2557966,3442817,3580230,3638985,3661307,3711235));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (2557966,3442817,3580230,3638985,3661307,3711235));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE testsessionid IN (2557966,3442817,3580230,3638985,3661307,3711235);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (2557966,3442817,3580230,3638985,3661307,3711235);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (2557966,3442817,3580230,3638985,3661307,3711235);
     
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 720026738, 12, now(), 'REST_STUDENT_TRACKER', ('{"TestSessionIds": "2557966,3442817,3580230,3638985,3661307,3711235", "activeflag": true}')::JSON,  ('{"Reason": "As per US18950, inactivated the students tests"}')::JSON);
    
 update studenttracker set status = 'UNTRACKED' where id in (283293);
-- student:720026738--ELA
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (2557956,3443269,3579369,3638911,3661001,3710618));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (2557956,3443269,3579369,3638911,3661001,3710618));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE testsessionid IN (2557956,3443269,3579369,3638911,3661001,3710618);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (2557956,3443269,3579369,3638911,3661001,3710618);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (2557956,3443269,3579369,3638911,3661001,3710618);
     
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 720026738, 12, now(), 'REST_STUDENT_TRACKER', ('{"TestSessionIds": "2557956,3443269,3579369,3638911,3661001,3710618", "activeflag": true}')::JSON,  ('{"Reason": "As per US18950, inactivated the students tests"}')::JSON);
    
 update studenttracker set status = 'UNTRACKED' where id in (283299);



 
-- student:7409087415--ELA
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (3229012,3754197));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (3229012,3754197));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE testsessionid IN (3229012,3754197);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (3229012,3754197);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (3229012,3754197);
     
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 7409087415, 12, now(), 'REST_STUDENT_TRACKER', ('{"TestSessionIds": "3229012,3754197", "activeflag": true}')::JSON,  ('{"Reason": "As per US18950, inactivated the students tests"}')::JSON);
    
 update studenttracker set status = 'UNTRACKED' where id in (191976);
 */
 -- student:720026738--sci
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (2557834,3442904,3579058,3638641,3661723,3711212,3724376,3742198,3775055));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (2557834,3442904,3579058,3638641,3661723,3711212,3724376,3742198,3775055));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE testsessionid IN (2557834,3442904,3579058,3638641,3661723,3711212,3724376,3742198,3775055);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (2557834,3442904,3579058,3638641,3661723,3711212,3724376,3742198,3775055);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (2557834,3442904,3579058,3638641,3661723,3711212,3724376,3742198,3775055);
     
INSERT INTO domainaudithistory (source, objecttype, objectid, createduserid, createddate, action, objectbeforevalues, objectaftervalues)
      values('SCRIPT', 'STUDENTSTESTS', 720026738, 12, now(), 'REST_STUDENT_TRACKER', ('{"TestSessionIds": "2557834,3442904,3579058,3638641,3661723,3711212,3724376,3742198,3775055", "activeflag": true}')::JSON,  ('{"Reason": "As per US18950, inactivated the students tests"}')::JSON);
    
 update studenttracker set status = 'UNTRACKED' where id in (283161);
COMMIT;  
 
