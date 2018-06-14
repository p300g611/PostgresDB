BEGIN;
--ssid:8126518553
update enrollment 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
	where id = 2895157;
	
	
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16350687,16000323,16350689,17071152) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16350687,16000323,16350689,17071152);


update studentstests 
set    enrollmentid =2920992,
       testsessionid= 4099322,
	   modifieddate =now(),
	   modifieduser =174744
	where id = 16260905;
commit;