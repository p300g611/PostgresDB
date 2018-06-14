BEGIN;

 insert into usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 106711             aartuserid,
                   36588               organizationid,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='DTC')  groupid,
                           2                                             status,
                (select id from usersorganizations where aartuserid=106711 and organizationid = 36588)  userorganizationid,
			   true                   isdefault,
			    now()                 createddate,
                12                    createduser,
                now()                 modifieddate,
                   12                 modifieduser, 
                true                  activeflag;
				
update userassessmentprogram
set activeflag=true,
    isdefault =true,
	modifieddate =now(),
	modifieduser = 12,
	userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=106711 and organizationid = 36588))
	where id = 110798;
	
commit;