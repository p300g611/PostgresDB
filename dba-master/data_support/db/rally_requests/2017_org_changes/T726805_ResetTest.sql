/*
1332509835 - 2051
1661338941 - 1785
7383663454 - 8218
7475314308 - 8218
7951265713 - 8224
8256439335 - 2051
8380889487 - 8185
9897946632 - 1846

--find the roster
select stu.statestudentidentifier ssid,stu.id stui, en.id enid,r.id rosterid, ca.abbreviatedname
from student stu
join enrollment en on en.studentid=stu.id and en.activeflag is true
left outer join  enrollmentsrosters enr on enr.enrollmentid=en.id and enr.activeflag is true
left outer join roster r on r.id =enr.rosterid and r.activeflag is true
left outer join contentarea ca on ca.id =r.statesubjectareaid
where stu.activeflag is true and en.currentschoolyear =2017
and stu.statestudentidentifier ='8380889487';

--backup T726805_ResetTestbackup.csv
SELECT    distinct stu.statestudentidentifier ssid,
	       stu.id stuid,
           en.id enid,
           en.activeflag as enflag,
		   attsch.displayidentifier schdis,
           st.id AS stid,
           st.activeflag as stflag,
           --t.id as testid,
           --ts.id tsid,
		   ts.name tsname,
		   ts.rosterid,
		  ts.activeflag as tsflag,
          sts.id stsid,
		  sts.activeflag stsflag,
           c.categorycode as status,
           ca.abbreviatedname AS sub,
          sr.activeflag srflag
		   --iti.id itiid
--		   iti.activeflag itiflag,
--		   strb.id strbid,
--		   str.id strid
into temp tmp_resettest
     FROM studentstests st
     JOIN enrollment en ON en.id = st.enrollmentid
     JOIN testcollection tc ON tc.id = st.testcollectionid
	 JOIN test t on t.id =st.testid
     JOIN organization attsch ON attsch.id = en.attendanceschoolid
     JOIN organization aypsch ON aypsch.id = en.aypschoolid
     JOIN contentarea ca ON ca.id = tc.contentareaid
     JOIN student stu ON stu.id = en.studentid
     JOIN testsession ts ON ts.id = st.testsessionid
	 join studentstestsections sts on sts.studentstestid =st.id
     JOIN category c ON c.id = st.status
	 left outer join studentsresponses sr on sr.studentid =stu.id and sr.studentstestsid=st.id
     left outer join ititestsessionhistory iti on iti.studentid =stu.id and iti.testsessionid=ts.id
     left outer join studenttrackerband strb on  strb.testsessionid = ts.id
     left outer join studenttracker str on str.id =strb.studenttrackerid and str.studentid=stu.id
               
   where  en.activeflag is true and stu.statestudentidentifier IN ('1332509835',
'1661338941',
'7383663454',
'7475314308',
'7951265713',
'8256439335',
'8380889487',
'9897946632')
   order by en.id, ca.abbreviatedname;
   
\copy (select * from tmp_resettest) to 'T726805_ResetTest.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 
*/
BEGIN;
--ssid:1661338941

update enrollment 
set activeflag = false,
	 modifieddate = now(),
	 modifieduser =174744
 where id = 2495744 and activeflag = true;
 
 
 update studentstests
 set    enrollmentid= 2908153,
    	modifieddate = now(),
	    modifieduser =174744
 where id = 14709350 and enrollmentid = 2495744;

 update studentstests 
 set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where id in (16045533,14748051,15734065);


update studentstestsections
set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where   studentstestid in (16045533,14748051,15734065);
 
 
--1332509835
 update enrollment 
set activeflag = false,
	 modifieddate = now(),
	 modifieduser =174744
 where id = 2756214 and activeflag = true;
 
 
 update studentstests
 set    enrollmentid= 2910648,
    	modifieddate = now(),
	    modifieduser =174744
 where id = 14695552 and enrollmentid = 2756214;
 
 
 update studentstests
 set    enrollmentid= 2910648,
    	modifieddate = now(),
	    modifieduser =174744
 where id = 15539176 and enrollmentid = 2544853;
 
 update studentstests 
 set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where id in (15472758,14642962,14643254,14695378,15882959,15912058,16289137,16289140);


update studentstestsections
set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where   studentstestid in (15472758,14642962,14643254,14695378,15882959,15912058,16289137,16289140);

 --7383663454
 
 update enrollment 
set activeflag = false,
	 modifieddate = now(),
	 modifieduser =174744
 where id = 2763273 and activeflag = true;
 
  update studentstests 
 set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where id in (15850635,16102598);


update studentstestsections
set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where   studentstestid in (15850635,16102598);
 
--7475314308
 
 update enrollment 
set activeflag = false,
	 modifieddate = now(),
	 modifieduser =174744
 where id = 2766603 and activeflag = true; 
 
   update studentstests 
 set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where id in (16211121,16211125);


update studentstestsections
set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where   studentstestid in (16211121,16211125);


--7951265713
  update enrollment 
set activeflag = false,
	 modifieddate = now(),
	 modifieduser =174744
 where id = 2762837 and activeflag = true; 
 
 update studentstests 
 set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where id in (15850203,16102401);


update studentstestsections
set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where   studentstestid in (15850203,16102401);

--8256439335
 update enrollment 
set activeflag = false,
	 modifieddate = now(),
	 modifieduser =174744
 where id = 2751403 and activeflag = true;
 

 
 update studentstests
 set    enrollmentid= 2910647,
    	modifieddate = now(),
	    modifieduser =174744
 where id = 14859536 and enrollmentid = 2751403; 
 
 update studentstests
 set    enrollmentid= 2910647,
    	modifieddate = now(),
	    modifieduser =174744
 where id in (15480843,15490747) and enrollmentid = 2544852;
 
 update studentstests 
 set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where id in (15878548,15906706,16285319,16285321);


update studentstestsections
set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where   studentstestid in (15878548,15906706,16285319,16285321); 
 
 
--8380889487
 update enrollment 
set activeflag = false,
	 modifieddate = now(),
	 modifieduser =174744
 where id = 2685152 and activeflag = true;

 update studentstests 
 set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where id in (15828230,16092137);


update studentstestsections
set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where   studentstestid in (15828230,16092137); 
 
 --9897946632
 update enrollment 
set activeflag = false,
	 modifieddate = now(),
	 modifieduser =174744
 where id = 2761802 and activeflag = true;
 
 
 update studentstests
 set    enrollmentid= 2908127,
        testsessionid =4023369,
    	modifieddate = now(),
	    modifieduser =174744
 where id =15157901 and enrollmentid = 2761802;
 
 update studentstests
 set    enrollmentid= 2908127,
        testsessionid =4023370,
    	modifieddate = now(),
	    modifieduser =174744
 where id =15157911 and enrollmentid = 2761802;
 
 
 update studentstests
 set    enrollmentid= 2908127,
        testsessionid =4023372,
    	modifieddate = now(),
	    modifieduser =174744
 where id =15157920 and enrollmentid = 2761802;
 

 update studentstests
 set    enrollmentid= 2908127,
        testsessionid =4023373,
    	modifieddate = now(),
	    modifieduser =174744
 where id =15157928 and enrollmentid = 2761802;
 
update studentstests 
 set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where id in (15849177,16101902);


update studentstestsections
set    activeflag =false,
     	modifieddate = now(),
	    modifieduser =174744
where   studentstestid in (15849177,16101902); 
commit;



   
   

 
 
 
