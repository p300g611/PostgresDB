BEGIN;
--inactive test with grade 4 : studenttestid:2538338758,--DLM
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #914756', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17381061,16731865,17421029,16834348,16834800,17460165,17460012,17381077,17461440,16732490,17461446,17421299,16834392,16834831);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17381061,16731865,17421029,16834348,16834800,17460165,17460012,17381077,17461440,16732490,17461446,17421299,16834392,16834831);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17381061,16731865,17421029,16834348,16834800,17460165,17460012,17381077,17461440,16732490,17461446,17421299,16834392,16834831));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17381061,16731865,17421029,16834348,16834800,17460165,17460012,17381077,17461440,16732490,17461446,17421299,16834392,16834831)  and activeflag is true ;


--inactive test with grade 6 : studenttestid:2484584466,--KAP

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #914756', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17476799,16037741);

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17476799,16037741);

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17476799,16037741);

commit;





