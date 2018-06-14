-- scripts has dependencies we need to run step by step
-- step1:we need to exclude the items by the subject. the script (table:tmp_epqa_exclude) below has insert tmp_no_response
-- drop table if exists tmp_epqa_exclude;
-- create temp table tmp_epqa_exclude (tvid bigint);
-- insert into tmp_epqa_exclude
 -- select distinct id from taskvariant
 -- where externalid in (
 -- select distinct taskvariantid from excludeditems where schoolyear = 2018 and assessmentprogramid = 12 and subjectid = 3);

-- step2:we need to find the school,district,state median
drop table if exists tmp_epqa_median;
select distinct org.schoolid,rpm.gradeid, rpm.score schoolscore, drpm.score districtscore, srpm.score statescore, rpm.standarderror schoolstandarderror, drpm.standarderror districtstandarderror, srpm.standarderror statestandarderror, 
rpm.studentcount schoolstudentcount, drpm.studentcount districtstudentcount, srpm.studentcount statestudentcount
into temp tmp_epqa_median
from organizationtreedetail org
inner join reportsmedianscore rpm on rpm.organizationid=org.schoolid and rpm.organizationtypeid =7
inner join reportsmedianscore drpm on drpm.organizationid=org.districtid and drpm.organizationtypeid=5 and drpm.gradeid =rpm.gradeid 
inner join reportsmedianscore srpm on srpm.organizationid = org.stateid and srpm.organizationtypeid=2 and srpm.gradeid=drpm.gradeid 
where rpm.assessmentprogramid =12 and rpm.contentareaid=3  and rpm.schoolyear=2018  and rpm.subscoredefinitionname  is null
 and drpm.assessmentprogramid =12 and drpm.contentareaid=3 and drpm.schoolyear=2018 and drpm.subscoredefinitionname is null 
 and srpm.assessmentprogramid =12 and srpm.contentareaid=3 and srpm.schoolyear=2018 and srpm.subscoredefinitionname is null
order by org.schoolid, rpm.gradeid;


-- view only lines:claim names different for ela
--step3: we need to exclude the items by the subject 
drop table if exists tmp_sub_score;
select distinct rss.studentid,sr.status,sr.levelid,sr.previousyearlevelid,sr.rawscore,sr.scalescore,sr.standarderror,sr.aggregatetoschool
,sr.aggregatetodistrict,sr.incompletestatus,sr.stage1hassccode,sr.stage2hassccode,sr.transferred,sr.exitstatus,sr.gradeid,sr.attendanceschoolid,sr.districtid
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
where sr.schoolyear=2018 and sr.assessmentprogramid=12 and sr.contentareaid=3
group by rss.studentid,sr.status,sr.rawscore,sr.scalescore,sr.standarderror,sr.aggregatetoschool
,sr.aggregatetodistrict ,sr.incompletestatus,sr.levelid,sr.previousyearlevelid
,sr.stage1hassccode,sr.stage2hassccode,sr.transferred,sr.exitstatus,sr.gradeid,sr.attendanceschoolid,sr.districtid;
 
CREATE index idx_sub_studentid on tmp_sub_score (studentid);
 
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
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and sap.assessmentprogramid =12 
and ts.source='BATCHAUTO' and ca.categorytypeid=79
and ts.operationaltestwindowid =10261
and tc.contentareaid=3; 

create index inx_sc_studentid on tmp_scode (studentid);
--=======================================================================================================
--[ELA,KS,KAP,Report]: Grade 5
--=======================================================================================================
drop table if exists tmp_no_response;
with no_response_cnt as (
select st.studentid, st.id studentstestsid,tstv.taskvariantid,gc.id gradeid, tc.contentareaid
from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true
inner join testcollection tc on tc.id =st.testcollectionid and tc.activeflag is true 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid--duplicate
where st.activeflag is true and ts.operationaltestwindowid =10261  and ts.schoolyear=2018  and st.status in (86,85,659)
and tc.contentareaid=3 and ts.source='BATCHAUTO'   and stg.code in ('Stg1','Stg2') 
and gc.abbreviatedname ='5' 
)
select distinct tmp.studentid, tmp.studentstestsid
,count(tmp.taskvariantid ) no_req_items
,count(case when sr.score is not null and sr.activeflag is true then  sr.taskvariantid end ) no_res_items
,count(exld.id) no_excluded_items
,count(case when exld.id is null  and sr.taskvariantid is not null then sr.taskvariantid end )no_res_included_items
into temp tmp_no_response
from no_response_cnt  tmp
left outer join studentsresponses sr on sr.studentid=tmp.studentid and sr.studentstestsid =tmp.studentstestsid and sr.taskvariantid=tmp.taskvariantid
left outer join (select distinct tv.id, gc.id gradeid from taskvariant tv 
                join excludeditems exld on exld.taskvariantid =tv.externalid
                join gradecourse gc on gc.id=exld.gradeid
                where exld.schoolyear=2018 and exld.subjectid=3 and exld.assessmentprogramid=12) exld on exld.id=sr.taskvariantid AND exld.gradeid=tmp.gradeid 
