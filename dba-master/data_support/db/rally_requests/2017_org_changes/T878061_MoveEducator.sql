BEGIN;

update usersorganizations
  set  organizationid = 47173,
       modifieddate = now(),
	   modifieduser =12
	where id = 108131;
	
	
	
 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                              status,
               108131                                     userorganizationid,
			   true                                       isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   true                                       activeflag;
			   
			   
update userassessmentprogram
   set activeflag = true,
       isdefault = true,
	   modifieddate = now(),
	   modifieduser=12,
	   userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid =108131)
	where id = 19330;
	
	
COMMIT;
