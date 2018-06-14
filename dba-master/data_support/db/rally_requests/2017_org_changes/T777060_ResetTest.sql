begin;

--sid:5257277972--ELA  SSID:6654375254-- math ,reset stage 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket #777060', 
	  modifieduser =174744
where id in (17754624 ,17976146 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17754624 ,17976146 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where  studentstestsid  in (17754624 ,17976146)  ;





COMMIT;





