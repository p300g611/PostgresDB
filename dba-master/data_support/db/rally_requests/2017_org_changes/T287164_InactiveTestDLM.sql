BEGIN;
--ssid:40049382 
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #287164', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17167770,17167819);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17167770,17167819);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17167770,17167819));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17167770,17167819)  and activeflag is true ;






commit;





