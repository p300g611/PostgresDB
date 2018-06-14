BEGIN;
--SSID:5522861762

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16084764,16468143);



update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16084764,16468143);



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1039062 and studentstestsid in (16084764,16468143);


COMMIT;
