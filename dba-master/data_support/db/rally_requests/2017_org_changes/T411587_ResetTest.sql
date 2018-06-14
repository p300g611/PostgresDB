BEGIN;
--ssid:4831009881  reset test:2017_0829_Grade 5_English Language Arts_Stage 1
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =15832267;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid  =15832267;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 158260 and studentstestsid = 15832267;

--reset test: 2017_0829_Grade 5_English Language Arts_Stage 2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =16770408;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid  =16770408;


COMMIT;
