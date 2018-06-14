BEGIN;
--reset DLM-PostolSidney-1406868-Teacher Survey A  ssid:4726276424 
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #256460', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16496968);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16496968);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16496968));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16496968)  and activeflag is true ;

COMMIT;
