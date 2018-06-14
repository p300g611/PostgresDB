-- 1) ATS AND EP DASHBOARD DAILY TESTING SUMMARY COUNTS
select 'process started:'||clock_timestamp() AS dashboardnewsessionsdaily;
drop table if exists dashboardnewsessionsdaily;
with optid as (select coalesce(max(otw.id),0) id from operationaltestwindow otw 
inner join operationaltestwindowstate otws on otw.id = otws.operationaltestwindowid and otws.stateid = (select id from organization where displayidentifier='KS')
inner join assessmentprogram ap on ap.id=otw.assessmentprogramid and ap.abbreviatedname='KAP'
where otw.windowname ~* 'interim' and otw.windowname ~* 'predictive'  and otw.effectivedate < now() 
union 
select coalesce(max(otw.id),0) id from operationaltestwindow otw 
inner join operationaltestwindowstate otws on otw.id = otws.operationaltestwindowid and otws.stateid = (select id from organization where displayidentifier='KS')
inner join assessmentprogram ap on ap.id=otw.assessmentprogramid and ap.abbreviatedname='KAP'
where otw.windowname ~* 'interim' and otw.windowname ~* 'Instructional' and otw.effectivedate < now()
union 
select coalesce(operationaltestwindowid,0) id from dashboardconfig  where configcode='assigned' -- ALL Assessmentprogram Assigned
 ),tmp_test_cnt as( 
select st.enrollmentid,st.id,ts.testcollectionid,operationaltestwindowid,ts.stageid,st.status,ts.source,st.enddatetime
from studentstests st
inner join testsession ts on st.testsessionid=ts.id
inner join optid opt on opt.id=ts.operationaltestwindowid
where st.status in (84,85,86,659)    
and st.startdatetime::date 
BETWEEN (select configvalue::date from dashboardconfig  where configcode='startdatetime' and dashboardentityname='General')
 AND (select coalesce(configvalue::date,now()::date) from dashboardconfig  where configcode='endtime' and dashboardentityname='General')
and st.activeflag is true and ts.activeflag is true),