group by tmp.studentid, tmp.studentstestsid;


create index inx_sr_studentid on no_response (studentid,studentstestsid);

drop table if exists tmp_epqa_allscenarios;

with cte_stg2 as (
select 
 st.studentid
,st.status as stg2_status
,st.enrollmentid as stg2_enrollmentid
,ot.schoolid as stg2_schoolid
,ot.districtid as stg2_districtid
,sc_codes.code as stg2_sc_code
,sc_codes.sc_statusname as stg2_sccode_status
, sr.no_req_items
,sr.no_res_items
,sr.no_excluded_items
,sr.no_res_included_items
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_scode sc_codes on sc_codes.stid=st.id and sc_codes.studentid=st.studentid
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10261
and tc.contentareaid=3 and stg.code='Stg2' 
and st.status in (84, 85, 86, 659) --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and gc.abbreviatedname = '5'
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sc_codes.code as stg1_sc_code
,sc_codes.sc_statusname as stg1_sccode_status
,sr.no_req_items
,sr.no_res_items
,sr.no_excluded_items
,sr.no_res_included_items
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_scode sc_codes on sc_codes.stid=st.id and sc_codes.studentid=st.studentid
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10261
and tc.contentareaid=3 and stg.code='Stg1' 
and st.status in (84, 85, 86, 659) --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and gc.abbreviatedname = '5'
)
select distinct
s.statestudentidentifier                 ssid --"Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'ELA'::Char(10)                          "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_req_items             		      "Stage1 #Required"
,stg1.no_res_items                        "Stage1 #Responded" 
,stg1.no_excluded_items                   "Stage1 #ExcludedItems"
,(stg1.no_req_items - stg1.no_excluded_items)     "Stage1 #IncludedItems"
,stg1.no_res_included_items               "Stage1 #IncludedItems Responded"
,stg1.stg1_sc_code                        "Stage1 SC Code"      
,stg1.stg1_sccode_status                  "Stage1 SC Status"   
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_req_items             		      "Stage2 #Required"
,stg2.no_res_items                        "Stage2 #Responded" 
,stg2.no_excluded_items                   "Stage2 #ExcludedItems"
,(stg2.no_req_items - stg2.no_excluded_items)         "Stage2 #IncludedItems"
,stg2.no_res_included_items               "Stage2 #IncludedItems Responded"
,stg2.stg2_sc_code                        "Stage2 SC Code"      
,stg2.stg2_sccode_status                  "Stage2  SC Status"   
,rss.status                               "Full Report Generated"
,rss.rawscore                             "Raw Score"
,rss.scalescore                           "Scale Score"
,rss.standarderror                        "Standard Error"
,ld.level                                 "Level"
,ld1.level                                "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,rpm.schoolstandarderror                  "School Standard Error"
,rpm.districtstandarderror                "District Standard Error"
,rpm.statestandarderror                   "State Standard Error"
,rpm.schoolstudentcount                   "School Student Count"
,rpm.districtstudentcount                 "District Student Count"
,rpm.statestudentcount                    "State Student Count"
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_2_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,rss.aggregatetoschool                    "Aggregated to School"
,rss.aggregatetodistrict                  "Aggregated to District"
,rss.incompletestatus                     "Incomplete flag" 
,rss.stage1hassccode                      "Stage 1 SC Flag"   
,rss.stage2hassccode                      "Stage 2 SC Flag"   
,rss.transferred                          "Transferred Flag"  
,rss.exitstatus                           "Exit Flag"

into temp tmp_epqa_allscenarios
from cte_stg1 stg1 
left join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
left outer join tmp_sub_score rss on stg1.studentid=rss.studentid
left outer join tmp_epqa_median rpm on rpm.schoolid=rss.attendanceschoolid and rpm.gradeid=rss.gradeid
left join organizationtreedetail rptsch on rss.attendanceschoolid = rptsch.schoolid  and rptsch.districtid = rss.districtid
left outer join leveldescription ld on rss.levelid=ld.id
left outer join leveldescription ld1 on rss.previousyearlevelid=ld1.id
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
and gc.abbreviatedname = '5';


\copy (select * from tmp_epqa_allscenarios) to 'tmp_epqa_allscenarios_ela_grade5.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


drop table if exists tmp_epqa_allscenarios;
drop table if exists no_response_cnt;
drop table if exists tmp_epqa_median;
drop table if exists tmp_sub_score;

