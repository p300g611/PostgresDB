/*
--validation
-- student 1390062 :with dual roster example
select er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,er.modifieddate,r.coursesectionname, statesubjectareaid,teacherid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
where studentid=1390062
order by statesubjectareaid,er.activeflag;

select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,st.id ,ts.source
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid
inner join testcollection tc on tc.id=ts.testcollectionid
where studentid =1390062 order by contentareaid,enrollmentid,rosterid;
*/

--==================================================================================
--student:238968
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1073497,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =238968) and rosterid=1073507 ;

update ititestsessionhistory
set    rosterid=1073497,
       studentenrlrosterid=15512611,
       modifieddate =now(),
       modifieduser =174744
where studentid =238968 and rosterid=1073507;

--Math

update testsession 
set    rosterid =1073513,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =238968) and rosterid=1073523;

update ititestsessionhistory
set    rosterid=1073513,
       studentenrlrosterid=15512612,
       modifieddate =now(),
       modifieduser =174744
where studentid =238968 and rosterid=1073523;

commit;

--==================================================================================
--student:482664
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1086010,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =482664) and rosterid=1072701 ;

update ititestsessionhistory
set    rosterid=1086010,
       studentenrlrosterid=15547591,
       modifieddate =now(),
       modifieduser =174744
where studentid =482664 and rosterid=1072701;

--Math

update testsession 
set    rosterid =1086011,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =482664) and rosterid=1072705;

update ititestsessionhistory
set    rosterid=1086011,
       studentenrlrosterid=15547589,
       modifieddate =now(),
       modifieduser =174744
where studentid =482664 and rosterid=1072705;

update studentstests 
set    enrollmentid = 2909506,
       modifieddate =now(),
       modifieduser =174744
where studentid =482664 and enrollmentid =2417908 ;


commit;

--==================================================================================
--student:483423
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1069729,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =483423) and rosterid=1071012 ;

update ititestsessionhistory
set    rosterid=1069729,
       studentenrlrosterid=15567812,
       modifieddate =now(),
       modifieduser =174744
where studentid =483423 and rosterid=1071012;

--Math

update testsession 
set    rosterid =1069733,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =483423) and rosterid=1071014;

update ititestsessionhistory
set    rosterid=1069733,
       studentenrlrosterid=15567813,
       modifieddate =now(),
       modifieduser =174744
where studentid =483423 and rosterid=1071014;


commit;
--==================================================================================
--student:499380
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1135731,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =499380) and rosterid=1082548 ;

update ititestsessionhistory
set    rosterid=1135731,
       studentenrlrosterid=15391546,
       modifieddate =now(),
       modifieduser =174744
where studentid =499380 and rosterid=1082548;

--Math

update testsession 
set    rosterid =1135732,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =499380) and rosterid=1082549;

update ititestsessionhistory
set    rosterid=1135732,
       studentenrlrosterid=15391548,
       modifieddate =now(),
       modifieduser =174744
where studentid =499380 and rosterid=1082549;


commit;


--==================================================================================
--student:499381
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1135731,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =499381) and rosterid=1082548 ;

update ititestsessionhistory
set    rosterid=1135731,
       studentenrlrosterid=15391545,
       modifieddate =now(),
       modifieduser =174744
where studentid =499381 and rosterid=1082548;

--Math

update testsession 
set    rosterid =1135732,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =499381) and rosterid=1082549;

update ititestsessionhistory
set    rosterid=1135732,
       studentenrlrosterid=15391547,
       modifieddate =now(),
       modifieduser =174744
where studentid =499381 and rosterid=1082549;


commit;

--==================================================================================
--student:511454
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1073572,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =511454) and rosterid=1094921 ;

update ititestsessionhistory
set    rosterid=1073572,
       studentenrlrosterid=15510414,
       modifieddate =now(),
       modifieduser =174744
where studentid =511454 and rosterid=1094921;

--Math

update testsession 
set    rosterid =1073575,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =511454) and rosterid=1094922;

update ititestsessionhistory
set    rosterid=1073575,
       studentenrlrosterid=15510415,
       modifieddate =now(),
       modifieduser =174744
where studentid =511454 and rosterid=1094922;


commit;

--==================================================================================
--student:640608
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1159112,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =640608) and rosterid=1067009 ;

update ititestsessionhistory
set    rosterid=1159112,
       studentenrlrosterid=15586763,
       modifieddate =now(),
       modifieduser =174744
