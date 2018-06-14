BEGIN;

             INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       58793                                   aartuserid,
                           (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                           true                           activeflag,
			   false                                      isdefault,
			   now()                                      createddate,
			   12                                         createduser,
			   now()                                      modifieddate,
			   12                                         modifieduser, 
			   36634                                      userorganizationsgroupsid;
			   
COMMIT;
