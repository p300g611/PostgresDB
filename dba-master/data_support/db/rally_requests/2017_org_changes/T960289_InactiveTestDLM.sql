BEGIN;
--reset test :DLM-JaberMohammad-1354341-YE ELA 3.5 S ,  studenttestid:473962765,
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #960289', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17890224);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17890224);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17890224));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17890224)  and activeflag is true ;


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (17890224));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where   studentid in ( 1354341) and contentareaid='3' ;


--we found the test DLM-JaberMohammad-1354341-YE ELA 3.6 S is complete "2017-04-17 16:38:49.319932". this time is earlier than 
--this test reset"2017-04-17 20:24:05.663189" so talked with charles, i set back this test from inactive to active. 
update studentstests
set    activeflag =true,
       manualupdatereason ='as for ticket #960289', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17890224);


update studentstestsections
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17890224);


update testsession
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17890224));


update studentsresponses
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17890224)  and activeflag is false ;


update studenttrackerband
set    activeflag =true,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (17890224));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where   studentid in ( 1354341) and contentareaid='3' ;
commit;





