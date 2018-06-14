BEGIN;
--ssid:1015678556 test:DLM-McClureDamian-865604-WI SS AA-8
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #408577', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16688183);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16688183);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16688183));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16688183)  and activeflag is true ;






commit;





