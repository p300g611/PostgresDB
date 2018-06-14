/* validation
select st.id as stid, ts.id as tsid, ts.name as testsessionname, stb.activeflag as A, t.testname,
 (select categorycode as status from category where id = sts.status),ts.source,st.status,st.studentid
from student stud
inner join enrollment e on e.studentid=stud.id and e.currentschoolyear=2018
join studenttracker st on st.studentid = stud.id
join studenttrackerband stb on stb.studenttrackerid = st.id
join testsession ts on ts.id = stb.testsessionid
join studentstests sts on sts.testsessionid = ts.id and sts.studentid = stud.id and e.id = sts.enrollmentid
join test t on t.id = sts.testid
where stud.statestudentidentifier = '9401003175'
-- and st.contentareaid =441
order by stb.createddate asc;

--research survey
select  ts.id as tsid, ts.name as testsessionname, 
 (select categorycode as status from category where id = sts.status),ts.source,sts.studentid,sts.activeflag
from student stud
inner join enrollment e on e.studentid=stud.id and e.currentschoolyear=2018
join studentstests sts on sts.studentid= stud.id and e.id = sts.enrollmentid
join testsession ts on ts.id = sts.testsessionid
where stud.statestudentidentifier = '9401003175';

--only for SS ( no need to deactivate studenttracker)
select id, name,activeflag from testsession where id in (select testsessionid from studentstests where studentid = (select id from student where statestudentidentifier ='9401003175')) and schoolyear=2018;

--if do not have tests and testsession not assigning
--UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu')
   --  WHERE id in (st);
*/
-- 310310
-- 188875
-- 6993781430
-- 9401003175

BEGIN;

 -- student:310310--ALL
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (5931835,5833637));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (5931835,5833637));

UPDATE studentstests SET manualupdatereason ='as for ticket #961055', activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE testsessionid IN (5931835,5833637);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE id IN (5931835,5833637);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu')
     WHERE testsessionid in (5931835,5833637);
     

 update studenttracker set status = 'UNTRACKED' where id in (594880);
COMMIT;  

BEGIN;

 -- student:188875--ALL
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (5847812,5827377,5930769));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (5847812,5827377,5930769));

UPDATE studentstests SET  manualupdatereason ='as for ticket #961055', activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE testsessionid IN (5847812,5827377,5930769);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE id IN (5847812,5827377,5930769);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu')
     WHERE testsessionid in (5847812,5827377,5930769);
     

 update studenttracker set status = 'UNTRACKED' where id in (587271,595580);
COMMIT; 


  -- student:6993781430--ALL
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (5832670,5955443,5849439,5840175));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (5832670,5955443,5849439,5840175));

UPDATE studentstests SET  manualupdatereason ='as for ticket #961055', activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE testsessionid IN (5832670,5955443,5849439,5840175);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE id IN (5832670,5955443,5849439,5840175);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu')
     WHERE testsessionid in (5832670,5955443,5849439,5840175);
     

 update studenttracker set status = 'UNTRACKED' where id in (581767,582092,592687);

   -- student:9401003175--ALL
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (5955503,5849511,5840263));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (5955503,5849511,5840263));

UPDATE studentstests SET  manualupdatereason ='as for ticket #961055',  activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE testsessionid IN (5955503,5849511,5840263);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE id IN (5955503,5849511,5840263);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu')
     WHERE testsessionid in (5955503,5849511,5840263);
     

 update studenttracker set status = 'UNTRACKED' where id in (582180,581853);
COMMIT; 


-- UPDATE studentstests SET  manualupdatereason ='as for ticket #961055'
--      WHERE testsessionid IN (5955503,5849511,5840263, 5832670,5955443,5849439,5840175,5847812,5827377,5930769,5931835,5833637) 
--      and activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu') ;