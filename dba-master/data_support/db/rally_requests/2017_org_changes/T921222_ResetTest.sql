BEGIN;

-SSID:9782887811 Reset test: ELA-- Stage 2 - 10th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17198501;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17198501;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 359448 and studentstestsid =17198501;

--reset stage1 to in process
update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =15748763;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =15748763;

--inactive stge 2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17389545;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17389545;

COMMIT;