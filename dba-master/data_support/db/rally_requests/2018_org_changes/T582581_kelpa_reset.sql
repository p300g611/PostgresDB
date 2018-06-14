begin;


select s.id studentid,st.id stid,ts.name,operationaltestwindowid from student s
inner join studentstests st on st.studentid=s.id 
inner join testsession ts on ts.id=st.testsessionid
where s.statestudentidentifier='7758835813' and schoolyear=2018;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #582581'
where id = 19660743 and studentid=1086771 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 19660743 and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1086771 and studentstestsid = 19660743 and activeflag is true;



select s.id studentid,st.id stid,ts.name,operationaltestwindowid from student s
inner join studentstests st on st.studentid=s.id 
inner join testsession ts on ts.id=st.testsessionid
where s.statestudentidentifier='3341337202' and schoolyear=2018;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #582581'
where id = 19660727 and studentid=1086484 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 19660727 and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1086484 and studentstestsid = 19660727 and activeflag is true;


commit;
