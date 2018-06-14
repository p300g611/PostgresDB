
BEGIN;

UPDATE aartuser
  set uniquecommonidentifier = '157534',
      modifieddate = now(),
	  modifieduser = 12  
	  where id = 70823;
	  
	  
update usersorganizations
  set organizationid = 32941,
      modifieddate = now(),
	  modifieduser = 12
	  where id = 71968;
	  
	  
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA'),
                       2                    status,
                       71968               userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                   modifieduser;	

update userassessmentprogram
  set activeflag = true,
      isdefault = true,
      userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid= 71968),
      modifieddate = now(),
      modifieduser =12
  where id =13794;				   
	  
	  
	  
COMMIT;

