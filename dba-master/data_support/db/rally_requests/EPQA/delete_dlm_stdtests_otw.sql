/* validation
select st.id as stid, ts.id as tsid, ts.name as testsessionname, stb.activeflag as A, t.testname,
 (select categorycode as status from category where id = sts.status)
from student stud
join studenttracker st on st.studentid = stud.id
join studenttrackerband stb on stb.studenttrackerid = st.id
join testsession ts on ts.id = stb.testsessionid
join studentstests sts on sts.testsessionid = ts.id and sts.studentid = stud.id
join test t on t.id = sts.testid
where stud.statestudentidentifier = '5235847741'
and st.contentareaid =3
order by stb.createddate asc;

--only for SS ( no need to deactivate studenttracker)
select id, name,activeflag from testsession where id in (select testsessionid from studentstests where studentid = (select id from student where statestudentidentifier ='1021788481'));

--if do not have tests and testsession not assigning
--UPDATE studenttrackerband SET activeflag = false, modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
   --  WHERE id in (st);
*/

--validation 

select count(*) from studenttracker where id in ( select studenttrackerid from studenttrackerband where operationalwindowid=10203);

select count(studenttrackerid) from studenttrackerband where operationalwindowid=10203;

select count(*) from studenttrackerband where  operationalwindowid=10203;

select count(*) from studentsresponses
where studentstestsid  in (select id from studentstests where testsessionid in (select distinct id from testsession where operationaltestwindowid=10203));

select count(*) from studentstestsections
where studentstestid in (select id from studentstests where testsessionid in (select id from testsession where operationaltestwindowid=10203)));

select count(distinct studentid) from studentstests where testsessionid in (select distinct id from testsession where operationaltestwindowid=10203);

select count(*) from studentstests where testsessionid in (select distinct id from testsession where operationaltestwindowid=10203);

select count(*) from testsession where id in (select id from testsession where operationaltestwindowid=10203);

--studenttrackerblueprintstatus
--studentsresponsescopy

--delete 
BEGIN;


select studenttrackerid into temp tmp_studenttrackerid from studenttrackerband where  operationalwindowid=10203;

select count(*) from tmp_studenttrackerid;

delete from studenttrackerband where operationalwindowid=10203;

delete from studenttracker where id in ( select studenttrackerid from tmp_studenttrackerid);

delete from studentstestsections
where studentstestid in (select id from studentstests where testsessionid in (select id from testsession where operationaltestwindowid=10203));

delete from studentstests where testsessionid in (select distinct id from testsession where operationaltestwindowid=10203);

delete from testsession where id in (select id from testsession where operationaltestwindowid=10203);



COMMIT;  
