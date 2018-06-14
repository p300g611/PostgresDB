begin;

--sid:2883704627 math ,reset stage 1

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket #832234', 
	  modifieduser =174744
where id in (15712657 ,18068167 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15712657 ,18068167 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where  studentstestsid  in (15712657 ,18068167)  ;





COMMIT;





