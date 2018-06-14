--Delete student tests for KELPA by operational test window

--Validation:
select operationaltestwindowid,createddate::date,modifieddate::date,count(*) from testsession
where operationaltestwindowid=10171 and schoolyear=2017
group by operationaltestwindowid,createddate::date,modifieddate::date;

select operationaltestwindowid,st.createddate::date,st.modifieddate::date,count(*),count(distinct st.studentid) from testsession ts
inner join studentstests st on st.testsessionid=ts.id
where operationaltestwindowid=10171 and schoolyear=2017
group by operationaltestwindowid,st.createddate::date,st.modifieddate::date;

select operationaltestwindowid,st.createddate::date,st.modifieddate::date,count(distinct sts.id),count(distinct st.studentid) from testsession ts
inner join studentstests st on st.testsessionid=ts.id
inner join studentstestsections sts
on st.id=sts.studentstestid
where operationaltestwindowid=10171 and schoolyear=2017
group by operationaltestwindowid,st.createddate::date,st.modifieddate::date;

--Tests for KELPA
begin;

delete from ccqscoreitem where ccqscoreid in (select id from ccqscore where scoringassignmentstudentid in
 (select id from scoringassignmentstudent where studentstestsid in (select id from studentstests where testsessionid in (select id from testsession where operationaltestwindowid=10171))));
delete from ccqscore where scoringassignmentstudentid in (select id from scoringassignmentstudent where studentstestsid in (select id from studentstests where testsessionid in (select id from testsession where operationaltestwindowid=10171)));
delete from scoringassignmentstudent where scoringassignmentid in (select id from scoringassignment where testsessionid in(select id from testsession where operationaltestwindowid=10171));
delete from scoringassignmentscorer where scoringassignmentid in (select id from scoringassignment where testsessionid in(select id from testsession where operationaltestwindowid=10171));
delete from scoringassignment where testsessionid in(select id from testsession where operationaltestwindowid=10171);

delete from studentsresponses where studentstestsectionsid in (
 select id from studentstestsections
 where studentstestid in (select id from studentstests where testsessionid in (select id from testsession where operationaltestwindowid=10171)));
delete from studentstestsections
 where studentstestid in (select id from studentstests where testsessionid in (select  id from testsession where operationaltestwindowid=10171));
delete from studentspecialcircumstance where studenttestid in (select id from studentstests where testsessionid in (select  id from testsession where operationaltestwindowid=10171));
delete from studentstests where testsessionid in (select distinct id from testsession where operationaltestwindowid=10171);
delete from testsession where id in (select id from testsession where operationaltestwindowid=10171);

commit;






