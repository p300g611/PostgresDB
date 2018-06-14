BEGIN;

update aartuser
set  
	   uniquecommonidentifier='65216483',
	   modifieddate =now(),
	   modifieduser =174744
where id =69966;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    71085    userorganizationid,
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
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 71085 )
where id = 101511;	



update 	 userorganizationsgroups
set      activationno = '69966-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =174744
		 where userorganizationid =71085;	


COMMIT;		 