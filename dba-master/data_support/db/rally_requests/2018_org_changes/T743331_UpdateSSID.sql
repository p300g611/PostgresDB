begin;
update student
set    statestudentidentifier ='9106151213',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
	   where id =1420892;
	   
update student
set    statestudentidentifier ='3367213829',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
	   where id =1420466;	   

	   
	   update student
set    statestudentidentifier ='7591376985',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
	   where id =1429584;	   
	   
	   update student
set    statestudentidentifier ='7823567997',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
	   where id =1420530;	

commit;	   