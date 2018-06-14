-- scripts has dependencies we need to run step by step
-- step1:we need to exclude the items by the subject
drop table if exists tmp_epqa_exclude;
create temp table tmp_epqa_exclude (tvid bigint);
insert into tmp_epqa_exclude
select distinct id from taskvariant
where externalid in (
select distinct taskvariantid from excludeditems where schoolyear = 2017 and assessmentprogramid = 12 and subjectid = 3);

-- step2:we need to find the school,district,state median
drop table if exists tmp_epqa_median;
select distinct org.schoolid,gc.abbreviatedname grade, rpm.score schoolscore, drpm.score districtscore, srpm.score statescore, rpm.standarderror schoolstandarderror, drpm.standarderror districtstandarderror, srpm.standarderror statestandarderror, 
rpm.studentcount schoolstudentcount, drpm.studentcount districtstudentcount, srpm.studentcount statestudentcount
into temp tmp_epqa_median
from organizationtreedetail org
inner join reportsmedianscore rpm on rpm.organizationid=org.schoolid and rpm.organizationtypeid =7
inner join reportsmedianscore drpm on drpm.organizationid=org.districtid and drpm.organizationtypeid=5 and drpm.gradeid =rpm.gradeid 
inner join reportsmedianscore srpm on srpm.organizationid = org.stateid and srpm.organizationtypeid=2 and srpm.gradeid=drpm.gradeid 
inner join gradecourse gc on gc.id= rpm.gradeid  
where rpm.assessmentprogramid =12 and rpm.contentareaid=3  and rpm.schoolyear=2017  and rpm.subscoredefinitionname  is null
 and drpm.assessmentprogramid =12 and drpm.contentareaid=3 and drpm.schoolyear=2017 and drpm.subscoredefinitionname is null 
 and srpm.assessmentprogramid =12 and srpm.contentareaid=3 and srpm.schoolyear=2017 and srpm.subscoredefinitionname is null
order by org.schoolid, gc.abbreviatedname;


-- view only lines:claim names different for ela
--step3: we need to exclude the items by the subject 
drop table if exists tmp_sub_score;
select rss.studentreportid,rss.studentid
,MAX(case when rss.subscoredefinitionname ='Claim_1_all'         then rss.rating end) as    Claim_1_all         
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_1' then rss.rating end) as    Claim_1_Rpt_Group_1 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_2' then rss.rating end) as    Claim_1_Rpt_Group_2 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_3' then rss.rating end) as    Claim_1_Rpt_Group_3
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_4' then rss.rating end) as    Claim_1_Rpt_Group_4 
,MAX(case when rss.subscoredefinitionname ='Claim_2_all'         then rss.rating end) as    Claim_2_all
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_1' then rss.rating end) as    Claim_2_Rpt_Group_1
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_2' then rss.rating end) as    Claim_2_Rpt_Group_2 
,MAX(case when rss.subscoredefinitionname ='Claim_2_Rpt_Group_3' then rss.rating end) as    Claim_2_Rpt_Group_3 
into temp tmp_sub_score  
from reportsubscores rss 
inner join studentreport sr on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3
group by rss.studentreportid,rss.studentid;
 
--step4:find sccode at ELA
drop table if exists tmp_scode;
select distinct st.id as stid, st.studentid, ca.id as sc_status, ca.categoryname as sc_statusname,
(case  when sc.id in (41,33,34,42,12,30) then 'SC-B1'
       when sc.id in (36,31,24,35,44,9,10,8) then 'SC-B2'
       when sc.id in (37,38,39,3,43,2) then 'SC-A' END) as code
into temp tmp_scode
from studentstests st
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join studentspecialcircumstance ssp on ssp.studenttestid=st.id and ssp.activeflag is true
inner join category ca on ca.id =ssp.status and ca.activeflag is true
inner join specialcircumstance sc on sc.id=ssp.specialcircumstanceid and sc.activeflag is true
inner join statespecialcircumstance ssc on ssc.specialcircumstanceid=sc.id  and ssc.activeflag is true
inner join studentassessmentprogram sap on sap.studentid = st.studentid and sap.activeflag is true
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true and sap.assessmentprogramid =12 
and ts.source='BATCHAUTO' and ca.categorytypeid=79
and ts.operationaltestwindowid =10172
and tc.contentareaid=3; 

--=======================================================================================================
--[ELA,KS,KAP,Report]: Grade 10
--=======================================================================================================