where studentid =640608 and rosterid=1067009;

--Math

update testsession 
set    rosterid =1159113,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =640608) and rosterid=1067010;

update ititestsessionhistory
set    rosterid=1159113,
       studentenrlrosterid=15586764,
       modifieddate =now(),
       modifieduser =174744
where studentid =640608 and rosterid=1067010;



commit;

--==================================================================================
--student:655773
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1150254,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =655773) and rosterid=1068564 ;

update ititestsessionhistory
set    rosterid=1150254,
       studentenrlrosterid=15521224,
       modifieddate =now(),
       modifieduser =174744
where studentid =655773 and rosterid=1068564;

commit;

--==================================================================================
--student:686406
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1159035,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =686406) and rosterid=1080903 ;

update ititestsessionhistory
set    rosterid=1159035,
       studentenrlrosterid=15586539,
       modifieddate =now(),
       modifieduser =174744
where studentid =686406 and rosterid=1080903;

--Math

update testsession 
set    rosterid =1159037,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =686406) and rosterid=1080905;

update ititestsessionhistory
set    rosterid=1159037,
       studentenrlrosterid=15586541,
       modifieddate =now(),
       modifieduser =174744
where studentid =686406 and rosterid=1080905;

update studentstests 
set    enrollmentid = 2921866,
       modifieddate =now(),
       modifieduser =174744
where studentid =686406 and enrollmentid =2421488 ;


commit;

--==================================================================================
--student:699246
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1069523,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =699246) and rosterid=1069509 ;

update ititestsessionhistory
set    rosterid=1069523,
       studentenrlrosterid=15568600,
       modifieddate =now(),
       modifieduser =174744
where studentid =699246 and rosterid=1069509;

--Math

update testsession 
set    rosterid =1069550,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =699246) and rosterid=1069536;

update ititestsessionhistory
set    rosterid=1069550,
       studentenrlrosterid=15568601,
       modifieddate =now(),
       modifieduser =174744
where studentid =699246 and rosterid=1080905;


commit;

--==================================================================================
--student:725375
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1096124,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =725375) and rosterid=1096521 ;

update ititestsessionhistory
set    rosterid=1096124,
       studentenrlrosterid=15032459,
       modifieddate =now(),
       modifieduser =174744
where studentid =725375 and rosterid=1096521;

--Math

update testsession 
set    rosterid =1096125,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =725375) and rosterid=1096540;

update ititestsessionhistory
set    rosterid=1096125,
       studentenrlrosterid=15032466,
       modifieddate =now(),
       modifieduser =174744
where studentid =725375 and rosterid=1096540;


commit;
--==================================================================================
--student:725468
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1096124,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =725468) and rosterid=1096521 ;

update ititestsessionhistory
set    rosterid=1096124,
       studentenrlrosterid=15032462,
       modifieddate =now(),
       modifieduser =174744
where studentid =725468 and rosterid=1096521;

--Math

update testsession 
set    rosterid =1096125,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =725468) and rosterid=1096540;

update ititestsessionhistory
set    rosterid=1096125,
       studentenrlrosterid=15032469,
       modifieddate =now(),
       modifieduser =174744
where studentid =725468 and rosterid=1096540;


commit;


--==================================================================================
--student:751005
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1069350,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =751005) and rosterid=1069376 ;

update ititestsessionhistory
set    rosterid=1069350,
       studentenrlrosterid=15440950,
       modifieddate =now(),
       modifieduser =174744
where studentid =751005 and rosterid=1069376;

--Math

update testsession 
set    rosterid =1069624,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =751005) and rosterid=1069649;

update ititestsessionhistory
set    rosterid=1069624,
       studentenrlrosterid=15440951,
       modifieddate =now(),
       modifieduser =174744
where studentid =751005 and rosterid=1069649;

update studentstests 
set    enrollmentid = 2839987,
       modifieddate =now(),
       modifieduser =174744
where studentid =751005 and enrollmentid =2409409 ;


commit;

--==================================================================================
--student:797109
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1068672,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =797109) and rosterid=1071021 ;

update ititestsessionhistory
set    rosterid=1068672,
       studentenrlrosterid=15543019,
       modifieddate =now(),
       modifieduser =174744
where studentid =797109 and rosterid=1071021;

--Math

