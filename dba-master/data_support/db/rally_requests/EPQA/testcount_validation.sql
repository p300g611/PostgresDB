--psql -h pg1 -U aart_reader -f "teststatus_by_stage.sql" aart-prod 
select otw.windowname,tc.name as testcollection, stg.name as stage, ts.operationaltestwindowid,
(CASE WHEN st.status=86 THEN 'Complete' WHEN st.status=85 THEN 'In Progress' ELSE 'Not Started' END) as status,count(distinct st.id) count,org.organizationname
into temp teststatus_by_stage
from studentstests st 
inner join student s on s.id=st.studentid
inner join  organization org on org.id=s.stateid 
inner join testsession ts on st.testsessionid=ts.id
inner join testcollection tc on ts.testcollectionid=tc.id
inner join stage stg on stg.id=tc.stageid
inner join operationaltestwindow otw on ts.operationaltestwindowid=otw.id
where st.startdatetime::date BETWEEN '2016-09-01'::date AND NOW()::date
and st.status=ANY ('{86,85,84}'::integer[])
and st.activeflag is true and ts.activeflag is true
group by otw.windowname,tc.name,stg.name,st.status, ts.operationaltestwindowid,org.organizationname
order by otw.windowname,tc.name,stg.name,st.status;
\copy (select * from teststatus_by_stage) to 'teststatus_by_stage.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--Find the distinct student count by assessment program
select s.stateid,sap.assessmentprogramid,count(distinct s.id) cnt 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
where e.currentschoolyear=2017  
group by s.stateid,sap.assessmentprogramid;


--Find the distinct student count by assessment program by school
select s.stateid,e.attendanceschoolid ,sap.assessmentprogramid,count(distinct s.id) cnt into temp tmp_47
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
where e.currentschoolyear=2017  and s.stateid=51 and sap.assessmentprogramid=47
group by s.stateid,sap.assessmentprogramid,e.attendanceschoolid;

--dual enrolled on kelpa
select s.id,count(distinct e.attendanceschoolid ) cnt 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
where e.currentschoolyear=2017  and s.stateid=51 and sap.assessmentprogramid=47
group by s.id
having count( distinct e.attendanceschoolid )>1;



-- Find the number of the student received the enroll subjects
select s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename,count(*)
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid  in (47,12)
group by s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename;


select s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename,count(*)
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid in (47,12)
group by s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename;

--scorinf script from change pond
Select stg.name,count(sa.*) from scoringassignment sa
inner join testsession ts on ts.id = sa.testsessionid and ts.activeflag is true
inner join testcollection tc on tc.id = ts.testcollectionid and tc.activeflag is true
inner join assessmentstestcollections asmnttc on asmnttc.testcollectionid = ts.testcollectionid and asmnttc.activeflag is true
inner join assessment asmnt on asmnt.id = asmnttc.assessmentid and asmnt.activeflag is true
inner join testingprogram tp on tp.id = asmnt.testingprogramid and tp.activeflag is true
inner join assessmentprogram ap on ap.id = tp.assessmentprogramid and ap.activeflag is true
inner join stage stg  on stg.id=ts.stageid
where ap.abbreviatedname ilike 'K-ELPA' and (sa.rosterid is not null or sa.source = 'BATCHAUTO') and sa.activeflag is true
and stg.code in ('Wrtng','Spkng','Lstng')
group by  stg.name;

--KELPA SQLITE
select distinct
 scs.id scoringassignmentstudentid
,scs.studentid
,scs.studentstestsid
,scs.scoringassignmentid
,sc.testsessionid
,stg.code stagecode
,ccq.totalscore
,ccq.source
,ccq.status
,c.categorycode
,ccqi.ccqscoreid
,ccqi.taskvariantid
,ccqi.nonscoringreason
,ccqi.score
into temp tmp_epqa
from scoringassignmentstudent scs 
inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
inner join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and ccq.scoringassignmentscorerid=sc.id and ccq.activeflag is true
inner join ccqscoreitem ccqi on ccqi.ccqscoreid=ccq.id and ccqi.activeflag is true
inner join testsession ts on ts.id = sc.testsessionid and ts.activeflag is true
inner join testcollection tc on tc.id = ts.testcollectionid and tc.activeflag is true
inner join assessmentstestcollections asmnttc on asmnttc.testcollectionid = ts.testcollectionid and asmnttc.activeflag is true
inner join assessment asmnt on asmnt.id = asmnttc.assessmentid and asmnt.activeflag is true
inner join testingprogram tp on tp.id = asmnt.testingprogramid and tp.activeflag is true
inner join assessmentprogram ap on ap.id = tp.assessmentprogramid and ap.activeflag is true
inner join stage stg  on stg.id=ts.stageid
inner join category c on c.id=ccq.status and c.activeflag is true
where ap.id=47 and (sc.rosterid is not null or sc.source = 'BATCHAUTO') and sc.activeflag is true
and (stg.code ='Wrtng' or stg.code ='Spkng');


