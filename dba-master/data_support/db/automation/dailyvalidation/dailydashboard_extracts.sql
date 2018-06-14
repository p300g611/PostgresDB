-- DB_EP.1) ATS AND EP DASHBOARD DAILY TESTING SUMMARY COUNTS
select 'process started:'||clock_timestamp() AS dashboardnewsessionsdaily;
select st.statename,st.operationaltestwindowid,st.contentarea,st.testcollectionname,st.grade,st.gradebandname,st.status,
sum(nooftests) nooftests,sum(nooftests_lastday) nooftests_lastday,
sum(nooftests_today) nooftests_today,sum(nostage2testscompleted) nostage2testscompleted  into temp dailydashboard_newsessions
from dashboardnewsessionsdaily st
group by st.statename,st.operationaltestwindowid,st.contentarea,st.testcollectionname,st.grade,st.gradebandname,st.status;
\copy (select * from dailydashboard_newsessions order by 1,2,4,5,6) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_newsessions.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_EP.2) ATS AND EP DASHBOARD DAILY STUDENT SCORING
select 'process started:'||clock_timestamp() AS dashboardstudentscoringdaily;
\copy (select * from dashboardstudentscoringdaily where assessmentprogramid=47) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_kelpa_scoring_student.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from dashboardstudentscoringdaily where assessmentprogramid=12) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_kap_scoring_student.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_EP.3) ATS AND EP DASHBOARD DAILY REACTIVATION TESTS 
select 'process started:'||clock_timestamp() AS dashboardreactivationsdaily;
\copy (select * from dashboardreactivationsdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_reactivationsdaily.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_EP.4) ATS AND EP DASHBOARD DAILY TESTING OUTSIDE OF HOURS
select 'process started:'||clock_timestamp() AS dashboardtestingoutsidehoursdaily;
\copy (select * from dashboardtestingoutsidehoursdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_testingoutsidehoursdaily.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_EP.5) ATS AND EP DASHBOARD DAILY DLM TEST SESSIONS COMPLETED
select 'process started:'||clock_timestamp() AS dashboardstudentscompleteddaily;
\copy (select * from dashboardstudentscompleteddaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_studentscompleteddaily.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_EP.6) ATS AND EP DASHBOARD DAILY INTERIM
select 'process started:'||clock_timestamp() AS dashboardinterimdaily;
select  statename,districtname,districtdbid,schoolname,schooldbid,grade,gradebandname,contentarea,
 roster,rosterdbid,teacher,teacherdbid,operationaltestwindowid,testcollectionname,status,nooftests,nooftests_lastday,nooftests_today
 into temp dailydashboard_interim   
