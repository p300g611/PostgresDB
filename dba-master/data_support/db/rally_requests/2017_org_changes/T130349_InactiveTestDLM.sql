BEGIN;
--reset test.SS test  ssid:1012540537 
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #130349', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16689668);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16689668);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16689668));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16689668)  and activeflag is true ;



--reset test.SS test  ssid:1010681153
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #130349', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16689674);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16689674);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16689674));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16689674)  and activeflag is true ;


commit;





