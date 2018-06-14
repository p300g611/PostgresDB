/*
--information before reset test

--SSID: 1017562113 reset test:speaking
studentid │ studenttestid │   status   │ stflag │ testsessionid │       testname       │ studenttestsectionid │ stsflag │ statusid │ scorstuid │ sasflag │
├───────────┼───────────────┼────────────┼────────┼───────────────┼──────────────────────┼──────────────────────┼─────────┼──────────┼───────────┼─────────┤
│    242570 │      15226384 │ inprogress │ t      │       4027132 │ Grades 4-5 Speaking  │             25440401 │ t       │      126 │     98387 │ t       │
│    242570 │      15226374 │ complete   │ t      │       4027131 │ Grades 4-5 Writing   │             25440391 │ t       │      127 │     98402 │ t       │
│    242570 │      15226365 │ complete   │ t      │       4027130 │ Grades 4-5 Reading   │             25440382 │ t       │      127 │      NULL │ NULL    │
│    242570 │      15226359 │ complete   │ t      │       4027129 │ Grades 4-5 Listening │             25440376 │ t       │      127 │      NULL │ NULL    

*/
BEGIN;



update studentstests
set    activeflag =false,
       status=659,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =15226384;



update studentstestsections
set    activeflag =false,
       statusid=128,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid =15226384;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 242570 and studentstestsid =15226384;


update scoringassignmentstudent
set    activeflag =false
where id =98387;

COMMIT;

