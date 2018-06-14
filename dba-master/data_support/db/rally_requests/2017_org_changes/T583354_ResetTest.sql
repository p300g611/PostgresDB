--  sid:840879   ELA
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #825643', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17871584 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17871584 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17871584 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #825643', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15692426 )  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15692426 ) ;

COMMIT;