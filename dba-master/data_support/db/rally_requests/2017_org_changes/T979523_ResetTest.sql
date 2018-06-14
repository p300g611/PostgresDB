begin;
--ssid:9243681575 -math  inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #979523', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17889213) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17889213)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17889213)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #979523', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16411507)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16411507)  ;

commit;