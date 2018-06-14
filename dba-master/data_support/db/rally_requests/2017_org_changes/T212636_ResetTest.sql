BEGIN;

BEGIN;

--ssid:3458095969  stage 10-- Math

--inactive stage 2 and stage 1
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id = 17694301 ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17694301   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1122214       and studentstestsid =17694301  ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id = 16063397  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16063397  ;

COMMIT;

