BEGIN;

update aartuser
set    
	   uniquecommonidentifier='cromine@whitnall.com',
	   modifieddate =now(),
	   modifieduser =12
where id =106519;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                     1                     status,
                   112328                 userorganizationid,
	                true                   isdefault,
                   now()                  createddate,
                   12                     createduser,
                   now()                  modifieddate,
                   12                     modifieduser, 
                   true                   activeflag;
				   

update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =12,
	   userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 112328 )
where id = 105743;	

update 	 userorganizationsgroups
set      activationno = '106519-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
 where userorganizationid =112328 ;			   
 
COMMIT;


