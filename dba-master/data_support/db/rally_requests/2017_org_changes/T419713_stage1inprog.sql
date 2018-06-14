begin;

/*
--validation
 select studentid,st.enrollmentid,rosterid,st.id studenttest,st.testid,st.status,ts.source,ts.operationaltestwindowid opwid,ts.stageid,contentareaid,st.activeflag,st.modifieddate,manualupdatereason
 from studentstests st 
 inner join testsession ts on ts.id=st.testsessionid
 inner join testcollection tc on tc.id=ts.testcollectionid
 inner join student s on s.id=st.studentid
 where  statestudentidentifier ='7240719219';


*/

--studentid:673211,-KAP M,reset stage1


--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
      modifieduser =174744,
      manualupdatereason='Ticket#419713'
where id in (17000912)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17000912)  ;

COMMIT;





