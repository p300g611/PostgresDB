begin;

select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.id=1050829
order by 2;

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #258192', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21270871,21268168 ) and studentid=1050829 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21270871,21268168)  and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (21270871 ,21268168) and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #258192', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20713971 ,21010587 ) and studentid=1050829;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20713971 ,21010587) ;

COMMIT;





