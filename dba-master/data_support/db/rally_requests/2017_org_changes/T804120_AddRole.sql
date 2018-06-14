BEGIN;
--keirrariggs@mooreschools.com
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                     100144         userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;
				   
update userassessmentprogram
set activeflag =true,
    isdefault = true,
	modifieddate = now(),
	modifieduser =12,
	userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 100144)
where id = 112990;

--marlashook@mooreschools.com
update aartuser
set   
	   activeflag =true,
	   modifieddate =now(),
	   modifieduser =12
where id =96470;
	
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                     100404         userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;	
	
update userassessmentprogram
set activeflag =true,
    isdefault = true,
	modifieddate = now(),
	modifieduser =12,
	userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 100404)
where id = 113727;


--terrichancellor@mooreschools.com
INSERT INTO  userorganizationsgroups ( groupid, status,userorganizationid,isdefault,createddate,createduser,modifieddate,modifieduser,activeflag) 
              select      (select id from groups where groupcode='TEA')  groupid,
                           2                                             status,
                     100159         userorganizationid,
	                true               isdefault,
                   now()               createddate,
                   12                 createduser,
                   now()              modifieddate,
                   12                 modifieduser, 
                   true               activeflag;	

				   
update userassessmentprogram
set activeflag =true,
    isdefault = true,
	modifieddate = now(),
	modifieduser =12,
	userorganizationsgroupsid =(select id from userorganizationsgroups where userorganizationid = 100159)
where id = 113460;

COMMIT;