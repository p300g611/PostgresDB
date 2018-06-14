begin;
--ssid:4220585613,sid:558528  -KAP math,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #275546', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16304044 ,16304043  ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16304044 ,16304043  )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 558528    and studentstestsid =16304044   ;

commit;