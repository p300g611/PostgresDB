BEGIN;
/*
before reset
statestudentidentifier │ studentid │ enrollmentid │ studenttestid │   status   │ stflag │ testsessionid │ studenttestsectionid │ stsflag │ statusid │ scorstuid │ sasflag │
├────────────────────────┼───────────┼──────────────┼───────────────┼────────────┼────────┼───────────────┼──────────────────────┼─────────┼──────────┼───────────┼─────────┤
│ 1579245455             │   1388651 │      2753942 │      15183159 │ complete   │ t      │       4018865 │             25397118 │ t       │      127 │    172772 │ t       │
│ 1579245455             │   1388651 │      2753942 │      15183149 │ inprogress │ t      │       4018863 │             25397108 │ t       │      129 │      NULL │ NULL    │
│ 1579245455             │   1388651 │      2753942 │      15183141 │ complete   │ t      │       4018861 │             25397099 │ t       │      127 │    172981 │ t       │
│ 1579245455             │   1388651 │      2753942 │      15183132 │ complete   │ t      │       4018859 │             25397091 │ t       │      127 │      NULL │ NULL    │
└────────────────────────┴───────────┴──────────────┴───────────────┴────────────┴────────┴───────────────┴──────────────────────┴─────────┴──────────┴───────────┴─────────┘
│ id  │    categorycode    │ id │          typecode          │
├─────┼────────────────────┼────┼────────────────────────────┤
│ 659 │ inprogresstimedout │ 22 │ STUDENT_TEST_STATUS        │
│ 128 │ inprogresstimedout │ 33 │ STUDENT_TESTSECTION_STATUS │
└─────┴────────────────────┴────┴────────────────────────────┘

*/
--SSID:1579245455  Test:Writing,Reading

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =15183159;

update studentstests
set    activeflag =false,
       status=659,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =15183149;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid =15183159;

update studentstestsections
set    activeflag =false,
       statusid=128,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentstestid =15183149;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where studentid = 1388651 and studentstestsid in (15183149,15183159);


update scoringassignmentstudent
set    activeflag =false
where id =172772;


COMMIT;
