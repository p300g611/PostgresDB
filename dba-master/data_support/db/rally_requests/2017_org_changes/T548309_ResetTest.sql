BEGIN;
--reset test.SS test  studentid:1129749
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #548309', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16688686);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16688686);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16688686));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16688686)  and activeflag is true ;

commit;