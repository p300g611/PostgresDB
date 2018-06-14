--reset student test ELA
--SSID:7618553424, studentid:1472420
begin;

select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.id=1472420
order by 2;


--stage1
update studentstests
set    activeflag=false,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #740382', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21437277 ) and studentid=1472420;


update studentstestsections
set    activeflag=false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21437277) ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (21437277) and activeflag =true ;



--SSID:5629588583  studentid:1401222
--stage1

update studentstests
set    activeflag=false,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #740382', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21593940 ) and studentid=1401222;


update studentstestsections
set    activeflag=false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21593940) ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (21593940) and activeflag =true ;


COMMIT;
