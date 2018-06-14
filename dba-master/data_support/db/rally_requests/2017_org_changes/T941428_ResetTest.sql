begin;
--ssid:9862767332,8493101583,1082331961,1210432633,6293872657-math,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #941428', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17415373,17480488,17477778,17575883,17059886 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17415373,17480488,17477778,17575883,17059886 )     ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17415373,17480488,17477778,17575883,17059886 )  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #941428', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15769896,15765167,15768433,15769691,15753644)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15769896,15765167,15768433,15769691,15753644) ;


--SSID:6153707343,9338189112 ,7740344338 ,5393190131 reset stage 2--ELA

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #941428', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17067964,17125015,17621000,17419670 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17067964,17125015,17621000,17419670 )     ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17067964,17125015,17621000,17419670 )  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #941428', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16058166,16044050,16047076,16059157)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16058166,16044050,16047076,16059157) ;
COMMIT;





