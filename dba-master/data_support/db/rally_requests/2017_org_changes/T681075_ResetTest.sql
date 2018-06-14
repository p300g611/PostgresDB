BEGIN;
--ssid:4173092745  reset test:ELA--5.3dp ADN 5.4ip
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16737919,16742106);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16737919,16742106);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16737919,16742106));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1308909 and studentstestsid in (16737919,16742106);

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16737919,16742106));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16737919,16742106))) and studentid= 1308909;
commit;