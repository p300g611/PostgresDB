begin;
--ssid:3278188594   math 

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #267563', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18090369);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18090369);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18090369)  and activeflag is true ;
--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #267563', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16000892)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16000892) ;

commit;


