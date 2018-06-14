BEGIN;

BEGIN;

--ssid:1043565671,2838671081,1265283168,3299078968  stage 7-- ELA

--inactive stage 2 and stage 1
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17382501,17382525,17382531,17382543) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17382501,17382525,17382531,17382543)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 328200     and studentstestsid =17382501 ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 577768     and studentstestsid =17382525 ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 329219     and studentstestsid =17382531 ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 578514     and studentstestsid =17382543 ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id in (16280933,16282586,16282700,16283335)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16280933,16282586,16282700,16283335)  ;

COMMIT;