with cte_stg2 as (
select distinct
 st.studentid
,st.status as stg2_status
,st.enrollmentid as stg2_enrollmentid
,ot.schoolid as stg2_schoolid
,ot.districtid as stg2_districtid
,sc_codes.code as stg2_sc_code
,sc_codes.sc_statusname as stg2_sccode_status
,tsec.numberoftestitems no_req_items
,count(distinct sres1.taskvariantid) no_res_items
,count(distinct exld.tvid) no_excluded_items
,(tsec.numberoftestitems - count(distinct exld.tvid)) no_included_items
,count(distinct sres2.taskvariantid) no_res_included_items
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
left join tmp_scode sc_codes on sc_codes.stid=st.id and sc_codes.studentid=st.studentid
left join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
left join tmp_epqa_exclude exld2 on exld2.tvid=tstv.taskvariantid 
left join studentsresponses sres2 ON st.id = sres2.studentstestsid and sres2.taskvariantid=tstv.taskvariantid and sres2.score is not null and exld2.tvid is null
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and tc.contentareaid=3 and stg.code='Stg2' 
and st.status in (84, 85, 86, 659) --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and gc.abbreviatedname = '10'
group by st.studentid,st.enrollmentid,ot.schoolid,ot.districtid, sc_codes.code, sc_codes.sc_statusname,st.status,tsec.numberoftestitems
)
,cte_stg1 as (
select distinct
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sc_codes.code as stg1_sc_code
,sc_codes.sc_statusname as stg1_sccode_status
,tsec.numberoftestitems no_req_items
,count(distinct sres1.taskvariantid) no_res_items
,count(distinct exld.tvid) no_excluded_items
,(tsec.numberoftestitems - count(distinct exld.tvid)) no_included_items
,count(distinct sres2.taskvariantid) no_res_included_items
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid  
left join tmp_scode sc_codes on sc_codes.stid=st.id and sc_codes.studentid=st.studentid
left join cte_stg2 stg2 on stg2.studentid=st.studentid 
left join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
left join tmp_epqa_exclude exld2 on exld2.tvid=tstv.taskvariantid 
left join studentsresponses sres2 ON st.id = sres2.studentstestsid and sres2.taskvariantid=tstv.taskvariantid and sres2.score is not null and exld2.tvid is null
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and tc.contentareaid=3 and stg.code='Stg1' 
and st.status in (84, 85, 86, 659) --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and gc.abbreviatedname = '10'
group by st.studentid,st.enrollmentid,ot.schoolid,ot.districtid, sc_codes.code, sc_codes.sc_statusname,st.status,tsec.numberoftestitems
)
select distinct
s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'ELA'::Char(10)                          "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_req_items             		  "Stage1 #Required"
,stg1.no_res_items                        "Stage1 #Responded" 
,stg1.no_excluded_items                   "Stage1 #ExcludedItems"
,stg1.no_included_items                   "Stage1 #IncludedItems"
,stg1.no_res_included_items               "Stage1 #IncludedItems Responded"
,stg1.stg1_sc_code                        "Stage1 SC Code"      
,stg1.stg1_sccode_status                  "Stage1 SC Status"   
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_req_items             		  "Stage2 #Required"
,stg2.no_res_items                        "Stage2 #Responded" 
,stg2.no_excluded_items                   "Stage2 #ExcludedItems"
,stg2.no_included_items                   "Stage2 #IncludedItems"
,stg2.no_res_included_items               "Stage2 #IncludedItems Responded"
,stg2.stg2_sc_code                        "Stage2 SC Code"      
,stg2.stg2_sccode_status                  "Stage2  SC Status"   
,sr.status                                "Full Report Generated"
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
,sr.stage1hassccode                       "Stage 1 SC Flag"   
,sr.stage2hassccode                       "Stage 2 SC Flag"   
,sr.transferred                           "Transferred Flag"  
,sr.exitstatus                            "Exit Flag"

into temp tmp_epqa_allscenarios_g10
from cte_stg1 stg1 
left join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
left outer join tmp_epqa_median rpm on rpm.schoolid=e.attendanceschoolid and rpm.grade=gc.abbreviatedname
left outer join studentreport sr on sr.studentid=s.id and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join leveldescription ld on sr.levelid=ld.id
left outer join leveldescription ld1 on sr.previousyearlevelid=ld1.id
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
and gc.abbreviatedname = '10';

\copy (select * from tmp_epqa_allscenarios_g10) to 'tmp_epqa_allscenarios_ela_grade10.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--drop table if exists tmp_epqa_allscenarios;

drop table if exists tmp_epqa_allscenarios_g10;
drop table if exists tmp_epqa_exclude;
drop table if exists tmp_epqa_median;
drop table if exists tmp_sub_score;
