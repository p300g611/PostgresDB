select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.id=1167970
order by 2;
--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for Ticket #214989', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22060268 and studentid=1167970 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22060268 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22060268 and studentid =1167970 and activeflag =true ;

--stage1
update studentstests
set    status =84,  
       modifieddate=now(),
	  manualupdatereason ='for Ticket #214989', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id= 22030601
and studentid=1167970;

update studentstestsections
set    statusid =125,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22030601;

COMMIT;
