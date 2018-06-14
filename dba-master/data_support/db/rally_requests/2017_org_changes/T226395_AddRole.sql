BEGIN;
update aartuser
set    uniquecommonidentifier='smiller@usd252.org',
       activeflag = true,
       modifieddate =now()
where id =58650;
	   


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                    58537       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;


INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       58650                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid =58537 and groupid =9681)    userorganizationsgroupsid;					   

		   
 COMMIT;			   