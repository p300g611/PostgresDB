BEGIN;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA')  groupid,
                       2                    status,
                       76349                userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                   modifieduser;
					   
update userassessmentprogram
   set activeflag =true,
       isdefault = true,
	   userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid = 76349),
	   modifieduser =12,
	   modifieddate = now()
	where id = 106320 and activeflag is false;

COMMIT;