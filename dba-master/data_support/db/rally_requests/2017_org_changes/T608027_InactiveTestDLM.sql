BEGIN;
--inactive test with grade 7 ,  ssid:1016976518
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #608027', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17836009,17835576);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17836009,17835576);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17836009,17835576));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17836009,17835576)  and activeflag is true ;

--inactive test with grade 6 ssid:1018146539
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #608027', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17768160,17926703,17964909,17966977,17926383,17768183,17923570);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17768160,17926703,17964909,17966977,17926383,17768183,17923570);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17768160,17926703,17964909,17966977,17926383,17768183,17923570));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17768160,17926703,17964909,17966977,17926383,17768183,17923570)  and activeflag is true ;
commit;





