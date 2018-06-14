BEGIN;
--ssid:323315507  remove 4th test
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #297487', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16838136,16838132);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16838136,16838132);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16838136,16838132));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16838136,16838132)  and activeflag is true ;


--ssid:7207033626   remove 7th test

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #297487', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16590196,16587721);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16590196,16587721);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16590196,16587721));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16590196,16587721)  and activeflag is true ;

--ssid:4038178672 remove 3th test
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #297487', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16590196,16587721);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16590196,16587721);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16590196,16587721));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16590196,16587721)  and activeflag is true ;


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (18056662,18056667));

commit;





