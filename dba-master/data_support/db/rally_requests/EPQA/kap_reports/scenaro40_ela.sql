drop table if exists tmp_epqa_scenario40;
with cte_stg1 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid   stg1_schoolid
--,count(distinct tstv.taskvariantid) no_req_items
--,count(distinct sres1.taskvariantid) no_res_items
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
--inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
and st.status=84
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
--having count(distinct sres1.taskvariantid)=0

)
select 
'scenario40'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'ELA'::Char(10)                          "Subject"
,otstg1.districtname                      "Stage 1 District"
,otstg1.schoolname                        "Stage 1 School"
--,stg1.no_req_items             "Stage 1 #Required"
--,stg1.no_res_items             "Stage 1 #Responded" 
--,otstg2.districtname                      "Stage 2 District"
--,otstg2.schoolname                        "Stage 2 School"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_2_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag"
into temp tmp_epqa_scenario40
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid  and e.activeflag is true 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=tmp.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
left outer join tmp_epqa_median rpm on rpm.schoolid=e.attendanceschoolid and rpm.grade=gc.abbreviatedname
left outer join studentreport sr on sr.studentid=s.id and e.id=sr.enrollmentid
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join leveldescription ld on sr.levelid=ld.id
left outer join leveldescription ld1 on sr.previousyearlevelid=ld1.id
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
;  

\copy (select * from tmp_epqa_scenario40) to 'tmp_epqa_scenario40_ela.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
