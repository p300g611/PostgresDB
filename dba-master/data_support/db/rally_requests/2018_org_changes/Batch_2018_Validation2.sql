--deactivate the student test in grade 4. SSID:6010552744 
 select st.studentid,st.id stid,st.status,st.activeflag,ts.source,t.testname,gc.name sessions,gct.name collection,gce.name enroll,st.modifieddate
 from studentstests st
 inner join test t on t.id=st.testid
 inner join enrollment e on e.id=st.enrollmentid
 inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
 inner join testcollection tc on tc.id=ts.testcollectionid
 left outer join gradecourse gc on gc.id=ts.gradecourseid
 left outer join gradecourse gct on gct.id=tc.gradecourseid
 left outer join gradecourse gce on gce.id=e.currentgradelevel
 where st.studentid =1438182  order by st.activeflag,t.testname;

begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason ='Validation2'
where id in (21205455,22499648) and studentid =1438182;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21205455,22499648);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (21205455,22499648));


update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1438182 and studentstestsid in (21205455,22499648) and activeflag is true;


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1438182 and testsessionid in (select testsessionid from studentstests where id in (21205455,22499648));

commit;

