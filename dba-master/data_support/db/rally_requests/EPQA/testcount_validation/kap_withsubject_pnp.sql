--Need to update the test status for each stage
drop table if exists tmp_epqa;
with cte_st as (select st.id,st.status,st.enrollmentid,st.studentid,stg.code,gc.abbreviatedname grade
,case when tc.contentareaid=3 then  17 when tc.contentareaid=440 then 1 when tc.contentareaid=441 then 19 end subjectareaid 
from 
studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10172,10174))
,cte_std as(
select 
 s.id studentid
,case when s.profilestatus = 'CUSTOM' then 1 else 0 end std_pnp 
,e.id enrollmentid
,gc.abbreviatedname        grade
,sub.id                    subjectareaid
,attendanceschoolid
from student s 
inner join enrollment e on s.id=e.studentid  and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id in (17,1,19) and tt.id=2  
)
,tmp_merge as (
select 
 attendanceschoolid
,std.grade
,st.id
,std.std_pnp
,std.studentid std_studentid
,st.studentid  st_studentid
,st.enrollmentid std_enrollmentid
,st.enrollmentid st_enrollmentid
,st.status
,st.code
,std.subjectareaid std_subjectareaid 
,st.subjectareaid  st_subjectareaid
from cte_std std
left outer join cte_st st on st.enrollmentid=std.enrollmentid and st.studentid=std.studentid and st.grade=std.grade )
select
 ot.statedisplayidentifier state
,ot.districtname           districtname
,ot.schoolname             schoolname
,grade
,count(distinct std_studentid)         noof_enrolled
,count(distinct case when std_pnp=1 then std_studentid else null end)         noof_pnp_enrolled
,count(distinct  case when std_subjectareaid=17 then std_studentid else null end )        noof_ELA_enrolled
,count(distinct  case when std_subjectareaid=17 and std.std_pnp=1 then std_studentid else null end )        noof_pnp_ELA_enrolled
,count(distinct  case when std_subjectareaid=1 then std_studentid else null end )         noof_Math_enrolled
,count(distinct  case when std_subjectareaid=1 and std.std_pnp=1 then std_studentid else null end )         noof_pnp_Math_enrolled
,count(distinct  case when std_subjectareaid=19 then std_studentid else null end )         noof_Sci_enrolled
,count(distinct  case when std_subjectareaid=19 and std.std_pnp=1 then std_studentid else null end )         noof_pnp_Sci_enrolled
,count(distinct case when std.id is not null then st_studentid else null end) noof_studenthavetests
,count(distinct case when std.id is not null and std.std_pnp=1 then st_studentid else null end) noof_pnp_studenthavetests
,count(distinct case when std.id is not null then std.id else null end) noof_testscreated
,count(distinct case when std.code='Stg1' and st_subjectareaid=17 and std.id is not null then st_studentid else null end ) stage_ELA_Stg1
,count(distinct case when std.code='Stg1' and st_subjectareaid=1 and std.id is not null then st_studentid else null end ) stage_Math_Stg1
,count(distinct case when std.code='Stg1' and st_subjectareaid=19 and std.id is not null then st_studentid else null end ) stage_Sci_Stg1
,count(distinct case when std.code='Stg2' and st_subjectareaid=17 and std.id is not null then st_studentid else null end ) stage_ELA_Stg2
,count(distinct case when std.code='Stg2' and st_subjectareaid=1 and std.id is not null then st_studentid else null end ) stage_Math_Stg2
,count(distinct case when std.code='Stg2' and st_subjectareaid=19 and std.id is not null then st_studentid else null end ) stage_Sci_Stg2
into temp tmp_epqa
 from tmp_merge std 
 inner join organizationtreedetail ot on ot.schoolid=std.attendanceschoolid 
where ot.stateid=51
group by ot.statedisplayidentifier,ot.districtname,ot.schoolname,grade
order by 1,2,3,4;

\copy (select * from tmp_epqa) to 'kap_pnp_withsubject.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