update testsession 
set    rosterid =1068673,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =797109) and rosterid=1071022;

update ititestsessionhistory
set    rosterid=1068673,
       studentenrlrosterid=15543018,
       modifieddate =now(),
       modifieduser =174744
where studentid =797109 and rosterid=1071022;

update studentstests 
set    enrollmentid = 2896063,
       modifieddate =now(),
       modifieduser =174744
where studentid =797109 and enrollmentid =2417255 ;


commit;

--==================================================================================
--student:855614
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1073163,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =855614) and rosterid=1073283 ;

update ititestsessionhistory
set    rosterid=1073163,
       studentenrlrosterid=14600955,
       modifieddate =now(),
       modifieduser =174744
where studentid =855614 and rosterid=1073283;

--Math

update testsession 
set    rosterid =1073166,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =855614) and rosterid=1073288;

update ititestsessionhistory
set    rosterid=1073166,
       studentenrlrosterid=14600973,
       modifieddate =now(),
       modifieduser =174744
where studentid =855614 and rosterid=1073288;

update studentstests 
set    enrollmentid = 2418224,
       modifieddate =now(),
       modifieduser =174744
where studentid =855614 and enrollmentid =2886186 ;


commit;


--==================================================================================
--student:856108
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1155686,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =856108) and rosterid=1087793 ;

update ititestsessionhistory
set    rosterid=1155686,
       studentenrlrosterid=15562453,
       modifieddate =now(),
       modifieduser =174744
where studentid =856108 and rosterid=1087793;

--Math

update testsession 
set    rosterid =1155688,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =856108) and rosterid=1087794;

update ititestsessionhistory
set    rosterid=1155688,
       studentenrlrosterid=15562464,
       modifieddate =now(),
       modifieduser =174744
where studentid =856108 and rosterid=1087794;

update studentstests 
set    enrollmentid = 2915041,
       modifieddate =now(),
       modifieduser =174744
where studentid =856108 and enrollmentid =2450058 ;


commit;

--==================================================================================
--student:858265
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1068923,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =858265) and rosterid=1069220 ;

update ititestsessionhistory
set    rosterid=1068923,
       studentenrlrosterid=15566848,
       modifieddate =now(),
       modifieduser =174744
where studentid =858265 and rosterid=1069220;

--Math

update testsession 
set    rosterid =1068924,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =858265) and rosterid=1069219;

update ititestsessionhistory
set    rosterid=1068924,
       studentenrlrosterid=15566849,
       modifieddate =now(),
       modifieduser =174744
where studentid =858265 and rosterid=1069219;

update studentstests 
set    enrollmentid = 2916165,
       modifieddate =now(),
       modifieduser =174744
where studentid =858265 and enrollmentid =2414398 ;


commit;

--==================================================================================
--student:859972
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1157941,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =859972) and rosterid=1075890 ;

update ititestsessionhistory
set    rosterid=1157941,
       studentenrlrosterid=15580260,
       modifieddate =now(),
       modifieduser =174744
where studentid =859972 and rosterid=1075890;

--Math

update testsession 
set    rosterid =1157942,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =859972) and rosterid=1075935;

update ititestsessionhistory
set    rosterid=1157942,
       studentenrlrosterid=15580262,
       modifieddate =now(),
       modifieduser =174744
where studentid =859972 and rosterid=1075935;

update studentstests 
set    enrollmentid = 2919823,
       modifieddate =now(),
       modifieduser =174744
where studentid =859972 and enrollmentid =2424098 ;


commit;

--==================================================================================
--student:860588
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1074043,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =860588) and rosterid=1074047 ;

update ititestsessionhistory
set    rosterid=1074043,
       studentenrlrosterid=14603792,
       modifieddate =now(),
       modifieduser =174744
where studentid =860588 and rosterid=1074047;

--Math

update testsession 
set    rosterid =1074045,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =860588) and rosterid=1074048;

update ititestsessionhistory
set    rosterid=1074045,
       studentenrlrosterid=14603793,
       modifieddate =now(),
       modifieduser =174744
where studentid =860588 and rosterid=1074048;




commit;

--==================================================================================
--student:861962
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1158126,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =861962) and rosterid=1069983 ;

update ititestsessionhistory
set    rosterid=1158126,
       studentenrlrosterid=15581234,
       modifieddate =now(),
       modifieduser =174744
where studentid =861962 and rosterid=1069983;

--Math

