/*
studenttestid │ status │ stflag │ testsessionid │                             name                              │ gradecourseid │ tsflag │ studenttestsectionsflag │
                      │
│      15377045 │     84 │ t      │       4023222 │ 2017_8538_ELP Grade 11_English Language Proficiency_Reading   │           256 │ t      │ t                       │
│      15377044 │     84 │ t      │       4023218 │ 2017_8538_ELP Grade 11_English Language Proficiency_Speaking  │           256 │ t      │ t                       │
│      15329478 │    477 │ f      │       4023222 │ 2017_8538_ELP Grade 11_English Language Proficiency_Reading   │           256 │ t      │ t                       │
│      15118147 │    477 │ f      │       4020473 │ 2017_8538_ELP Grade 10_English Language Proficiency_Writing   │           255 │ t      │ t                       │
│      15118137 │    477 │ f      │       4020472 │ 2017_8538_ELP Grade 10_English Language Proficiency_Reading   │           255 │ t      │ t                       │

(14 rows)
*/
BEGIN;

--SSID: 3322404951 keep studentstestid 15118137 remove studentstestid 15377045



update studentstests
set    activeflag =false,
       status=477,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =15377045;

update studentstestsections
set   activeflag =false,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =25591358;   



  
update studentstests
set    activeflag =true,
       status=86,
       testsessionid=4023222,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =15118137;

COMMIT;


