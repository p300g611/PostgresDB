/* validation
select st.id as stid, ts.id as tsid, ts.name as testsessionname, stb.activeflag as A, t.testname,
 (select categorycode as status from category where id = sts.status)
from student stud
join studenttracker st on st.studentid = stud.id
join studenttrackerband stb on stb.studenttrackerid = st.id
join testsession ts on ts.id = stb.testsessionid
join studentstests sts on sts.testsessionid = ts.id and sts.studentid = stud.id
join test t on t.id = sts.testid
where stud.statestudentidentifier = '6572671850'
and st.contentareaid =440
order by stb.createddate asc;

--only for SS ( no need to deactivate studenttracker)
select id, name,activeflag from testsession where id in (select testsessionid from studentstests where studentid = (select id from student where statestudentidentifier ='1021788481'));

--if do not have tests and testsession not assigning
--UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
   --  WHERE id in (st);
*/
BEGIN;
-- ELA
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (6579404,6674182));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (6579404,6674182));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now(),manualupdatereason='Ticket#647333'
     WHERE testsessionid IN (6579404,6674182);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (6579404,6674182);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (6579404,6674182);
     
    
 update studenttracker set status = 'UNTRACKED' where id in (622784);


COMMIT;  

BEGIN;
-- math
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (6577224,6674173));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (6577224,6674173));

UPDATE studentstests SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now(),manualupdatereason='Ticket#647333'
     WHERE testsessionid IN (6577224,6674173);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin'), modifieddate = now()
     WHERE id IN (6577224,6674173);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
     WHERE testsessionid in (6577224,6674173);
     
    
 update studenttracker set status = 'UNTRACKED' where id in (612579);


COMMIT;


