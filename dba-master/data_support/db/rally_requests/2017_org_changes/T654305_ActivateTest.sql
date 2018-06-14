/*
 studentstestid │ status │       startdatetime        │        enddatetime         │ stflag │ testsessionid │                            name                            │ tsstatus │ tsrost
erid │ tsflag │      testname      │ itiid │ itistatus │ itirosterid │ scsid  │ activeflag │ scaid │                                          ccqtestname
      │
├────────────────┼────────┼────────────────────────────┼────────────────────────────┼────────┼───────────────┼────────────────────────────────────────────────────────────┼──────────┼───────
─────┼────────┼────────────────────┼───────┼───────────┼─────────────┼────────┼────────────┼───────┼─────────────────────────────────────────────────────────────────────────────────────────
──────┤
│       15143210 │    477 │ 2017-02-13 16:39:16.150865 │ 2017-02-13 16:57:24.765086 │ f      │       4022030 │ 2017_8530_ELP Grade 8_English Language Proficiency_Writing │       84 │
NULL │ t      │ Grades 6-8 Writing │  NULL │      NULL │        NULL │ 210054 │ f          │ 17887 │ Jason JMS 8th Writing
      │
│       15143210 │    477 │ 2017-02-13 16:39:16.150865 │ 2017-02-13 16:57:24.765086 │ f      │       4022030 │ 2017_8530_ELP Grade 8_English Language Proficiency_Writing │       84 │
NULL │ t      │ Grades 6-8 Writing │  NULL │      NULL │        NULL │ 137901 │ f          │ 12612 │ 2017_8530_ELP Grade 8_English Language Proficiency_Writing_ELP-K.Paschke TEST_6138432711
_8530 │
│       15467664 │     84 │ NULL                       │ NULL                       │ t      │       4022030 │ 2017_8530_ELP Grade 8_English Language Proficiency_Writing │       84 │
NULL │ t      │ Grades 6-8 Writing │  NULL │      NULL │        NULL │ 227404 │ t          │ 12612 │ 2017_8530_ELP Grade 8_English Language Proficiency_Writing_ELP-K.Paschke TEST_6138432711
_8530 │
*/

BEGIN;
--activate studentstestid:15143210 , deactivate studentstestsid:15467664
update 

update studentstests
set    activeflag =true,
       enrollmentid= 2882602
       status =86,
	   modifieddate =now(),
       modifieduser =174744
where id  =15143210 and enrollmentid =2540964;


update scoringassignmentstudent
set    activeflag =true
where id =137901;



       
update studentstests
set    activeflag =false,
       status =477,
	   modifieddate =now(),
       modifieduser =174744
where id  =15467664;


update studentstestsections
set   activeflag= false,
      statusid = 476,
	  	modifieddate =now(),
       modifieduser =174744
where studentstestid  =15467664 and activeflag is true;

update scoringassignmentstudent
set    activeflag =false
where id =227404;

COMMIT;






