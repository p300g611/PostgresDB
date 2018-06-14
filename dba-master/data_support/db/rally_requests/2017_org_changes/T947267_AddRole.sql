BEGIN;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       107370                                   aartuserid,
                           (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
                           true                                          activeflag,
			   false                                          isdefault,
			   now()                                      createddate,
			   12                            createduser,
			   now()                                      modifieddate,
			   12                            modifieduser, 
			  122708                                         userorganizationsgroupsid;
			  
COMMIT;