update testsession 
set    rosterid =1158127,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =861962) and rosterid=1070022;

update ititestsessionhistory
set    rosterid=1158127,
       studentenrlrosterid=15581237,
       modifieddate =now(),
       modifieduser =174744
where studentid =861962 and rosterid=1070022;




commit;

--==================================================================================
--student:864788
--==================================================================================
begin;
--ELA


--Math

update testsession 
set    rosterid =1151749,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =864788) and rosterid=1096407;

update ititestsessionhistory
set    rosterid=1151749,
       studentenrlrosterid=15533806,
       modifieddate =now(),
       modifieduser =174744
where studentid =864788 and rosterid=1096407;



commit;


--==================================================================================
--student:865023
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1071980,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =865023) and rosterid=1074734 ;

update ititestsessionhistory
set    rosterid=1071980,
       studentenrlrosterid=15552574,
       modifieddate =now(),
       modifieduser =174744
where studentid =865023 and rosterid=1074734;

--Math

update testsession 
set    rosterid =1071988,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =865023) and rosterid=1074735;

update ititestsessionhistory
set    rosterid=1071988,
       studentenrlrosterid=15552575,
       modifieddate =now(),
       modifieduser =174744
where studentid =865023 and rosterid=1074735;

update studentstests 
set    enrollmentid = 2911400,
       modifieddate =now(),
       modifieduser =174744
where studentid =865023 and enrollmentid =2413544 ;


commit;

--==================================================================================
--student:865883
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1160468,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =865883) and rosterid=1153592 ;

update ititestsessionhistory
set    rosterid=1160468,
       studentenrlrosterid=15592737,
       modifieddate =now(),
       modifieduser =174744
where studentid =865883 and rosterid=1074734;

--Math

update testsession 
set    rosterid =1160470,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =865883) and rosterid=1153591;

update ititestsessionhistory
set    rosterid=1160470,
       studentenrlrosterid=15592739,
       modifieddate =now(),
       modifieduser =174744
where studentid =865883 and rosterid=1074735;

update studentstests 
set    enrollmentid = 2612924,
       modifieddate =now(),
       modifieduser =174744
where studentid =865883 and enrollmentid =2909550 ;


commit;

--==================================================================================
--student:886033
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1079934,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =886033) and rosterid=1080145 ;

update ititestsessionhistory
set    rosterid=1079934,
       studentenrlrosterid=15586235,
       modifieddate =now(),
       modifieduser =174744
where studentid =886033 and rosterid=1080145;

--Math

update testsession 
set    rosterid =1079933,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =886033) and rosterid=1080144;

update ititestsessionhistory
set    rosterid=1079933,
       studentenrlrosterid=15586236,
       modifieddate =now(),
       modifieduser =174744
where studentid =886033 and rosterid=1080144;

update studentstests 
set    enrollmentid = 2921742,
       modifieddate =now(),
       modifieduser =174744
where studentid =886033 and enrollmentid =2449087 ;


commit;

--==================================================================================
--student:896203
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1076289,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =896203) and rosterid=1101808 ;

update ititestsessionhistory
set    rosterid=1076289,
       studentenrlrosterid=15567023,
       modifieddate =now(),
       modifieduser =174744
where studentid =896203 and rosterid=1101808;

--Math

update testsession 
set    rosterid =1076288,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =896203) and rosterid=1101809;

update ititestsessionhistory
set    rosterid=1076288,
       studentenrlrosterid=15567022,
       modifieddate =now(),
       modifieduser =174744
where studentid =896203 and rosterid=1101809;

update studentstests 
set    enrollmentid = 2916255,
       modifieddate =now(),
       modifieduser =174744
where studentid =896203 and enrollmentid =2449085 ;


commit;

--==================================================================================
--student:916087
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1072572,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =916087) and rosterid=1072575 ;

update ititestsessionhistory
set    rosterid=1072572,
       studentenrlrosterid=15585475,
       modifieddate =now(),
       modifieduser =174744
where studentid =916087 and rosterid=1072575;

--Math

update testsession 
set    rosterid =1072573,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =916087) and rosterid=1072576;

update ititestsessionhistory
set    rosterid=1072573,
       studentenrlrosterid=15585477,
       modifieddate =now(),
       modifieduser =174744
where studentid =916087 and rosterid=1072576;


commit;


--==================================================================================
--student:1100953
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1153627,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1100953) and rosterid=1143995 ;

