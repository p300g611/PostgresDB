--Inactivate the user groups and user asseessment groups
drop table if exists retired_roles;
select distinct au.id as aartid, au.firstname as firstname, au.surname as lastname, au.email as email, au.uniquecommonidentifier educatorid, au.activeflag as useractive, o.organizationname as orgname,
 o.activeflag as orgactive, ot.typename as orglevel, uo.activeflag as userorgactive, g.id as g_id, g.groupname as role, uog.activeflag as roleactive, abbreviatedname as ap, au.internaluserindicator as internal, uog.activeflag as uogactive, uog.status as uogstatus, ua.activeflag as uaactive,
case when ot.id is null then null
when ot.id = 2 then o.displayidentifier
else (select displayidentifier from organization_parent(uo.organizationid) where organizationtypeid = 2) end as state,
case when (ot.id is null or ot.id < 5) then null
when ot.id = 5 then o.organizationname
else (select organizationname from organization_parent(uo.organizationid) where organizationtypeid = 5) end as district
,ua.id userassessmentprogramid,uog.id userorganizationsgroupsid
into temp table retired_roles
from aartuser au
left join usersorganizations uo on au.id = uo.aartuserid
left join userorganizationsgroups uog on uo.id = uog.userorganizationid
left join userassessmentprogram ua on ua.aartuserid = au.id and ua.userorganizationsgroupsid = uog.id
left join assessmentprogram ap on ua.assessmentprogramid = ap.id
left join groups g on uog.groupid = g.id
left join organization o on uo.organizationid = o.id
left join organizationtype ot on o.organizationtypeid = ot.id
where g.id in (9682, 9699, 9710, 9717, 9718, 9716, 9715, 9714, 9711,9686)
-- and uog.status != 3
-- and ua.activeflag is true
-- and uo.activeflag is true
-- and au.activeflag is true
;

select count(distinct aartid from retired_roles where state='KS' and roleactive is true
select * from retired_roles where state='KS' and roleactive is true and ap='DLM' and uogactive is true;
select count(*) from userorganizationsgroups 
where id in (select distinct userorganizationsgroupsid from retired_roles where state='KS' and roleactive is true)
and activeflag is true;


select count(*) from userassessmentprogram 
where id in (select distinct userassessmentprogramid from retired_roles where state='KS' and roleactive is true)
and activeflag is true;

begin;
update userorganizationsgroups
set    modifieddate =now(),
       modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
       activeflag =false 
where id in (select distinct userorganizationsgroupsid from retired_roles where state='KS' and roleactive is true)
and activeflag is true;    

update userassessmentprogram
set    modifieddate =now(),
       modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
       activeflag =false 
where id in (select distinct userassessmentprogramid from retired_roles where state='KS' and roleactive is true)
and activeflag is true;   

commit;