BEGIN;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =15311565;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =25523055;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid=15311565 and studentid=1396668 ;

update scoringassignmentstudent
set    activeflag =false
where id =180646 and studentid=1396668;


COMMIT;