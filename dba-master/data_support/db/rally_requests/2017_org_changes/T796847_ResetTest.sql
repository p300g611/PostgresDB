begin;
--ssid:3804868347 ,3218172403 ,9880508661-KAP math,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #796847', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17626981,17626987,17627012 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17626981,17626987,17627012 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 698858     and studentstestsid =17626981  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 699081     and studentstestsid =17626987  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 386503     and studentstestsid =17627012  ;
--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #796847', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15989578,15989605,15989683)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15989578,15989605,15989683)  ;



COMMIT;





