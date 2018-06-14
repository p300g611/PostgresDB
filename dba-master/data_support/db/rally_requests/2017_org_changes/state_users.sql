
--Request1: roles
--note golbal level do not have any assessment
select aa.email,groupname,organizationname,array_agg(asm.abbreviatedname)
from aartuser aa
INNER join usersorganizations ug on aa.id = ug.aartuserid and aa.activeflag and ug.activeflag
INNER join userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag
INNER join groups g on usg.groupid = g.id and g.activeflag
INNER join organization og on og.id = ug.organizationid and og.activeflag
left outer join userassessmentprogram usm on aa.id = usm.aartuserid and usm.userorganizationsgroupsid = usg.id and usm.activeflag
left outer join assessmentprogram asm on asm.id = usm.assessmentprogramid and asm.activeflag
where g.groupcode in ('GSAD','SSAD','PDAD','TAQCP')
group by aa.email,groupname,organizationname
order by email;



select distinct aa.email
from aartuser aa
INNER join usersorganizations ug on aa.id = ug.aartuserid and aa.activeflag and ug.activeflag
INNER join userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag
INNER join groups g on usg.groupid = g.id and g.activeflag
INNER join organization og on og.id = ug.organizationid and og.activeflag
left outer join userassessmentprogram usm on aa.id = usm.aartuserid and usm.userorganizationsgroupsid = usg.id and usm.activeflag
left outer join assessmentprogram asm on asm.id = usm.assessmentprogramid and asm.activeflag
where g.groupcode in ('GSAD','SSAD','PDAD','TAQCP')
order by email;

--Request2: roles
select aa.email,
       aa.firstname,
       aa.surname,
       array_agg( distinct asm.abbreviatedname) programs,
       array_agg( distinct g.groupcode) roles,
       array_agg(distinct CASE WHEN otd.schoolid is not null then otd.statename 
                               WHEN dt.id is not null then (select organizationname from organization_parent(dt.id) where organizationtypeid=2) 
                               ELSE st.organizationname end) state,
       case max(usg.status) when  1 then  'Pending' when 2 then 'Active' else 'Inactive' end  status   
       into temp tmp_users    
from aartuser aa
INNER join usersorganizations ug on aa.id = ug.aartuserid and aa.activeflag and ug.activeflag
INNER join userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag
INNER join groups g on usg.groupid = g.id and g.activeflag
LEFT OUTER JOIN organizationtreedetail otd ON (ug.organizationid = otd.schoolid) 
LEFT OUTER JOIN organization dt ON (ug.organizationid = dt.id AND dt.organizationtypeid = 5)
LEFT OUTER JOIN organization st ON (ug.organizationid = st.id AND st.organizationtypeid = 2)
left outer join userassessmentprogram usm on aa.id = usm.aartuserid and usm.userorganizationsgroupsid = usg.id and usm.activeflag
left outer join assessmentprogram asm on asm.id = usm.assessmentprogramid and asm.activeflag
group by  aa.email,aa.firstname,aa.surname;

select email ,count(*) from tmp_users group  by email having count(*)>1;

\copy (select * from tmp_users) to 'ep_users.csv' (FORMAT CSV,HEADER TRUE, FORCE_QUOTE *);
--Rundeck staff search
select au.uniquecommonidentifier,
       au.email,
       au.firstname,
       au.middlename,
       au.surname,
       g.groupname as "userole",
       au.activeflag as "useractive", 
       otd.schoolname,
       CASE WHEN otd.schoolid is not null then otd.districtname else dt.organizationname end as DistrictName,
       CASE WHEN otd.schoolid is not null then otd.statename WHEN dt.id is not null then (select organizationname from organization_parent(dt.id) where organizationtypeid=2) ELSE st.organizationname       end as StateName
  FROM aartuser au 
  JOIN usersorganizations uso ON (au.id = uso.aartuserid) 
  JOIN usersecurityagreement usa ON (au.id = usa.aartuserid) 
  LEFT OUTER JOIN organizationtreedetail otd ON (uso.organizationid = otd.schoolid) 
  LEFT OUTER JOIN organization dt ON (uso.organizationid = dt.id AND dt.organizationtypeid = 5) 
  LEFT OUTER JOIN organization st ON (uso.organizationid = st.id AND st.organizationtypeid = 2) 
  JOIN userorganizationsgroups uog ON uso.id = uog.userorganizationid 
  LEFT JOIN groups g ON uog.groupid = g.id 