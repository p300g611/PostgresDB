BEGIN;
-- select * from aartuser where email ='djoyce@whitnall.com';
-- select * from usersorganizations where aartuserid =82380;
-- select * from userorganizationsgroups where userorganizationid =84593;
-- select * from userassessmentprogram where aartuserid =82380;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                    2               status,
                    84593      userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userassessmentprogram
set    assessmentprogramid=3,
       activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =12,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 84593 )
where aartuserid =82380;				



update 	 userorganizationsgroups
set      activationno = '120495-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 84593;   
COMMIT;