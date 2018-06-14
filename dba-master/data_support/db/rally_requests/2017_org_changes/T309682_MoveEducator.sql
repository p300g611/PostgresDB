BEGIN;

update aartuser
set uniquecommonidentifier = 'smillang@aea267.k12.ia.us',
    modifieddate = now(),
	modifieduser =12 
	where id = 72914;

	
update usersorganizations 
  set organizationid =58721,
      modifieddate = now (),
	  modifieduser =12
	where id = 74185;
	
	

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA'),
                       2                    status,
                       74185                userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12 modifieduser;
					   

update 	userassessmentprogram
    set userorganizationsgroupsid =	(select id from userorganizationsgroups where userorganizationid=74185),
        activeflag =true,
        isdefault= true,
        modifieddate = now(),
	    modifieduser =12 
	where id = 2681;		

	
	
COMMIT;