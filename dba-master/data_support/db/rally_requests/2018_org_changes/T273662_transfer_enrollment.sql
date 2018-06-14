--transfer enrollmentid in the studentstests. studentid:563628. testssionid_old=5820760
begin;

update studentstests 
set    enrollmentid =3403947,
       testsessionid=5820756.
        modifieddate=now(),
		modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu'),
		manualupdatereason='for ticket#273662'
		where id = 20443618;
		
		
commit;