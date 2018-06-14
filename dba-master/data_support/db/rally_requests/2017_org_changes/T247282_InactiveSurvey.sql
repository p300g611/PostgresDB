BEGIN;
--reset DLM-AGEMAIAN-1362422-WI SS-AA 4  ssid:1021886552 
--reset DLM-NeesRichard-1126777-WI SS-AA 8 ssid:1019120363
--reset DLM-PoggenseeAustin-1301389-WI SS-AA 8  ssid:1016792131
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #247282', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16689781,16688617,16689783);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16689781,16688617,16689783);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16689781,16688617,16689783));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16689781,16688617,16689783)  and activeflag is true ;

COMMIT;
