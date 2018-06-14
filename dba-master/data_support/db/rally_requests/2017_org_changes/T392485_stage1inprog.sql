begin;

/*
--validation
 select studentid,st.enrollmentid,rosterid,st.id studenttest,st.testid,st.status,ts.source,ts.operationaltestwindowid opwid,ts.stageid,contentareaid,st.activeflag,st.modifieddate,manualupdatereason
 from studentstests st 
 inner join testsession ts on ts.id=st.testsessionid
 inner join testcollection tc on tc.id=ts.testcollectionid
 inner join student s on s.id=st.studentid
 where  statestudentidentifier ='4852583064';

 select * from st
*/

--studentid:1187898,-KAP M,inactive stage 2

update studentstests
set    activeflag =false,
       modifieddate=now(),
       modifieduser =174744,
       manualupdatereason='Ticket#392485'
where id in (17901731) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17901731)    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 797031    and studentstestsid =17901731  ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
      modifieduser =174744,
      manualupdatereason='Ticket#392485'
where id in (15670707)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15670707)  ;

COMMIT;





