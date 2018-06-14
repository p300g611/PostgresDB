BEGIN;

update usersorganizations
set  organizationid = 2879,
     modifieddate = now(),
	 modifieduser =12
where id = 64873;



INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
             64873                                         userorganizationid,
			   true                                        isdefault,
			   now()                                       createddate,
			   12                                          createduser,
			   now()                                       modifieddate,
			   12                                          modifieduser, 
			   true                                        activeflag;
			   
			   
update userassessmentprogram
   SET activeflag = true,
       isdefault = true,
	   modifieddate = now(),
	   modifieduser =12,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 64873)
  where id = 1760;
  
COMMIT;