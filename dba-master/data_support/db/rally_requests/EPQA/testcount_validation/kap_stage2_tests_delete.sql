--delete the stage 2 kap tests by opw and grade level (math 4,5,10 grades excluded)
-- Find the missing subject
with one_sub_in as (
select s.statestudentidentifier,s.legallastname,ets.subjectareaid,s.id studentid,e.id enrollid,gc.abbreviatedname from student s
 inner join enrollment e on s.id=e.studentid  and e.activeflag is true and s.activeflag is true
 inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true
 inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
 inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
 inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
 inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true
 inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2 and ot.schooldisplayidentifier = '1896')
select s.statestudentidentifier,s.legallastname,ets.subjectareaid,s.id,e.id,gc.abbreviatedname from student s
 inner join enrollment e on s.id=e.studentid  and e.activeflag is true and s.activeflag is true
 inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true
 inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
 inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
 inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true
 inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
 inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2 and ot.schooldisplayidentifier = '1896'
 and not exists (select one.enrollid from one_sub_in one where one.enrollid=e.id and one.abbreviatedname=gc.abbreviatedname);

--validation
--Find stage 2 tests
select stg.id,stg.code,gc.abbreviatedname grade
,tc.contentareaid,count(st.id)
from 
studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
where --ts.activeflag is true and 
ts.schoolyear=2017
 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid=10172
and stg.id=2
group by stg.id,stg.code,gc.abbreviatedname,tc.contentareaid
order by tc.contentareaid,gc.abbreviatedname;

--FInd stage2 tests by status
select stg.id,stg.code,gc.abbreviatedname grade,st.status
,tc.contentareaid,count(st.id)
from 
studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid=10172
and stg.id=2
group by stg.id,stg.code,gc.abbreviatedname,tc.contentareaid,st.status
order by tc.contentareaid,gc.abbreviatedname;

--FInd stage2 tests after exclude
select stg.id,stg.code,gc.abbreviatedname grade,st.status
,tc.contentareaid,count(st.id)
from 
studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid=10172
and stg.id=2
and (tc.contentareaid=3 or (tc.contentareaid=440 and gc.abbreviatedname not in ('4','5','10')))
group by stg.id,stg.code,gc.abbreviatedname,tc.contentareaid,st.status
order by tc.contentareaid,gc.abbreviatedname;

--list of the stage 2 after exclude.
drop table if exists tmp_epqa;
select st.id studentstestid,st.testsessionid,st.status,st.enrollmentid,st.studentid,st.testid,ts.name,stg.id,stg.code,gc.abbreviatedname grade
,tc.contentareaid
into temp tmp_epqa
from 
studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
where --ts.activeflag is true and 
ts.schoolyear=2017 --and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid=10172
and stg.id=2
and (tc.contentareaid=3 or (tc.contentareaid=440 and gc.abbreviatedname not in ('4','5','10')))
order by tc.contentareaid,gc.abbreviatedname;

\copy (select * from tmp_epqa) to 'kap_stage2.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


begin;

select count(*) from studentsresponses where studentstestsectionsid in (
 select id from studentstestsections
 where studentstestid in (select studentstestid from tmp_epqa));
select count(*) from studentstestsections
 where studentstestid in (select studentstestid from tmp_epqa);
select count(*) from studentstests where testsessionid in (select distinct testsessionid from tmp_epqa);
select count(*) from testsession where id in (select distinct testsessionid from tmp_epqa);
select count(*) from studentsresponseparameters where studentstestsectionsid in (select id from studentstestsections where studentstestid in (select studentstestid from tmp_epqa));

select count(*) from exitwithoutsavetest where studenttestsectionid in (select id from studentstestsections where studentstestid in (select studentstestid from tmp_epqa));

-- select count(*) from scoringassignmentstudent where scoringassignmentid in (select id from scoringassignment where testsessionid in(select distinct testsessionid from tmp_epqa));
-- select count(*) from scoringassignmentscorer where scoringassignmentid in (select id from scoringassignment where testsessionid in(select distinct testsessionid from tmp_epqa));
-- select count(*) from scoringassignment where testsessionid in(select distinct testsessionid from tmp_epqa);


delete from studentsresponses where studentstestsectionsid in (
 select id from studentstestsections
 where studentstestid in (select studentstestid from tmp_epqa));

delete from studentsresponseparameters where studentstestsectionsid in (select id from studentstestsections where studentstestid in (select studentstestid from tmp_epqa));

delete from exitwithoutsavetest where studenttestsectionid in (select id from studentstestsections where studentstestid in (select studentstestid from tmp_epqa));
 
delete from studentstestsections
 where studentstestid in (select studentstestid from tmp_epqa);
delete from studentstests where testsessionid in (select distinct testsessionid from tmp_epqa);
delete from testsession where id in (select distinct testsessionid from tmp_epqa);


commit;











