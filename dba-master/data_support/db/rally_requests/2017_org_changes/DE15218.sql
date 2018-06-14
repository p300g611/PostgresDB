with cte as
(
select aa.id aartuserid,ug.organizationid,array_agg(distinct groupcode) assessment
 from aartuser aa
 inner join roster r on r.teacherid=aa.id and r.currentschoolyear=2017 and r.activeflag is true
 INNER join usersorganizations ug on aa.id = ug.aartuserid and aa.activeflag and ug.activeflag
 INNER join userorganizationsgroups usg on ug.id = usg.userorganizationid and usg.activeflag
 INNER join groups g on usg.groupid = g.id and g.activeflag
 inner join userassessmentprogram usm on aa.id = usm.aartuserid and usm.userorganizationsgroupsid = usg.id and usm.activeflag
--  inner join assessmentprogram asm on asm.id = usm.assessmentprogramid and asm.activeflag
group by aa.id,ug.organizationid)
select distinct ot.statename,ot.districtname,ot.schoolname
,aa.id,aa.uniquecommonidentifier,aa.email,aa.firstname,aa.surname,aa.activeflag useractive,aa.modifieddate usermod,internaluserindicator
,r.coursesectionname,r.statesubjectareaid,r.currentschoolyear,r.sourcetype,uo.assessment role_in_current_org,uoo.assessment role_in_oth_org
,r.modifieddate rostermod
into temp tmp_rosters
from roster r
inner join organizationtreedetail ot on ot.schoolid=r.attendanceschoolid
left outer join aartuser aa on r.teacherid=aa.id 
left outer join cte uo on uo.aartuserid=r.teacherid and uo.organizationid=r.attendanceschoolid  
left outer join cte uoo on uoo.aartuserid=r.teacherid   
where currentschoolyear=2017 and r.activeflag is true and uo.aartuserid is null
order by statename desc,districtname,schoolname;

\copy (select * from tmp_rosters) to 'educator_roster_missing_role.csv' (FORMAT CSV,HEADER TRUE, FORCE_QUOTE *);

