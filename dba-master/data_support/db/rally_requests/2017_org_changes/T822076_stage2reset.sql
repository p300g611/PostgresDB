

/*
--validation
 select studentid,st.enrollmentid,rosterid,st.id studenttest,st.testid,st.status,ts.source,ts.operationaltestwindowid opwid,ts.stageid,contentareaid,st.activeflag,st.modifieddate,manualupdatereason
 from studentstests st 
 inner join testsession ts on ts.id=st.testsessionid
 inner join testcollection tc on tc.id=ts.testcollectionid
 inner join student s on s.id=st.studentid
 where  statestudentidentifier ='1499502354';


*/

--studentid:1187898,-KAP M,inactive stage 2
begin;
update studentstests
set    activeflag =false,
       modifieddate=now(),
       modifieduser =174744,
       manualupdatereason='Ticket#822076'
where id in (17212525);

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17212525);

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1312379 and studentstestsid =17212525;

COMMIT;


begin;
update studentstests
set    activeflag =false,
       modifieddate=now(),
       modifieduser =174744,
       manualupdatereason='Ticket#822076'
where id in (17314462);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17314462);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 520917 and studentstestsid =17314462;

COMMIT;




