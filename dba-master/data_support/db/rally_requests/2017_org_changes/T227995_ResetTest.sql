--  ssid:2759302628,1600286925,2443341844,2177015367, 6913475829,1126431095, 4228784933  ELA
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #227995', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17660746,17660662,17658564,17660798,17660575,17660760,17660699 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17660746,17660662,17658564,17660798,17660575,17660760,17660699 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17660746,17660662,17658564,17660798,17660575,17660760,17660699 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #227995', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16062347,16061858,16062035,16137145,16061618,16062501,16062047)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16062347,16061858,16062035,16137145,16061618,16062501,16062047 ) ;


--6303303072,2647693099  MATH
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #227995', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18004455,17955470 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18004455,17955470 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18004455,17955470 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #227995', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15771368,15777010)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15771368,15777010 ) ;


COMMIT;