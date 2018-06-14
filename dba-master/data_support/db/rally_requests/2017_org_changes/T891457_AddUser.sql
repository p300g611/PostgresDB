BEGIN;

UPDATE aartuser 
  set email ='mrunnion@usd325.com',
      username ='mrunnion@usd325.com',
	  modifieddate =now(),
	  modifieduser =12
	where id = 10812;
	
	
UPDATE usersorganizations
   set organizationid = 5823,
       modifieddate = now(),
	   modifieduser =12
	where id = 10745;
	
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       10812                                  aartuserid,
                           (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
               true                                           activeflag,
			   false                                          isdefault,
			   now()                                          createddate,
			   12                                             createduser,
			   now()                                          modifieddate,
			   12                                             modifieduser, 
			   35957                                          userorganizationsgroupsid;
			   
COMMIT;
