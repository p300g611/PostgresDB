-- scripts has dependencies we need to run step by step
-- step1:we need to exclude the items by the subject
drop table if exists tmp_epqa_exclude;
create temp table tmp_epqa_exclude (tvid bigint);
insert into tmp_epqa_exclude
select distinct id from taskvariant
where externalid in (
58467,58526,58466,58571,58708,58840,58528,58825,58530,52830,52782,58465,58845,58826,58712,58573,58716,58709,52833,58844,58470,58574,58850,58829,58911,58920,58915,58908,
58923,58916,61384,58912,61079,61087,61083,61078,61088,61085,61089,61081,58508,58506,58509,58504,58514,58502,61382,58517,61033,61041,61042,61039,61031,61045,61044,61035,
52832,52776,58713,58842,58711,58468,58572,58827,58507,58519,58511,58516,58512,58503,61383,58518,61037,61038,61034,61043,61032,61040,61036,58717,58828,58714,52767,58469,
58846,58576,58910,58913,58914,58917,58909,58918,58921,58922,61084,61082,61090,61086,61077,61080,58339,58602,58600,58347,58582,58799,58344,58594,58584,58591,61721,58719,
58346,58359,58802,52899,60738,60751,60761,60780,60736,61490,60772,60750,61189,61013,61010,61185,61495,61006,61009,61186,58592,58579,58723,58341,58718,61722,58360,58815,
58727,58739,58725,58731,58728,58734,58735,58737,60986,61001,60987,60999,61005,60997,61002,60993,52900,52882,58342,52644,52864,58598,58593,58580,58729,58736,58726,58732,
61487,58738,58730,60989,60995,61003,60988,60985,61494,61004,61000,58358,58343,58601,58586,52642,58813,58722,58816,60774,61488,60769,60754,60732,61489,60778,60748,61008,
61018,61007,61012,61497,61496,61011,57872,57957,58167,57876,57956,57868,57964,58166,58223,58210,57940,57948,58214,58232,60839,57967,58389,61568,58390,58408,58393,58373,
58402,58407,61117,61127,61120,61109,61588,61118,61126,61116,57879,57875,58183,58161,57873,60836,58205,52922,58536,58540,61574,58545,58534,58549,58548,58539,36628,36648,
60969,61057,36638,36620,36640,36645,57965,57878,60837,58208,58188,58169,58537,58550,58541,58535,61573,58546,58547,58538,60965,36623,36637,61576,36639,36642,36635,57882,
57880,52931,58180,57961,60838,58164,58384,58380,58394,58400,61567,58392,58405,61114,61119,61591,61122,61113,61124,61125,58235,57722,57782,57763,57749,57778,57768,57801,
61723,57744,58248,57753,57781,57807,57776,51286,61432,58291,58292,58284,58276,61436,58280,58277,60903,60919,60915,60908,60904,60902,60909,61439,57762,57719,57938,57756,
52990,57779,54338,57804,57902,57913,57896,61429,57927,57910,57920,57925,60874,60886,60881,60878,60873,60880,60883,60875,57773,57723,53368,58289,57774,57755,57769,57803,
57928,57899,57926,57903,57912,57924,57919,57906,60885,60877,60876,61438,60872,60882,60884,57765,57806,52987,58258,57780,58250,57754,57743,58278,58294,58293,61434,58282,
58290,58283,60920,60906,60907,60900,60913,60912,60917,60905,58857,58750,58863,52938,58901,55368,58866,55370,51543,58859,53102,58905,58754,58758,60555,55369,61151,61076,
61146,61143,61164,61542,61155,61139,61028,60953,60960,60958,61029,60942,60961,60947,61023,60950,60954,61030,60946,61538,61024,51578,58752,58933,58860,51551,55367,58907,
56286,56265,56260,61537,56269,56273,56292,56270,60562,58756,60553,58755,58906,52934,53095,51546,61159,61160,61169,61165,61175,61170,61172,61154,56267,56263,56291,56279,
56282,56276,56295,61161,61075,61152,61163,61541,61148,61142,61137,56287,58940,58867,60549,51538,58869,58856,58903,61027,61025,61157,61167,61544,61162,61173,61171,61156,
61158,61149,61174,58558,53493,58740,56297,58742,51813,58554,58567,60702,60698,60705,58565,53143,53148,58553,58743,58185,58184,58240,61617,61618,58181,58243,58244,61130,
61623,61129,61134,61132,61147,61136,61145,53132,58744,53150,51819,58569,56285,56307,56304,58489,58481,61622,58472,58491,58476,61621,58477,58234,58189,58192,58182,58247,
58245,56019,56037,56059,56002,61611,56074,56072,56080,58570,53144,51442,53133,51816,53494,56299,60708,58485,58487,61620,58475,58473,58480,58488,61619,58246,58241,56022,
56044,56090,56004,61610,56055,56078,61612,56259,58566,60679,60686,51448,51444,58568,51804,58486,58479,58490,58474,61133,61138,61131,61128,61135,61144,61141,56091,56053,
56083,51697,53410,55681,55674,58002,58187,55292,57840,57995,57996,61073,61050,61074,53248,61061,58190,58035,58075,58048,58084,58067,58033,58072,58064,58301,61459,58308,
58296,58313,58300,58319,58322,56336,56337,56340,56349,56347,56341,56334,56351,55303,60544,61055,61056,58203,61047,61058,61063,57998,57838,61094,61093,61051,58193,61067,
53245,58043,58053,58081,61458,58031,58069,58078,61210,61184,61463,61192,61205,61213,61212,61195,56338,56354,56345,56339,56350,56335,61460,60546,57837,61069,61070,61048,
61060,58191,61068,55306,55307,55275,55287,58299,58305,58327,58312,61191,61183,61217,61198,61182,61211,56356,57993,57841,61071,61072,61049,61065,61066,53247,58045,58065,
58306,58298,58326,58304,58323,58318,58302,61216,61206,61214,61215);

