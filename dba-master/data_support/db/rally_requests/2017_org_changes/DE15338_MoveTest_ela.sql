BEGIN;

update studentstests 
set    enrollmentid = 2886276,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where enrollmentid =2649346 and status=86 and activeflag is true and studentid= 1350338;


		
		
update testsession 
set    rosterid =1095766,
       attendanceschoolid=18765, 
        modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where id in(3988818,3988819,3988863,3988823,3988816) ;



		
update testsession 
set    rosterid =1095767,
       attendanceschoolid=18765, 
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where id in (3988925,3988918,3988920,3988921,3988927,3988923);	


		
update ititestsessionhistory
set    rosterid=1095766,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu') 
where studentid =1350338 and rosterid=1072072;