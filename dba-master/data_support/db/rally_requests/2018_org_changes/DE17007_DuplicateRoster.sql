
--studentid:1216301

update studentstests 
set    enrollmentid = 3180117,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =1216301 and enrollmentid =2938900;

--ELA
update testsession 
set    rosterid =1205938,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1216301 and enrollmentid =3180117 and activeflag is true ) and rosterid =1173101 ;

update ititestsessionhistory
set    rosterid=1205938,
       studentenrlrosterid=16083657,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1216301 and enrollmentid =3180117 and activeflag is true ) and rosterid= 1173101 and studentid=1216301;

--MATH
update testsession 
set    rosterid =1205937,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1216301 and enrollmentid =3180117 and activeflag is true ) and rosterid =1173106 ;

update ititestsessionhistory
set    rosterid=1205937,
       studentenrlrosterid=16083656,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1216301 and enrollmentid =3180117 and activeflag is true ) and rosterid= 1173106 and studentid=1216301;

--studentid:1227301

update studentstests 
set    enrollmentid = 3402841,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =1227301 and enrollmentid =3123750;

--ELA
update testsession 
set    rosterid =1252590,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1227301 and enrollmentid =3402841 and activeflag is true ) and rosterid =1189589 ;

update ititestsessionhistory
set    rosterid=1252590,
       studentenrlrosterid=16411298,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1227301 and enrollmentid =3402841 and activeflag is true ) and rosterid= 1189589 and studentid=1227301;

--MATH
update testsession 
set    rosterid =1252593,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1227301 and enrollmentid =3402841 and activeflag is true ) and rosterid =1189590 ;

update ititestsessionhistory
set    rosterid=1252593,
       studentenrlrosterid=16411301,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1227301 and enrollmentid =3402841 and activeflag is true ) and rosterid= 1189590 and studentid=1227301;
--Sci
update testsession 
set    rosterid =1252594,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1227301 and enrollmentid =3402841 and activeflag is true ) and rosterid =1189591 ;

update ititestsessionhistory
set    rosterid=1252594,
       studentenrlrosterid=16411302,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1227301 and enrollmentid =3402841 and activeflag is true ) and rosterid= 1189591 and studentid=1227301;

--studentid:891427

update studentstests 
set    enrollmentid = 3078201,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =891427 and enrollmentid =3319430;

--ELA
update testsession 
set    rosterid =1184762,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=891427 and enrollmentid =3078201 and activeflag is true ) and rosterid =1173475 ;

update ititestsessionhistory
set    rosterid=1184762,
       studentenrlrosterid=15890742,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=891427 and enrollmentid =3078201 and activeflag is true ) and rosterid= 1173475 and studentid=891427;

--MATH
update testsession 
set    rosterid =1184763,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=891427 and enrollmentid =3078201 and activeflag is true ) and rosterid =1173476 ;

update ititestsessionhistory
set    rosterid=1184763,
       studentenrlrosterid=15890745,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=891427 and enrollmentid =3078201 and activeflag is true ) and rosterid= 1173476 and studentid=891427;
--Sci
update testsession 
set    rosterid =1184764,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=891427 and enrollmentid =3078201 and activeflag is true ) and rosterid =1173477 ;

update ititestsessionhistory
set    rosterid=1184764,
       studentenrlrosterid=15890747,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=891427 and enrollmentid =3078201 and activeflag is true ) and rosterid= 1173477 and studentid=891427;

--studentid:1398743

update studentstests 
set    enrollmentid = 3187987,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =1398743 and enrollmentid =2983955;

--MATH
update testsession 
set    rosterid =1202578,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1398743 and enrollmentid =3187987 and activeflag is true ) and rosterid =1172824 ;

update ititestsessionhistory
set    rosterid=1202578,
       studentenrlrosterid=16069662,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1398743 and enrollmentid =3187987 and activeflag is true ) and rosterid= 1172824 and studentid=1398743;

--studentid:680150
update studentstests 
set    enrollmentid = 3381468,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =680150 and enrollmentid =2960025;

--becuser there is no math roster. return to old enrollment for math
update studentstests 
set    enrollmentid = 2960025,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now()
where  id in (21167586,19351009,19351011,19351012);


--ELA
update testsession 
set    rosterid =1253316,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=680150 and enrollmentid =3381468 and activeflag is true ) and rosterid =1170701 ;

update ititestsessionhistory
set    rosterid=1253316,
       studentenrlrosterid=16419020,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=680150 and enrollmentid =3381468 and activeflag is true ) and rosterid= 1170701 and studentid=680150;

--studentid:1323948
update studentstests 
set    enrollmentid = 3318682,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =1323948 and enrollmentid =2987084;

