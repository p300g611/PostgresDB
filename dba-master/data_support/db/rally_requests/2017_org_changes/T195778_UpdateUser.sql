BEGIN;

update aartuser
set    username='jmainz@usd234.org',
       email='jmainz@usd234.org',
	   uniquecommonidentifier='6317864845',
	   activeflag =true,
	   modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =33051;


update usersorganizations
set activeflag =false,
    isdefault=false,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 32984;

update usersorganizations
set isdefault=true,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 143916;


update userorganizationsgroups
set activeflag =false,
    isdefault=false,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 12225;   


update 	 userorganizationsgroups
set      status=1,
         activationno = '33051-171658',
         activationnoexpirationdate = now()+interval'30 days',
		 isdefault=true,
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
 where id =171658;
 
update userassessmentprogram
set activeflag =false,
    isdefault=false,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 197024;



update userassessmentprogram
set isdefault=true,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 320156;


COMMIT;

