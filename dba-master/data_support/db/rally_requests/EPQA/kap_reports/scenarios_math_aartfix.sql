-- scripts has dependencies we need to run step by step
-- step1:we need to exclude the items by the subject
drop table if exists tmp_epqa_exclude;
create temp table tmp_epqa_exclude (tvid bigint);
insert into tmp_epqa_exclude
select distinct id from taskvariant
where externalid in (59032,57975,56775,57077,57853,35928,57060,56777,59494,57321,57084,56768,57863,57063,57324,57072,57944,56954,57143,58950,57083,56703,59456,57937,56705,59524,57022,57320,57323,57852,59523,56757,56960,
58948,57851,57074,58946,57067,58949,57071,57856,57945,57883,59495,57073,59522,59457,59167,59498,57078,57328,57142,59459,59372,57079,59525,56764,57027,57066,59476,58965,56955,57326,59478,57322,59545,
59195,59624,57850,57325,59104,59487,59501,59168,57080,59547,56711,59490,60123,57026,59568,56779,57870,57972,56986,58885,57106,56792,57858,56984,59404,56785,56958,56980,58884,58887,57111,57316,61635,
58972,58971,57114,59284,59471,58877,59403,58831,58837,58953,59401,59405,57126,56965,58955,58878,59097,57127,56972,61636,57986,59406,57109,58874,57976,59392,59033,56787,59020,57855,57301,59407,59092,
57877,61637,60005,57992,56789,56973,57881,59282,58974,56977,57317,59393,56781,59408,58008,59002,59325,58970,58880,58832,59021,59326,61639,58976,56780,58956,59510,59395,58010,56935,56912,57984,59006,
57169,56968,56919,58996,59035,59281,58017,57115,58034,56928,56932,56939,57123,58089,58060,59036,56934,56803,58036,59453,59430,56936,57120,56925,58012,59037,56937,57122,56924,59010,59038,57117,57983,
59004,58015,59119,56907,59435,56927,59043,59439,56979,58085,58092,57979,59448,56981,58029,59529,56926,56930,56911,57178,56923,60896,59044,56974,56920,57128,60084,59560,56909,57985,59558,59449,56905,
57119,58978,58992,56922,59126,56970,58088,59531,58097,58983,58030,56811,58114,58125,58129,56725,58076,59947,59400,56824,56728,58269,56821,59904,59949,56817,58275,59903,58038,58112,58042,58131,59948,
58270,59316,56832,58083,56827,56823,59888,58098,60101,59889,59026,56819,57019,56834,58151,58117,59483,59024,58122,58111,59946,59165,59314,59321,59953,56808,58274,59305,59023,56835,58057,59151,59482,
57295,59880,59025,59397,58100,59319,58152,58119,59310,59398,57173,59955,59306,59315,59322,57299,59900,59307,58271,58028,59027,58272,59311,58159,56747,58209,59065,59051,58222,56713,56769,56798,59189,
56739,57006,57003,59068,59426,57094,56730,56784,59058,57000,59164,56710,56799,59427,56738,56767,56726,57001,56801,56762,59122,56727,58268,59062,59055,57228,56732,57154,56802,57221,58260,56756,58993,
56797,59419,56800,59555,56794,57004,58986,56743,58988,57161,56795,56746,58224,57689,59497,59003,57096,58212,57155,56786,58999,56793,56741,56733,57220,58266,60129,59423,59039,56773,59008,60643,56796,
58215,58226,59187,59417,59554,56833,56836,59064,57196,57682,57356,57397,57204,59125,56998,59504,59508,58204,57206,61021,59546,59914,59466,57344,59541,57212,56987,57209,59906,60944,57207,59512,57269,
58893,57346,57211,59061,59467,59505,57197,57139,57683,58177,59484,60118,57203,59514,56999,57210,58895,56842,59507,61022,56841,57350,58896,57208,57198,57141,59098,57354,57360,59485,60740,56839,59042,
59486,57140,57153,59910,59945,57348,58890,58888,57357,60729,57271,58897,58945,59481,59515,57399,57273,56886,57108,57612,58171,57035,57044,57051,57034,56853,56879,59821,56882,59517,59566,58013,59556,
56889,58014,56871,59853,56887,57048,60083,59520,59196,58929,59204,58020,59841,59852,56873,57179,57037,59200,59205,59845,59855,58022,58930,59100,57133,59530,59544,59572,56890,56884,59088,58021,59532,
59202,57091,59201,57052,59944,58202,59534,60853,57045,58206,59586,57046,57105,56888,58926,59084,59887,58176,59518,58925,59551,57047,58253,60074,59549,60850,57333,59584,59590,59854,59865);

