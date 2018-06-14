BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =165434;



update aartuser
set    username='hemphilld@lawsoncardinals.org',
       email='hemphilld@lawsoncardinals.org',
	   uniquecommonidentifier='hemphilld@lawsoncardinals.org',
	   modifieddate =now(),
	   modifieduser =12
where id =55345;



INSERT INTO usersorganizations(aartuserid,organizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag)
            select 55345             aartuserid,
                   19024             organizationid,
                   false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   

		  
				   
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
            (select id from usersorganizations where aartuserid=55345 and organizationid =19024)       userorganizationid,
	                false               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userassessmentprogram
set 	   modifieddate =now(),
	         modifieduser =12,
			userorganizationsgroupsid = (select id from userorganizationsgroups where userorganizationid =(select id from usersorganizations where aartuserid=55345 and organizationid =19024) ) 
where id =215414;


update roster 
set   teacherid = 55345,
      modifieddate = now(),
	  modifieduser= 12
where teacherid =165434;

COMMIT;
			   