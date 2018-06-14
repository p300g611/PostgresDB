begin;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #567972'
where id in (
18637280,
18637283,
18637284,
18637286,
18637287,
18637289,
18637292,
18637293,
18637295,
18637297,
18637299,
18637316,
18637317,
18637319,
18637322
);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in 
(
18637280,
18637283,
18637284,
18637286,
18637287,
18637289,
18637292,
18637293,
18637295,
18637297,
18637299,
18637316,
18637317,
18637319,
18637322
);


update testsession
set    activeflag =false,
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in 
(
18637280,
18637283,
18637284,
18637286,
18637287,
18637289,
18637292,
18637293,
18637295,
18637297,
18637299,
18637316,
18637317,
18637319,
18637322
));


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1328074 and studentstestsid in 
(
18637280,
18637283,
18637284,
18637286,
18637287,
18637289,
18637292,
18637293,
18637295,
18637297,
18637299,
18637316,
18637317,
18637319,
18637322
) and activeflag is true;



update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1328074 and testsessionid in (select testsessionid from studentstests where id in 
(
18637280,
18637283,
18637284,
18637286,
18637287,
18637289,
18637292,
18637293,
18637295,
18637297,
18637299,
18637316,
18637317,
18637319,
18637322
));


commit;
