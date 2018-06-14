begin;
--sid:886609  ssid:6826018268-KAP ELA,inactive stage 1 and 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='As for tikcet442263',
	  modifieduser =174744
where id in (15755638,17723396);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15755638,17723396);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 886609    and studentstestsid =15755638;




commit;


