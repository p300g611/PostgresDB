BEGIN;

update aartuser
set    
	   uniquecommonidentifier='9923197913',
	   activeflag =true,
	   modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
where id =1469;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    1408                                     userorganizationid,
	                true                                     isdefault,
                   now()                                     createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                  createduser,
                   now()                                     modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                  modifieduser, 
                   true                                        activeflag;
				   
				   
update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 1408 )
where id = 63587;					   



update 	 userorganizationsgroups
set      activationno = '1469-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
 where userorganizationid =1408 ;
 
 COMMIT;