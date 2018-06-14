BEGIN;
--reset test:  DLM-MielkeBrock-988544-WI SS-AA 10   ssid:1010172594 
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #130349', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16689796);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16689796);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16689796));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16689796)  and activeflag is true ;






commit;





