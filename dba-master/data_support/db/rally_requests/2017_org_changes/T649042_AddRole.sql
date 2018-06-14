BEGIN;

update usersorganizations
set organizationid = 187,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 52451;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='DUS')  groupid,
                           1                                             status,
                   52451       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;
				   
				   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       52559                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =52451 )    userorganizationsgroupsid;	

 
 update 	 userorganizationsgroups
set      activationno = '52559-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
		 where userorganizationid =52451 ;
COMMIT;
 