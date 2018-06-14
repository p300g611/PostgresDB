DO $BODY$
DECLARE
now_date timestamp with time zone; 
var_userid integer;
var_assessmentid integer;
BEGIN
FOR var_userid IN (select id from aartuser where email in ('pam.blackburn@ku.edu','natmartin@ku.edu','pegiribidi_sta@ku.edu','mikeray@ku.edu','stoney.weaver@ku.edu'))
LOOP
 raise info 'Processing userid:%',var_userid;
 INSERT INTO usersorganizations(aartuserid, organizationid, isdefault, createddate, createduser, modifieddate, modifieduser, activeflag)
 select a.id,50,false,now(),12,now(),12,true from aartuser a 
 where a.id=var_userid and not exists (select 1 from usersorganizations uo where  aartuserid=var_userid and organizationid=50 and activeflag is true );

 raise info 'Noof Noof incremental rows inserted on usersorganizations:%',(select count(*) from usersorganizations where createddate=now());
 INSERT INTO userorganizationsgroups(groupid, status, activationno, activationnoexpirationdate, userorganizationid, isdefault, createddate, 
                                     createduser, modifieddate, modifieduser, activeflag)
 select 
   (select id from groups where groupcode='GSAD') groupid, 2 status, --currval('usergroups_id_seq'::regclass)
    uo.id activationno,( now()+ '2 year')::date activationnoexpirationdate,
   uo.id userorganizationid,false isdefault,now() createddate, 12 createduser,now() modifieddate,12 modifieduser,true activeflag
 from usersorganizations uo 
 where  uo.aartuserid=var_userid and uo.organizationid=50 
    and not exists (select 1 from userorganizationsgroups uog where uog.userorganizationid =uo.id) ;
 raise info 'Noof Noof incremental rows inserted on userorganizationsgroups:%',(select count(*) from userorganizationsgroups where createddate=now());
    FOR var_assessmentid IN (select id from assessmentprogram   where id in (12,3,47,11))
 LOOP  
        INSERT INTO userassessmentprogram(aartuserid, assessmentprogramid, activeflag, isdefault, createddate, 
            createduser, modifieddate, modifieduser, userorganizationsgroupsid)
        select a.id aartuserid,var_assessmentid assessmentprogramid,true activeflag, false isdefault,now() createddate, 
             12 createduser,now() modifieddate,12 modifieduser,uog.id userorganizationsgroupsid 
             from aartuser a
		inner join usersorganizations uo on uo.aartuserid=a.id 
		inner join userorganizationsgroups uog on uog.userorganizationid=uo.id
		inner join groups g on g.id=uog.groupid 
		left outer join userassessmentprogram uap on uap.userorganizationsgroupsid=uog.id and uap.aartuserid=a.id and assessmentprogramid=var_assessmentid
		 where groupcode='GSAD' and a.id=var_userid and uo.organizationid=50 and uap.id is null ;
 END LOOP;
 raise info 'Noof incremental rows inserted on userassessmentprogram:%',(select count(*) from userassessmentprogram where createddate=now());
END LOOP; 			       
END; $BODY$; 


-- select distinct a.email,a.id,uo.organizationid,uap.assessmentprogramid from aartuser a
-- inner join usersorganizations uo on uo.aartuserid=a.id 
-- inner join userorganizationsgroups uog on uog.userorganizationid=uo.id
-- inner join userassessmentprogram uap on uap.userorganizationsgroupsid=uog.id
-- inner join groups g on g.id=uog.groupid 
-- where groupcode='GSAD' order by 3;


