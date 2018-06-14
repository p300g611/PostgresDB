
BEGIN;

--EducatorID:3682819193

UPDATE aartuser 
  set email = 'nsmith@vikingnet.net',
	  username ='nsmith@vikingnet.net',
	  activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where uniquecommonidentifier ='3682819193';
	
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA'),
                       2                    status,
                       119861               userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                   modifieduser;

update userassessmentprogram
  set activeflag = true,
      isdefault = true,
      userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid= 119861),
      modifieddate = now(),
      modifieduser =12
  where id =63981;

  
update usersorganizations
  set organizationid = 2018,
      modifieddate = now(),
      modifieduser =12
	  where id = 119861;
	 
  

--EducatorID:5866352788
UPDATE aartuser 
   set  email = 'sclay@vikingnet.net',
	   username ='sclay@vikingnet.net',
	   activeflag = true,
	   modifieddate = now(),
	   modifieduser =12
	where uniquecommonidentifier ='5866352788';
	
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA'),
                       2                    status,
                       114192               userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                   modifieduser;

update userassessmentprogram
  set activeflag = true,
      isdefault = true,
      userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid= 114192),
      modifieddate = now(),
      modifieduser =12
  where id =54682;
  
  
 update usersorganizations
  set organizationid = 2018,
      modifieddate = now(),
      modifieduser =12
	  where id = 114192;
  
  
--EducatorID: 2549824458

UPDATE aartuser 
   set email = 'kmartinez@vikingnet.net',
	  username ='kmartinez@vikingnet.net',
	  modifieddate = now(),
	  modifieduser =12
	where id = 116026;
	
update usersorganizations
  set organizationid = 2018,
      modifieddate = now(),
      modifieduser =12
   where id = 123272;
	  
insert into usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
  select 116026 aartuserid,
         2019   organizationid,
		 false   isdefault,
		 now()  createddate ,
		 12     createduser,
         now()  modifieddate,
         12     modifieduser,
         true   activeflag;
		 
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA'),
                       2                    status,
        (select id from usersorganizations where aartuserid= 116026 and organizationid=2019) userorganizationid,
                       false                isdefault,
                       12                   createduser,
                       12                   modifieduser;
					   
update userorganizationsgroups
 set status =2,
     activationno= null,
	 activationnoexpirationdate =null,
	 modifieddate = now(),
	 modifieduser =12 
	 where id = 136786;					   


COMMIT;		 