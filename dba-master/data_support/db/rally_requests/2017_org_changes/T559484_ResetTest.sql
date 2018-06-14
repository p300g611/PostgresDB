--  ssid:5085617657  ELA
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #559484', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16069902,18200524 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16069902,18200524 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16069902,18200524 )  and activeflag is true ;

commit;