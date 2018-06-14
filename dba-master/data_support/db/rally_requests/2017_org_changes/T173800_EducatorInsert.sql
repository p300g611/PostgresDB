BEGIN;

select * from aartuser where id = 15210;
select * from usersorganizations where aartuserid = 15210; 

update aartuser
set email = 'mvest@indyschools.com',
    modifieddate = now(),
	modifieduser =12 
	where id = 15210;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA'),
                       2                    status,
                       15143                userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12 modifieduser;
					   
					   
INSERT INTO userassessmentprogram(
             aartuserid, assessmentprogramid, activeflag, isdefault, createddate, 
            createduser, modifieddate, modifieduser, userorganizationsgroupsid)
  select  15210 aartuserid,12 assessmentprogramid, true activeflag, true isdefault,now() createddate, 
            12 createduser,now() modifieddate,12 modifieduser, (select id from userorganizationsgroups where userorganizationid=15143) userorganizationsgroupsid;
select * from  userassessmentprogram where  aartuserid= 15210;  
select * from    userorganizationsgroups where  userorganizationid=15143;


COMMIT;
