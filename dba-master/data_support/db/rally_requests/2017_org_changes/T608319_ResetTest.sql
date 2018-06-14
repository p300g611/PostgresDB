BEGIN;

-SSID:8072894773 Reset test:all ELA-- Stage 2 - 10th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =16960859;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16960859;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 61982 and studentstestsid =16960859;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =15731675;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =15731675;

--inactive stage 2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17389543;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17389543;

commit;