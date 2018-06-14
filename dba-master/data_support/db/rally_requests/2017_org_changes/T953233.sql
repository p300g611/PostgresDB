

begin;
update usersorganizations 
set organizationid=38427,modifieddate=now(),modifieduser=12
where aartuserid =97352;

INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='DTC')  groupid,
                           2                                             status,
            (select id from usersorganizations where aartuserid=97352 and organizationid =38427)       userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;

INSERT INTO  userassessmentprogram (aartuserid,assessmentprogramid,activeflag,isdefault,createddate,createduser,modifieddate,modifieduser,userorganizationsgroupsid) 
              select       97352                                   aartuserid,
               (select id from assessmentprogram where abbreviatedname ='DLM') assessmentprogramid,
                   true                activeflag,
                   true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
			   (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=97352 and organizationid =38427) )    userorganizationsgroupsid;



update userorganizationsgroups 
set activationno='38427'||'-'|| (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=97352 and organizationid =38427))
,activationnoexpirationdate=now()+ interval '30 day'
where id= (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=97352 and organizationid =38427));

COMMIT;	

select * from usersorganizations  where aartuserid =97352; 
select * from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=97352 and organizationid =38427); 
select * from userassessmentprogram  where aartuserid =97352; 



