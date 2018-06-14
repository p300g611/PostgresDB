select 'process started:'||clock_timestamp() AS dashboardkapelamathdaily;
drop table if exists dashboardkapelamathdaily;
select 
ts.operationaltestwindowid,
st.studentid,
st.id studentstestsid,
ort.statename,
ort.districtname,
ort.districtid,
ort.schoolname,
ort.schoolid,
gc.abbreviatedname grade,
tc.contentareaid subjectareaid,
tc.name testcollectionname,
t.testname testname,
(startdatetime ) AT TIME ZONE 'US/Central' startdatetime_cst,
(enddatetime ) AT TIME ZONE 'US/Central'   enddatetime_cst,
round(EXTRACT(EPOCH FROM (st.enddatetime - st.startdatetime))/60) Timetaken_min,
st.status
 into dashboardkapelamathdaily
from studentstests st 
inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
inner join testsession ts on st.testsessionid=ts.id 
inner join test t on st.testid=t.id and t.activeflag is true
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10261
and st.startdatetime::date< now()::date;
\copy (select * from dashboardkapelamathdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_kap_ela_math_timestamp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--10 7 * * SAT psql -h aartdwdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aartdw -f "/srv/extracts/helpdesk/dailyvalidation/dailydashboard_extracts_weekly.sql" -d aartdw > /dev/null