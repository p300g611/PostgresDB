begin;
--ssid:3869427892，7751489324-math,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #743968', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17889361,17891144) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17889361,17891144)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17889361,17891144)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #743968', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15938782,15940153)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15938782,15940153) ;

commit;