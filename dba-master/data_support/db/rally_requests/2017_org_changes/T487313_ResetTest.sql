--  ssid:4277428177    ELA
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #487313', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17554198 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17554198 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17554198 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #487313', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17285013)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17285013 ) ;

COMMIT;