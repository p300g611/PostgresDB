--  ssid:5804379712  math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #465198', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15883437,17493240 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15883437,17493240 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (15883437,17493240 )  and activeflag is true ;

commit;