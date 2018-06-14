begin;
--ssid:1692435329 -ela,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #129696', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16994642) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16994642)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16994642)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #129696', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15800955)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15800955) ;

commit;