BEGIN;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='DUS'),
                       2                    status,
                       80606                userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                   modifieduser;


update    userassessmentprogram
set activeflag = true,
    isdefault =true,
    userorganizationsgroupsid = (select id from  userorganizationsgroups where  userorganizationid=80606),
    modifieddate = now(),
    modifieduser = 12
    where id = 16650;
	
COMMIT;