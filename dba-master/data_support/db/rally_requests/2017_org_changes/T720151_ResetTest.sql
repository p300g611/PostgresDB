BEGIN;

BEGIN;

--ssid:3525474296,3141241414  reset stage 2--4th ELA 

--inactive stage 2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id = 17346809  ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17346809   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1171002      and studentstestsid =17346809  ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =15727745  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =15727745  ;

--inactive stage 2  
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id = 17379075  ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17379075   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 295193      and studentstestsid =17379075  ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =16039643  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16039643  ;

COMMIT;

