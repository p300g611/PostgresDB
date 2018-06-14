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

\copy (select * from tmp_epqa) to 'kelpa_withoutsubject.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);