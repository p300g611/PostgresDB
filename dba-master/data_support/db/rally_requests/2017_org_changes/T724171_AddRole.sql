BEGIN;

--shelly.brooks@usd480.net
UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =97811;



INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    2855              userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       2921                                   aartuserid,
               47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
   (select id from userorganizationsgroups where userorganizationid = 2855)    userorganizationsgroupsid;

update 	 userorganizationsgroups
set      activationno = '2921-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 2855;   
		 
--lorena.cisneros@usd480.net		 
INSERT INTO usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 3064             aartuserid,
                   82786               organizationid,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userorganizationsgroups
set    isdefault=false,
       modifieddate =now(),
	   modifieduser =12
where id =47023;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
            (select id from usersorganizations where aartuserid=3064 and organizationid =82786)       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userassessmentprogram
set    isdefault=false,
       modifieddate =now(),
	   modifieduser =12
where id =230242;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       3064                                   aartuserid,
                    47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=3064 and organizationid =82786) )    userorganizationsgroupsid;	
 
 update   userorganizationsgroups
  set      activationno = '3064-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
where userorganizationid = (select id from usersorganizations where aartuserid=3064 and organizationid =82786);


--louisa.garcia@usd480.net

INSERT INTO usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 64850             aartuserid,
                   82785               organizationid,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userorganizationsgroups
set    activeflag=false,
       modifieddate =now(),
	   modifieduser =12
where id =46926;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
            (select id from usersorganizations where aartuserid=64850 and organizationid =82785)       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       64850                                   aartuserid,
                    47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
 (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=64850 and organizationid =82785) )    userorganizationsgroupsid;					   

  update   userorganizationsgroups
  set      activationno = '64850-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
where userorganizationid = (select id from usersorganizations where aartuserid=64850 and organizationid =82785);


--mike.loggins@usd480.net
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    65469              userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       64857                                   aartuserid,
               47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
   (select id from userorganizationsgroups where userorganizationid = 65469)    userorganizationsgroupsid;

update 	 userorganizationsgroups
set      activationno = '64857-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 65469;   
		 
		 
--connie.tennis@usd480.net
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    2844              userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       2910                                   aartuserid,
               47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
   (select id from userorganizationsgroups where userorganizationid = 2844)    userorganizationsgroupsid;	

update 	 userorganizationsgroups
set      activationno = '2910-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 2844; 
		 
--teresa.young@usd480.net		 
 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    4273              userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       4340                                   aartuserid,
               47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
   (select id from userorganizationsgroups where userorganizationid = 4273)    userorganizationsgroupsid;	

update 	 userorganizationsgroups
set      activationno = '4340-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 4273;  


--araceli.rios@usd480.net	
 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    4229              userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       4296                                   aartuserid,
               47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
   (select id from userorganizationsgroups where userorganizationid = 4229)    userorganizationsgroupsid;	

update 	 userorganizationsgroups
set      activationno = '4296-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 4229;

--cathy.segovia@usd480.net		 

 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    65441              userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       64829                                   aartuserid,
               47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
   (select id from userorganizationsgroups where userorganizationid = 65441)    userorganizationsgroupsid;	

update 	 userorganizationsgroups
set      activationno = '64829-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 65441;
		 

--polly.brown@usd480.net
 INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                    2913              userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       2979                                   aartuserid,
               47                 assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
   (select id from userorganizationsgroups where userorganizationid = 2913)    userorganizationsgroupsid;	

update 	 userorganizationsgroups
set      activationno = '2979-'||id,
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
		 where userorganizationid = 2913;

COMMIT;		 