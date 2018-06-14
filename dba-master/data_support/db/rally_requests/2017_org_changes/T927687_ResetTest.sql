BEGIN;

-SSID:9402338942,9342620213,3969510228  Reset test: Math-- Stage 2 - 10th grade ELA

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17310916 ,17310437,17310439);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17310916 ,17310437,17310439);


--reset stage1 to in process and inactive stage 2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17387957 ,17387958,17387959);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17387957 ,17387958,17387959);


update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id in (16920588,16920607,16920609);


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16920588,16920607,16920609);





COMMIT;