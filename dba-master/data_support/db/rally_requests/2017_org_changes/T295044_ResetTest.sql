begin;
--ssid:2442485168-math,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #295044', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17960803) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17960803)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17960803)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #295044', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15821622)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15821622) ;

commit;