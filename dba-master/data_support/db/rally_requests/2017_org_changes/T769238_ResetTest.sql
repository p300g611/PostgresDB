begin;

--sid:3828874754 ELA 3th,inactive stage 1

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket #769238', 
	  modifieduser =174744
where id in (15848929 ,17096620 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15848929 ,17096620 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where  studentstestsid  in (15848929 ,17096620)  ;





COMMIT;





