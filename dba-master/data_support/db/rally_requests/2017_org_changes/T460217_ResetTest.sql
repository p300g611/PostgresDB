BEGIN;

-SSID:1842579983 Reset test: math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #460217', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18256852 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18256852 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18256852 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #460217', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16493579)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16493579) ;




COMMIT;