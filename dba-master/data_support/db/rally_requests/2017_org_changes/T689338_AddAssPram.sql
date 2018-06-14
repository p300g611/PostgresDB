BEGIN;

      INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
      select       30116                                  aartuserid,
                   (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                   true                                          activeflag,
	   true                                          isdefault,
	   now()                                         createddate,
	   12                                            createduser,
	   now()                                         modifieddate,
	   12                                            modifieduser, 
	   9290                                         userorganizationsgroupsid;
	   
COMMIT;
