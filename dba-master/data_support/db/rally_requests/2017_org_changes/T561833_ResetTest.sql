begin;

--sid:1084783 ssid:4547171599 ,ELA 3th,inactive stage 1

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket #561833', 
	  modifieduser =174744
where id in (15886603 ,17269996 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15886603 ,17269996 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where  studentstestsid  in (15886603 ,17269996 )  ;





COMMIT;





