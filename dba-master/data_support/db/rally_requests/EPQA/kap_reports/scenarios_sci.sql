drop table if exists tmp_epqa_exclude;
create temp table tmp_epqa_exclude (tvid bigint);
insert into tmp_epqa_exclude
select distinct id from taskvariant
where externalid in (59032,57975,56775,57077,57853,35928,57060,56777,59494,57321,57084,56768,57863,57063,57324,57072,57944,
56954,57143,58950,57083,56703,59456,57937,56705,59524,57022);

--Scenario1[Math,KS,KAP,Report]:(1)Stage_1_Status=Complete (2)Stage_2_Status=Complete (3)Score_Report=yes
drop table if exists tmp_epqa_scenario1;
with cte_stg2 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid
,count(distinct tstv.taskvariantid) no_req_items
,count(distinct sres1.taskvariantid) no_res_items
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct tstv.taskvariantid)=count(distinct sres1.taskvariantid)
limit 100)
,cte_stg1 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid   stg1_schoolid
,stg2.attendanceschoolid stg2_schoolid
,count(distinct tstv.taskvariantid) no_req_items
,count(distinct sres1.taskvariantid) no_res_items
from studentstests st 
inner join cte_stg2 stg2 on stg2.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct tstv.taskvariantid)=count(distinct sres1.taskvariantid)
limit 100)
select 
'Scenario1'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname        "Student Last Name"
,legalfirstname       "Student First Name"
,ot.schoolname        "CurrentEnrollment School"
,ot.districtname      "District"
,gc.name              "Grade"
,'Math'::Char(10)     "Subject"
,otstg1.schoolname    "Stage 1 School"
,otstg2.schoolname    "Stage 2 School"
,sr.generated "Full Report Generated"
,'' "Raw Score"
,'' "Scale Score"
,'' "Standard Error"
,'' "Level"
,'' "Last Year Performance Level"
,'' "School Median"
,'' "District Median"
,'' "State Median"
,'' "OVERALL CONCEPTS AND PROCEDURES"
,'' "CONCEPTS AND PROCEDURES: Operations and Algebraic Thinking(Grade 3 and 4)"
,'' "CONCEPTS AND PROCEDURES: Number and Operations in Base Ten(Grade 4 and 5)"
,'' "CONCEPTS AND PROCEDURES: Number and Operations with Fractions(Grade 4 and 5)"
,'' "CONCEPTS AND PROCEDURES: Measurement and Data(Grade 3, 4 and 5)"
,'' "CONCEPTS AND PROCEDURES: Geometry(GRade 7, 8 and 10)"
,'' "CONCEPTS AND PROCEDURES: The Number System(Grade 6)"
,'' "CONCEPTS AND PROCEDURES: Expressions and Equations(Grade 6, 7 and 8)"
,'' "CONCEPTS AND PROCEDURES: Statistics and Probability(Grade 7)"
,'' "CONCEPTS AND PROCEDURES: Algebra(Grade 10)"
,'' "PROBLEM SOLVING"
,'' "COMMUNICATING REASONING"
,'' "MODELING AND DATA ANALYSIS"
,sr.aggregatetoschool "Aggregated to School"
,sr.aggregatetodistrict "Aggregated to District"
,sr.incompletestatus "Incomplete flag" 
into temp tmp_epqa_scenario1
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid  and e.activeflag is true 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=tmp.stg1_schoolid
inner join organizationtreedetail otstg2 on otstg2.schoolid=tmp.stg2_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
left outer join studentreport sr on sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 30; 





select * from (
select  "Scenarios", "Student SSID","Student Last Name" from tmp_epqa_scenario1
union all
select  "Scenarios", "Student SSID","Student Last Name" from tmp_epqa_scenario2) all_s;