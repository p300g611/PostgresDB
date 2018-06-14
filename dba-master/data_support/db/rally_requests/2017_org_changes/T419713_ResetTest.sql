BEGIN;

-SSID:7240719219 Reset test: math
begin;


--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #460217', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17000912)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17000912) ;




COMMIT;