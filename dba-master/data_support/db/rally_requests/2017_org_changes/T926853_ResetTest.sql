begin;

 --math  SSID:6318193073

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #926853', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15811708)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15811708) ;

COMMIT;





