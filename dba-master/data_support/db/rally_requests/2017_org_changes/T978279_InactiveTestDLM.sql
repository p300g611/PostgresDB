BEGIN;
--reset test :DLM-MeyerCassandra-1274643-WI SS-AA 4 studenttestid:1020508949,
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #978279', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16689458);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16689458);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16689458));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16689458)  and activeflag is true ;


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16689458));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where   studentid in ( 16689458);



commit;





