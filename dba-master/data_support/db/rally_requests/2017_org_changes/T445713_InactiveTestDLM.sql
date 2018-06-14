BEGIN;
/*select sts.id as stid, ts.id as tsid, ts.name as testsessionname, t.testname,
 (select categorycode as status from category where id = sts.status)
from student stud
join studentstests sts on sts.studentid = stud.id
join testsession ts on ts.id = sts.testsessionid
join test t on t.id = sts.testid
where stud.statestudentidentifier = '8044726774'
order by sts.createddate asc;
*/
--inactive   ssid:1003931462
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #445713', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16689239);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16689239);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16689239));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16689239)  and activeflag is true ;

--inactive  ssid:8044726774
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #608027', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16689242);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16689242);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16689242));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16689242)  and activeflag is true ;
commit;





