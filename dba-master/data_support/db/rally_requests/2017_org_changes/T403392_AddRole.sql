BEGIN;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='SAAD')  groupid,
                   2                  status,
                   68368              userorganizationid,
	               true               isdefault,
                   now()              createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userassessmentprogram
set activeflag =true,
    isdefault = true,
	modifieddate = now(),
	modifieduser =12,
	userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 68368)
where id = 1691;

COMMIT;