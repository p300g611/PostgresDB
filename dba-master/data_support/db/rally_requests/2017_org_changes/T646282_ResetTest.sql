--  ssid:1315991985  math
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #646282', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18044878);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18044878 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18044878 )  and activeflag is true ;

commit;