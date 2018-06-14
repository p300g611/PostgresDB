--update district name
begin;

update organization 
set    displayidentifier='NH100',
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email = 'ats_dba_team@ku.edu')
	   where id =58579;
	   
	   
	   
	   
update organization 
set    displayidentifier='NH101',
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email = 'ats_dba_team@ku.edu')
	   where id =58635;
	   
	   
update organization 
set    displayidentifier='NH102',
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email = 'ats_dba_team@ku.edu')
	   where id =58641;
	   
	   
update organization 
set    displayidentifier='NH103',
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email = 'ats_dba_team@ku.edu')
	   where id =58591;
	   
COMMIT;