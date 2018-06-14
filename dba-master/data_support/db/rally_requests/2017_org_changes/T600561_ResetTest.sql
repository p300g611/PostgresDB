BEGIN;

BEGIN;

--ssid:4883889327 sid: 386531 --10th MATH stage 2

--inactive stage 2 and stage 1
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id = 17545412  ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17545412   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 386531      and studentstestsid =17545412  ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =16105753  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16105753  ;

COMMIT;

