with atea_users as (
select distinct aart.id
from aartuser aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
inner join userorganizationsgroups usg on usg.userorganizationid=us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid =usg.id and usp.activeflag is true
inner join groups g on g.id =usg.groupid and g.activeflag is true
where aart.activeflag is true

and usp.assessmentprogramid =15)
select aart.id,count(distinct usp.assessmentprogramid) cnt
 into temp tmp_user
from atea_users aart
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
inner join organizationtreedetail ort on ort.schoolid= us.organizationid 
inner join userorganizationsgroups usg on usg.userorganizationid=us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid =usg.id and usp.activeflag is true
inner join groups g on g.id =usg.groupid and g.activeflag is true
group by aart.id 
having count(distinct usp.assessmentprogramid)=1;

drop table if exists tmp_replic;
select distinct aart.id aartid,usg.id usorggroupid,usp.assessmentprogramid,uniquecommonidentifier,firstname,surname,email,groupid,
    schoolname,districtname,statename,usp.id uspid
into temp tmp_replic 
from tmp_user aart
inner join aartuser a on aart.id=a.id
inner join usersorganizations us on us.aartuserid=aart.id and us.activeflag is true
inner join organizationtreedetail ort on ort.schoolid= us.organizationid 
inner join userorganizationsgroups usg on usg.userorganizationid=us.id and usg.activeflag is true
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid =usg.id and usp.activeflag is true
inner join groups g on g.id =usg.groupid and g.activeflag is true;

\copy (select * from tmp_replic) to 'tmp_replic_before.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


begin;
update userassessmentprogram
set assessmentprogramid=12
where id in (select distinct uspid from tmp_replic);

--re run above create tmp_replic
select aartid,email,groupid,schoolname,assessmentprogramid from tmp_replic order by 1;
\copy (select * from tmp_replic) to 'tmp_replic_after.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
commit;




