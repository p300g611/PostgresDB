begin;
drop table if exists tmp_epqa;
with cte_st as 
(select 
 st.id,st.enrollmentid,st.studentid,tc.gradecourseid, tc.gradebandid
,tc.contentareaid subjectareaid,opws.stateid opw_stateid
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join test t on st.testid=t.id and t.activeflag is true 
inner join operationaltestwindowstate opws on opws.operationaltestwindowid=ts.operationaltestwindowid
where ts.activeflag is true and st.activeflag is true 
and ts.operationaltestwindowid in (10219) 
)
,cte_std as(
select 
 s.id studentid
,e.id enrollmentid
,gc.abbreviatedname        grade
,r.statesubjectareaid     subjectareaid
,e.attendanceschoolid
from student s 
inner join enrollment e on s.id=e.studentid  and e.activeflag is true and s.activeflag is true
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true
inner join roster r on er.rosterid=r.id and r.activeflag is true
where e.currentschoolyear=2017 and sap.assessmentprogramid=3 and r.statesubjectareaid in (443) 
) 
,tmp_merge as (
select 
 attendanceschoolid
,std.grade
,st.id
,std.studentid std_studentid
,st.studentid  st_studentid
,st.enrollmentid std_enrollmentid
,st.enrollmentid st_enrollmentid
,std.subjectareaid std_subjectareaid 
,st.subjectareaid  st_subjectareaid
,opw_stateid
from cte_std std
left outer join cte_st st on st.enrollmentid=std.enrollmentid and st.studentid=std.studentid 
)
select
 ot.statedisplayidentifier state
,grade "Grade"
,count(distinct  case when std_subjectareaid=443 then std_studentid else null end )                          "SS_Enrolled"
,count(distinct case when st_subjectareaid=443 and std.id is not null then st_studentid else null end )      "SS_Tests"
into temp tmp_epqa
 from tmp_merge std 
 inner join organizationtreedetail ot on ot.schoolid=std.attendanceschoolid and ot.stateid=opw_stateid
group by ot.statedisplayidentifier,grade
order by state,REGEXP_REPLACE(COALESCE(grade, '0'), '[^0-9]*' ,'0')::integer;
\copy (select * from tmp_epqa) to 'dlm_SS_counts.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

drop table if exists tmp_merge;
rollback;