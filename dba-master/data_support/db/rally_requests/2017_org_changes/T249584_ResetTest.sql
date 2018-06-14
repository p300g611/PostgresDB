--SSID:8484016099  math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #249584', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18028252);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18028252);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18028252)  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #249584', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15715879)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15715879) ;

COMMIT;