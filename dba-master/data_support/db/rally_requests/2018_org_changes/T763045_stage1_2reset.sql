select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid,s.statestudentidentifier
from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.statestudentidentifier in ('6377932189') and tc.contentareaid=440;


BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #763045', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20809305,22540038) and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20809305,22540038) and activeflag =true;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid in (20809305,22540038) and activeflag =true;

COMMIT;
