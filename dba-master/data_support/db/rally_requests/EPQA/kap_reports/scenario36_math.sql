--=======================================================================================================
--Scenario36[ELA,KS,KAP,Report]:		A	Complete>5	B	Complete>5	Exit and not enrolled anywhere
--=======================================================================================================
drop table if exists tmp_epqa_scenario36;
with cte_stg2 as (
select distinct 
 st.studentid
,st.enrollmentid as stg2_enrollmentid
,ot.schoolid as stg2_schoolid
,ot.districtid as stg2_districtid
,count(distinct sres1.taskvariantid) no_res_items
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid and e.activeflag is false
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86
and exld.tvid is null
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ot.schoolid,ot.districtid
having count(distinct sres1.taskvariantid)>5
)
,cte_stg1 as (
select distinct
 st.studentid
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,count(distinct sres1.taskvariantid) no_res_items
from studentstests st 
inner join enrollment e on e.id = st.enrollmentid and e.activeflag is false
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017  
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and tc.contentareaid=440
and st.status=86 
and exld.tvid is null
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ot.schoolid,ot.districtid

having count(distinct sres1.taskvariantid)>5
)
select 
'scenario1'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'M'::Char(10)                          "Subject"
,otstg1.districtname                      "Stage 1 District"
,otstg1.schoolname                        "Stage 1 School"
--,stg1.no_req_items             "Stage 1 #Required"
--,stg1.no_res_items             "Stage 1 #Responded" 
,otstg2.districtname                      "Stage 2 District"
,otstg2.schoolname                        "Stage 2 School"
--,stg1.no_req_items             "Stage 2 #Required" 
--,stg2.no_res_items             "Stage 2 #Responded" 
,sr.status                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,ld.level                                 "Level"
,ld1.level                               "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,rpm.schoolstandarderror                  "School Standard Error"
,rpm.districtstandarderror                "District Standard Error"
,rpm.statestandarderror                   "State Standard Error"
,rpm.schoolstudentcount                  "School Student Count"
,rpm.districtstudentcount                "District Student Count"
,rpm.statestudentcount                   "State Student Count"
,rss.Claim_1_all                          "OVERALL CONCEPTS AND PROCEDURES"
,rss.Claim_1_Rpt_Group_1                  "CONCEPTS AND PROCEDURES: Operations and Algebraic Thinking"
,rss.Claim_1_Rpt_Group_2                  "CONCEPTS AND PROCEDURES: Number and Operations in Base Ten"
,rss.Claim_1_Rpt_Group_3                  "CONCEPTS AND PROCEDURES: Number and Operations with Fractions"
,rss.Claim_1_Rpt_Group_4                  "CONCEPTS AND PROCEDURES: Measurement and Data"
,rss.Claim_1_Rpt_Group_5                  "CONCEPTS AND PROCEDURES: Geometry"
,rss.Claim_1_Rpt_Group_6                  "CONCEPTS AND PROCEDURES: The Number System"
,rss.Claim_1_Rpt_Group_7                  "CONCEPTS AND PROCEDURES: Expressions and Equations"
,rss.Claim_1_Rpt_Group_8                  "CONCEPTS AND PROCEDURES: Statistics and Probability"
,rss.Claim_1_Rpt_Group_9                  "CONCEPTS AND PROCEDURES: Algebra"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag"
into temp tmp_epqa_scenario36
from cte_stg1 stg1 
inner join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left outer join enrollment e on s.id=e.studentid  and e.activeflag is false 
left outer join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
left outer join tmp_epqa_median rpm on rpm.schoolid=e.attendanceschoolid and rpm.grade=gc.abbreviatedname
left outer join studentreport sr on sr.studentid=s.id and e.id=sr.enrollmentid
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join leveldescription ld on sr.levelid=ld.id
left outer join leveldescription ld1 on sr.previousyearlevelid=ld1.id
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2

and stg2.stg2_enrollmentid=e.id and stg2.stg2_schoolid = e.attendanceschoolid
and stg1.stg1_districtid is not null and stg2.stg2_districtid is not null
--and stg1.stg1_districtid = stg2.stg2_districtid 
and stg1.stg1_schoolid<>stg2.stg2_schoolid  and stg1.stg1_enrollmentid<>stg2.stg2_enrollmentid
--and scd.code='SC-A' and scd.id=549 --'Approved'
;
\copy (select * from tmp_epqa_scenario36) to 'tmp_epqa_scenario36_math.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);