\copy (select * from tmp_epqa) to 'studentstestscoring.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--2017 student tests assignment count validation
--We need operation test windowid in prod
--Need same script by status
--KELPA--main
drop table if exists tmp_epqa;
with cte_std as (
select 
 e.attendanceschoolid          attendanceschoolid
 ,gc.abbreviatedname grade
 ,count(distinct s.id)         noof_enrolled
,count(distinct case when ets.enrollmentid is not null then s.id else null end) noof_enrolledsubject
,count(distinct case when ap.id=47 then st.studentid else null end) noof_studenthavetests
,count(distinct case when ap.id=47 then st.id else null end) noof_testscreated
,count (distinct case when stg.code='Lstng' and ap.id=47 then st.studentid else null end ) stage_Lstng
,count (distinct case when stg.code='Rdng'  and ap.id=47 then st.studentid else null end ) stage_Rdng
,count (distinct case when stg.code='Spkng' and ap.id=47 then st.studentid else null end ) stage_Spkng
,count (distinct case when stg.code='Spkng' and ap.id=47 and ccq.studentstestsid is not null then st.studentid else null end ) stage_Spkng_score
,count (distinct case when stg.code='Wrtng' and ap.id=47 then st.studentid else null end)  stage_Wrtng
,count (distinct case when stg.code='Wrtng' and ap.id=47 and ccq.studentstestsid is not null then st.studentid else null end)  stage_Wrtng_score
,count (distinct case when stg.id is not null and ap.id=47 then st.studentid else null end ) stage_all
,count (distinct case when ap.id=47 and ccq.studentstestsid is not null then st.studentid else null end)  stage_all_score
from student s 
inner join enrollment e on s.id=e.studentid  and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true and sub.id=10 and tt.id=50  
left outer join studentstests st on st.enrollmentid=e.id and s.id=st.studentid and st.activeflag is true 
left outer join testsession ts on st.testsessionid=ts.id and ts.activeflag is true and ts.schoolyear=2017 
and ts.source='BATCHAUTO' --and ts.operationaltestwindowid=10168
left outer join (select sc.testsessionid,scs.studentstestsid,count(distinct scs.studentid) studentid
from scoringassignmentstudent scs 
inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
where sc.rosterid is not null  
group by sc.testsessionid,scs.studentstestsid) ccq on ccq.testsessionid=ts.id and ccq.studentstestsid=st.id
left outer join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  and ap.id=47
where 
 e.currentschoolyear=2017 and sap.assessmentprogramid=47
 group by e.attendanceschoolid,gc.abbreviatedname)
 select
 ot.statedisplayidentifier state
,ot.districtname           districtname
,ot.schoolname             schoolname
,grade                     grade
,noof_enrolled             noof_enrolled
,noof_enrolledsubject      noof_enrolledsubject
,noof_studenthavetests     noof_studenthavetests
,noof_testscreated         noof_testscreated
,stage_Lstng               stage_Lstng   
,stage_Rdng                stage_Rdng   
,stage_Spkng               stage_Spkng   
,stage_Spkng_score         stage_Spkng_score
,stage_Wrtng               stage_Wrtng 
,stage_Wrtng_score         stage_Wrtng_score
,stage_all                 stage_all
,stage_all_score
into temp tmp_epqa
from cte_std tmp
inner join organizationtreedetail ot on ot.schoolid=tmp.attendanceschoolid 
where ot.stateid=51
order by 1,2,3,4;

\copy (select * from tmp_epqa) to 'kelpa_epqa.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--KAP
DROP table if exists tmp_epqa;
with cte_std as (
select 
  e.attendanceschoolid          attendanceschoolid
 ,gc.abbreviatedname            grade
 ,sub.subjectareacode           subjectareacode
,count (distinct case when stg.code='Stg1'  and ap.id=12 then st.studentid else null end ) stage_Stg1
,count (distinct case when stg.code='Stg2'  and ap.id=12 then st.studentid else null end ) stage_Stg2
,count (distinct case when stg.code='Prfrm' and ap.id=12 then st.studentid else null end ) stage_Prfrm
,count (distinct case when stg.code='Stg3'  and ap.id=12 then st.studentid else null end) stage_Stg3
,count (distinct case when stg.code='Stg4'  and ap.id=12 then st.studentid else null end) stage_Stg4
,count (distinct case when stg.id is not null and ap.id=12 then st.studentid else null end ) stage_all
,count(distinct s.id)         noof_enrolled
,count(distinct case when ap.id=12 then st.studentid else null end) noof_studenthavetests
,count(distinct case when ap.id=12 then st.id else null end) noof_testscreated
from student s 
inner join enrollment e on s.id=e.studentid  and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id and ets.activeflag is true
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true  	 	
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
left outer join studentstests st on st.enrollmentid=e.id and s.id=st.studentid and st.activeflag is true 
left outer join testsession ts on st.testsessionid=ts.id and ts.activeflag is true and ts.schoolyear=2017 
and ts.source='BATCHAUTO' --and ts.operationaltestwindowid=10168
left outer join (select sc.testsessionid,scs.studentstestsid,count(distinct scs.studentid) studentid
from scoringassignmentstudent scs 
inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
inner join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and ccq.scoringassignmentscorerid=sc.id and ccq.activeflag is true
where sc.rosterid is not null  
group by sc.testsessionid,scs.studentstestsid) ccq on ccq.testsessionid=ts.id and ccq.studentstestsid=st.id
left outer join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  and ap.id=12
where 
 e.currentschoolyear=2017  
  and sap.assessmentprogramid=12  
  and (sub.id =1 or sub.id =17)
  and  tt.id=2 group by e.attendanceschoolid,gc.abbreviatedname,sub.subjectareacode)
 select
 ot.statedisplayidentifier state
,ot.districtname           districtname
,ot.schoolname             schoolname
,grade                     grade
,subjectareacode           subjectareacode
,noof_enrolled             noof_enrolled
,noof_studenthavetests     noof_studenthavetests
,noof_testscreated         noof_testscreated
,stage_Stg1                stage_Stg1   
,stage_Stg2                stage_Stg2   
,stage_Prfrm               stage_Prfrm   
,stage_Stg3                stage_Stg3   
,stage_Stg4                stage_Stg4 
,stage_all                 stage_all
into temp tmp_epqa
from cte_std tmp
inner join organizationtreedetail ot on ot.schoolid=tmp.attendanceschoolid 
where ot.stateid=51
order by 1,2,3,4;

\copy (select * from tmp_epqa) to 'kelpa_epqa.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);