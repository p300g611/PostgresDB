BEGIN;

update studentstests
set    activeflag =true,
      status=86,
      manualupdatereason ='as for ticket #226171', 
      modifieddate=now(),
	  modifieduser =174744
where enrollmentid =2633197 and studentid = 1266575 and status=679 and activeflag is false ;


update studentstestsections
set    activeflag =true,
      statusid=127,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (select id from studentstests where enrollmentid =2633197 and studentid = 1266575 and status=679 and activeflag is false );


update testsession
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where enrollmentid =2633197 and studentid = 1266575 and status=679 and activeflag is false);


update studentsresponses
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (select id from studentstests where enrollmentid =2633197 and studentid = 1266575 and status=679 and activeflag is false)  and activeflag is false;


--
update studentstests
set    activeflag =true,
      status=84,
      manualupdatereason ='as for ticket #226171', 
      modifieddate=now(),
	  modifieduser =174744
	where id =18494733;
	
update studentstestsections
set    activeflag =true,
      statusid=125,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =	18494733;

update testsession
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id =18494733);


COMMIT;