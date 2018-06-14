begin;
--  sid: 669818   inactive test with grade 5th

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #145967', 
      modifieddate=now(),
	  modifieduser =174744
where id in (14716276,14716285,14716279,14716275,14716282,14716287,14716273,14716274);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (14716276,14716285,14716279,14716275,14716282,14716287,14716273,14716274);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (14716276,14716285,14716279,14716275,14716282,14716287,14716273,14716274));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (14716276,14716285,14716279,14716275,14716282,14716287,14716273,14716274)  and activeflag is true ;

COMMIT;
