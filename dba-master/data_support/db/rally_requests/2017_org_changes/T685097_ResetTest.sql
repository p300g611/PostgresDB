--  ssid:5676920106  ELA
begin;

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
where studentstestid in (16020833) ;

commit;