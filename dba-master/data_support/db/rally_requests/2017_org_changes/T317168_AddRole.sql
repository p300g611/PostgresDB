BEGIN;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                    190386           userorganizationid,
	                false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
				   
update userassessmentprogram
set    modifieddate =now(),
       modifieduser =12,
	   activeflag = true,
        isdefault =false,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where groupid = 9681 and userorganizationid = 190386)
where id = 403362;




COMMIT;