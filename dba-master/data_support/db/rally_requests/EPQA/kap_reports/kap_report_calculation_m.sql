--Step1:Find the school,district,state median
drop table if exists tmp_epqa_median;
select distinct org.schoolid,gc.abbreviatedname grade, rpm.score schoolscore, drpm.score districtscore, srpm.score statescore
into temp tmp_epqa_median
from organizationtreedetail org
inner join reportsmedianscore rpm on rpm.organizationid=org.schoolid and rpm.organizationtypeid =7
inner join reportsmedianscore drpm on drpm.organizationid=org.districtid and drpm.organizationtypeid=5 and drpm.gradeid =rpm.gradeid 
inner join reportsmedianscore srpm on srpm.organizationid = org.stateid and srpm.organizationtypeid=2 and srpm.gradeid=drpm.gradeid 
inner join gradecourse gc on gc.id= rpm.gradeid  
where rpm.assessmentprogramid =12 and rpm.contentareaid=440  and rpm.schoolyear=2017 and rpm.subscoredefinitionname  is null
 and drpm.assessmentprogramid =12 and drpm.contentareaid=440 and drpm.schoolyear=2017 and drpm.subscoredefinitionname is null 
 and srpm.assessmentprogramid =12 and srpm.contentareaid=440 and srpm.schoolyear=2017 and srpm.subscoredefinitionname is null
order by org.schoolid, gc.abbreviatedname;

--Step2:Find the rating
drop table if exists tmp_sub_score;
select rss.studentreportid,rss.studentid
,MAX(case when rss.subscoredefinitionname ='Claim_1_all'         then rss.rating end) as    Claim_1_all_rating         
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_1' then rss.rating end) as    Claim_1_Rpt_Group_1_rating   
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_2' then rss.rating end) as    Claim_1_Rpt_Group_2_rating   
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_3' then rss.rating end) as    Claim_1_Rpt_Group_3_rating  
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_4' then rss.rating end) as    Claim_1_Rpt_Group_4_rating   
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_5' then rss.rating end) as    Claim_1_Rpt_Group_5_rating   
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_6' then rss.rating end) as    Claim_1_Rpt_Group_6_rating   
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_7' then rss.rating end) as    Claim_1_Rpt_Group_7_rating   
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_8' then rss.rating end) as    Claim_1_Rpt_Group_8_rating   
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_9' then rss.rating end) as    Claim_1_Rpt_Group_9_rating   
,MAX(case when rss.subscoredefinitionname ='Claim_2_all'         then rss.rating end) as    Claim_2_all_rating  
,MAX(case when rss.subscoredefinitionname ='Claim_3_all'         then rss.rating end) as    Claim_3_all_rating  
,MAX(case when rss.subscoredefinitionname ='Claim_4_all'         then rss.rating end) as    Claim_4_all_rating  

,max(case when rss.subscoredefinitionname='Claim_1_all'         then rss.subscorerawscore end) "Claim_1_all"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_1' then rss.subscorerawscore end) "Claim_1_Rpt_Group_1"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_2' then rss.subscorerawscore end) "Claim_1_Rpt_Group_2"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_3' then rss.subscorerawscore end) "Claim_1_Rpt_Group_3"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_4' then rss.subscorerawscore end) "Claim_1_Rpt_Group_4"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_5' then rss.subscorerawscore end) "Claim_1_Rpt_Group_5"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_6' then rss.subscorerawscore end) "Claim_1_Rpt_Group_6"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_7' then rss.subscorerawscore end) "Claim_1_Rpt_Group_7"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_8' then rss.subscorerawscore end) "Claim_1_Rpt_Group_8"
,max(case when rss.subscoredefinitionname='Claim_1_Rpt_Group_9' then rss.subscorerawscore end) "Claim_1_Rpt_Group_9"
,max(case when rss.subscoredefinitionname='Claim_2_all'	        then rss.subscorerawscore end) "Claim_2_all"
,max(case when rss.subscoredefinitionname='Claim_3_all'	        then rss.subscorerawscore end) "Claim_3_all"
,max(case when rss.subscoredefinitionname='Claim_4_all'	        then rss.subscorerawscore end) "Claim_4_all"

into temp tmp_sub_score  
from reportsubscores rss 
inner join studentreport sr on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440 
--and sr.studentid=688474
group by rss.studentreportid,rss.studentid;

