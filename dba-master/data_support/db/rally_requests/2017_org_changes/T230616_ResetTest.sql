--  ssid:8715714063,7817575207    math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #230616', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17579386,17562364 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17579386,17562364 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17579386,17562364 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #230616', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15822275,15816762 )  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15822275,15816762  ) ;

COMMIT;