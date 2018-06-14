BEGIN;

update usersorganizations
set organizationid = 20126,
    modifieddate= now(),
	modifieduser =174744
where id  = 94660;


INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           1                                             status,
                   94660      userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   174744                 createduser,
                   now()              modifieddate,
                   174744                 modifieduser, 
                   true               activeflag;
				   
				   

update 	 userorganizationsgroups
set      activationno = '91245-'||id,
         activationnoexpirationdate = now()+interval'30 days',
         status=2,
		 modifieddate = now(),
		 modifieduser =174744
 where userorganizationid = 94660;	

update 	 userassessmentprogram
set      userorganizationsgroupsid=(select id from userorganizationsgroups where userorganizationid=94660 order by id desc limit 1 ),
         activeflag=true,
         isdefault=true,
		 modifieddate = now(),
		 modifieduser =174744
 where aartuserid =91245;

COMMIT;

select * from aartuser where email ilike '%jglass@howardparkcenter.org%';
select * from usersorganizations where aartuserid =91245;
select * from organizationtreedetail  where schoolid  =20126;
select * from userorganizationsgroups where userorganizationid =94660;
select * from userassessmentprogram  where aartuserid =91245;