BEGIN;

-SSID:6454058247 Reset test: ELA
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #505409', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17553721 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17553721 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17553721 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #505409', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15698853)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15698853 ) ;




COMMIT;