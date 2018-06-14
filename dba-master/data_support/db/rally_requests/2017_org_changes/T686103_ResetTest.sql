begin;
--sid:1155072 ssid:6328010656  ,-KAP ELA,inactive stage 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket 686103', 
	  modifieduser =174744
where id in (17528552 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17528552 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1155072    and studentstestsid =17528552   ;






--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  manualupdatereason ='as for ticket 686103',
	  modifieduser =174744
where id in (15984094 )  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15984094 )  ;


COMMIT;





