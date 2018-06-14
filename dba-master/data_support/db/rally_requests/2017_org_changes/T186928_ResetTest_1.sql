begin;
--sid:561012  ssid:6520171417-KAP ELA,inactive stage 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id = 17315708 ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17315708   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 561012    and studentstestsid =17315708  ;




commit;