update ititestsessionhistory
set    rosterid=1153627,
       studentenrlrosterid=15547229,
       modifieddate =now(),
       modifieduser =174744
where studentid =1100953 and rosterid=1143995;

--Math

update testsession 
set    rosterid =1153628,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1100953) and rosterid=1143975;

update ititestsessionhistory
set    rosterid=1153628,
       studentenrlrosterid=15547227,
       modifieddate =now(),
       modifieduser =174744
where studentid =1100953 and rosterid=1143975;



commit;

--==================================================================================
--student:1101057
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1153627,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1101057) and rosterid=1143995 ;

update ititestsessionhistory
set    rosterid=1153627,
       studentenrlrosterid=15548450,
       modifieddate =now(),
       modifieduser =174744
where studentid =1101057 and rosterid=1143995;

--Math

update testsession 
set    rosterid =1153628,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1101057) and rosterid=1143975;

update ititestsessionhistory
set    rosterid=1153628,
       studentenrlrosterid=15548452,
       modifieddate =now(),
       modifieduser =174744
where studentid =1101057 and rosterid=1143975;



commit;

--==================================================================================
--student:1101081
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1153627,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1101081) and rosterid=1143995 ;

update ititestsessionhistory
set    rosterid=1153627,
       studentenrlrosterid=15547230,
       modifieddate =now(),
       modifieduser =174744
where studentid =1101081 and rosterid=1143995;

--Math

update testsession 
set    rosterid =1153628,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1101081) and rosterid=1143975;

update ititestsessionhistory
set    rosterid=1153628,
       studentenrlrosterid=15547228,
       modifieddate =now(),
       modifieduser =174744
where studentid =1101081 and rosterid=1143975;



commit;

--==================================================================================
--student:1116924
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1108564,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1116924) and rosterid=1155477 ;

update ititestsessionhistory
set    rosterid=1108564,
       studentenrlrosterid=15130421,
       modifieddate =now(),
       modifieduser =174744
where studentid =1116924 and rosterid=1155477;

--Math

update testsession 
set    rosterid =1155476,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1116924) and rosterid=1108565;

update ititestsessionhistory
set    rosterid=1155476,
       studentenrlrosterid=15561591,
       modifieddate =now(),
       modifieduser =174744
where studentid =1116924 and rosterid=1108565;


commit;

--==================================================================================
--student:1128253
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1135276,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1128253) and rosterid=1135278 ;

update ititestsessionhistory
set    rosterid=1135276,
       studentenrlrosterid=15547081,
       modifieddate =now(),
       modifieduser =174744
where studentid =1128253 and rosterid=1135278;

--Math

update testsession 
set    rosterid =1135277,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1128253) and rosterid=1135279;

update ititestsessionhistory
set    rosterid=1135277,
       studentenrlrosterid=15547083,
       modifieddate =now(),
       modifieduser =174744
where studentid =1128253 and rosterid=1135279;



commit;

--==================================================================================
--student:1200771
--==================================================================================
begin;


--Math

update testsession 
set    rosterid =1075176,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1200771) and rosterid=1075190;

update ititestsessionhistory
set    rosterid=1075176,
       studentenrlrosterid=15386738,
       modifieddate =now(),
       modifieduser =174744
where studentid =1200771 and rosterid=1075190;

update studentstests 
set    enrollmentid = 2815810,
       modifieddate =now(),
       modifieduser =174744
where studentid =1200771 and enrollmentid =2422758 ;


commit;

--==================================================================================
--student:1205090
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1148706,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1205090) and rosterid=1066363 ;

update ititestsessionhistory
set    rosterid=1148706,
       studentenrlrosterid=15511833,
       modifieddate =now(),
       modifieduser =174744
where studentid =1205090 and rosterid=1066363;

--Math

update testsession 
set    rosterid =1148710,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1205090) and rosterid=1073742;

update ititestsessionhistory
set    rosterid=1148710,
       studentenrlrosterid=15511842,
       modifieddate =now(),
       modifieduser =174744
where studentid =1205090 and rosterid=1073742;

update studentstests 
set    enrollmentid = 2889178,
       modifieddate =now(),
       modifieduser =174744
where studentid =1205090 and enrollmentid =2409450 ;


commit;

--==================================================================================
--student:1208030
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1069434,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1208030) and rosterid=1069349 ;

