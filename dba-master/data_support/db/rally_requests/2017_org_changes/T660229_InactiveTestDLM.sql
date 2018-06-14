BEGIN;
--  ssid:4326251678  inactive test with grade 5
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #660229', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17184305,17184396);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17184305,17184396);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17184305,17184396));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17184305,17184396)  and activeflag is true ;

commit;