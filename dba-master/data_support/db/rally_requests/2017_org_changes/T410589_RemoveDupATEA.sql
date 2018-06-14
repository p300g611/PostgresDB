

===================================================================================================
with assess_dup as(
select distinct aart.id, count(distinct usp.assessmentprogramid)
from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true 
inner join userorganizationsgroups usg on usg.userorganizationid = us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id and usp.activeflag is true
inner join groups g on g.id=usg.groupid and g.activeflag is true
where  aart.activeflag is true 
group by aart.id
having count(distinct usp.assessmentprogramid)>1)

select distinct aart.id aartid, aart.email, usp.id uspid, usp.assessmentprogramid
into temp tmp_dup

from aartuser aart
inner join assess_dup tmp on tmp.id =aart.id
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
inner join userorganizationsgroups usg on usg.userorganizationid = us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id and usp.activeflag is true
where usp.assessmentprogramid=15 and aart.activeflag is true 
order by aart.id;


drop table if exists tmp_user;
select aart.id aartid, aart.email, aart.firstname,aart.surname,ug.id usorid,usg.id usgropid,usp.id uspid,usp.assessmentprogramid,
usp.activeflag uspflag,
ort.schoolname,

CASE WHEN ort.schoolid is not null then ort.districtname else dt.organizationname end as DistrictName, 
               
CASE WHEN ort.schoolid is not null then ort.statename 
    WHEN dt.id is not null then (select organizationname from organization_parent(dt.id) where organizationtypeid=2)
    ELSE st.organizationname end as StateName 
into temp tmp_user

from tmp_dup tmp

inner join aartuser aart on aart.id =tmp.aartid 
inner join usersorganizations ug on ug.aartuserid=aart.id and ug.activeflag is true
left outer join organizationtreedetail ort on ort.schoolid = ug.organizationid
left outer join organization dt on (dt.id=ug.organizationid and dt.organizationtypeid=5)
left outer join organization st on (st.id = ug.organizationid and st.organizationtypeid =2)
inner join userorganizationsgroups usg on usg.userorganizationid = ug.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id and usp.activeflag is true
where aart.activeflag is true 
order by aart.id;


\copy (select * from tmp_user where tmp_user.statename='Kansas') to 'T410589_dup_before_1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

BEGIN;

update userassessmentprogram
set   activeflag =false,
      modifieddate =now(),
	  modifieduser =12
where id in (select distinct uspid from tmp_user where assessmentprogramid=15 and statename ='Kansas');


COMMIT;

--should be zero
select distinct aart.id aartid, aart.email, usp.id uspid, usp.assessmentprogramid
--into temp tmp_dup 
from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
inner join userorganizationsgroups usg on usg.userorganizationid = us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id and usp.activeflag is true
where usp.assessmentprogramid=15 and aart.activeflag is true  and usp.activeflag is true;

--rerun script above
\copy (select * from tmp_user) to 'T410589_dup_after_1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--validation when activeflag and isdefault both are ture in the userassessmentprogram
--  select distinct aart.id from aartuser aart 
-- 
-- id from userassessmentprogram usm
--join tmp_user tmp on tmp.uspid=usm.id 
--where usm.activeflag is true and usm.isdefault=true and usm.assessmentprogramid=15;

--three user with one program
--tirving@usd259.net
--sbird@usd259.net
--cparnell@usd259.net
begin;

update userassessmentprogram
set   assessmentprogramid =12,
      modifieddate =now(),
	  modifieduser =12
where id in (193691,198693,199646);

commit;


