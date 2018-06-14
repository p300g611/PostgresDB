begin;
--ssid:6342762945-math,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #422190', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17894458) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17894458)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17894458)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #422190', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16063397)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16063397) ;

commit;