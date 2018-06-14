BEGIN;

BEGIN;

--ssid:9725631897 reset both --5th ELA

--inactive stage 2 and stage 1
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17158473 ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17158473  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 666677   and studentstestsid =17158473 ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =15703386;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =15703386;

COMMIT;

