begin;
--ssid:3397969492  ,--math,inactive stage 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket 251341', 
	  modifieduser =174744
where id in (17697009 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17697009 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1187898    and studentstestsid =17697009   ;






--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  manualupdatereason ='as for ticket 774263',
	  modifieduser =174744
where id in (16025142 )  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16025142 )  ;


COMMIT;





