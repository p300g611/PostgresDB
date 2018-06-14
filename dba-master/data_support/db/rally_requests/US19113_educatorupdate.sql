BEGIN;

-- select * from aartuser where id=15322;
-- select * from usersorganizations  where aartuserid=15322;

insert into userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='PRN'),
                       2                    status,
                       15255                userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12 modifieduser;
INSERT INTO userassessmentprogram(
             aartuserid, assessmentprogramid, activeflag, isdefault, createddate, 
            createduser, modifieddate, modifieduser, userorganizationsgroupsid)
  select  15322 aartuserid,12 assessmentprogramid, true activeflag, true isdefault,now() createddate, 
            12 createduser,now() modifieddate,12 modifieduser, (select id from userorganizationsgroups where userorganizationid=15255) userorganizationsgroupsid;


update aartuser 
set activeflag= true,
    email='dcarlson@usd253.org',
  modifieddate=now()
where id=15322;

-- select * from  userassessmentprogram where  aartuserid= 15322;  
-- select * from    userorganizationsgroups where  userorganizationid=15255;
-- select * from aartuser where id=15322;



COMMIT; 
