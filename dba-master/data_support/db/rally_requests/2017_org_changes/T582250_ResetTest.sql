begin;

--sid:7179452289, 6413390158 ELA ,reset stage 1

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket #582250', 
	  modifieduser =174744
where id in (16035418 ,16035475 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16035418 ,16035475  )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where  studentstestsid  in (16035418 ,16035475 )  ;





COMMIT;





