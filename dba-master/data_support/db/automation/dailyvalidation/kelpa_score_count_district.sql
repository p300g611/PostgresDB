drop table if exists  dailydashboard_kelpa_scoring;
with cte_std as (
select 
 e.attendanceschoolid          attendanceschoolid
 ,gc.abbreviatedname grade
 ,count(distinct s.id)         noof_enrolled
,count(distinct case when ets.enrollmentid is not null then s.id else null end) noof_enrolledsubject
,count(distinct case when ap.id=47 then st.studentid else null end) noof_studenthavetests
,count(distinct case when ap.id=47 and st.status=84 then st.studentid else null end) noof_unusedtests
,count(distinct case when ap.id=47 and st.status=85 then st.studentid else null end) noof_inprogresstests
,count(distinct case when ap.id=47 and st.status=86 then st.studentid else null end) noof_completedtests
,count(distinct case when ap.id=47 then st.id else null end) noof_testscreated
,count (distinct case when stg.code='Lstng' and ap.id=47 then st.studentid else null end ) stage_Lstng
,count (distinct case when stg.code='Rdng'  and ap.id=47 then st.studentid else null end ) stage_Rdng
,count (distinct case when stg.code='Spkng' and ap.id=47 then st.studentid else null end ) stage_Spkng
,count (distinct case when stg.code='Spkng' and ap.id=47 and ccq.studentstestsid is not null then st.studentid else null end ) stage_Spkng_score_assigned
,count (distinct case when stg.code='Spkng' and ap.id=47 and ccq.studentstestsid is not null and ccq.status=629 then st.studentid else null end ) stage_Spkng_score_inprogress
,count (distinct case when stg.code='Spkng' and ap.id=47 and ccq.studentstestsid is not null and ccq.status is null then st.studentid else null end ) stage_Spkng_scored_pending
,count (distinct case when stg.code='Spkng' and ap.id=47 and ccq.studentstestsid is not null and ccq.status=631 then st.studentid else null end ) stage_Spkng_scored_completed
,count (distinct case when stg.code='Wrtng' and ap.id=47 then st.studentid else null end)  stage_Wrtng
,count (distinct case when stg.code='Wrtng' and ap.id=47 and ccq.studentstestsid is not null then st.studentid else null end)  stage_Wrtng_score_assigned
,count (distinct case when stg.code='Wrtng' and ap.id=47 and ccq.studentstestsid is not null and ccq.status=629 then st.studentid else null end)  stage_Wrtng_score_inprogress
,count (distinct case when stg.code='Wrtng' and ap.id=47 and ccq.studentstestsid is not null and ccq.status is null then st.studentid else null end)  stage_Wrtng_scored_pending
,count (distinct case when stg.code='Wrtng' and ap.id=47 and ccq.studentstestsid is not null and ccq.status=631 then st.studentid else null end)  stage_Wrtng_scored_completed
,count (distinct case when stg.id is not null and ap.id=47 then st.studentid else null end ) stage_all
,count (distinct case when ap.id=47 and ccq.studentstestsid is not null then st.studentid else null end)  stage_all_score
from student s 
inner join enrollment e on s.id=e.studentid  --and e.activeflag is true 
and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
left outer join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
left outer join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
left outer join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true and sub.id=10 and tt.id=50  
left outer join studentstests st on st.enrollmentid=e.id and s.id=st.studentid and st.activeflag is true 
left outer join testsession ts on st.testsessionid=ts.id and ts.activeflag is true and ts.schoolyear=2017 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid=10171
left outer join (select sc.testsessionid,scs.studentstestsid,scs.kelpascoringstatus as status
from scoringassignmentstudent scs 
inner join scoringassignment sc on scs.scoringassignmentid=sc.id  and sc.activeflag is true
inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
--left outer join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and sccq.id=ccq.scoringassignmentscorerid 
--and ccq.status in (629,630,631)
where scs.activeflag is true  
group by sc.testsessionid,scs.studentstestsid,scs.kelpascoringstatus) ccq on ccq.testsessionid=ts.id and ccq.studentstestsid=st.id
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
,sum(stage_Spkng_score_assigned)         stage_Spkng_score_assigned
,sum(stage_Spkng_score_assigned-stage_Spkng_scored_completed)  stage_Spkng_score_unscored
,sum(stage_Spkng_scored_completed)       stage_Spkng_scored_completed
,sum(stage_Wrtng_score_assigned)         stage_Wrtng_score_assigned
,sum(stage_Wrtng_score_assigned-stage_Wrtng_scored_completed)       stage_Wrtng_score_unscored
,sum(stage_Wrtng_scored_completed)       stage_Wrtng_scored_completed 
into temp dailydashboard_kelpa_scoring
from cte_std tmp
inner join organizationtreedetail ot on ot.schoolid=tmp.attendanceschoolid 
where ot.stateid=51
group by ot.statedisplayidentifier,ot.districtname
order by 1,2;	
\copy (select * from dailydashboard_kelpa_scoring) to 'dailydashboard_kelpa_scoring.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);