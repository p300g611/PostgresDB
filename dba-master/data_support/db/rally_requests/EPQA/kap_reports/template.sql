--====================================================================================================================
--Scenario28:(B)Current Enrollment School:C (D)stage1 school:A (E)stage1 status Complete>5 (F)stg2-B Complete>5 Within district Transfer after stage1
--====================================================================================================================
drop table if exists tmp_epqa_scenario28;
with cte_stg2 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid
,ot.districtid
,count(distinct tstv.taskvariantid) no_req_items
,count(distinct sres1.taskvariantid) no_res_items
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid
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
--and gc.abbreviatedname='10'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid,ot.districtid
having count(distinct sres1.taskvariantid)>5
)
,cte_stg1 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid   stg1_schoolid
,stg2.attendanceschoolid stg2_schoolid
,ot.districtid
,count(distinct tstv.taskvariantid) no_req_items
,count(distinct sres1.taskvariantid) no_res_items
from studentstests st 
inner join cte_stg2 stg2 on stg2.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid
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
-- and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid and ot.districtid=stg2.districtid
and tc.contentareaid=440 
and st.status=86 
and transferedenrollmentid is not null
--and gc.abbreviatedname='10'
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid,ot.districtid
having count(distinct sres1.taskvariantid)>5
)
select 
'scenario28'::char(20) "Scenarios"
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
,rawscore "Raw Score"
,scalescore "Scale Score"
,standarderror "Standard Error"
,levelid "Level"
,previousyearlevelid "Last Year Performance Level"
,rpm.schoolscore "School Median"
,rpm.districtscore "District Median"
,rpm.statescore "State Median"
,case when rss.subscoredefinitionname='Claim_1_all'         then rss.rating end "OVERALL CONCEPTS AND PROCEDURES"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_1' then rss.rating end ": Operations and Algebraic Thinking(Grade 3 and 4)"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_2' then rss.rating end ": Number and Operations in Base Ten(Grade 4 and 5)"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_3' then rss.rating end ": Number and Operations with Fractions(Grade 4 and 5)"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_4' then rss.rating end ": Measurement and Data(Grade 3, 4 and 5)"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_5' then rss.rating end ": Geometry(GRade 7, 8 and 10)"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_6' then rss.rating end ": The Number System(Grade 6)"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_7' then rss.rating end ": Expressions and Equations(Grade 6, 7 and 8)"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_8' then rss.rating end ": Statistics and Probability(Grade 7)"
,case when rss.subscoredefinitionname='Claim_1_Rpt_Group_9' then rss.rating end ": Algebra(Grade 10)"
,case when rss.subscoredefinitionname='Claim_2_all'	    then rss.rating end "PROBLEM SOLVING"
,case when rss.subscoredefinitionname='Claim_3_all'	    then rss.rating end "COMMUNICATING REASONING"
,case when rss.subscoredefinitionname='Claim_4_all'	    then rss.rating end "MODELING AND DATA ANALYSIS"
,sr.aggregatetoschool "Aggregated to School"
,sr.aggregatetodistrict "Aggregated to District"
,sr.incompletestatus "Incomplete flag" 
into temp tmp_epqa_scenario28
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
left outer join tmp_epqa_median rpm on rpm.schoolid=e.attendanceschoolid and rpm.grade=gc.abbreviatedname
left outer join studentreport sr on sr.studentid=s.id and e.id=sr.enrollmentid
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
-- and tmp.enrollmentid=e.id
and tmp.stg1_schoolid<>e.attendanceschoolid and ot.districtid=otstg2.districtid
--and gc.abbreviatedname='10'
limit 50; 