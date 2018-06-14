BEGIN;


update usersorganizations
  set organizationid = 67911,
      modifieddate = now(),
	  modifieduser =12
	where id = 107322;
	
	
 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                           107322                                        userorganizationid,
			   true                                                      isdefault,
			   now()                                                     createddate,
			   12                                                        createduser,
			   now()                                                     modifieddate,
			   12                                                        modifieduser, 
			   true                                                      activeflag;
			   
			   
update 	userassessmentprogram
    set  activeflag = true,
         isdefault = true,
		 userorganizationsgroupsid = (select id from  userorganizationsgroups  where userorganizationid = 107322),
       	 modifieddate = now(),
	     modifieduser =12
	where id = 19230;	 
	

	
COMMIT;