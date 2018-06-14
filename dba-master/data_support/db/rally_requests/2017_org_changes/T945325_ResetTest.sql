begin;
--ssid:2971291855   math 

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #945325', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17659617);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17659617);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17659617)  and activeflag is true ;
--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #945325', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15864960)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15864960) ;

commit;