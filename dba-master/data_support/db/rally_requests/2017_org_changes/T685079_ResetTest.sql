BEGIN;

-SSID:5676920106 Reset test: ELA- 7th grade ELA
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #685097', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18175923 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18175923 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18175923 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #685097', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16020833)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16020833 ) ;

COMMIT;



COMMIT;