
select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.id in (1062553,158765)
order by 2;

BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #189052', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22278824 and studentid=1062553 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22278824 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22278824 and studentid =1062553 and activeflag =true ;

COMMIT;

BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #189052', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22271530 and studentid=158765 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =22271530 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =22271530 and studentid =158765 and activeflag =true ;

COMMIT;


