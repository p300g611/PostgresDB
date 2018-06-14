begin;

select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.id=265207
order by 2;

--SSID:4356650697 , studentid:265207 stage 1 and 2 ELA

BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #880503', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21780617 and studentid=265207 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21780617 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21780617 and studentid =265207 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #880503', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20921764 and studentid=265207 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20921764 ;


COMMIT;


