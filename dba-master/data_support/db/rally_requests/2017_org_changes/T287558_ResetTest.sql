--SSID:6364092292  math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #287558', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18097186);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18097186);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18097186)  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #287558', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15824417)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15824417) ;

COMMIT;