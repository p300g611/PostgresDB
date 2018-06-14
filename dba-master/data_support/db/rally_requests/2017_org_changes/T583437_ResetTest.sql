begin;
--ssid:7469846352-math,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #422190', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17794823) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17794823)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17794823)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #422190', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16415075)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16415075) ;

commit;