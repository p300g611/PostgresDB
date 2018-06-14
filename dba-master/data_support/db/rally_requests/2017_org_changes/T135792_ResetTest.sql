--  ssid:8657531259    math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #135792', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17886437 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17886437 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17886437 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #135792', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15813210)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15813210 ) ;

COMMIT;