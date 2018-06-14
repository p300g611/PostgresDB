BEGIN;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select   (select id from groups where groupcode='SSAD')     groupid,
                           2                                             status,
                     70043           userorganizationid,
	                false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       69008                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid = 70043 and groupid =55)    userorganizationsgroupsid;	
			   


COMMIT;