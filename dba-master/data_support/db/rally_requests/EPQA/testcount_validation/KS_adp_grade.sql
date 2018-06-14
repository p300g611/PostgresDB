--Need to update the test status for each stage
-- step1:
  drop table if exists tmp_student_asl;
  select studentid,count(distinct profileitemattributenameattributecontainerid) 
  into temp tmp_student_asl  from studentprofileitemattributevalue 
  where profileitemattributenameattributecontainerid in (7,9) and selectedvalue in ('true','asl') and activeflag is true 
  group by studentid
  having count(distinct profileitemattributenameattributecontainerid)=2;

-- step2:
  drop table if exists tmp_student_spa;
  select studentid,count(distinct profileitemattributenameattributecontainerid) 
   into temp tmp_student_spa 
   from studentprofileitemattributevalue 
  where profileitemattributenameattributecontainerid in (84,86) and selectedvalue in ('true','spa') and activeflag is true 
  group by studentid
  having count(distinct profileitemattributenameattributecontainerid)=2;

--step:3
drop table if exists tmp_epqa;
with cte_st as (select st.id,st.status,st.enrollmentid,st.studentid,stg.code,gc.abbreviatedname grade
,case when tc.contentareaid=3 then  17 when tc.contentareaid=440 then 1 when tc.contentareaid=441 then 19 end subjectareaid 
,case when accessibleform is true then 1 else 0 end st_pnp 
from 
studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join test t on st.testid=t.id and t.activeflag is true 
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
,st.st_pnp
,std.studentid std_studentid
,st.studentid  st_studentid
,st.enrollmentid std_enrollmentid
,st.enrollmentid st_enrollmentid
,st.status
,st.code
,std.subjectareaid std_subjectareaid 
,st.subjectareaid  st_subjectareaid
from cte_std std
left outer join cte_st st on st.enrollmentid=std.enrollmentid and st.studentid=std.studentid and st.grade=std.grade 
)
select
--  ot.statedisplayidentifier state
-- ,ot.districtname           districtname
-- ,ot.schoolname             schoolname,
 grade "Grade"
,count(distinct  case when std_subjectareaid=17 then std_studentid else null end )                          "ELA_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=17 and std.id is not null then st_studentid else null end ) "ELA_Stg1_Tests"
,count(distinct  case when std_subjectareaid=17 and std.std_pnp=1 then std_studentid else null end )        "ELA_PNP_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=17 and std.st_pnp=1  and std.std_pnp=1 and std.id is not null then st_studentid else null end ) "ELA_PNP_Stg1_Tests"
,count(distinct  case when std_subjectareaid=1 then std_studentid else null end )                           "M_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=1 and std.id is not null then st_studentid else null end )  "M_Stg1_Tests"
,count(distinct  case when std_subjectareaid=1 and std.std_pnp=1 then std_studentid else null end )         "M_PNP_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=1 and std.st_pnp=1 and std.std_pnp=1 and std.id is not null then st_studentid else null end )  "M_PNP_Stg1_Tests"
,count(distinct  case when std_subjectareaid=19 then std_studentid else null end )                          "Sci_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=19 and std.id is not null then st_studentid else null end ) "Sci_Stg1_Tests"
,count(distinct  case when std_subjectareaid=19 and std.std_pnp=1 then std_studentid else null end )        "Sci_PNP_Enrolled"
,count(distinct case when std.code='Stg1' and st_subjectareaid=19 and std.st_pnp=1 and std.std_pnp=1 and std.id is not null then st_studentid else null end ) "Sci_PNP_Stg1_Tests"
,count(distinct case when std.code='Stg1' and st_subjectareaid=19 and std.st_pnp=1 and std.std_pnp=1 and asl.studentid is not null and std.id is not null then st_studentid else null end ) "Sci_PNP_asl_Stg1_Tests"
,count(distinct case when std.code='Stg1' and st_subjectareaid=19 and std.st_pnp=1 and std.std_pnp=1 and spa.studentid is not null and std.id is not null then st_studentid else null end ) "Sci_PNP_spa_Stg1_Tests"
into temp tmp_epqa
 from tmp_merge std 
 inner join organizationtreedetail ot on ot.schoolid=std.attendanceschoolid 
 left outer join tmp_student_asl asl on asl.studentid=std.std_studentid
 left outer join tmp_student_spa spa on asl.studentid=std.std_studentid
where ot.stateid=51
-- group by ot.statedisplayidentifier,ot.districtname,ot.schoolname,grade
group by grade
order by REGEXP_REPLACE(COALESCE(grade, '0'), '[^0-9]*' ,'0')::integer;
--\copy (select * from tmp_epqa) to 'KS_adp_grade.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

