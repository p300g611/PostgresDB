BEGIN;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='PRN')  groupid,
                           1                                             status,
                    122611        userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;
				   
				   
update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 122611)
where id = 104726;	



update 	 userorganizationsgroups
set      activationno = '115496-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
		 where userorganizationid =122611 ;
		 
COMMIT;
				   
				   