BEGIN;


update aartuser
set    
	   uniquecommonidentifier='grassod@hhsd.k12.nj.us',
	   modifieddate =now(),
	   modifieduser =12
where id =78780;

update usersorganizations
set organizationid = 55094,
    modifieddate= now(),
	modifieduser =12
where id  = 80481;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1              status,
                     80481   userorganizationid,
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
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 80481)
where id = 101877;	


update 	 userorganizationsgroups
set      status =1,
         activationno = '78780-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
 where userorganizationid = 80481;  

COMMIT; 