from dashboardinterimdaily ;   
\copy (select * from dailydashboard_interim order by 1,2,4,6,7) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_interim.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_EP.7) ATS AND EP DASHBOARD STUDENTS SESSIONS ASSIGNED
select 'process started:'||clock_timestamp() AS dashboardstudentsassigneddaily;   
\copy (select * from dashboardstudentsassigneddaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_studentsassigneddaily.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


/*
-- DB_ATS.1) ATS AND EP DASHBOARD DAILY DLM FCS DATA
select 'process started:'||clock_timestamp() AS dashboarddlmfcsdaily;
\copy (select * from dashboarddlmfcsdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_dlm.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
     
	 
-- DB_ATS.2) ATS AND EP DASHBOARD DAILY TDE 
select 'process started:'||clock_timestamp() AS dashboardtdedaily;
\copy (select * from dashboardtdedaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_tde.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_ATS.3) ATS AND EP DASHBOARD DAILY KAP ELA AND MATH
select 'process started:'||clock_timestamp() AS dashboardkapelamathdaily;
\copy (select * from dashboardkapelamathdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_kap_ela_math_timestamp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_ATS.4) ATS AND EP DASHBOARD DAILY KAP SCIENCE
select 'process started:'||clock_timestamp() AS dashboardkapscidaily;
drop table if exists dashboardkapscidaily;
\copy (select * from dashboardkapscidaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_kap_science_timestamp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

-- DB_ATS.5) ATS AND EP DASHBOARD DAILY CPASS 
select 'process started:'||clock_timestamp() AS dashboardcpassdaily;
\copy (select * from dashboardcpassdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_cpass_timestamp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
select 'process ended:'||clock_timestamp() AS dailydashboard;

*/
select 'process started:'||clock_timestamp() AS dashboarddlmfcsdaily;
drop table if exists dashboarddlmfcsdaily;
with dlm_std
    as ( select s.id,
         ost.organizationname
                             from student s
                                   inner join enrollment e  on s.id=e.studentid and e.activeflag is true                          
                                inner join organization ost on s.stateid=ost.id  
                                inner join studentassessmentprogram saps ON saps.studentid = s.id 
                                inner join assessmentprogram ap ON ap.id = saps.assessmentprogramid and ap.activeflag is true
                                where     ap.abbreviatedname ='DLM' and s.activeflag is true and saps.activeflag is true and e.currentschoolyear=2018 
       )                             
    select        
         s.organizationname                                                 "STATE_NAME",
         sum(case when categorycode='COMPLETE' then 1 else 0 end )          "COMPLETE",
         sum(case when categorycode='READY_TO_SUBMIT' then 1 else 0 end )   "READY_TO_SUBMIT",
         sum(case when categorycode='IN_PROGRESS' then 1 else 0 end )       "IN_PROGRESS",
         sum(case when categorycode='NOT_STARTED' 
                  or categorycode is null then 1 else 0 end )             "NOT_STARTED",
         count(*)                                                           "TOTAL_FCS",
         count(distinct s.id)                                               "TOTAL_STUDENTS"  
 into dashboarddlmfcsdaily		 
     from dlm_std s
           left outer join survey sr on sr.studentid=s.id and sr.activeflag is true
           left outer join category c on c.id=sr.status
           left outer join categorytype ctype on ctype.id = c.categorytypeid and ctype.typecode = 'SURVEY_STATUS'
           left outer join (select s.id
                             from dlm_std s
                                inner join studentassessmentprogram saps ON saps.studentid = s.id and saps.activeflag is true
                                inner join assessmentprogram ap ON ap.id = saps.assessmentprogramid and ap.activeflag is true
                                where      (organizationname ='Alaska' and ap.abbreviatedname ='AMP')
                                        or (organizationname ='Kansas' and ap.abbreviatedname ='KAP') 
                           group by s.id) ak on ak.id=s.id
           where  ak.id is null
           group by s.organizationname
     order by s.organizationname;
\copy (select * from dashboarddlmfcsdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_dlm.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
     
	 
-- DB_ATS.2) ATS AND EP DASHBOARD DAILY TDE 
select 'process started:'||clock_timestamp() AS dashboardtdedaily;
drop table if exists dashboardtdedaily;
SELECT to_timestamp(floor((extract('epoch' from (startdatetime ) AT TIME ZONE 'US/Central') / 3600 )) * 3600)::timestamp::date as day,
to_char(to_timestamp(floor((extract('epoch' from (startdatetime ) AT TIME ZONE 'US/Central') / 3600 )) * 3600)::Time, 'HH12:MI:SS AM') as time,
COUNT(*) studenttestsectioncount, 
to_timestamp(floor((extract('epoch' from (startdatetime ) AT TIME ZONE 'US/Central') / 3600 )) * 3600) as interval_alias
 into dashboardtdedaily
FROM studentstestsections 
where (startdatetime ) AT TIME ZONE 'US/Central' >= (((current_timestamp at time zone 'US/Central')::date)-1) 
and (startdatetime ) AT TIME ZONE 'US/Central' < ((current_timestamp at time zone 'US/Central')::date) 
and activeflag=true GROUP BY interval_alias order by interval_alias;
\copy (select * from dashboardtdedaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_tde.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

/*
-- DB_ATS.3) ATS AND EP DASHBOARD DAILY KAP ELA AND MATH
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
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10261;
\copy (select * from dashboardkapelamathdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_kap_ela_math_timestamp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


-- DB_ATS.4) ATS AND EP DASHBOARD DAILY KAP SCIENCE
select 'process started:'||clock_timestamp() AS dashboardkapscidaily;
drop table if exists dashboardkapscidaily;
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
  into dashboardkapscidaily
from studentstests st 
inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
inner join testsession ts on st.testsessionid=ts.id 
inner join test t on st.testid=t.id and t.activeflag is true
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10174;
\copy (select * from dashboardkapscidaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_kap_science_timestamp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
*/
-- DB_ATS.5) ATS AND EP DASHBOARD DAILY CPASS 
select 'process started:'||clock_timestamp() AS dashboardcpassdaily;
drop table if exists dashboardcpassdaily;
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
 into dashboardcpassdaily
from studentstests st 
inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
inner join testsession ts on st.testsessionid=ts.id 
inner join test t on st.testid=t.id and t.activeflag is true
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10238;
\copy (select * from dashboardcpassdaily) to '/srv/extracts/helpdesk/dailyvalidation/data/dailydashboard_cpass_timestamp.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select 'process ended:'||clock_timestamp() AS dailydashboard;