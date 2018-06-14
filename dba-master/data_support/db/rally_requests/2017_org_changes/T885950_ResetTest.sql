begin;
--ssid:2178524176,7177529462   math 

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #885950', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16728772,18131000,16728782,18131001);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16728772,18131000,16728782,18131001);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16728772,16728782)  and activeflag is true ;


commit;


