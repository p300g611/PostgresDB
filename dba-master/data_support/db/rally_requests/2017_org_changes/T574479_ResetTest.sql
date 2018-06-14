begin;
--ssid:6328010656 math

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #574479', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16030766)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16030766) ;

commit;


