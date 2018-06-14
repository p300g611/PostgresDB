drop table if exists tmp_std;
select distinct 
s.statestudentidentifier "StateStudentIdentifier",
st.studentid  "StudentID",
ort.statename  "StateName",
ort.districtname "DistrictName",
ort.schoolname   "SchoolName",
gc.abbreviatedname "Grade"
-- ts.source,
-- ts.operationaltestwindowid,
-- st.startdatetime AT TIME ZONE 'US/Central' startdatetime_cst,
-- st.startdatetime  startdatetime,
-- st.enddatetime AT TIME ZONE 'US/Central' enddatetime_cst, 
-- st.enddatetime enddatetime 
 into temp tmp_std
from studentstests st 
inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id
inner join student s on s.id=e.studentid
inner join category c on c.id=st.status
inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
inner join testsession ts on st.testsessionid=ts.id 
where ts.activeflag is true 
and ts.schoolyear=2018 and ts.operationaltestwindowid=10270
and st.activeflag is true  
and ort.statedisplayidentifier='IL'
and c.categoryname ilike '%Complete%'
and  ( (st.enddatetime AT TIME ZONE 'US/Central')::date='03-12-2018' or 
       (st.startdatetime AT TIME ZONE 'US/Central')::date='03-12-2018');

\copy (select * from tmp_std order by statename,districtname,schoolname) to 'IL_studentstests_03122018.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- From Helpdesk 
drop table if exists tmp_std;
select distinct s.statestudentidentifier, s.legalfirstname as student_first, s.legallastname as student_last, otd.statedisplayidentifier as state, otd.districtname as district_name, otd.schoolname as school_name,
 t.testname as test_name, categoryname as test_status, st.currenttestnumber, au.displayname as teacher, au.email as teacher_email, ca.abbreviatedname subject
into temp tmp_std
from studentstests st
join testsession ts on st.testsessionid = ts.id
left outer join testcollection tc on tc.id=st.testcollectionid
left outer join contentarea ca on ca.id=tc.contentareaid
join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
join student s on e.studentid = s.id
join test t on st.testid = t.id
join category c on st.status = c.id
left join roster r on ts.rosterid = r.id
left join aartuser au on r.teacherid = au.id
join organizationtreedetail otd on e.attendanceschoolid = otd.schoolid
where ts.schoolyear=2018 and ts.operationaltestwindowid=10270
and st.activeflag is true  
and otd.statedisplayidentifier='IL'
and c.categoryname ilike '%Complete%'
and  ( (st.enddatetime AT TIME ZONE 'US/Central')::date='03-12-2018' or 
       (st.startdatetime AT TIME ZONE 'US/Central')::date='03-12-2018');

\copy (select * from tmp_std order by state,district_name,school_name,statestudentidentifier) to 'IL_studentstests_03122018.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);