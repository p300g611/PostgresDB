--  ssid:4038178672     inactive test with grade 4

update studentstests
set    activeflag =false,
       manualupdatereason ='T225815-validation2', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18426218,18426216);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18426218,18426216);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (18426218,18426216));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18426218,18426216)  and activeflag is true ;

COMMIT;