-- 1. validation
    select  a.id,a.email,ap.abbreviatedname,g.groupname,o.organizationname,o.id
    , (select districtname from organizationtreedetail where schoolid=o.id) districtname ,count(*) FROM aartuser a
    JOIN usersorganizations uo ON a.id = uo.aartuserid
    JOIN userorganizationsgroups ug ON uo.id = ug.userorganizationid
    JOIN organization o ON o.id = uo.organizationid
    JOIN groups g ON g.id = ug.groupid
    JOIN userassessmentprogram ua ON ua.userorganizationsgroupsid = ug.id
    join assessmentprogram ap on ap.id=ua.assessmentprogramid
     --where uniquecommonidentifier='2513599241'
   group by a.id,a.email,ap.abbreviatedname,g.groupname,o.organizationname,districtname,o.id
   having count(*)>1 order by a.id;

-- Remove duplicates (1. with any shared userorganizationsgroups-- dups in assessmentprogram only)
drop table if exists tmp_dup_user_roles;
with duplicate_role as (
    select  a.id aartid,ap.id assessmentprogramid,g.id groupid,o.id orgid,count(*) FROM aartuser a
    JOIN usersorganizations uo ON a.id = uo.aartuserid
    JOIN userorganizationsgroups ug ON uo.id = ug.userorganizationid
    JOIN organization o ON o.id = uo.organizationid
    JOIN groups g ON g.id = ug.groupid
    JOIN userassessmentprogram ua ON ua.userorganizationsgroupsid = ug.id
    join assessmentprogram ap on ap.id=ua.assessmentprogramid
     --where uniquecommonidentifier='2513599241'
   group by a.id,ap.id,g.id,o.id
   having count(*)>1)
select  a.id aartid,ap.id assessmentprogramid,g.id groupid,o.id orgid,ug.id ugid,ug.activeflag ugactive,
 ua.id uaid,ua.activeflag uaactiveflag,
    ROW_NUMBER() over (partition by a.id,ap.id,g.id,o.id order by case when ug.activeflag is true then 1 else 0 end desc, ug.modifieddate desc,ug.id desc) row_num 
      into temp tmp_dup_user_roles 
    FROM aartuser a
    JOIN usersorganizations uo ON a.id = uo.aartuserid
    JOIN userorganizationsgroups ug ON uo.id = ug.userorganizationid
    JOIN organization o ON o.id = uo.organizationid
    JOIN groups g ON g.id = ug.groupid
    JOIN userassessmentprogram ua ON ua.userorganizationsgroupsid = ug.id
    join assessmentprogram ap on ap.id=ua.assessmentprogramid
    where a.id in (select aartid from duplicate_role);


    
 select * from tmp_dup_user_roles where row_num>1 and  ugactive is true;
 
 select  a.id,a.email,ap.abbreviatedname,g.groupname,o.organizationname,o.id
    , (select districtname from organizationtreedetail where schoolid=o.id) districtname
    ,ug.id ugid,ug.activeflag ugactive,ug.modifieddate,ua.id,ua.activeflag uaactiveflag  FROM aartuser a
    JOIN usersorganizations uo ON a.id = uo.aartuserid
    JOIN userorganizationsgroups ug ON uo.id = ug.userorganizationid
    JOIN organization o ON o.id = uo.organizationid
    JOIN groups g ON g.id = ug.groupid
    JOIN userassessmentprogram ua ON ua.userorganizationsgroupsid = ug.id
    join assessmentprogram ap on ap.id=ua.assessmentprogramid
    where a.id=63246;

    select * from userassessmentprogram  where userorganizationsgroupsid =42851 and aartuserid =63246;    
    select * from userorganizationsgroups where id=42851; 

    begin;
    delete from userassessmentprogram where id=432758;
    
    commit;

-- Remove duplicates (2. with out any shared userorganizationsgroups-- dups in userorganizationsgroups and usersorganizations)

drop table if exists tmp_dup_user_roles;
with duplicate_role as (
    select  a.id aartid,ap.id assessmentprogramid,g.id groupid,o.id orgid,count(distinct ug.id) FROM aartuser a
    JOIN usersorganizations uo ON a.id = uo.aartuserid
    JOIN userorganizationsgroups ug ON uo.id = ug.userorganizationid
    JOIN organization o ON o.id = uo.organizationid
    JOIN groups g ON g.id = ug.groupid
    JOIN userassessmentprogram ua ON ua.userorganizationsgroupsid = ug.id
    join assessmentprogram ap on ap.id=ua.assessmentprogramid
     --where uniquecommonidentifier='2513599241'
   group by a.id,ap.id,g.id,o.id
   having count(distinct ug.id)>1)
select  a.id aartid,ap.id assessmentprogramid,g.id groupid,o.id orgid,ug.id ugid,ug.activeflag ugactive,
    ua.id uaid,ua.activeflag uaactiveflag,
    ROW_NUMBER() over (partition by a.id,ap.id,g.id,o.id order by case when ug.activeflag is true then 1 else 0 end desc, ug.modifieddate desc,ug.id desc) row_num 
      into temp tmp_dup_user_roles 
    FROM aartuser a
    JOIN usersorganizations uo ON a.id = uo.aartuserid
    JOIN userorganizationsgroups ug ON uo.id = ug.userorganizationid
    JOIN organization o ON o.id = uo.organizationid
    JOIN groups g ON g.id = ug.groupid
    JOIN userassessmentprogram ua ON ua.userorganizationsgroupsid = ug.id
    join assessmentprogram ap on ap.id=ua.assessmentprogramid
    where a.id in (select aartid from duplicate_role);


select * from tmp_dup_user_roles where row_num>1 and  ugactive is true;  
select * from tmp_dup_user_roles where row_num>1 ;  

begin;
delete from userassessmentprogram
where id in (select uaid from tmp_dup_user_roles where row_num>1);

commit;

begin;
delete from userorganizationsgroups 
where id in (select ugid from tmp_dup_user_roles where row_num>1 and ugid not in (
 select ugid from userassessmentprogram src inner join tmp_dup_user_roles tgt on src.userorganizationsgroupsid=tgt.ugid and row_num>1));

commit;


