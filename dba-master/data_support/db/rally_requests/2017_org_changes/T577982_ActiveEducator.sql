BEGIN;

--EducatorID:6277918761
update aartuser 
  set username ='chelsea.hammons@usd262.net',
      email= 'chelsea.hammons@usd262.net',
	  uniquecommonidentifier ='6277918761', 
	  surname ='Hammons',
	  displayname ='Chelsea Hammons',
	  activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where id = 108809;
	
update usersorganizations
  set organizationid = 1473,
      activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where id = 114896;
	
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
               2                                             status,
               114896                                        userorganizationid,
			   true                                          isdefault,
			   now()                                         createddate,
			   12                                            createduser,
			   now()                                         modifieddate,
			   12                                            modifieduser, 
			   true                                          activeflag;

update userassessmentprogram
  set isdefault = true,
      activeflag = true,
	  modifieddate = now(),
	  modifieduser =12,
	  userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid = 114896)
	where id = 52285;
	
	
--educatorID:4464762786
update aartuser 
  set username ='jessie.pohlman@usd262.net',
      email= 'jessie.pohlman@usd262.net',
	  uniquecommonidentifier ='4464762786', 
	  activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where id = 18003;
	
update usersorganizations
  set organizationid = 1473,
      activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where id = 17936;
	
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
               2                                             status,
               17936                                        userorganizationid,
			   true                                          isdefault,
			   now()                                         createddate,
			   12                                            createduser,
			   now()                                         modifieddate,
			   12                                            modifieduser, 
			   true                                          activeflag;	

update userassessmentprogram
  set isdefault = true,
      activeflag = true,
	  modifieddate = now(),
	  modifieduser =12,
	  userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid = 17936)
	where id = 50609;
	
--educatorID:3969413281
update aartuser 
  set 
	  uniquecommonidentifier ='3969413281', 
	  modifieddate = now(),
	  modifieduser =12
	where id = 162751;
	
--educatorID:1483534472
update aartuser 
  set username ='perry.warden@usd262.net',
      email= 'perry.warden@usd262.net',
	  uniquecommonidentifier ='1483534472', 
	  activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where id = 3350;
	
update usersorganizations
  set organizationid = 1473,
      activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where id = 3284;	
	
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
               2                                             status,
               3284                                        userorganizationid,
			   true                                          isdefault,
			   now()                                         createddate,
			   12                                            createduser,
			   now()                                         modifieddate,
			   12                                            modifieduser, 
			   true                                          activeflag;
			   
			   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       3350                                   aartuserid,
                           (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                           true                               activeflag,
			   true                                          isdefault,
			   now()                                      createddate,
			   12                                        createduser,
			   now()                                      modifieddate,
			   12                                       modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid = 3284)       userorganizationsgroupsid;
			   
			   
--educatorID:3989882236  
update aartuser 
  set username ='david.corns@usd262.net',
      email= 'david.corns@usd262.net',
	  uniquecommonidentifier ='3989882236', 
	  activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where id = 13307;
	
update usersorganizations
  set organizationid = 1474,
      activeflag = true,
	  modifieddate = now(),
	  modifieduser =12
	where id = 13240;
	
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
               2                                             status,
               13240                                        userorganizationid,
			   true                                          isdefault,
			   now()                                         createddate,
			   12                                            createduser,
			   now()                                         modifieddate,
			   12                                            modifieduser, 
			   true                                          activeflag;
			   
			   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       13307                                   aartuserid,
                           (select id from assessmentprogram where abbreviatedname ='KAP') assessmentprogramid,
                           true                               activeflag,
			   true                                          isdefault,
			   now()                                      createddate,
			   12                                        createduser,
			   now()                                      modifieddate,
			   12                                       modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid = 13240)       userorganizationsgroupsid;
			   
COMMIT;