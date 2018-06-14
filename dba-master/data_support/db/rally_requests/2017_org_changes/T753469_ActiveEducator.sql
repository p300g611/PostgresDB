BEGIN;
update aartuser
 set email = 'jessica.garrett@usd258.net',
     username ='jessica.garrett@usd258.net',
     activeflag = true,
     modifieddate = now(),
	 modifieduser =12
  where id =122205 and activeflag is false;


 
select * from  userassessmentprogram where  aartuserid= 122205;  
select * from  userorganizationsgroups where  userorganizationid=131361;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createduser,modifieduser)	
      select (select id from groups where groupcode='TEA'),
                       2                    status,
                       131361               userorganizationid,
                       true                 isdefault,
                       12                   createduser,
                       12                   modifieduser;
					   
update userassessmentprogram
   set 	activeflag = true,
        isdefault = true,
        userorganizationsgroupsid=(select id from userorganizationsgroups where userorganizationid=131361),
        modifieddate =now(),
        modifieduser = 12
  where id = 73874 and activeflag is false;		

						
select * from  userassessmentprogram where  aartuserid= 122205;  
select * from    userorganizationsgroups where  userorganizationid=131361;

COMMIT;
