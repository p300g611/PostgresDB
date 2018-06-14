/*Ticket #827317
NJ
LYNDHURST TOWNSHIP (032860)
ROOSEVELT E.S.
SSID: 9013877112
Students name was changed from Racquel to Raquel...Test Session name is needing to be updated to reflect this change please. 
*/

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
where stud.statestudentidentifier = '9013877112'
order by stb.createddate asc;

--research survey
select  ts.id as tsid, ts.name as testsessionname, 
 (select categorycode as status from category where id = sts.status),ts.source,sts.studentid,sts.activeflag
from student stud
inner join enrollment e on e.studentid=stud.id and e.currentschoolyear=2018
join studentstests sts on sts.studentid= stud.id and e.id = sts.enrollmentid
join testsession ts on ts.id = sts.testsessionid
where stud.statestudentidentifier = '9013877112';
*/

BEGIN;

 -- student:310310--ALL
UPDATE studentsresponses SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE studentstestsid IN (SELECT id FROM studentstests WHERE testsessionid IN (6353801,6353701,5959949));

UPDATE studentstestsections SET activeflag = false,  modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
      WHERE studentstestid IN (SELECT id FROM studentstests WHERE testsessionid IN (6353801,6353701,5959949));

UPDATE studentstests SET manualupdatereason ='as for ticket #961055', activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE testsessionid IN (6353801,6353701,5959949);
                 
UPDATE testsession SET activeflag = false, modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu'), modifieddate = now()
     WHERE id IN (6353801,6353701,5959949);

UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'ats_dba_team@ku.edu')
     WHERE testsessionid in (6353801,6353701,5959949);


update studenttracker set status = 'UNTRACKED' where id in (717922,718067);

COMMIT;  

