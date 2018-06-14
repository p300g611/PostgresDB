begin;
--ssid:6328010656 ,-KAP math,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #686103', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17604007 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17604007 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1155072     and studentstestsid =17604007  ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #686103', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16030766 )  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16030766 )  ;

--reactive ELA Test stage 1 to complete

update studentstests
set    status =86,
       enddatetime=now(),
	   manualupdatereason ='as for ticket #686103', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15984094)  ;


update studentstestsections
set    statusid =127,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15984094)  ;

--set ELA stage 2 to inactive

update studentstests
set    activeflag =true,
      manualupdatereason ='as for ticket #686103', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17528552 ) ;


update studentstestsections
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17528552 )    ;


update studentsresponses
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1155072     and studentstestsid =17528552  ;

COMMIT;





