BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =165828;


update aartuser
set    username='slawson@ncsd.k12.mo.us',
       email='slawson@ncsd.k12.mo.us',
	   uniquecommonidentifier='slawson@ncsd.k12.mo.us',
	   activeflag =true,
	   modifieddate =now(),
	   modifieduser =12
where id =76311;


 insert into usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 76311             aartuserid,
                   18874               organizationid,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
            (select id from usersorganizations where aartuserid=76311 and organizationid =18874)       userorganizationid,
	                false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       76311                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
                   true                activeflag,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=76311 and organizationid =18874) )    userorganizationsgroupsid;				 
commit; 

