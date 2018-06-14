BEGIN;
--reset test :DLM-HouthuizenPayge-1129741-WI SS-AA 10 studenttestid:1002172523,
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #727581', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16688689);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16688689);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16688689));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16688689)  and activeflag is true ;


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16688689));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where   studentid in ( 16688689);



commit;





