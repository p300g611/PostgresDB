BEGIN;

BEGIN;

--ssid:7790086138  --3th ELA stage 2

--inactive stage 2 
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id = 17538796  ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17538796   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1220506      and studentstestsid =17538796  ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =17388429  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17388429  ;

COMMIT;

