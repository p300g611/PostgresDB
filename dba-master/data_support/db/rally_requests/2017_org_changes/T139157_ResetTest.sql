begin;

--sid:4324834687 math 3th,inactive stage 1

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason ='as for ticket #139157', 
	  modifieduser =174744
where id in (15858325 ,17236960 ) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15858325 ,17236960 )    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where  studentstestsid  in (15858325 ,17236960)  ;





COMMIT;





