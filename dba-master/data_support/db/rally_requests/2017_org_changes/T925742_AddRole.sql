BEGIN;

--username:mjacobs@hscatholic.org 
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                   41057       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;
				   
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='PRO')  groupid,
                           1                                             status,
                   41057       userorganizationid,
	                false               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       41142                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =41057 and groupid =9681 )    userorganizationsgroupsid;				   
 
 
 
 INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       41142                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =41057 and groupid =9570 )    userorganizationsgroupsid;
 
  update 	 userorganizationsgroups
set      activationno = '41142-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
		 where userorganizationid =41057 ;
		 
 --username:tfollis@hscatholic.org
 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                   41052       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;
				   
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='PRO')  groupid,
                           1                                             status,
                   41052       userorganizationid,
	                false               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       41137                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =41052 and groupid =9681 )    userorganizationsgroupsid;				   
 
 
 
 INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       41137                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 createduser,
                   now()              modifieddate,
                   (select id from aartuser where email='ats_dba_team@ku.edu')                 modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =41052 and groupid =9570 )    userorganizationsgroupsid;
 
  update 	 userorganizationsgroups
set      activationno = '41137-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu')
		 where userorganizationid =41052 ;	

COMMIT;
		 