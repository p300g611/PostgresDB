BEGIN;
--ssid:7613080263 remove 4th test 
update studentstests
set    activeflag =false,
       manualupdatereason ='T287164-validation2', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18229498);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18229498);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (18229498));


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	  modifieduser =174744
where id  = 3073301;   


--ssid:2686759390 remove 8th test 


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	  modifieduser =174744
where id  in (3291942,3291898);   





--ssid:1026927156 remove 7th test
update studentstests
set    activeflag =false,
       manualupdatereason ='T287164-validation2', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18494631,18494646);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18494631,18494646);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (18494631,18494646));


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	  modifieduser =174744
where id  in (3283322,3283324);   


--ssid:1707515963 remove 7th test
update studentstests
set    activeflag =false,
       manualupdatereason ='T287164-validation2', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18406899);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18406899);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (18406899));



commit;