--Step3:Find the rating
drop table if exists tmp_min_score;
select rms.studentreportid,rms.studentid
,sum(case when rms.subscoredefinitionname='Claim_1_all'         then rms.itemsresponded end)   "Claim_1_all_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_1' then rms.itemsresponded end)   "Claim_1_Rpt_Group_1_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_2' then rms.itemsresponded end)   "Claim_1_Rpt_Group_2_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_3' then rms.itemsresponded end)   "Claim_1_Rpt_Group_3_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_4' then rms.itemsresponded end)   "Claim_1_Rpt_Group_4_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_5' then rms.itemsresponded end)   "Claim_1_Rpt_Group_5_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_6' then rms.itemsresponded end)   "Claim_1_Rpt_Group_6_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_7' then rms.itemsresponded end)   "Claim_1_Rpt_Group_7_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_8' then rms.itemsresponded end)   "Claim_1_Rpt_Group_8_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_9' then rms.itemsresponded end)   "Claim_1_Rpt_Group_9_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_2_all'	    then rms.itemsresponded end)       "Claim_2_all_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_3_all'	    then rms.itemsresponded end)       "Claim_3_all_W_Responses"
,sum(case when rms.subscoredefinitionname='Claim_4_all'	    then rms.itemsresponded end)       "Claim_4_all_W_Responses"

,sum(case when rms.subscoredefinitionname='Claim_1_all'         then rms.totalitemsincluded end) "Claim_1_all_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_1' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_1_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_2' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_2_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_3' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_3_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_4' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_4_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_5' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_5_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_6' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_6_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_7' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_7_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_8' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_8_Included"
,sum(case when rms.subscoredefinitionname='Claim_1_Rpt_Group_9' then rms.totalitemsincluded end) "Claim_1_Rpt_Group_9_Included"
,sum(case when rms.subscoredefinitionname='Claim_2_all'	        then rms.totalitemsincluded end)     "Claim_2_all_Included"
,sum(case when rms.subscoredefinitionname='Claim_3_all'	        then rms.totalitemsincluded end)     "Claim_3_all_Included"
,sum(case when rms.subscoredefinitionname='Claim_4_all'	        then rms.totalitemsincluded end)     "Claim_4_all_Included"

into temp tmp_min_score  
from reporttestlevelsubscores rms 
inner join studentreport sr on rms.studentreportid=sr.id and sr.studentid=rms.studentid
where sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440
 --and sr.studentid=688474
group by rms.studentreportid,rms.studentid;


--====================================================================================================================
--KAP ELA report  
--====================================================================================================================
drop table if exists tmp_epqa_scenario1;
with cte_stg1 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid
,gc.abbreviatedname
,t.externalid
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail otstg1 on otstg1.schoolid=ts.attendanceschoolid
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join test t on t.id=st.testid and t.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and stg.code='Stg1' 
-- and otstg1.districtid=203 
and st.studentid in (64048,39701,39700,64189,44115,64055,44006,32425,44669,63502)
group by st.studentid,st.enrollmentid,ts.attendanceschoolid,gc.abbreviatedname,t.externalid
)
,cte_stg2 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid
,gc.abbreviatedname
,t.externalid
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join cte_stg1 on cte_stg1.studentid=st.studentid
inner join organizationtreedetail otstg1 on otstg1.schoolid=ts.attendanceschoolid
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join test t on t.id=st.testid and t.activeflag is true 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and stg.code='Stg2' 
-- and otstg1.districtid=203
and st.studentid in (64048,39701,39700,64189,44115,64055,44006,32425,44669,63502)
group by st.studentid,st.enrollmentid,ts.attendanceschoolid,gc.abbreviatedname,t.externalid
)
select s.statestudentidentifier                 "State Student Identifier"
,'Kansas'::Char(6)    "State"
,ot.districtname      "District"
,ot.schoolname        "School"
,gc.name              "Grade"
,legallastname        "Student Last Name"
,legalfirstname       "Student First Name"
,'Math'::Char(10)     "Subject"
,stg1.externalid    "Stage 1"
,stg2.externalid   "Stage 2"
,rawscore "Satge Raw Score"
,scalescore "Scale_Score"
,standarderror "Standard_Error"
,lev.level "Level_Number"
,"Claim_1_all"
,"Claim_1_Rpt_Group_1"
,"Claim_1_Rpt_Group_2"
,"Claim_1_Rpt_Group_3"
,"Claim_1_Rpt_Group_4"
,"Claim_1_Rpt_Group_5"
,"Claim_1_Rpt_Group_6"
,"Claim_1_Rpt_Group_7"
,"Claim_1_Rpt_Group_8"
,"Claim_1_Rpt_Group_9"
,"Claim_2_all"
,"Claim_3_all"
,"Claim_4_all"