-- step2:we need to find the school,district,state median
drop table if exists tmp_epqa_median;
select distinct org.schoolid,gc.abbreviatedname grade, rpm.score schoolscore, drpm.score districtscore, srpm.score statescore
into temp tmp_epqa_median
from organizationtreedetail org
inner join reportsmedianscore rpm on rpm.organizationid=org.schoolid and rpm.organizationtypeid =7
inner join reportsmedianscore drpm on drpm.organizationid=org.districtid and drpm.organizationtypeid=5 and drpm.gradeid =rpm.gradeid 
inner join reportsmedianscore srpm on srpm.organizationid = org.stateid and srpm.organizationtypeid=2 and srpm.gradeid=drpm.gradeid 
inner join gradecourse gc on gc.id= rpm.gradeid  
where rpm.assessmentprogramid =12 and rpm.contentareaid=440  and rpm.schoolyear=2017  and rpm.subscoredefinitionname  is null
 and drpm.assessmentprogramid =12 and drpm.contentareaid=440 and drpm.schoolyear=2017 and drpm.subscoredefinitionname is null 
 and srpm.assessmentprogramid =12 and srpm.contentareaid=440 and srpm.schoolyear=2017 and srpm.subscoredefinitionname is null
order by org.schoolid, gc.abbreviatedname;

-- view only lines:claim names different for ela and math
-- select subscoredefinitionname,subscorereportdisplayname
-- from subscoresdescription where assessmentprogramid=12 and subjectid=3 and report='Student' and schoolyear=2017;
/*
-- step3:we need to exclude the items by the subject
drop table if exists tmp_sub_score;
 select 
 rss.studentreportid
,rss.studentid
,rss.subscoredefinitionname
,rss.rating
into temp tmp_sub_score  
from reportsubscores rss 
inner join studentreport sr on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440;
*/
--step3: we need to exclude the items by the subject 
drop table if exists tmp_sub_score;
select rss.studentreportid,rss.studentid
,MAX(case when rss.subscoredefinitionname ='Claim_1_all'         then rss.rating end) as    Claim_1_all         
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_1' then rss.rating end) as    Claim_1_Rpt_Group_1 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_2' then rss.rating end) as    Claim_1_Rpt_Group_2 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_3' then rss.rating end) as    Claim_1_Rpt_Group_3
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_4' then rss.rating end) as    Claim_1_Rpt_Group_4 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_5' then rss.rating end) as    Claim_1_Rpt_Group_5 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_6' then rss.rating end) as    Claim_1_Rpt_Group_6 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_7' then rss.rating end) as    Claim_1_Rpt_Group_7 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_8' then rss.rating end) as    Claim_1_Rpt_Group_8 
,MAX(case when rss.subscoredefinitionname ='Claim_1_Rpt_Group_9' then rss.rating end) as    Claim_1_Rpt_Group_9 
,MAX(case when rss.subscoredefinitionname ='Claim_2_all'         then rss.rating end) as    Claim_2_all
,MAX(case when rss.subscoredefinitionname ='Claim_3_all'         then rss.rating end) as    Claim_3_all
,MAX(case when rss.subscoredefinitionname ='Claim_4_all'         then rss.rating end) as    Claim_4_all
into temp tmp_sub_score  
from reportsubscores rss 
inner join studentreport sr on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440
group by rss.studentreportid,rss.studentid;
 
--step4:find sccode at ELA and MATH
drop table if exists tmp_scode;
select distinct st.studentid , ca.id,
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
and tc.contentareaid=440; 


