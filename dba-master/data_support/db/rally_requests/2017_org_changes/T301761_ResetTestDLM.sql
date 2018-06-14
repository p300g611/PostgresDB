BEGIN;
--reset test :DLM-HARTBRETT-522604-WI SS-AA 8 ,  ssid:1013786858,
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #301761', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16687956);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16687956);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16687956));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16687956)  and activeflag is true ;



commit;





