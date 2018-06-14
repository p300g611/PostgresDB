/*
ssid:12061069 --old ssid
DLM-RyanBenjamin-1408838-YE ELA 11.1 T           stid: 16838485       1408838 sid,  enrollmentid:2918020

DLM-RyanBenjamin-1408838-YE M 11.1 T                  16838476

ssid: 120610699 --new ssid     sid:1414316                                  enrollmentid = 2927896

DLM-RyanBenjamin-1414316-YE M 11.1 T                   18056662

DLM-RyanBenjamin-1414316-YE ELA 11.1 T                 18056667
DLM-RyanBenjamin-1408838-SP SCI HS.LS4-2 T              16837587
DLM-RyanBenjamin-1414316-SP SCI HS.LS4-2 T             18069121 
*/
 
BEGIN;

update student 
set   statestudentidentifier='120610699',
      modifieddate =now(),
	  modifieduser =174744
	  where id =1408838;
	  
	  
--inactvie studentstestid in (18056662,18056667)
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #997140', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18056662,18056667,18069121);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18056662,18056667,18069121);

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18056662,18056667,18069121)  and activeflag is true ;

/*
update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (18056662,18056667));



update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (18056662,18056667));
*/
--merge studentstestsid in (16838485,16838476)

update studentstests 
set    enrollmentid = 2927896,
       testsessionid = 5048123,
	   manualupdatereason ='as for ticket #997140', 
	   modifieddate=now(),
	   modifieduser=174744
where id =16838485;

update studentstests 
set    enrollmentid = 2927896,
       testsessionid = 5048118,
	   manualupdatereason ='as for ticket #997140', 
	   modifieddate=now(),
	   modifieduser=174744
where id =16838476;

update studentstests 
set    enrollmentid = 2927896,
       testsessionid = 5058826,
	   manualupdatereason ='as for ticket #997140', 
	   modifieddate=now(),
	   modifieduser=174744
where id =16837587;

update studenttracker
set   status='UNTRACKED',
      modifieddate=now(),
	  modifieduser =174744
	  where id in (544985,545597,545369) and studentid=1414316; 
	  
	  
update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =5047537;
	  
	  
COMMIT;

