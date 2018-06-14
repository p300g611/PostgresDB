
BEGIN;
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                2                                             status,
               91131                                      userorganizationid,
			   true                                       isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   true                                       activeflag;
			   
			   
update userassessmentprogram
 set   activeflag =true,
	   isdefault =true,
	   modifieddate =now(),
	   modifieduser =12,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid =91131 )
where id = 106602;	   
	   
COMMIT;