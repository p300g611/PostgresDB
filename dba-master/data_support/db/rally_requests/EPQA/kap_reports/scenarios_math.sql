-- scripts has dependencies we need to run step by step
-- step1:we need to exclude the items by the subject
drop table if exists tmp_epqa_exclude;
create temp table tmp_epqa_exclude (tvid bigint);
insert into tmp_epqa_exclude
select distinct id from taskvariant
where externalid in 
(59032,57975,56775,57077,57853,35928,57060,56777,59494,57321,57084,56768,57863,57063,57324,57072,57944,56954,57143,58950,57083,56703,59456,57937,56705,59524,57022,57320,57323,57852,59523,56757,56960,
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
where rpm.assessmentprogramid =12 and rpm.contentareaid=440  and rpm.schoolyear=2016 and rpm.subscoredefinitionname  is null
 and drpm.assessmentprogramid =12 and drpm.contentareaid=440 and drpm.schoolyear=2016 and drpm.subscoredefinitionname is null 
 and srpm.assessmentprogramid =12 and srpm.contentareaid=440 and srpm.schoolyear=2016 and srpm.subscoredefinitionname is null
order by org.schoolid, gc.abbreviatedname;

-- view only lines:claim names different for ela and math
-- select subscoredefinitionname,subscorereportdisplayname
-- from subscoresdescription where assessmentprogramid=12 and subjectid=440 and report='Student' and schoolyear=2017;

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
 where sr.schoolyear=2016 and sr.assessmentprogramid=12 and sr.contentareaid=440;

--====================================================================================================================
--Scenario1[Math,KS,KAP,Report]:(1)Stage_1_Status=Complete (2)Stage_2_Status=Complete (3)Score_Report=yes --All Same school
--====================================================================================================================
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
--and gc.abbreviatedname='10'
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
--and gc.abbreviatedname='10'
and exld.tvid is null
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
and stg.code='Stg1' 
group by st.studentid,st.enrollmentid,ts.attendanceschoolid
,stg2.attendanceschoolid
having count(distinct sres1.taskvariantid)=count(distinct tstv.taskvariantid)
limit 100)
select 
'scenario1'::char(20) "Scenarios"
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
and tmp.stg1_schoolid=e.attendanceschoolid
--and gc.abbreviatedname='10'
limit 50; 

-- \copy (select  * from tmp_epqa_scenario1) to 'tmp_epqa_scenario1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--====================================================================================================================
--Scenario2[Math,KS,KAP,Report]:(1)Stage_1_Status=5 (2)Stage_2_Status=5 (3)Score_Report=yes --All Same school
--====================================================================================================================
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
having count(distinct sres1.taskvariantid)=5
limit 100)
select 
'scenario2'::char(20) "Scenarios"
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
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50; 

-- \copy (select  * from tmp_epqa_scenario2) to 'tmp_epqa_scenario2.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--====================================================================================================================
--Scenario9[Math,KS,KAP,Report]:(1)Stage_1_Status>5 (2)Stage_2_Status=unused (3)Score_Report=yes --all same school
--====================================================================================================================
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid 
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
having count(distinct sres1.taskvariantid)>5
limit 100)
select 
'scenario9'::char(20) "Scenarios"
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
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=1 and tt.id=2
and tmp.enrollmentid=e.id
and tmp.stg1_schoolid=e.attendanceschoolid
limit 50; 

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


 
-- --final report:
-- select * from (
-- select  "Scenarios", "Student SSID","Student Last Name" from tmp_epqa_scenario1
-- union all
-- select  "Scenarios", "Student SSID","Student Last Name" from tmp_epqa_scenario2) all_s;