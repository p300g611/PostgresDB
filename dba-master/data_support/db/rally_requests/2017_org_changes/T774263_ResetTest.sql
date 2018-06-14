begin;
--ssid:6267385213  ,--math,inactive stage 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket 774263', 
	  modifieduser =174744
where id in (17791807 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17791807 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 531210    and studentstestsid =17791807   ;






--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  manualupdatereason ='as for ticket 774263',
	  modifieduser =174744
where id in (15976600 )  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15976600 )  ;


COMMIT;





