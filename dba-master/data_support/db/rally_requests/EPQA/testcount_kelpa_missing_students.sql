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


select s.stateid,sap.assessmentprogramid,e.id cnt 

select count(distinct s.id)
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
left outer join (select testtypename,e.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=19 and st.id=10
group by e.id,testtypename) tmpcc on tmpcc.id=e.id
left outer join (select testtypename,e.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=50 and st.id=10
group by e.id,testtypename) tmp on tmp.id=e.id
where tmp.id is null and e.currentschoolyear=2017  and sap.assessmentprogramid=47 and s.stateid=51;





select s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename,count(*)
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id -- and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and tt.id=19 
group by s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename;


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

--dual enroll kids
select e.sourcetype,e.modifieddate,
 ot.statedisplayidentifier state
,ot.districtname           districtname
,ot.schoolname             schoolname
,gc.name                     grade
,s.id,
s.statestudentidentifier
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and currentschoolyear=2017
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
where s.id in (  564758 ,592574 ,969858 ,1229453 );



-- Find the number of the student received the enroll subjects
select s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename,count(*)
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid in (47,12)
group by s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename;


select s.stateid,sap.assessmentprogramid,st.id,st.subjectareacode,st.subjectareaname,ets.testtypeid,tt.id,tt.testtypename,count(*)
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid in (12)
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