kap_allstg as (
select st_in.studentid,count(distinct stg_in.id) from studentstests st_in 
inner join testsession ts_in on st_in.testsessionid=ts_in.id and ts_in.activeflag is true
inner join stage stg_in on stg_in.id=ts_in.stageid 
where st_in.status=86 
and ts_in.schoolyear=(select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General')
and stg_in.code in ('Stg1','Stg2','Prfrm') and st_in.activeflag is true 
group by st_in.studentid 
having count(distinct stg_in.id)>1)
select ot.statename,st.operationaltestwindowid,ca.name contentarea, ca.id contentareaid
,tc.name testcollectionname,gc.name grade,gb.name gradebandname,st.status
,schoolid,schoolname,districtid,districtname,stateid,st.source,stg.name stagename
,ap.programname assessmentprogram , ap.id assessmentprogramid
,count(distinct case when st.enddatetime::date=NOW()::date-1 then st.id else null end ) nooftests_lastday
,count(distinct case when st.enddatetime::date=NOW()::date then st.id else null end ) nooftests_today
,count(distinct st.id) nooftests
,count(distinct case when (stg.code='Stg2' or stg.code='Prfrm') and st.status=86 then kapstg.studentid else null end ) nostage2testscompleted
into dashboardnewsessionsdaily
from tmp_test_cnt st
inner join enrollment e on st.enrollmentid=e.id and e.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join testcollection tc on st.testcollectionid=tc.id
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT outer JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  
left outer join contentarea ca on tc.contentareaid=ca.id
left outer join gradecourse gc on tc.gradecourseid=gc.id
left outer join gradeband gb on tc.gradebandid=gb.id
left outer join kap_allstg kapstg on kapstg.studentid=e.studentid
group by ot.statename,st.operationaltestwindowid,ca.name,ca.id 
,tc.name ,gc.name ,gb.name ,st.status
,schoolid,schoolname,districtid,districtname,stateid,st.source,stg.name 
,ap.programname ,ap.id;

-- 2) ATS AND EP DASHBOARD DAILY STUDENT SCORING
select 'process started:'||clock_timestamp() AS dashboardstudentscoringdaily;
drop table if exists dashboardstudentscoringdaily;
with tmp_kelpa as (
select st_in.studentid, count(distinct stg_in.id)
from studentstests st_in 
inner join testsession ts_in on st_in.testsessionid=ts_in.id and ts_in.activeflag is true
inner join stage stg_in on stg_in.id =ts_in.stageid 
where st_in.activeflag is true and st_in.status=86 and stg_in.code in ('Lstng','Rdng','Spkng','Wrtng') 
and ts_in.schoolyear =(select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General')
group by st_in.studentid
having count(distinct stg_in.id)>=4),
tmp_testsession as (
select distinct st.id,st.studentid,st.status,st.enddatetime,st.enrollmentid,ts.name testsessionname,tc.name testcollectionname,ap.id assessmentprogramid
,ap.programname assessmentprogram,stg.id stageid,stg.name stagename
,ca.name,ca.id contentareaid
from studentstests st
inner join testsession ts on ts.id =st.testsessionid and ts.activeflag is true
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join contentarea ca on tc.contentareaid=ca.id
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join assessmentstestcollections atc ON tc.id = atc.testcollectionid
inner join assessment a ON atc.assessmentid = a.id 
inner join testingprogram tp ON a.testingprogramid = tp.id 
inner JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id 
where st.activeflag is true and ts.schoolyear =(select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General')
and ap.id in (47,11,12)
AND ca.name = case when ap.id=12 then 'Social Studies' else ca.name end
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (select operationaltestwindowid from dashboardconfig  where configcode='scoring')
)
select distinct 
 s.statestudentidentifier ssid
,s.legalfirstname
,s.legallastname
,s.id studentid
,ort.schoolname schoolname
,ort.districtname districtname
,gc.abbreviatedname grade
,e.activeflag  enrollflag
,tmpts.id studenttestid
,tmpts.status ststatus
,tmpts.testsessionname
,tmpts.testcollectionname
,(case when ccq.studentstestsid is null then 'no' else 'yes' end )  scored
,ccq.status scorestatus
,ort.schoolid schoolid
,ort.districtid districtid
,ort.stateid stateid
,ort.statename statename
,tmpts.assessmentprogram 
,tmpts.assessmentprogramid
,tmpts.stageid
,tmpts.stagename
,tmpts.enddatetime 
,tmpts.name contentarea
,tmpts.contentareaid
,(case when tmp.studentid is not null then s.id else null end )  studentid_kelpa_allsessions
,now() createddate 
,ccq_modifieddate   
into dashboardstudentscoringdaily    	   
from  tmp_testsession tmpts 
inner join enrollment e on e.studentid=tmpts.studentid and e.id=tmpts.enrollmentid and e.activeflag is true
inner join student s on e.studentid=s.id and s.activeflag is true
inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
left outer join (select sc.testsessionid,scs.studentstestsid,scs.kelpascoringstatus as status,max(scs.modifieddate) ccq_modifieddate
from scoringassignmentstudent scs 
inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
group by sc.testsessionid,scs.studentstestsid,scs.kelpascoringstatus) ccq on  ccq.studentstestsid=tmpts.id
left join tmp_kelpa tmp on tmp.studentid =s.id  
where e.currentschoolyear=(select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General') 
order by ort.districtname,ort.schoolname,s.id;

-- 3) ATS AND EP DASHBOARD DAILY REACTIVATION TESTS 
select 'process started:'||clock_timestamp() AS dashboardreactivationsdaily;
drop table if exists dashboardreactivationsdaily;
with tmp_test as (select st.studentid,st.enrollmentid,st.id studentstestsid,ts.id testsessionid,ts.name testsessionname,stg.name stagename,
gc.abbreviatedname grade,gc.id gradecourseid,gb.id gradebandid,gb.abbreviatedname gradeband,t.testname ,
tc.contentareaid subjectareaid,ca.name subject,startdatetime,enddatetime,sth.id studentstestshistoryid,
ap.programname assessmentprogram , ap.id assessmentprogramid,sth.action,sth.acteddate,sth.acteduser,ts.source, ts.operationaltestwindowid
from studentstests st
join test t on t.id=st.testid
join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join assessmentstestcollections atc ON tc.id = atc.testcollectionid
inner join assessment a ON atc.assessmentid = a.id 
inner join testingprogram tp ON a.testingprogramid = tp.id 
inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id  
inner join contentarea ca on tc.contentareaid=ca.id
inner join studentstestshistory sth on sth.studentstestsid = st.id
left outer join gradecourse gc on tc.gradecourseid=gc.id
left outer join gradeband gb on tc.gradebandid=gb.id
left outer join stage stg on stg.id=ts.stageid and stg.activeflag is true
where ts.activeflag is true and st.activeflag is true
and ts.schoolyear=(select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General')
and sth.acteddate>=(select coalesce(configvalue::timestamp,now()) from dashboardconfig  where configcode='endtime' and dashboardentityname='General')-interval '24 hour' 
and sth.action='REACTIVATION' )
select distinct
s.legalfirstname|| ' ' ||s.legallastname studentname,
s.statestudentidentifier,
st.studentid,
ort.stateid,
ort.statename,
ort.districtname,
ort.districtid,
ort.schoolname,
ort.schoolid,
st.grade,
st.gradecourseid,
st.gradebandid,
st.gradeband,
st.subjectareaid,
st.subject,
st.startdatetime,
st.enddatetime,
st.assessmentprogram , 
st.assessmentprogramid,
st.studentstestsid,
st.testsessionid,
st.testsessionname,
st.action,
st.acteddate,
st.acteduser,
au.id reactivatedbyid,
au.firstname || ' '||au.surname reactivatedby,
st.studentstestshistoryid,
st.stagename,
st.testname,
st.source,
st.operationaltestwindowid,
now() createddate
into dashboardreactivationsdaily
from tmp_test st 
inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
inner join student s on s.id=e.studentid
inner join organizationtreedetail ort on ort.schoolid=e.attendanceschoolid
inner join aartuser au on au.id=st.acteduser;

-- 4) ATS AND EP DASHBOARD DAILY TESTING OUTSIDE OF HOURS
select 'process started:'||clock_timestamp() AS dashboardtestingoutsidehoursdaily;
drop table if exists dashboardtestingoutsidehoursdaily;
with std_test as (
select st.id studentstestsid,st.studentid,st.enrollmentid,ts.testcollectionid,ts.id testsessionid,ts.name testsessionname, ort.id schoolid,ts.stageid,st.testid
,case when c.categorycode='US/Eastern'  then st.startdatetime AT TIME ZONE 'US/Eastern'  
      when c.categorycode='US/Alaska'   then st.startdatetime AT TIME ZONE 'US/Alaska' 
      when c.categorycode='US/Mountain' then st.startdatetime AT TIME ZONE 'US/Mountain'
      when c.categorycode='US/Pacific'  then st.startdatetime AT TIME ZONE 'US/Pacific'  
      when c.categorycode='US/Hawaii'   then st.startdatetime AT TIME ZONE 'US/Hawaii'
      else st.startdatetime AT TIME ZONE 'US/Central'  end startdatetime_local
,case when c.categorycode='US/Eastern'  then st.enddatetime AT TIME ZONE 'US/Eastern'  
      when c.categorycode='US/Alaska'   then st.enddatetime AT TIME ZONE 'US/Alaska' 
      when c.categorycode='US/Mountain' then st.enddatetime AT TIME ZONE 'US/Mountain'
      when c.categorycode='US/Pacific'  then st.enddatetime AT TIME ZONE 'US/Pacific'  
      when c.categorycode='US/Hawaii'   then st.enddatetime AT TIME ZONE 'US/Hawaii'
      else st.enddatetime AT TIME ZONE 'US/Central'  end enddatetime_local 
      ,st.startdatetime,st.enddatetime     
from studentstests st 
inner join enrollment e on st.studentid=e.studentid and e.id=st.enrollmentid and e.activeflag is true
inner join organization ort on ort.id=e.attendanceschoolid
inner join category c on c.id=ort.timezoneid      
inner join testsession ts on st.testsessionid=ts.id 
where ts.activeflag is true 
and ts.schoolyear=(select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General')
and st.activeflag is true  
and startdatetime>=(select coalesce(configvalue::timestamp,now()) from dashboardconfig  where configcode='endtime' and dashboardentityname='General')-interval '24 hour'     
)
select distinct
s.legalfirstname|| ' ' ||s.legallastname studentname,
s.statestudentidentifier,
st.studentid,
ort.stateid,
ort.statename,
ort.districtname,
ort.districtid,
ort.schoolname,
ort.schoolid,
gc.abbreviatedname grade,
gc.id gradecourseid,
gb.id gradebandid,
gb.abbreviatedname gradeband,
tc.contentareaid subjectareaid,
ca.name subject,
ap.programname assessmentprogram , 
ap.id assessmentprogramid,
st.studentstestsid studentstestsid,
st.testsessionid testsessionid,
st.testsessionname testsessionname,
st.startdatetime,
st.enddatetime,
stg.name stagename,
t.testname testname,
now() createddate
into dashboardtestingoutsidehoursdaily
from std_test st 
inner join test t on t.id=st.testid
inner join student s on s.id=st.studentid
inner join organizationtreedetail ort on ort.schoolid=st.schoolid
inner join testcollection tc on st.testcollectionid=tc.id and tc.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT outer JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  
left outer join contentarea ca on tc.contentareaid=ca.id
left outer join gradecourse gc on tc.gradecourseid=gc.id
left outer join gradeband gb on tc.gradebandid=gb.id
left outer join stage stg on stg.id=st.stageid and stg.activeflag is true
where (  extract(HOUR from st.startdatetime_local )>=17
      or extract(HOUR from st.startdatetime_local )<6 
      or extract(HOUR from st.enddatetime_local )>=17
      or extract(HOUR from st.enddatetime_local )<6
      or extract(dow from st.startdatetime_local ) in (0,6)
      or extract(dow from st.enddatetime_local ) in (0,6))
and not exists (select 1 from organizationtreedetail tgt where tgt.schoolname ilike '%virtu%' and ort.schoolid=tgt.schoolid);

-- 5) ATS AND EP DASHBOARD DAILY DLM TEST SESSIONS COMPLETED
select 'process started:'||clock_timestamp() AS dashboardstudentscompleteddaily;
drop table if exists dashboardstudentscompleteddaily;
WITH schoolswithdlmkids AS (
	  SELECT DISTINCT
	    ap.id assessmentprogramid, ap.programname assessmentprogram, otd.schoolid, otd.schoolname, otd.schooldisplayidentifier, otd.districtid, otd.districtname, otd.districtdisplayidentifier, otd.stateid, otd.statename,
	    otd.statedisplayidentifier
	  FROM organizationtreedetail otd
	  JOIN enrollment e ON e.attendanceschoolid = otd.schoolid
	  JOIN studentassessmentprogram sap ON e.studentid = sap.studentid
	  JOIN assessmentprogram ap ON sap.assessmentprogramid = ap.id
	  WHERE e.activeflag = TRUE
	  AND sap.activeflag = TRUE
	  AND ap.abbreviatedname = 'DLM'
	  AND e.currentschoolyear = (select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General')
	)
	SELECT distinct sch.assessmentprogramid, sch.assessmentprogram, conArea.name AS subject, conArea.id AS subjectid,
	  r.attendanceschoolid, sch.schoolname, sch.schooldisplayidentifier, sch.districtid, sch.districtname, sch.districtdisplayidentifier, sch.stateid, sch.statename, sch.statedisplayidentifier,
	  gc.name AS grade, gc.id AS gradeid, gc.abbreviatedname AS gradelevel,ts.source, count(distinct stu.id) AS countstudentscompleted, now() as createddate
      INTO dashboardstudentscompleteddaily 
	FROM student stu
	INNER JOIN studentassessmentprogram sap ON sap.studentid = stu.id
	INNER JOIN enrollment e ON stu.id = e.studentid
	INNER JOIN schoolswithdlmkids sch ON e.attendanceschoolid = sch.schoolid
	INNER JOIN enrollmentsrosters er ON e.id = er.enrollmentid
	INNER JOIN roster r ON er.rosterid = r.id AND e.currentschoolyear = r.currentschoolyear
	INNER JOIN contentarea conArea ON conArea.id = r.statesubjectareaid
	INNER JOIN gradecourse gc ON e.currentgradelevel = gc.id
	LEFT JOIN studentstests st ON stu.id = st.studentid AND e.id = st.enrollmentid AND st.activeflag = TRUE
	LEFT JOIN category ststatus ON st.status = ststatus.id
	LEFT JOIN test t ON st.testid = t.id AND conArea.id = t.contentareaid
	LEFT JOIN testspecification tspec ON t.testspecificationid = tspec.id AND tspec.id IS NOT NULL
	LEFT JOIN testsession ts ON st.testsessionid = ts.id AND r.id = ts.rosterid AND e.currentschoolyear = ts.schoolyear AND ts.activeflag = TRUE
	LEFT JOIN testcollection tc ON st.testcollectionid = tc.id AND tc.phasetype IN ('EOY', 'INSTRUCTIONAL') AND tc.contentareaid = conArea.id
	LEFT JOIN operationaltestwindow otw
	  ON ts.operationaltestwindowid = otw.id
	  AND otw.testenrollmentmethodid != (SELECT id FROM testenrollmentmethod WHERE methodcode = 'MLTASGNFT')
	where sap.activeflag = true
	and stu.activeflag = true
	and e.activeflag = true
	and er.activeflag = true
	and r.activeflag = true
	and e.currentschoolyear = (select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General')
	AND sap.assessmentprogramid = (select id from assessmentprogram where abbreviatedname = 'DLM')
	AND conArea.abbreviatedname IN ('M', 'ELA', 'Sci', 'SS')
    and st.startdatetime::date BETWEEN (select configvalue::date from dashboardconfig  where configcode='startdatetime' and dashboardentityname='General')
         AND (select coalesce(configvalue::date,now()::date) from dashboardconfig  where configcode='endtime' and dashboardentityname='General')
    and tspec.minimumnumberofees is not null
	GROUP BY sch.assessmentprogramid, sch.assessmentprogram, conArea.name, conArea.id, sch.stateid, sch.statename,  sch.statedisplayidentifier,sch.districtid, r.attendanceschoolid, sch.schoolname, sch.districtname, sch.districtdisplayidentifier,
	  sch.schooldisplayidentifier, gc.name, gc.id, gc.abbreviatedname,ts.source,tspec.minimumnumberofees
    HAVING (tspec.minimumnumberofees - COUNT(CASE WHEN tc.phasetype = 'EOY' AND ststatus.categorycode = 'complete' THEN 1 ELSE 0 END) = 0);

-- 6) ATS AND EP DASHBOARD DAILY INTERIM
select 'process started:'||clock_timestamp() AS dashboardinterimdaily;
drop table if exists dashboardinterimdaily;
with optid as (select coalesce(max(otw.id),0) id from operationaltestwindow otw 
inner join operationaltestwindowstate otws on otw.id = otws.operationaltestwindowid and otws.stateid = (select id from organization where displayidentifier='KS')
inner join assessmentprogram ap on ap.id=otw.assessmentprogramid and ap.abbreviatedname='KAP'
where otw.windowname ~* 'interim' and otw.windowname ~* 'predictive'  and otw.effectivedate < now() 
union 
select coalesce(max(otw.id),0) id from operationaltestwindow otw 
inner join operationaltestwindowstate otws on otw.id = otws.operationaltestwindowid and otws.stateid = (select id from organization where displayidentifier='KS')
inner join assessmentprogram ap on ap.id=otw.assessmentprogramid and ap.abbreviatedname='KAP'
where otw.windowname ~* 'interim' and otw.windowname ~* 'Instructional' and otw.effectivedate < now())
,tmp_test_cnt as ( 
select e.attendanceschoolid,ts.operationaltestwindowid,tc.contentareaid,tc.name testcollectionname,
tc.gradecourseid,tc.gradebandid,ts.rosterid,st.status,count(distinct st.id) nooftests
,count(distinct case when st.enddatetime::date=NOW()::date-1 then st.id else null end ) nooftests_lastday
,count(distinct case when st.enddatetime::date=NOW()::date then st.id else null end ) nooftests_today
,ap.programname assessmentprogram 
,ap.id assessmentprogramid
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id
inner join optid opt on opt.id=ts.operationaltestwindowid
inner join enrollment e on  st.enrollmentid=e.id and st.studentid=e.studentid and e.activeflag is true
inner join student s on s.id=e.studentid
inner join testcollection tc on ts.testcollectionid=tc.id
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id 
where  ts.schoolyear=(select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General') and
st.status in (84,85,86) 
and st.startdatetime::date BETWEEN (select configvalue::date from dashboardconfig  where configcode='startdatetime' and dashboardentityname='General')
         AND (select coalesce(configvalue::date,now()::date) from dashboardconfig  where configcode='endtime' and dashboardentityname='General')
and st.activeflag is true and ts.activeflag is true 
group by e.attendanceschoolid,ts.operationaltestwindowid,tc.contentareaid,tc.name,
tc.gradecourseid,tc.gradebandid,ts.rosterid,st.status,ap.programname,ap.id
)
select ot.statename,ot.stateid statedbid,ot.districtname,ot.districtid districtdbid,ot.schoolname,schoolid schooldbid,gc.name grade,gb.name gradebandname,ca.name contentarea,ca.id contentareaid,
r.coursesectionname roster,r.id rosterdbid,a.firstname || ' '||a.surname Teacher,a.id teacherdbid,st.operationaltestwindowid,testcollectionname,
CASE WHEN st.status=86 THEN 'Complete' WHEN st.status=85 THEN 'In Progress'  ELSE 'Not Started' END as status
,assessmentprogram,assessmentprogramid
,nooftests,nooftests_lastday,nooftests_today
 into dashboardinterimdaily   
from tmp_test_cnt st
inner join organizationtreedetail ot on st.attendanceschoolid=ot.schoolid
left outer join roster r on st.rosterid =r.id
left outer join aartuser a on a.id=r.teacherid
left outer join contentarea ca on st.contentareaid=ca.id
left outer join gradecourse gc on st.gradecourseid=gc.id
left outer join gradeband gb on st.gradebandid=gb.id;
 
-- 7) ATS AND EP DASHBOARD STUDENTS SESSIONS ASSIGNED
select 'process started:'||clock_timestamp() AS dashboardstudentsassigneddaily;
drop table if exists dashboardstudentsassigneddaily;
with optid as (select coalesce(max(otw.id),0) id from operationaltestwindow otw 
inner join operationaltestwindowstate otws on otw.id = otws.operationaltestwindowid and otws.stateid = (select id from organization where displayidentifier='KS')
inner join assessmentprogram ap on ap.id=otw.assessmentprogramid and ap.abbreviatedname='KAP'
where otw.windowname ~* 'interim' and otw.windowname ~* 'predictive'  and otw.effectivedate < now() 
union 
select coalesce(max(otw.id),0) id from operationaltestwindow otw 
inner join operationaltestwindowstate otws on otw.id = otws.operationaltestwindowid and otws.stateid = (select id from organization where displayidentifier='KS')
inner join assessmentprogram ap on ap.id=otw.assessmentprogramid and ap.abbreviatedname='KAP'
where otw.windowname ~* 'interim' and otw.windowname ~* 'Instructional' and otw.effectivedate < now()
union 
select coalesce(operationaltestwindowid,0) id from dashboardconfig  where configcode='assigned' -- ALL Assessmentprogram Assigned
 )
select ap.programname as assessmentprogram, ap.id as assessmentprogramid,
CASE WHEN ca.abbreviatedname = 'ELP' THEN stg.name ELSE ca.name END as contentarea, 
ca.id as contentareaid,
gc.name grade, 
gc.id gradeid,
gc.gradelevel,
ts.operationaltestwindowid,
ts.source,
stg.name stagename,
count(distinct st.id) as sessionsassignedyear, 
count(distinct st.studentid) as studentsassignedyear,
ort.stateid, ort.statename, ort.statedisplayidentifier, ort.districtid, ort.districtname, ort.districtdisplayidentifier, 
ort.schoolid, ort.schoolname, ort.schooldisplayidentifier, now() as createddate
into dashboardstudentsassigneddaily
from studentstests st
join testsession ts on st.testsessionid = ts.id
inner join enrollment e on st.enrollmentid=e.id and e.activeflag is true
inner join optid opt on opt.id=ts.operationaltestwindowid
join operationaltestwindow otw on otw.id=ts.operationaltestwindowid
join assessmentprogram ap on ap.id=otw.assessmentprogramid
join testcollection tc on ts.testcollectionid = tc.id
join contentarea ca on tc.contentareaid = ca.id
left outer join gradecourse gc on tc.gradecourseid = gc.id
left outer join gradeband gb on tc.gradebandid = gb.id
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
join organizationtreedetail ort on e.attendanceschoolid=ort.schoolid
where st.activeflag = true
and ts.schoolyear=(select configvalue::bigint from dashboardconfig  where configcode='schoolyear' and dashboardentityname='General')
and st.createddate::date<=(select coalesce(configvalue::date,now()::date) from dashboardconfig  where configcode='endtime' and dashboardentityname='General')
group by ap.programname, ap.id, ca.name,ca.abbreviatedname, ca.id, gc.name, gc.id, gc.gradelevel,ts.operationaltestwindowid,
ts.source, stg.name,ort.stateid, ort.statename, ort.districtid, ort.districtname, ort.schoolid, ort.schoolname,stg.name;
select 'process ended:'||clock_timestamp() as dailydashboard_EP;