update ititestsessionhistory
set    rosterid=1069434,
       studentenrlrosterid=15508740,
       modifieddate =now(),
       modifieduser =174744
where studentid =1208030 and rosterid=1069349;

--Math

update testsession 
set    rosterid =1073935,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1208030) and rosterid=1069623;

update ititestsessionhistory
set    rosterid=1073935,
       studentenrlrosterid=15508743,
       modifieddate =now(),
       modifieduser =174744
where studentid =1208030 and rosterid=1069623;

update studentstests 
set    enrollmentid = 2889271,
       modifieddate =now(),
       modifieduser =174744
where studentid =1208030 and enrollmentid =2408864 ;


commit;

--==================================================================================
--student:1307551
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1156174,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1307551) and rosterid=1111389 ;

update ititestsessionhistory
set    rosterid=1156174,
       studentenrlrosterid=15564137,
       modifieddate =now(),
       modifieduser =174744
where studentid =1307551 and rosterid=1111389;



commit;

--==================================================================================
--student:1312983
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1087748,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1312983) and rosterid=1087763 ;

update ititestsessionhistory
set    rosterid=1087748,
       studentenrlrosterid=15564031,
       modifieddate =now(),
       modifieduser =174744
where studentid =1312983 and rosterid=1087763;

--Math

update testsession 
set    rosterid =1087749,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1312983) and rosterid=1087764;

update ititestsessionhistory
set    rosterid=1087749,
       studentenrlrosterid=15564032,
       modifieddate =now(),
       modifieduser =174744
where studentid =1312983 and rosterid=1087764;

update studentstests 
set    enrollmentid = 2915554,
       modifieddate =now(),
       modifieduser =174744
where studentid =1312983 and enrollmentid =2416629 ;


commit;

--==================================================================================
--student:1317189
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1155952,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1317189) and rosterid=1073395 ;

update ititestsessionhistory
set    rosterid=1155952,
       studentenrlrosterid=15563563,
       modifieddate =now(),
       modifieduser =174744
where studentid =1317189 and rosterid=1073395;

--Math

update testsession 
set    rosterid =1155951,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1317189) and rosterid=1073394;

update ititestsessionhistory
set    rosterid=1155951,
       studentenrlrosterid=15563562,
       modifieddate =now(),
       modifieduser =174744
where studentid =1317189 and rosterid=1073394;



commit;

--==================================================================================
--student:1323776
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1155260,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1323776) and rosterid=1069347 ;

update ititestsessionhistory
set    rosterid=1155260,
       studentenrlrosterid=15560789,
       modifieddate =now(),
       modifieduser =174744
where studentid =1323776 and rosterid=1069347;

--Math

update testsession 
set    rosterid =1155261,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1323776) and rosterid=1069621;

update ititestsessionhistory
set    rosterid=1155261,
       studentenrlrosterid=15560790,
       modifieddate =now(),
       modifieduser =174744
where studentid =1323776 and rosterid=1069621;

update studentstests 
set    enrollmentid = 2914607,
       modifieddate =now(),
       modifieduser =174744
where studentid =1323776 and enrollmentid =2408850 ;


commit;

--==================================================================================
--student:1323778
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1153982,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1323778) and rosterid=1069351 ;

update ititestsessionhistory
set    rosterid=1153982,
       studentenrlrosterid=15552579,
       modifieddate =now(),
       modifieduser =174744
where studentid =1323778 and rosterid=1069351;

--Math

update testsession 
set    rosterid =1153986,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1323778) and rosterid=1069625;

update ititestsessionhistory
set    rosterid=1153986,
       studentenrlrosterid=15552593,
       modifieddate =now(),
       modifieduser =174744
where studentid =1323778 and rosterid=1069625;

update studentstests 
set    enrollmentid = 2911401,
       modifieddate =now(),
       modifieduser =174744
where studentid =1323778 and enrollmentid =2408918 ;


commit;

--==================================================================================
--student:1328172
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1080114,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1328172) and rosterid=1080105 ;

update ititestsessionhistory
set    rosterid=1080114,
       studentenrlrosterid=15326583,
       modifieddate =now(),
       modifieduser =174744
where studentid =1328172 and rosterid=1080105;

--Math

update testsession 
set    rosterid =1080115,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1328172) and rosterid=1080106;

