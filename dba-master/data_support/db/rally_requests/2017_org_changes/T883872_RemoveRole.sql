BEGIN;

 insert into usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select  805             aartuserid,
                   51              organizationid,
                   false               isdefault,
                   now()           createddate,
                   12              createduser,
                   now()           modifieddate,
                   12              modifieduser, 
                   true            activeflag;
				   
update userorganizationsgroups
   set activeflag = false,
       modifieddate = now(),
	   modifieduser = 12
	where id in (49246,49253,15811);
	
	
update userassessmentprogram
  set activeflag = false,
      modifieddate = now(),
	   modifieduser = 12
	where id in (200769,231707,231714);
	
		
	
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='SAAD')  groupid,
                           2                                             status,
               (select id from usersorganizations where aartuserid =805 and organizationid=51)  userorganizationid,
			   false                                      isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   true                                       activeflag;
			   
			   
			   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       805                                   aartuserid,
              (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
               true                                       activeflag,
			   false                                      isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid = (select id from usersorganizations where aartuserid =805 and organizationid=51))   userorganizationsgroupsid;
			   
			   
			   
COMMIT;