BEGIN;

--sid:511918 ssid:3679653484  3th-- math

--inactive stage 2 and stage 1
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17701255,15964159) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17701255,15964159)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 511918  and studentstestsid in (17701255,15964159)  ;




COMMIT;