--=======================================================================================================
--Scenario1[ELA,KS,KAP,Report]:(1)Stage_1_Status=Complete (2)Stage_2_Status=Complete (3)Score_Report=yes
--=======================================================================================================
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
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and ot.districtid=203 
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=count(distinct tstv.taskvariantid)
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
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and ot.districtid=203 
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)=count(distinct tstv.taskvariantid)
limit 100)
select 
'scenario1'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
left outer join tmp_epqa_median rpm on rpm.schoolid=e.attendanceschoolid and rpm.grade=gc.abbreviatedname
left outer join studentreport sr on sr.studentid=s.id and e.id=sr.enrollmentid
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and ot.districtid=203 
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;  

\copy (select * from tmp_epqa_scenario1) to 'tmp_epqa_scenario1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=======================================================================================
--Scenario2[ELA,KS,KAP,Report]:(1)Stage_1_Status=5 (2)Stage_2_Status=5 (3)Score_Report=yes
--========================================================================================
drop table if exists tmp_epqa_scenario2;
with cte_stg2 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and ot.districtid=203
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
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
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and ot.districtid=203
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario2'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
into temp tmp_epqa_scenario2
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and ot.districtid=203
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;  
\copy (select * from tmp_epqa_scenario2) to 'tmp_epqa_scenario2.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=========================================================================================================
--Scenario3[ELA,KS,KAP,Report]:(1)Stage_1_Status<5 (2)Stage_2_Status=<5 (3)Score_Report=no(4)Text_Report=yes           ??????
--==========================================================================================================
drop table if exists tmp_epqa_scenario3;
with cte_stg2 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and ot.districtid=203
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)<5
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
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and ot.districtid=203
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)<5
limit 100)
select 
'scenario3'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
into temp tmp_epqa_scenario3
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and ot.districtid=203
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50; 
\copy (select * from tmp_epqa_scenario3) to 'tmp_epqa_scenario3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--=========================================================================================================
--Scenario4[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status=in process>5 (3)Score_Report=yes          
--==========================================================================================================
drop table if exists tmp_epqa_scenario4;
with cte_stg2 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=85 
and exld.tvid is null
and ot.districtid=203
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and ot.districtid=203
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario4'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
into temp tmp_epqa_scenario4
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and ot.districtid=203
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50; 
\copy (select * from tmp_epqa_scenario4) to 'tmp_epqa_scenario4.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=========================================================================================================
--Scenario5[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status=in process=5 (3)Score_Report=no(4)Text_Report=yes          
--==========================================================================================================
drop table if exists tmp_epqa_scenario5;
with cte_stg2 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=85 
and exld.tvid is null
and ot.districtid=203
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
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
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and ot.districtid=203
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario5'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario5
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and ot.districtid=203
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50; 
\copy (select * from tmp_epqa_scenario5) to 'tmp_epqa_scenario5.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=========================================================================================================
--Scenario6[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status=in process time out<5 (3)Score_Report=no (4)Text_Report=yes         
--==========================================================================================================
drop table if exists tmp_epqa_scenario6;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=659
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)<5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario6'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario6
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50; 
\copy (select * from tmp_epqa_scenario6) to 'tmp_epqa_scenario6.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=========================================================================================================
--Scenario7[ELA,KS,KAP,Report]:(1)Stage_1_Status<5 (2)Stage_2_Status=in process time out>5 (3)Score_Report=no (4)Text_Report=yes          
--==========================================================================================================
drop table if exists tmp_epqa_scenario7;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=659
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)<5
limit 100)
select 
'scenario7'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario7
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario7) to 'tmp_epqa_scenario7.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=========================================================================================================
--Scenario8[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status=in process time out=5 (3)Score_Report=yes          
--==========================================================================================================
drop table if exists tmp_epqa_scenario8;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=659
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario8'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario8
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
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario8) to 'tmp_epqa_scenario8.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=========================================================================================================
--Scenario9[ELA,KS,KAP,Report]:(1)Stage_1_Status<5 (2)Stage_2_Status=in process >5 
--==========================================================================================================
drop table if exists tmp_epqa_scenario9;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=85
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)<5
limit 100)
select 
'scenario9'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario9
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario9) to 'tmp_epqa_scenario9.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--=========================================================================================================
--Scenario10[ELA,KS,KAP,Report]:(1)Stage_1_Status<5 (2)Stage_2_Status >5 
--==========================================================================================================
drop table if exists tmp_epqa_scenario10;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)<5
limit 100)
select 
'scenario10'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario10
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario10) to 'tmp_epqa_scenario10.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--==============================================================================================================
--Scenario11[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status:unused (3)Score_Report:no (4)Text_Report:yes
--===============================================================================================================
drop table if exists tmp_epqa_scenario11;
with cte_stg2 as (
select distinct 
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=84
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
--having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)<5
limit 100)
select 
'scenario11'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario11
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario11) to 'tmp_epqa_scenario11.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--==============================================================================================================
--Scenario12[ELA,KS,KAP,Report]:(1)Stage_1_Status:in process>5 (2)Stage_2_Status:n/a (3)Score_Report:no (4)Text_Report:yes
--===============================================================================================================
drop table if exists tmp_epqa_scenario12;
with cte_stg2 as (
select distinct 
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status is null
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
--having count(distinct sres1.taskvariantid)>5
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
left outer join cte_stg2 stg2 on stg2.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=85
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario12'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario12
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario12) to 'tmp_epqa_scenario12.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--==============================================================================================================
--Scenario13[ELA,KS,KAP,Report]:(1)Stage_1_Status:in process<5 (2)Stage_2_Status:n/a (3)Score_Report:no (4)Text_Report:yes
--===============================================================================================================
drop table if exists tmp_epqa_scenario13;
with cte_stg2 as (
select distinct 
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status is null
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
--having count(distinct sres1.taskvariantid)>5
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
left outer join cte_stg2 stg2 on stg2.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=85
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)<5
limit 100)
select 
'scenario13'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario13
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario13) to 'tmp_epqa_scenario13.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--==============================================================================================================
--Scenario14[ELA,KS,KAP,Report]:(1)Stage_1_Status:in process time out=5 (2)Stage_2_Status:n/a (3)Score_Report:no (4)Text_Report:yes
--===============================================================================================================
drop table if exists tmp_epqa_scenario14;
with cte_stg2 as (
select distinct 
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status is null
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
--having count(distinct sres1.taskvariantid)>5
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
left outer join cte_stg2 stg2 on stg2.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=659
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario14'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario14
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario14) to 'tmp_epqa_scenario14.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--==============================================================================================================
--Scenario15[ELA,KS,KAP,Report]:(1)Stage_1_Status:complete=5(including excluding item)(2)Stage_2_Status>5(3)Score_Report:no (4)Text_Report:yes
--===============================================================================================================
drop table if exists tmp_epqa_scenario15;
with cte_stg2 as (
select distinct 
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status =86
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
left outer join cte_stg2 stg2 on stg2.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario15'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario15
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario15) to 'tmp_epqa_scenario15.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



