BEGIN;

-SSID:5623323472,1173463771,4287834542,7849164148  Reset test: Math-- Stage 2 - 4th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17045235,17045335,17045284,17045298);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17045235,17045335,17045284,17045298);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1091397 and studentstestsid =17045235;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1091508 and studentstestsid =17045335;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1091442 and studentstestsid =17045284;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1091468 and studentstestsid =17045298;

---set stage1 to in process
update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id in (15857547,15858054,15857765,15857914);


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15857547,15858054,15857765,15857914);

--inactive stage2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17388374,17388377,17388375,17388376);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17388374,17388377,17388375,17388376);


COMMIT;