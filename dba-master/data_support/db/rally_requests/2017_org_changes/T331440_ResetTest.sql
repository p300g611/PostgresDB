BEGIN;
--set stage 1 status to in process
update studentstests
set    status =85,
       enddatetime=null,
       modifieddate=now(),
       modifieduser =174744,
       manualupdatereason='Ticket#331440'
where id =17627836;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17627836;

COMMIT;