--=======================================================================================================================================================
--Scenario16[ELA,KS,KAP,Report]:(1)Stage_1_Status>5(2)Stage_2_Status:in process time out=5(including excluding item)(3)Score_Report:no (4)Text_Report:yes
--=====================================================================================================================================================
drop table if exists tmp_epqa_scenario16;
with cte_stg2 as (
select distinct 
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status =659
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
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
left outer join cte_stg2 stg2 on stg2.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario16'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario16
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario16) to 'tmp_epqa_scenario16.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--====================================================================================================================================================
--Scenario17[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status>5 (3)Score_Report=no (4)Text_Report=yes (5)Scode:SC-B1(6)Scode_Applied=applied
--====================================================================================================================================================
drop table if exists tmp_epqa_scenario17;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario17'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario17
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-B1' and scd.id=549--Approved
limit 50;
\copy (select * from tmp_epqa_scenario17) to 'tmp_epqa_scenario17.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--======================================================================================================================================================
--Scenario18[ELA,KS,KAP,Report]:(1)Stage_1_Status=5 (2)Stage_2_Status=5 (3)Score_Report=yes (4)Text_Report=no (5)Scode:SC-B1(6)Scode_Applied=not applied
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario18;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario18'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario18
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-B1' and scd.id=550 --'Not Approved'
limit 50;
\copy (select * from tmp_epqa_scenario18) to 'tmp_epqa_scenario18.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--======================================================================================================================================================
--Scenario19[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status=5 (3)Score_Report=no (4)Text_Report=yes (5)Scode:SC-B1(6)Scode_Applied=applied
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario19;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario19'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS" 
into temp tmp_epqa_scenario19
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-B1' and scd.id=549 --'Approved'
limit 50;
\copy (select * from tmp_epqa_scenario19) to 'tmp_epqa_scenario19.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--======================================================================================================================================================
--Scenario20[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status:In process>5 (3)Score_Report=yes (4)Text_Report=no (5)Scode:SC-B1(6)Scode_Applied=not applied
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario20;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=85 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario20'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario20
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-B1' and scd.id=550 --'Not Approved'
limit 50;
\copy (select * from tmp_epqa_scenario20) to 'tmp_epqa_scenario20.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--======================================================================================================================================================
--Scenario21[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status:In process=5 (3)Score_Report=yes (4)Text_Report=null (5)Scode:SC-A(6)Scode_Applied=no  
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario21;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=85 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario21'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario21
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-A' and scd.id=550 --'Not Approved'
limit 50;
\copy (select * from tmp_epqa_scenario21) to 'tmp_epqa_scenario21.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--======================================================================================================================================================
--Scenario22[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status:In process=5 (3)Score_Report=no (4)Text_Report=yes (5)Scode:SC-A(6)Scode_Applied=yes 
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario22;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=85 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario22'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario22
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-A' and scd.id=549 --'Approved'
limit 50;
\copy (select * from tmp_epqa_scenario22) to 'tmp_epqa_scenario22.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--======================================================================================================================================================
--Scenario23[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status>5 (3)Score_Report=yes(4)Text_Report=no (5)Scode:SC-B2(6)Scode_Applied=Applied 
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario23;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario23'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario23
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-B2' and scd.id=549 --'Approved'
limit 50;
\copy (select * from tmp_epqa_scenario23) to 'tmp_epqa_scenario23.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--======================================================================================================================================================
--Scenario24[ELA,KS,KAP,Report]:(1)Stage_1_Status=5 (2)Stage_2_Status=5 (3)Score_Report=yes(4)Text_Report=no (5)Scode:SC-B2(6)Scode_Applied=not applied 
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario24;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario24'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario24
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-B2' and scd.id=550 --'Not Approved'
limit 50;
\copy (select * from tmp_epqa_scenario24) to 'tmp_epqa_scenario24.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--======================================================================================================================================================
--Scenario25[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status=5 (3)Score_Report=yes(4)Text_Report=null(5)Scode:SC-B2(6)Scode_Applied=applied 
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario25;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario25'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario25
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-B2' and scd.id=549 --'Approved'
limit 50;
\copy (select * from tmp_epqa_scenario25) to 'tmp_epqa_scenario25.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--======================================================================================================================================================
--Scenario26[ELA,KS,KAP,Report]:(1)Stage_1_Status=5 (2)Stage_2_Status<5 (3)Score_Report=no(4)Text_Report=yes(5)Scode:SC-B2(6)Scode_Applied=notapplied 
--=======================================================================================================================================================
drop table if exists tmp_epqa_scenario26;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)<5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario26'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario26
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid 
and scd.code='SC-B2' and scd.id=550 --'Not Approved'
limit 50;
\copy (select * from tmp_epqa_scenario26) to 'tmp_epqa_scenario26.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--================================================================================================================================================================================================
--Scenario27[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status>5 (3)within district transfer after stage1(4)Scode:SC-B2(5)Scode_Applied=yes(6)Score_Report=no(7)Text_Report=yes
--=============================================================================================================================================================================================
drop table if exists tmp_epqa_scenario27;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 --and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario27'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS" 
into temp tmp_epqa_scenario27
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid and e.activeflag is true 
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
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg2_schoolid=e.attendanceschoolid and otstg1.districtid = otstg2.districtid
and scd.code='SC-A' and scd.id=549 --'Approved'
limit 50;
\copy (select * from tmp_epqa_scenario27) to 'tmp_epqa_scenario27.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--================================================================================================================================================================================================
--Scenario28[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status>5 (3)within district transfer after stage1(6)Score_Report=Yes-B
--=============================================================================================================================================================================================
drop table if exists tmp_epqa_scenario28;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 --and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario28'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS" 
into temp tmp_epqa_scenario28
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid and e.activeflag is true 
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg2_schoolid=e.attendanceschoolid and otstg1.districtid = otstg2.districtid
limit 50;
\copy (select * from tmp_epqa_scenario28) to 'tmp_epqa_scenario28.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--================================================================================================================================================================================================
--Scenario29[ELA,KS,KAP,Report]:(1)Stage_1_Status=5 (2)Stage_2_Status:In process=5 (3)within district transfer after stage1(6)Score_Report=Yes-B
--=============================================================================================================================================================================================
drop table if exists tmp_epqa_scenario29;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=85
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017  st.activeflag =false
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario29'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario29
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid and e.activeflag is true 
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg2_schoolid=e.attendanceschoolid and otstg1.districtid = otstg2.districtid
limit 50;
\copy (select * from tmp_epqa_scenario29) to 'tmp_epqa_scenario29.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--================================================================================================================================================================================================
--Scenario30[ELA,KS,KAP,Report]:(1)Stage_1_Status=5 (2)Stage_2_Status:unused (3)within district transfer after stage1(4)Score_Report=no(5)Text_Report:Yes=B
--=============================================================================================================================================================================================
drop table if exists tmp_epqa_scenario30;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=84
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
--having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag =false 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario30'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario30
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid and e.activeflag is true 
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg2_schoolid=e.attendanceschoolid and otstg1.districtid = otstg2.districtid
limit 50;
\copy (select * from tmp_epqa_scenario30) to 'tmp_epqa_scenario30.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--================================================================================================================================================================================================
--Scenario31[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status:In process time out=5 (3)within district transfer after stage1(4)Score_Report=Yes-B
--=============================================================================================================================================================================================
drop table if exists tmp_epqa_scenario31;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=659
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag=false
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario31'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario31
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid and e.activeflag is true 
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg2_schoolid=e.attendanceschoolid and otstg1.districtid = otstg2.districtid
limit 50;
\copy (select * from tmp_epqa_scenario31) to 'tmp_epqa_scenario31.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--================================================================================================================================================================================================
--Scenario32[ELA,KS,KAP,Report]:(1)Stage_1_Status:in process =5 (2)Stage_2_Status:both complete>5(3)within district transfer after stage1(4)Score_Report=Yes-B
--=============================================================================================================================================================================================
drop table if exists tmp_epqa_scenario32;
with cte_stg2 as (
select
st.studentid
,st.enrollmentid
,ts.attendanceschoolid
,(case when stg1.code ='Stg1' then count(distinct tstv.taskvariantid) end ) no_req_items_stg1
,(case when stg1.code ='Stg2' then count(distinct tstv.taskvariantid) end ) no_req_items_stg2
,(case when stg1.code ='Stg1' then count(distinct sres1.taskvariantid) end ) no_res_items_stg1
,(case when stg1.code ='Stg2' then count(distinct sres1.taskvariantid) end ) no_res_items_stg2

from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg1 on stg1.id=tc.stageid and stg1.activeflag is true and stg.code='Stg1'
inner join stage stg2 on stg2.id =tc.stageid and stg2.activeflag is true and stg2.code='Stg2'
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and stg1.code='Stg1'
inner join studentsresponses sres2 ON st.id = sres2.studentstestsid and sres2.taskvariantid=tstv.taskvariantid and stg2.code='Stg2'
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
--and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=count(distinct sres2.taskvariantid)=5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag=false
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=85 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario32'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario32
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid and e.activeflag is true 
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg2_schoolid=e.attendanceschoolid and otstg1.districtid = otstg2.districtid
limit 50;
\copy (select * from tmp_epqa_scenario32) to 'tmp_epqa_scenario32.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--================================================================================================================================================================================================
--Scenario33[ELA,KS,KAP,Report]:(1)Stage_1_Status:in process =5 (2)Stage_2_Status:both complete-stage1=5,stage2=4(3)within district transfer after stage1(4)Score_Report=no (5)Text_Report:Yes-B
--=================================================================================================================================================================================================
drop table if exists tmp_epqa_scenario33;
with cte_stg2 as (
select
st.studentid
,st.enrollmentid
,ts.attendanceschoolid
,(case when stg1.code ='Stg1' then count(distinct tstv.taskvariantid) end ) no_req_items_stg1
,(case when stg1.code ='Stg2' then count(distinct tstv.taskvariantid) end ) no_req_items_stg2
,(case when stg1.code ='Stg1' then count(distinct sres1.taskvariantid) end ) no_res_items_stg1
,(case when stg1.code ='Stg2' then count(distinct sres1.taskvariantid) end ) no_res_items_stg2

from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg1 on stg1.id=tc.stageid and stg1.activeflag is true and stg.code='Stg1'
inner join stage stg2 on stg2.id =tc.stageid and stg2.activeflag is true and stg2.code='Stg2'
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and stg1.code='Stg1'
inner join studentsresponses sres2 ON st.id = sres2.studentstestsid and sres2.taskvariantid=tstv.taskvariantid and stg2.code='Stg2'
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
--and stg.code='Stg2' 
-- and gc.abbreviatedname='5'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=5 and count(distinct sres2.taskvariantid)=4
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag=false
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=85 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario33'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario33
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid and e.activeflag is true 
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
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg2_schoolid=e.attendanceschoolid and otstg1.districtid = otstg2.districtid
limit 50;
\copy (select * from tmp_epqa_scenario33) to 'tmp_epqa_scenario33.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);




--======================================================================================================================================
--Scenario34[ELA,KS,KAP,Report]:(1)Stage_1_Status>5 A (2)Stage_2_Status>5 A (3)within district transfer after stage2(4)Score_Report:Yes-B
--=====================================================================================================================================
drop table if exists tmp_epqa_scenario34;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario34'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario34
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
and otstg2.districtid=ot.districtid and otstg2.schoolid<>e.attendanceschoolid
limit 50;
\copy (select * from tmp_epqa_scenario34) to 'tmp_epqa_scenario35.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=======================================================================================================
--Scenario35[ELA,KS,KAP,Report]:A	Complete>5	A	Complete>5	Exit and not enrolled anywhere
--=======================================================================================================
drop table if exists tmp_epqa_scenario35;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario35'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario35
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid  and e.activeflag is false 
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
and not exists (select 1 from enrollment e_act where e_act.studentid=e.studentid and e_act.activeflag is true)
limit 50;  

\copy (select * from tmp_epqa_scenario35) to 'tmp_epqa_scenario35.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=======================================================================================================
--Scenario36[ELA,KS,KAP,Report]:		A	Complete>5	B	Complete>5	Exit and not enrolled anywhere
--=======================================================================================================
drop table if exists tmp_epqa_scenario36;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario36'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario36
from cte_stg1 tmp 
inner join student s on tmp.studentid=s.id and s.activeflag is true
inner join enrollment e on s.id=e.studentid  and e.activeflag is false 
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
and not exists (select 1 from enrollment e_act where e_act.studentid=e.studentid and e_act.activeflag is true)
limit 50;
\copy (select * from tmp_epqa_scenario36) to 'tmp_epqa_scenario36.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=======================================================================================================
--Scenario37[ELA,KS,KAP,Report]:Enrollment school B,(1)Stage_1_Status>5,A (2)Stage_2_Status>5,A (3)Outside district Transfer after stage2
--=======================================================================================================
drop table if exists tmp_epqa_scenario37;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario37'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario37
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
and otstg2.districtid<>ot.districtid
limit 50;  

\copy (select * from tmp_epqa_scenario37) to 'tmp_epqa_scenario37.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=======================================================================================================
--Scenario38[ELA,KS,KAP,Report]:C		A	Complete=5	B	Complete>5
--=======================================================================================================
drop table if exists tmp_epqa_scenario38;
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg2'
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
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
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=440 
and st.status=86 
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario38'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,otstg2.schoolname                        "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario38
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
and e.attendanceschoolid<>otstg1.schoolid and e.attendanceschoolid<>otstg2.schoolid
limit 50;  

\copy (select * from tmp_epqa_scenario38) to 'tmp_epqa_scenario38.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=======================================================================================================
--Scenario39[ELA,KS,KAP,Report]:B		A	Complete>5	Outside district Transfer after stage1
--=======================================================================================================
drop table if exists tmp_epqa_scenario39;
with cte_stg1 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid   stg1_schoolid
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
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=86
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario39'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,''::char(1)                              "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
into temp tmp_epqa_scenario39
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and ot.districtid<>otstg1.districtid
limit 50;  

\copy (select * from tmp_epqa_scenario39) to 'tmp_epqa_scenario39.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=======================================================================================================
--Scenario40[ELA,KS,KAP,Report]:(1)Stage_1_Status A=Unused 
--=======================================================================================================
drop table if exists tmp_epqa_scenario40;
with cte_stg1 as (
select
 st.studentid
,st.enrollmentid
,ts.attendanceschoolid   stg1_schoolid
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
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
inner join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and tc.contentareaid=440 
and st.status=84
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
having count(distinct sres1.taskvariantid)=0
limit 100)
select 
'scenario40'::char(20) "Scenarios"
,s.statestudentidentifier                 "Student SSID"
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'Math'::Char(10)                          "Subject"
,otstg1.schoolname                        "Stage 1 School"
,''::char(1)                              "Stage 2 School"
,sr.generated                             "Full Report Generated"
,sr.rawscore                              "Raw Score"
,sr.scalescore                            "Scale Score"
,sr.standarderror                         "Standard Error"
,sr.levelid                               "Level"
,sr.previousyearlevelid                   "Last Year Performance Level"
,rpm.schoolscore                          "School Median"
,rpm.districtscore                        "District Median"
,rpm.statescore                           "State Median"
,Claim_1_all "OVERALL CONCEPTS AND PROCEDURES"
,Claim_1_Rpt_Group_1 "Operations and Algebraic Thinking(Grade 3 and 4)"
,Claim_1_Rpt_Group_2 "Number and Operations in Base Ten(Grade 4 and 5)"
,Claim_1_Rpt_Group_3 "Number and Operations with Fractions(Grade 4 and 5)"
,Claim_1_Rpt_Group_4 "Measurement and Data(Grade 3, 4 and 5)"
,Claim_1_Rpt_Group_5 "Geometry(GRade 7, 8 and 10)"
,Claim_1_Rpt_Group_6 "The Number System(Grade 6)"
,Claim_1_Rpt_Group_7 "Expressions and Equations(Grade 6, 7 and 8)"
,Claim_1_Rpt_Group_8 "Statistics and Probability(Grade 7)"
,Claim_1_Rpt_Group_9 "Algebra(Grade 10)"
,Claim_2_all "PROBLEM SOLVING"
,Claim_3_all "COMMUNICATING REASONING"
,Claim_4_all "MODELING AND DATA ANALYSIS"
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=440 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and ot.districtid<>otstg1.districtid
limit 50;  

\copy (select * from tmp_epqa_scenario40) to 'tmp_epqa_scenario40.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=======================================================================================================
--HOW TO RUN all at one time.


select * into temp tmp_epqa_scenario_all from tmp_epqa_scenario1;

insert into tmp_epqa_scenario_all select * from tmp_epqa_scenario2;
insert into tmp_epqa_scenario_all select * from tmp_epqa_scenario3;
insert into tmp_epqa_scenario_all select * from tmp_epqa_scenario4;
insert into tmp_epqa_scenario_all select * from tmp_epqa_scenario5;

\copy (select * from tmp_epqa_scenario_all) to 'tmp_epqa_scenario_all.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=======================================================================================================




