--  ssid:9143481663   math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #963280', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18053961 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18053961 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18053961 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #963280', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15825700 )  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15825700 ) ;

COMMIT;