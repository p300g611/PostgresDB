begin;
--ssid:4745336306-ela,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #619805', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17530670) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17530670)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17530670)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #619805', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16165860)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16165860) ;

commit;