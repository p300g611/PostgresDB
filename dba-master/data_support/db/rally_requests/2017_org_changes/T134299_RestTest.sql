--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #134299', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16000892 )  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16000892 ) ;

COMMIT;