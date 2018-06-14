BEGIN;

update usersorganizations
set organizationid = 46386,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 77789;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='DUS')  groupid,
                           1                                             status,
                 77789                userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;
				   
update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 77789 )
where id = 100677;



update 	 userorganizationsgroups
set      activationno = '76283-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
		 where userorganizationid =77789 ;
		 
COMMIT;
