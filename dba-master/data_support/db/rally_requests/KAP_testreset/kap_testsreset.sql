--find the student like this condition
select distinct e.studentid, st.enrollmentid, st.id as studentstestsid, st.testid, st.status, ca.abbreviatedname as testsubject
from testsession ts
join studentstests st on ts.id = st.testsessionid
join test t on st.testid = t.id
join contentarea ca on t.contentareaid = ca.id
join enrollment e on st.enrollmentid = e.id
join organizationtreedetail otd on e.attendanceschoolid = otd.schoolid
where ts.operationaltestwindowid in (10172,10174)
and st.activeflag
and not e.activeflag
-- and st.status in (85,86)
order by 1 desc;



select st.id stid,st.activeflag st_active,st.status, ts.name ts_active,ts.id tsid
,e.id e_id,e.activeflag e_active,otd.schooldisplayidentifier  from  testsession ts
join studentstests st on ts.id = st.testsessionid
join test t on st.testid = t.id
join contentarea ca on t.contentareaid = ca.id
join enrollment e on st.enrollmentid = e.id
join organizationtreedetail otd on e.attendanceschoolid = otd.schoolid
where ts.operationaltestwindowid in (10172,10174) and st.studentid=328611;


-- Inactive old school tests
begin;
update studentstests  
set activeflag =false,modifieddate=now(),modifieduser=174744,manualupdatereason='DBA:request from healpdesk student re-enrolled'
where activeflag is true  and studentid=328611 and testsessionid in (4099298,4095700);


select * from studentstestsections
where activeflag is true and studentstestid in (16428767,16429205);

update studentstestsections
set activeflag =false,modifieddate=now(),modifieduser=174744
where activeflag is true and studentstestid in (16428767,16429205);

-- move complete tests to new school 
begin;
update studentstests  
set modifieduser=174744 ,modifieddate=now(),testsessionid=4099298,enrollmentid=2909377
where activeflag is true  and studentid=328611 and testsessionid =4099518; 

update studentstests  
set modifieduser=174744 ,modifieddate=now(),enrollmentid=2909377,testsessionid=4095700
where activeflag is true  and studentid=328611 and testsessionid =4096204; 


--End date should be the before the last batch run time otherwise, stage 2 tests need to wait until over night
--EP logic
-- CASE WHEN sts.enddatetime is null THEN
--   (#{jobLastSubmissionDate,jdbcType=TIMESTAMP}) at TIME ZONE 'US/Central' &lt; (sts.modifieddate at TIME ZONE 'US/Central') at TIME ZONE 'US/Central'
--   ELSE
--   (#{jobLastSubmissionDate,jdbcType=TIMESTAMP}) at TIME ZONE 'US/Central' &lt; (sts.enddatetime at TIME ZONE 'GMT') at TIME ZONE 'US/Central'
--   END

 update studentstests set enddatetime=now() where id=16267104;

commit;

--2.studentid:1192667

--validation
select st.id stid,st.activeflag st_active,st.status, ts.name ts_active,ts.id tsid
,e.id e_id,e.activeflag e_active,otd.schooldisplayidentifier  from  testsession ts
join studentstests st on ts.id = st.testsessionid
join test t on st.testid = t.id
join contentarea ca on t.contentareaid = ca.id
join enrollment e on st.enrollmentid = e.id
join organizationtreedetail otd on e.attendanceschoolid = otd.schoolid
where ts.operationaltestwindowid in (10172,10174) and st.studentid=1192667;



