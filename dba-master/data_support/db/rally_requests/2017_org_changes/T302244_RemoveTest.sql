BEGIN;
--ssid:3050424389 remove 10th test 
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #302244', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18132561,16307846,18133277,15970712);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18132561,16307846,18133277,15970712);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18132561,16307846,18133277,15970712)  and activeflag is true ;



--ssid:3113112495 inactive 7th test
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #302244', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17179911,17179898);

update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17179911,17179898));


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17179911,17179898);

--ssid:4089639710 inactive 7th test

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #302244', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18229180,18376617,18229383);

update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (18229180,18376617,18229383));

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18229180,18376617,18229383);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18229180,18376617,18229383)  and activeflag is true ;
commit;





