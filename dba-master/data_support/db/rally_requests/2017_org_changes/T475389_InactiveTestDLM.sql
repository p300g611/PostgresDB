BEGIN;
--reset test:  DLM-BartowLily-1088394-WI SS-AA 10   ssid:1011315383  
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #475389', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16688490);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16688490);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16688490));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16688490)  and activeflag is true ;






commit;





