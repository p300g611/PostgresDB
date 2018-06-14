begin;
--ssid:7400128906 -math  inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #685001', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17347075,
17345003,
17356060,
17344999,
17356063,
17359718,
17347709,
17347705,
17347080,
17347697,
17347690,
17347729,
17347718,
17347071,
17376077
) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17347075,
17345003,
17356060,
17344999,
17356063,
17359718,
17347709,
17347705,
17347080,
17347697,
17347690,
17347729,
17347718,
17347071,
17376077)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17347075,
17345003,
17356060,
17344999,
17356063,
17359718,
17347709,
17347705,
17347080,
17347697,
17347690,
17347729,
17347718,
17347071,
17376077)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #685001', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15707481,
15708617,
15707296,
15708498,
15707560,
15707393,
15707909,
15707648,
15708171,
15707542,
15707533,
15708578,
15707981,
15707286,
15707617
)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15707481,
15708617,
15707296,
15708498,
15707560,
15707393,
15707909,
15707648,
15708171,
15707542,
15707533,
15708578,
15707981,
15707286,
15707617)  ;

commit;