update ititestsessionhistory
set    rosterid=1080115,
       studentenrlrosterid=15326584,
       modifieddate =now(),
       modifieduser =174744
where studentid =1328172 and rosterid=1080106;

update studentstests 
set    enrollmentid = 2782968,
       modifieddate =now(),
       modifieduser =174744
where studentid =1328172 and enrollmentid =2449061 ;


commit;

--==================================================================================
--student:1348735
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1153459,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1348735) and rosterid=1090068 ;

update ititestsessionhistory
set    rosterid=1153459,
       studentenrlrosterid=15546487,
       modifieddate =now(),
       modifieduser =174744
where studentid =1348735 and rosterid=1090068;

--Math

update testsession 
set    rosterid =1153460,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1348735) and rosterid=1090070;

update ititestsessionhistory
set    rosterid=1153460,
       studentenrlrosterid=15546488,
       modifieddate =now(),
       modifieduser =174744
where studentid =1348735 and rosterid=1090070;


commit;

--==================================================================================
--student:1356393
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1153627,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1356393) and rosterid=1143995 ;

update ititestsessionhistory
set    rosterid=1153627,
       studentenrlrosterid=15547231,
       modifieddate =now(),
       modifieduser =174744
where studentid =1356393 and rosterid=1143995;

--Math

update testsession 
set    rosterid =1153628,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1356393) and rosterid=1143975;

update ititestsessionhistory
set    rosterid=1153628,
       studentenrlrosterid=15547233,
       modifieddate =now(),
       modifieduser =174744
where studentid =1356393 and rosterid=1143975;



commit;


--==================================================================================
--student:1356592
--==================================================================================
begin;

--Math

update testsession 
set    rosterid =1093240,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1356592) and rosterid=1155623;

update ititestsessionhistory
set    rosterid=1093240,
       studentenrlrosterid=15546645,
       modifieddate =now(),
       modifieduser =174744
where studentid =1356592 and rosterid=1155623;

update studentstests 
set    enrollmentid = 2906122,
       modifieddate =now(),
       modifieduser =174744
where studentid =1356592 and enrollmentid =2692169 ;


commit;
--==================================================================================
--student:1390062
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1153459,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1390062) and rosterid=1090061 ;

update ititestsessionhistory
set    rosterid=1153459,
       studentenrlrosterid=15559929,
       modifieddate =now(),
       modifieduser =174744
where studentid =1390062 and rosterid=1090061;

--Math

update testsession 
set    rosterid =1153460,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1390062) and rosterid=1090062;

update ititestsessionhistory
set    rosterid=1153460,
       studentenrlrosterid=15559930,
       modifieddate =now(),
       modifieduser =174744
where studentid =1390062 and rosterid=1090062;

commit;
--==================================================================================
--student:1390094
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1088781,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1390094) and rosterid=1076357;

update ititestsessionhistory
set    rosterid=1088781,
       studentenrlrosterid=15586294,
       modifieddate =now(),
       modifieduser =174744
where studentid =1390094 and rosterid=1076357;

--Math

update testsession 
set    rosterid =1088782,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1390094) and rosterid=1076358;

update ititestsessionhistory
set    rosterid=1088782,
       studentenrlrosterid=15586299,
       modifieddate =now(),
       modifieduser =174744
where studentid =1390094 and rosterid=1076358;

update studentstests 
set    enrollmentid = 2921803,
       modifieddate =now(),
       modifieduser =174744
where studentid =1390094 and enrollmentid =2769614 ;


commit;
--==================================================================================
--student:1399093
--==================================================================================
begin;
--ELA
update testsession 
set    rosterid =1067108,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1399093) and rosterid=1067105;

update ititestsessionhistory
set    rosterid=1067108,
       studentenrlrosterid=15559745,
       modifieddate =now(),
       modifieduser =174744
where studentid =1399093 and rosterid=1067105;

--Math

update testsession 
set    rosterid =1067124,
       modifieddate =now(),
       modifieduser =174744
where id in (select testsessionid from studentstests where studentid =1399093) and rosterid=1067121;

update ititestsessionhistory
set    rosterid=1067124,
       studentenrlrosterid=15559746,
       modifieddate =now(),
       modifieduser =174744
where studentid =1399093 and rosterid=1067121;

update studentstests 
set    enrollmentid = 2914225,
       modifieddate =now(),
       modifieduser =174744
where studentid =1399093 and enrollmentid =2829429;


commit;