--ELA
update testsession 
set    rosterid =1231388,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1323948 and enrollmentid =3318682 and activeflag is true ) and rosterid =1173467 ;

update ititestsessionhistory
set    rosterid=1231388,
       studentenrlrosterid=16262493,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1323948 and enrollmentid =3318682 and activeflag is true ) and rosterid= 1173467 and studentid=1323948;

--MATH
update testsession 
set    rosterid =1231387,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1323948 and enrollmentid =3318682 and activeflag is true ) and rosterid =1173468 ;

update ititestsessionhistory
set    rosterid=1231387,
       studentenrlrosterid=16262491,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1323948 and enrollmentid =3318682 and activeflag is true ) and rosterid= 1173468 and studentid=1323948;


--studentid:432314
update studentstests 
set    enrollmentid = 2942324,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =432314 and enrollmentid =3123478;

--studentid:169571
update studentstests 
set    enrollmentid = 3240159,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =169571 and enrollmentid =3020991;

--ELA
update testsession 
set    rosterid =1168119,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=169571 and enrollmentid =3240159 and activeflag is true ) and rosterid =1179027 ;

update ititestsessionhistory
set    rosterid=1168119,
       studentenrlrosterid=16401159,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=169571 and enrollmentid =3240159 and activeflag is true ) and rosterid= 1179027 and studentid=169571;

--MATH
update testsession 
set    rosterid =1168128,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=169571 and enrollmentid =3240159 and activeflag is true ) and rosterid =1179028 ;

update ititestsessionhistory
set    rosterid=1168128,
       studentenrlrosterid=16401160,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=169571 and enrollmentid =3240159 and activeflag is true ) and rosterid= 1179028 and studentid=169571;


--studentid:877793
update studentstests 
set    enrollmentid = 3398751,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =877793 and enrollmentid =2954862;

--ELA
update testsession 
set    rosterid =1177432,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=877793 and enrollmentid =3398751 and activeflag is true ) and rosterid =1189110 ;

update ititestsessionhistory
set    rosterid=1177432,
       studentenrlrosterid=16395434,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=877793 and enrollmentid =3398751 and activeflag is true ) and rosterid= 1189110 and studentid=877793;

--MATH
update testsession 
set    rosterid =1177433,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=877793 and enrollmentid =3398751 and activeflag is true ) and rosterid =1189111 ;

update ititestsessionhistory
set    rosterid=1177433,
       studentenrlrosterid=16395436,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=877793 and enrollmentid =3398751 and activeflag is true ) and rosterid= 1189111 and studentid=877793;


--studentid:656687
update studentstests 
set    enrollmentid = 3181983,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =656687 and enrollmentid in (3091364,3179655);

--studentid:1325204
update studentstests 
set    enrollmentid = 3405029,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =1325204 and enrollmentid =3031617;

--ELA
update testsession 
set    rosterid =1254564,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1325204 and enrollmentid =3405029 and activeflag is true ) and rosterid =1180397 ;

update ititestsessionhistory
set    rosterid=1254564,
       studentenrlrosterid=16428092,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1325204 and enrollmentid =3405029 and activeflag is true ) and rosterid= 1180397 and studentid=1325204;

--MATH
update testsession 
set    rosterid =1254563,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1325204 and enrollmentid =3405029 and activeflag is true ) and rosterid =1180398 ;

update ititestsessionhistory
set    rosterid=1254563,
       studentenrlrosterid=16428091,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1325204 and enrollmentid =3405029 and activeflag is true ) and rosterid= 1180398 and studentid=1325204;


--studentid:1097532
update studentstests 
set    enrollmentid = 3407122,
       modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
       modifieddate =now(),
	   manualupdatereason='As for DE17007'
where studentid =1097532 and enrollmentid =3095964;

--ELA
update testsession 
set    rosterid =1166385,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1097532 and enrollmentid =3407122 and activeflag is true ) and rosterid =1193568 ;

update ititestsessionhistory
set    rosterid=1166385,
       studentenrlrosterid=16434473,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1097532 and enrollmentid =3407122 and activeflag is true ) and rosterid= 1193568 and studentid=1097532;

--MATH
update testsession 
set    rosterid =1166386,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select testsessionid from studentstests where studentid=1097532 and enrollmentid =3407122 and activeflag is true ) and rosterid =1193569 ;

update ititestsessionhistory
set    rosterid=1166386,
       studentenrlrosterid=16434474,
       modifieddate =now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from studentstests where studentid=1097532 and enrollmentid =3407122 and activeflag is true ) and rosterid= 1193569 and studentid=1097532;