begin;
--ssid:5242181389-ela,inactive stage 2
--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #529353', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15769760)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15769760) ;

commit;