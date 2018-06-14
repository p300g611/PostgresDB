select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid ,
st.enrollmentid,testsessionid from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.id in (785228)
order by 2;


BEGIN;
--stage2
update studentstests
set    enrollmentid = 3241487, testsessionid =5879027,
       modifieddate=now(),
	  manualupdatereason ='as for ticket #330167 ', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21808429;

update studentstests
set    enrollmentid = 3241482, testsessionid =5879523,
       modifieddate=now(),
	  manualupdatereason ='as for ticket #330167 ', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21593896;

commit;