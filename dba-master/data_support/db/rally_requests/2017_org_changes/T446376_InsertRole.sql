BEGIN;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA')  groupid,
                       2                    status,
                      79023                 userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                   modifieduser;


update userassessmentprogram
   set activeflag = true,
        isdefault = true,
		userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid = 79023),
        modifieddate = now(),
		modifieduser = 12
	where id = 104577;
	
COMMIT;