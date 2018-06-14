begin;
--  ssid:3417422124-KAP math,inactive stage 1 and 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='As for tikcet 820204',
	  modifieduser =174744
where id in (17650906,15882684);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17650906,15882684);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 665406    and studentstestsid in (17650906,15882684);

--stage 1 in process
update studentstests
set    status =85,
       enddatetime=null,
	   activeflag =true,
      modifieddate=now(),
	  manualupdatereason ='as for ticket 820204',
	  modifieduser =174744
where id in (15882684 )  ;


update studentstestsections
set    statusid =126,
      activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15882684 )  ;

update studentsresponses
set    activeflag =true,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 665406    and studentstestsid in (15882684);
commit;