--2017 student tests assignment count validation
--We need operation test windowid in prod
--Need same script by status
--KELPA--main
drop table if exists tmp_epqa;
with cte_std as (
select 
 e.attendanceschoolid          attendanceschoolid
 ,gc.abbreviatedname grade
,count (distinct case when stg.code='Lstng' and ap.id=47 then st.studentid else null end ) stage_Lstng
,count (distinct case when stg.code='Rdng'  and ap.id=47 then st.studentid else null end ) stage_Rdng
,count (distinct case when stg.code='Spkng' and ap.id=47 then st.studentid else null end ) stage_Spkng
,count (distinct case when stg.code='Wrtng' and ap.id=47 then st.studentid else null end)  stage_Wrtng
,count (distinct case when stg.id is not null and ap.id=47 then st.studentid else null end ) stage_all
,count(distinct s.id)         noof_enrolled
,count(distinct case when ets.enrollmentid is not null then s.id else null end)         noof_enrolledsubject
,count(distinct case when ap.id=47 then st.studentid else null end) noof_studenthavetests
,count(distinct case when ap.id=47 then st.id else null end) noof_testscreated
,count (distinct case when ap.id=47 then ccq.studentid else null end) noof_scored  
from student s 
inner join enrollment e on s.id=e.studentid  and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
left outer join (select ets.enrollmentid from enrollmenttesttypesubjectarea ets 
 inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
 inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true
 where sub.id=10 and tt.id=50 group by enrollmentid ) ets on ets.enrollmentid=e.id
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
,stage_Wrtng               stage_Wrtng 
,stage_all                 stage_all
,noof_scored
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

----------------------------------------------------------
--find the kelpa exit clear sent and missing enrollsubject

select 
e.sourcetype--,e.modifieddate
,ot.statedisplayidentifier state
,ot.districtname           districtname
,ot.schoolname             schoolname
,gc.name                     grade
,s.id studentid
,s.statestudentidentifier,
sap.assessmentprogramid,tmpcc.testtypename
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
left outer join (select testtypename,e.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=19 and st.id=10
group by e.id,testtypename) tmpcc on tmpcc.id=e.id
left outer join (select e.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=50 and st.id=10
group by e.id) tmp on tmp.id=e.id
where tmp.id is null and e.currentschoolyear=2017  and sap.assessmentprogramid=47 and s.stateid=51 and e.id is not null
order by s.id;


select 
tmpcc.testtypename,count(s.id)
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
left outer join (select testtypename,e.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=19 and st.id=10
group by e.id,testtypename) tmpcc on tmpcc.id=e.id
left outer join (select e.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=50 and st.id=10
group by e.id) tmp on tmp.id=e.id
where tmp.id is null and e.currentschoolyear=2017  and sap.assessmentprogramid=47 and s.stateid=51
group by tmpcc.testtypename;



select 
tmpcc.testtypename,count(distinct s.id)
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
left outer join (select testtypename,s.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=19 and st.id=10
group by s.id,testtypename) tmpcc on tmpcc.id=s.id
left outer join (select s.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=50 and st.id=10
group by s.id) tmp on tmp.id=e.id
where tmp.id is null and e.currentschoolyear=2017  and sap.assessmentprogramid=47 and s.stateid=51
group by tmpcc.testtypename;



select e.id
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=50 and st.id=10
group by e.id



select 
count(s.id)
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
where e.currentschoolyear=2017  and sap.assessmentprogramid=47 and s.stateid=51

left outer join (select testtypename,e.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=19 and st.id=10
group by e.id,testtypename) tmpcc on tmpcc.id=e.id
left outer join (select e.id 
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true 
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=50 and st.id=10
group by e.id) tmp on tmp.id=e.id
where tmp.id is null and e.currentschoolyear=2017  and sap.assessmentprogramid=47 and s.stateid=51
group by tmpcc.testtypename;


--find the student do not have the records in enrol subject
 select distinct 
tmpcc.testtypename,s.id studentid
,s.statestudentidentifier,e.id enrollid into temp tmp_audit
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
left outer join (select testtypename,e.id
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=19 and st.id=10
group by e.id,testtypename) tmpcc on tmpcc.id=e.id
left outer join (select e.id
from student s
inner join enrollment e on s.id=e.studentid and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id --and ets.activeflag is true
inner join subjectarea st on ets.subjectareaid=st.id and st.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true
where e.currentschoolyear=2017 and sap.assessmentprogramid =47 and tt.id=50 and st.id=10
group by e.id) tmp on tmp.id=e.id
where tmp.id is null and e.currentschoolyear=2017  and sap.assessmentprogramid=47 and s.stateid=51;


select count(distinct studentid),testtypename from tmp_audit group by testtypename;


select count(distinct studentid),testtypename from tmp_audit group by testtypename;

select * from tmp_audit;

\copy (select * from tmp_audit) to 'missing_students_all.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select distinct statestudentidentifier into temp  tmp_ssid_onlynot from tmp_audit 
where statestudentidentifier not in (select statestudentidentifier from tmp_audit where testtypename='Clear test subject indicator');

\copy (select * from tmp_ssid_onlynot) to 'tmp_ssid.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


create temp table tmp_ssid (ssid text );
\COPY tmp_ssid FROM 'tmp_ssid.csv' DELIMITER ',' CSV HEADER ;

select * into temp tmp_final from (SELECT kids.ksdexmlaudit_id as ksdexmlaudit_id, kids.sequence_order sequence_order, kids.create_date AS create_date, kids.record_common_id AS record_common_id, kids.record_type AS record_type, 
   	  kids.state_student_identifier AS state_student_identifier, kids.ayp_qpa_bldg_no AS ayp_qpa_bldg_no, kids.legal_last_name AS legal_last_name, kids.legal_first_name AS legal_first_name,
      kids.legal_middle_name AS legal_middle_name, kids.generation_code AS generation_code, kids.gender AS gender, kids.current_grade_level AS current_grade_level, kids.current_school_year AS current_school_year,
      kids.attendance_bldg_no AS attendance_bldg_no, kids.notes AS notes, kids.district_entry_date AS district_entry_date, kids.school_entry_date AS school_entry_date, kids.state_entry_date AS state_entry_date,
      kids.hispanic_ethnicity AS hispanic_ethnicity, kids.emailsent AS emailsent, kids.emailsentto AS emailsentto, kids.status AS status, kids.birth_date AS birth_date, kids.triggeremail AS triggeremail,
      '' AS educator_bldg_no, '' AS state_subj_area_code, '' AS local_course_id, '' AS course_status, '' AS teacher_identifier, '' AS teacher_last_name, '' AS teacher_first_name,
      '' AS teacher_middle_name, '' AS teacher_district_email, kids.comprehensive_race, kids.primary_exceptionality_code, kids.secondary_exceptionality_code, 
      kids.grouping_math_1, kids.grouping_math_2, kids.grouping_reading_1, kids.grouping_reading_2,
      kids.grouping_science_1, kids.grouping_science_2, kids.grouping_history_1, kids.grouping_history_2, kids.state_math_assess,kids.state_science_assess, kids.animal_systems_assess,
      kids.comprehensive_ag_assess, kids.comprehensive_business_assess, kids.design_preconstruction_assess, kids.ela_proctor_id, kids.ela_proctor_name, kids.elpa21_assess, kids.esol_participation_code,
      kids.finance_assess, kids.general_cte_assess, kids.grouping_animal_systems, kids.grouping_comprehensive_ag, kids.grouping_comprehensive_business, kids.grouping_cte_1, kids.grouping_cte_2,
      kids.grouping_design_preconstruction, kids.grouping_elpa21_1, kids.grouping_elpa21_2, kids.grouping_finance, kids.grouping_manufacturing_prod, kids.grouping_plant_systems,
      kids.manufacturing_prod_assess, kids.math_dlm_proctor_id, kids.math_dlm_proctor_name, kids.plant_systems_assess, kids.science_dlm_proctor_id, kids.science_dlm_proctor_name, 
      kids.state_ela_assess, kids.state_hist_gov_assess, kids.av_communications_assess, kids.grouping_av_communications, kids.financial_literacy_assess, kids.grouping_financial_literacy_1,
      kids.grouping_financial_literacy_2, kids.elpa_proctor_id, kids.elpa_proctor_first_name, kids.elpa_proctor_last_name, kids.exit_withdrawal_type, kids.exit_withdrawal_date
    	FROM kids_record_staging as kids where  state_student_identifier in ( select distinct ssid from tmp_ssid) 
		UNION
		SELECT tasc.ksdexmlaudit_id   AS ksdexmlaudit_id, tasc.sequence_order  AS sequence_order, tasc.create_date  AS create_date, tasc.record_common_id  AS record_common_id,
       tasc.record_type  AS record_type, tasc.state_student_identifier  AS state_student_identifier, tasc.ayp_qpa_bldg_no  AS ayp_qpa_bldg_no, tasc.student_legal_last_name  AS legal_last_name,
       tasc.student_legal_first_name  AS legal_first_name, tasc.student_legal_middle_name  AS legal_middle_name, tasc.student_generation_code  AS generation_code, tasc.student_gender  AS gender,
       tasc.current_grade_level  AS current_grade_level, tasc.current_school_year  AS current_school_year, tasc.attendance_bldg_no  AS attendance_bldg_no, tasc.notes  AS notes, 
       tasc.district_entry_date  AS district_entry_date, tasc.school_entry_date  AS school_entry_date, tasc.state_entry_date  AS state_entry_date, tasc.hispanic_ethnicity  AS hispanic_ethnicity,
       tasc.emailsent  AS emailsent, tasc.emailsentto  AS emailsentto, tasc.status  AS status, tasc.birth_date  AS birth_date, tasc.triggeremail  AS triggeremail,
      tasc.educator_bldg_no, tasc.state_subj_area_code, tasc.local_course_id, tasc.course_status, tasc.teacher_identifier, tasc.teacher_last_name, tasc.teacher_first_name,
      tasc.teacher_middle_name, tasc.teacher_district_email, '' AScomprehensive_race, '' ASprimary_exceptionality_code, '' ASsecondary_exceptionality_code, '' ASgrouping_math_1, 
      '' ASgrouping_math_2, '' ASgrouping_reading_1, '' ASgrouping_reading_2,
      '' ASgrouping_science_1, '' ASgrouping_science_2, '' ASgrouping_history_1, '' ASgrouping_history_2, '' ASstate_math_assess,'' ASstate_science_assess, '' ASanimal_systems_assess,
      '' AScomprehensive_ag_assess, '' AScomprehensive_business_assess, '' ASdesign_preconstruction_assess, '' ASela_proctor_id, '' ASela_proctor_name, '' ASelpa21_assess, '' ASesol_participation_code,
      '' ASfinance_assess, '' ASgeneral_cte_assess, '' ASgrouping_animal_systems, '' ASgrouping_comprehensive_ag, '' ASgrouping_comprehensive_business, '' ASgrouping_cte_1, '' ASgrouping_cte_2,
      '' ASgrouping_design_preconstruction, '' ASgrouping_elpa21_1, '' ASgrouping_elpa21_2, '' ASgrouping_finance, '' ASgrouping_manufacturing_prod, '' ASgrouping_plant_systems,
      '' ASmanufacturing_prod_assess, '' ASmath_dlm_proctor_id, '' ASmath_dlm_proctor_name, '' ASplant_systems_assess, '' ASscience_dlm_proctor_id, '' ASscience_dlm_proctor_name, 
      '' ASstate_ela_assess, '' ASstate_hist_gov_assess, '' ASav_communications_assess, '' ASgrouping_av_communications, '' ASfinancial_literacy_assess, '' ASgrouping_financial_literacy_1,
      '' ASgrouping_financial_literacy_2, '' ASelpa_proctor_id, '' ASelpa_proctor_first_name, '' ASelpa_proctor_last_name, '' ASexit_withdrawal_type, '' ASexit_withdrawal_date
		FROM tasc_record_staging as tasc where  state_student_identifier in ( select distinct ssid from tmp_ssid)
    ) as kidstascrecords ORDER BY  state_student_identifier,ksdexmlaudit_id, sequence_order;

\copy (select * from tmp_final) to 'tmp_final.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);





