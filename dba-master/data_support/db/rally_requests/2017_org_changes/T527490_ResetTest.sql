begin;
--ssid:3397969492-math,inactive stage 2
--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #527490', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16025142)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16025142) ;

commit;