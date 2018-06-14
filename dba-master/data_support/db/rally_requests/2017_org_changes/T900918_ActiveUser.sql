BEGIN;

 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                           73551                                         userorganizationid,
			   true                                                      isdefault,
			   now()                                                     createddate,
			   12                                                        createduser,
			   now()                                                     modifieddate,
			   12                                                        modifieduser, 
			   true                                                      activeflag;
			   
			   
update userassessmentprogram
   set activeflag = true,
       isdefault =true,
	   modifieddate = now(),
	   modifieduser=12,
	   userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid  = 73551)
	   where id =43003;
	   
	   
	   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                           73524                                         userorganizationid,
			   true                                                      isdefault,
			   now()                                                     createddate,
			   12                                                        createduser,
			   now()                                                     modifieddate,
			   12                                                        modifieduser, 
			   true                                                      activeflag;
			   
			   
update userassessmentprogram
   set activeflag = true,
       isdefault =true,
	   modifieddate = now(),
	   modifieduser=12,
	   userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid  = 73524)
	   where id =106215;	   
	   
COMMIT;