BEGIN;


  
  
  
UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =80898;
  
  
update usersorganizations
set organizationid = 33910,
    modifieddate= now(),
	modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id  = 83401;


INSERT INTO usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 81359             aartuserid,
                   33909               organizationid,
                   false               isdefault,
                   now()               createddate,
(select id from aartuser where email='ats_dba_team@ku.edu')       createduser,
                   now()              modifieddate,
(select id from aartuser where email='ats_dba_team@ku.edu')       modifieduser, 
                   true               activeflag;
				   
				   

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    83401             userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;
				   
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
            (select id from usersorganizations where aartuserid=81359 and organizationid =33909)       userorganizationid,
	                false               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;	
				   
				   
update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =12,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 83401 )
where id = 17089;


INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       81359                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                  createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                  modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=81359 and organizationid =33909) )    userorganizationsgroupsid;
 
 
 
 update 	 userorganizationsgroups
set      activationno = '81359-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
		 where userorganizationid = (select id from usersorganizations where aartuserid=81359 and organizationid =33910);


 update 	 userorganizationsgroups
set      activationno = '81359-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
		 where userorganizationid = (select id from usersorganizations where aartuserid=81359 and organizationid =33909);	


commit;		 