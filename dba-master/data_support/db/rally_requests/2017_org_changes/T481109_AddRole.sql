BEGIN;

update aartuser
set    
	   uniquecommonidentifier='epaulson@pcsedu.org',
	   modifieddate =now(),
	   modifieduser =12
where id =101945;


update usersorganizations
set organizationid = 48381,
    modifieddate= now(),
	modifieduser =12
where id  = 107109;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                   107109             userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =12,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 107109 )
where id = 481;	

update 	 userorganizationsgroups
set      activationno = '101945-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
 where userorganizationid = 107109;
 
 COMMIT;
		 				   

