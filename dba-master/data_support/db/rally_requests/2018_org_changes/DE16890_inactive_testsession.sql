select st.id stid,ts.id tsid,t.testname,ts.name,t.id,tl.externalid tlid,tss.id tssid FROM studentstests st
INNER JOIN enrollment en ON en.id = st.enrollmentid
INNER JOIN test t on t.id =st.testid
INNER JOIN student stu ON stu.id = en.studentid
INNER JOIN testsession ts ON ts.id = st.testsessionid
inner join testsection as tss ON (t.id = tss.testid)
inner JOIN testsectionstaskvariants AS tstv ON (tss.id = tstv.testsectionid)
JOIN testlet as tl ON (tstv.testletid = tl.id)
where stu.id=912159 and en.currentschoolyear=2018 
and tss.id in (57877,57879)
order by t.externalid;

select st.id stid,ts.id tsid,t.testname,ts.name,t.id,tl.externalid tlid,tss.id tssid FROM studentstests st
INNER JOIN enrollment en ON en.id = st.enrollmentid
INNER JOIN test t on t.id =st.testid
INNER JOIN student stu ON stu.id = en.studentid
INNER JOIN testsession ts ON ts.id = st.testsessionid
inner join testsection as tss ON (t.id = tss.testid)
inner JOIN testsectionstaskvariants AS tstv ON (tss.id = tstv.testsectionid)
JOIN testlet as tl ON (tstv.testletid = tl.id)
where stu.id=912159 and en.currentschoolyear=2018 
-- and tl.externalid in (6829,7148)
order by tl.externalid ;

begin;
update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #DE16890'
where id in (18665309,18677712) and studentid=912159 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (18665309,18677712) and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 912159 and studentstestsid in (18665309,18677712) and activeflag is true;
                 
UPDATE testsession
 SET activeflag = false, 
     modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
     modifieddate = now()
     WHERE id IN (5574150,5567964) and activeflag is true;

update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 912159 and testsessionid in (5574150,5567964);
     
commit;


