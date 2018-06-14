--merge student
--18133223     ----correct
--1349228876 - Incorrect 
--ticket #719250
begin;

update student 
set  statestudentidentifier='18133223',    --'1349228876'
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id =1473881;

	 
	 update student 
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id =1466527;


update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #719250'
	 where id =3414309;
	 
	 
	 update enrollment
set  activeflag =true,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #719250'
	 where id =3412117;

commit;