-- step2:we need to find the school,district,state median
drop table if exists tmp_epqa_median;
select distinct org.schoolid,gc.abbreviatedname grade, rpm.score schoolscore, drpm.score districtscore, srpm.score statescore
into temp tmp_epqa_median
from organizationtreedetail org
inner join reportsmedianscore rpm on rpm.organizationid=org.schoolid and rpm.organizationtypeid =7
inner join reportsmedianscore drpm on drpm.organizationid=org.districtid and drpm.organizationtypeid=5 and drpm.gradeid =rpm.gradeid 
inner join reportsmedianscore srpm on srpm.organizationid = org.stateid and srpm.organizationtypeid=2 and srpm.gradeid=drpm.gradeid 
inner join gradecourse gc on gc.id= rpm.gradeid  
where rpm.assessmentprogramid =12 and rpm.contentareaid=3  and rpm.schoolyear=2016  and rpm.subscoredefinitionname  is null
 and drpm.assessmentprogramid =12 and drpm.contentareaid=3 and drpm.schoolyear=2016 and drpm.subscoredefinitionname is null 
 and srpm.assessmentprogramid =12 and srpm.contentareaid=3 and srpm.schoolyear=2016 and srpm.subscoredefinitionname is null
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
where sr.schoolyear=2016 and sr.assessmentprogramid=12 and sr.contentareaid=3;
*/
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
where sr.schoolyear=2016 and sr.assessmentprogramid=12 and sr.contentareaid=3
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
and tc.contentareaid=3; 


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
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
and st.status=86 
and exld.tvid is null
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
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
and not exists (select 1 from studentspecialcircumstance ssps where ssps.studenttestid=st.id)
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
and st.status=86 
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
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
and tmp.enrollmentid=e.id
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
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
and st.status=86 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
and tmp.enrollmentid=e.id
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
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
and st.status=86 
and exld.tvid is null
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
and tmp.enrollmentid=e.id
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
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
and st.status=86 
and exld.tvid is null
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
and tmp.enrollmentid=e.id
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
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
left outer join tmp_epqa_exclude exld on exld.tvid=tstv.taskvariantid
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
and st.status=86 
and exld.tvid is null
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
and tmp.enrollmentid=e.id
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 --and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 --and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017  st.activeflag =false
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag =false 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag=false
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and stg1.code='Stg1'
left outer join studentsresponses sres2 ON st.id = sres2.studentstestsid and sres2.taskvariantid=tstv.taskvariantid and stg2.code='Stg2'
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag=false
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null and stg1.code='Stg1'
left outer join studentsresponses sres2 ON st.id = sres2.studentstestsid and sres2.taskvariantid=tstv.taskvariantid and stg2.code='Stg2'
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag=false
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
--left outer join  tmp_scode scd on scd.studentid=s.id 
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.enrollmentid=st.enrollmentid
and stg2.attendanceschoolid=ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and stg2.attendanceschoolid<>ts.attendanceschoolid
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
,sr.aggregatetoschool                     "Aggregated to School"
,sr.aggregatetodistrict                   "Aggregated to District"
,sr.incompletestatus                      "Incomplete flag" 
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
 and sr.schoolyear=2017 and sr.assessmentprogramid=12 and sr.contentareaid=3 
left outer join tmp_sub_score rss on rss.studentreportid=sr.id and sr.studentid=rss.studentid
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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
left outer join studentsresponses sres1 ON st.id = sres1.studentstestsid and sres1.taskvariantid=tstv.taskvariantid and sres1.score is not null 
where ts.activeflag is true and ts.schoolyear=2017 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10172
and tc.contentareaid=3 
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
,'ELA'::Char(10)                          "Subject"
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
,rss.Claim_1_all                          "OVERALL READING"
,rss.Claim_1_Rpt_Group_1                  "READING: Literary Texts"
,rss.Claim_1_Rpt_Group_2                  "READING: Informational Texts"
,rss.Claim_1_Rpt_Group_3                  "READING: Making and Supporting Conclusions"
,rss.Claim_1_Rpt_Group_4                  "READING: Main Idea"
,rss.Claim_2_all                          "OVERALL WRITING"
,rss.Claim_2_Rpt_Group_1                  "WRITING: Revising"
,rss.Claim_2_Rpt_Group_3                  "WRITING: Editing"
,rss.Claim_1_Rpt_Group_2                  "WRITING: Vocabulary and Language Use"
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
where e.currentschoolyear=2017 and sap.assessmentprogramid=12 and sub.id=17 and tt.id=2
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




