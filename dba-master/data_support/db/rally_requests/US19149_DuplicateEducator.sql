
BEGIN;  
  
  
  UPDATE aartuser
       set activeflag = true, email= 'cseyfert@usd273.org',
     	   modifieddate = now(), modifieduser = 12	   
	   where id = 19552 and activeflag is false;
	       
  INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='PRN'),
                       2                    status,
                       19485                userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                  modifieduser;
  
  INSERT INTO userassessmentprogram (aartuserid,assessmentprogramid,activeflag, isdefault,createddate,createduser,
               modifieddate,modifieduser,userorganizationsgroupsid)
	    select 19552 aartuserid,12 assessmentprogramid, true activeflag, true isdefault, now() createddate,
		      12 createduser, now() modifieddate, 12 modifieduser, (select id from userorganizationsgroups where userorganizationid=19485) userorganizationsgroupsid;
  
  
COMMIT;


