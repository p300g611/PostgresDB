--  ssid:1246088061  math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #478277', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17978991 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17978991 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17978991 )  and activeflag is true ;

commit;