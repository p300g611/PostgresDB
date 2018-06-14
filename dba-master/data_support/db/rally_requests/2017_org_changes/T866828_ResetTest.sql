begin;

--ssid:3629349498,math 3th,inactive stage 1

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket 866828', 
	  modifieduser =174744
where id in (17643159,15707213) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17643159,15707213)    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where  studentstestsid  in (15707213)  ;





COMMIT;