,"Claim_1_all_W_Responses"
,"Claim_1_Rpt_Group_1_W_Responses"
,"Claim_1_Rpt_Group_2_W_Responses"
,"Claim_1_Rpt_Group_3_W_Responses"
,"Claim_1_Rpt_Group_4_W_Responses"
,"Claim_1_Rpt_Group_5_W_Responses"
,"Claim_1_Rpt_Group_6_W_Responses"
,"Claim_1_Rpt_Group_7_W_Responses"
,"Claim_1_Rpt_Group_8_W_Responses"
,"Claim_1_Rpt_Group_9_W_Responses"
,"Claim_2_all_W_Responses"
,"Claim_3_all_W_Responses"
,"Claim_4_all_W_Responses"

,"Claim_1_all_Included"
,"Claim_1_Rpt_Group_1_Included"
,"Claim_1_Rpt_Group_2_Included"
,"Claim_1_Rpt_Group_3_Included"
,"Claim_1_Rpt_Group_4_Included"
,"Claim_1_Rpt_Group_5_Included"
,"Claim_1_Rpt_Group_6_Included"
,"Claim_1_Rpt_Group_7_Included"
,"Claim_1_Rpt_Group_8_Included"
,"Claim_1_Rpt_Group_9_Included"
,"Claim_2_all_Included"
,"Claim_3_all_Included"
,"Claim_4_all_Included"

,''::Char(1)  "Claim_1_all_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_1_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_2_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_3_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_4_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_5_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_6_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_7_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_8_Min_Respoonses"
,''::Char(1)  "Claim_1_Rtp_Group_9_Min_Respoonses"
,''::Char(1)  "Claim_2_all_Min_Respoonses"
,''::Char(1)  "Claim_3_all_Min_Respoonses"
,''::Char(1)  "Claim_4_all_Min_Respoonses"

,Claim_1_all_rating         "Claim_1_all_Rating"
,Claim_1_Rpt_Group_1_rating "Claim_1_Rpt_Group_1_Rating"
,Claim_1_Rpt_Group_2_rating "Claim_1_Rpt_Group_2_Rating"
,Claim_1_Rpt_Group_3_rating "Claim_1_Rpt_Group_3_Rating"
,Claim_1_Rpt_Group_4_rating "Claim_1_Rpt_Group_4_Rating"
,Claim_1_Rpt_Group_5_rating "Claim_1_Rpt_Group_5_Rating"
,Claim_1_Rpt_Group_6_rating "Claim_1_Rpt_Group_6_Rating"
,Claim_1_Rpt_Group_7_rating "Claim_1_Rpt_Group_7_Rating"
,Claim_1_Rpt_Group_8_rating "Claim_1_Rpt_Group_8_Rating"
,Claim_1_Rpt_Group_9_rating "Claim_1_Rpt_Group_9_Rating"
,Claim_2_all_rating         "Claim_2_all_Rating"
,Claim_3_all_rating         "Claim_3_all_Rating"
,Claim_4_all_rating         "Claim_4_all_Rating"

into temp tmp_epqa_scenario1
from student s 
inner join enrollment e on s.id=e.studentid  and e.activeflag is true
inner join cte_stg1 stg1 on stg1.studentid=s.id and e.id=stg1.enrollmentid
left outer join cte_stg2 stg2 on stg2.studentid=s.id and e.id=stg2.enrollmentid
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true 
left outer join tmp_epqa_median rpm on rpm.schoolid=e.attendanceschoolid and rpm.grade=gc.abbreviatedname
left outer join studentreport sr on sr.studentid=s.id and e.id=sr.enrollmentid
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440 
left outer join  leveldescription lev on lev.id=sr.levelid and lev.schoolyear=2017 and lev.assessmentprogramid=12 and lev.subjectid=440
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid 
left outer join tmp_min_score rms on rms.studentreportid=sr.id and sr.studentid=rms.studentid 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and s.activeflag is true
and s.id in (64048,39701,39700,64189,44115,64055,44006,32425,44669,63502);
--limit 1000; 

--select * from leveldescription  limit 1

-- \copy (select  * from tmp_epqa_scenario1) to 'tmp_epqa_scenario1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--select * from tmp_epqa_scenario1