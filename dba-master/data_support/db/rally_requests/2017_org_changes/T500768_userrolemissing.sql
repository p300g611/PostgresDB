INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser) 
      select (select id from groups where groupcode='TEA'),
                       2                    status,
                       49916                userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12 modifieduser;       
        
INSERT INTO userassessmentprogram(
             aartuserid, assessmentprogramid, activeflag, isdefault, createddate, 
            createduser, modifieddate, modifieduser, userorganizationsgroupsid)
  select  50020 aartuserid,3 assessmentprogramid, true activeflag, true isdefault,now() createddate, 
            12 createduser,now() modifieddate,12 modifieduser, (select id from userorganizationsgroups where userorganizationid=49916) userorganizationsgroupsid;