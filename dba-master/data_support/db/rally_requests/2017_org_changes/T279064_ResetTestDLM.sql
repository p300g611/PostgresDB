BEGIN;
--reset test :DLM-HirnZachary-1040555-WI SS-AA 10 ,  ssid:1014464579,
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #279064', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16689772);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16689772);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16689772));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16689772)  and activeflag is true ;

commit;





