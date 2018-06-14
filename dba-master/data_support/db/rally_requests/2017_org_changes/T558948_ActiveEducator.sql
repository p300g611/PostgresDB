BEGIN;

select * from  userassessmentprogram where  aartuserid= 60851;  
select * from    userorganizationsgroups where  userorganizationid=60765;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA'),
                       2                    status,
                       60765                userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                   modifieduser;
					   
					   
INSERT INTO userassessmentprogram(
             aartuserid, assessmentprogramid, activeflag, isdefault, createddate, 
            createduser, modifieddate, modifieduser, userorganizationsgroupsid)
  select  60851 aartuserid,12 assessmentprogramid, true activeflag, true isdefault,now() createddate, 
            12 createduser,now() modifieddate,12 modifieduser, (select id from userorganizationsgroups where userorganizationid=60765) userorganizationsgroupsid;
			
			
select * from  userassessmentprogram where  aartuserid= 60851;  
select * from    userorganizationsgroups where  userorganizationid=60765;


COMMIT;
