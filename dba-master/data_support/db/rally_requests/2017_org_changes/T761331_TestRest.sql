BEGIN;

BEGIN;
--ssid:1904597955  reset test:2017_1838_Grade 11_Science_Stage 1
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =16317640;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid  =16317640;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1154863 and studentstestsid = 16317640;

--reset test: 2017_1838_Grade 11_Science_Stage 2 
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =16317642;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid  =16317642;


COMMIT;
