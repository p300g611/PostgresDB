BEGIN;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='DTC')  groupid,
                           2                                             status,
                    77497      userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
				   
UPDATE userassessmentprogram
SET    activeflag = true,
       isdefault =true,
	   modifieddate = now(),
	   modifieduser = 12,
	   userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid =77497 )
where id = 15988;

COMMIT;