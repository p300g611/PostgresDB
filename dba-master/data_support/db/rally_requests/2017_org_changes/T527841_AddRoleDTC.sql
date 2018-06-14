BEGIN;

INSERT INTO usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 107862             aartuserid,
                   45930               organizationid,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='DTC')  groupid,
                           2                                             status,
            (select id from usersorganizations where aartuserid=107862 and organizationid =45930)       userorganizationid,
	                false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       107862                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=107862 and organizationid =45930) )    userorganizationsgroupsid;


COMMIT;			   