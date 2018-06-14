BEGIN;

update aartuser
set    username='mendenhalll@usd266.org',
       email='mendenhalll@usd266.org',
	   modifieddate =now(),
	   modifieduser =174744
where id =64867;



update usersorganizations
set organizationid = 2853,
    modifieddate= now(),
	modifieduser =174744
where id  = 65479;



INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                   65479     userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   174744                 createduser,
                   now()              modifieddate,
                   174744                 modifieduser, 
                   true               activeflag;
				   
				   
update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =174744,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 65479 )
where id = 61416;	


update 	 userorganizationsgroups
set      activationno = '64867-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =174744
		 where userorganizationid =65479 ;			   
		 
		 
COMMIT;