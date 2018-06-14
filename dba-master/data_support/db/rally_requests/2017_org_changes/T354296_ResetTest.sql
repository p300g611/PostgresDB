BEGIN;

--sid:1328963 ssid:4195576873 reset stage2--3th ELA

--inactive stage 2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17250522 ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17250522;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1328963 and studentstestsid =17250522;

--update stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =15693697;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =15693697;

COMMIT;