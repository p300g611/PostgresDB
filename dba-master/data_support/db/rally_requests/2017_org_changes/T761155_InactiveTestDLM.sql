BEGIN;
--ssid:1002237638 
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #761155', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17407285,17453331,17692622,17451449,17407290,17693767,17296469,17363701,17450783,17296928,17453452);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17407285,17453331,17692622,17451449,17407290,17693767,17296469,17363701,17450783,17296928,17453452);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17407285,17453331,17692622,17451449,17407290,17693767,17296469,17363701,17450783,17296928,17453452));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17407285,17453331,17692622,17451449,17407290,17693767,17296469,17363701,17450783,17296928,17453452)  and activeflag is true ;






commit;





