BEGIN;

-SSID:9250127588 Reset test: math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #859944', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18030865 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18030865 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18030865 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #859944', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15913722)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15913722 ) ;




COMMIT;