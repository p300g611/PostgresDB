 --activeflag set to false for all users that only have AMP
 
 --backup 
drop table if exists tmp_userole;
with tmp_role as (
select aart.id aartid
from aartuser aart
inner join usersorganizations ug on ug.aartuserid=aart.id
inner join userorganizationsgroups usg on usg.userorganizationid=ug.id
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id
where aart.activeflag is true and usp.activeflag is true and usp.assessmentprogramid=37
order by aartid)
select aart.id aartid,aart.activeflag aartflag, ug.id usorgid, ug.activeflag ugflag,ug.isdefault ugfault,
usg.id usgid, usg.activeflag usgflag,usg.isdefault usgfault, usp.id uspid, usp.assessmentprogramid uspprogramid,
usp.activeflag uspflag, usp.isdefault uspfault
into temp tmp_userole
from tmp_role tmp
inner join aartuser aart on aart.id=tmp.aartid
inner join usersorganizations ug on ug.aartuserid=aart.id
inner join userorganizationsgroups usg on usg.userorganizationid=ug.id
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id
where aart.activeflag is true and usp.activeflag is true 
order by aartid;
\copy (select * from tmp_userole) to 'tmp_userole.csv_prod.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--check count for role in amp
select count(distinct aart.id)
from aartuser aart
inner join usersorganizations ug on ug.aartuserid=aart.id
inner join userorganizationsgroups usg on usg.userorganizationid=ug.id
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id
where aart.activeflag is true and usp.activeflag is true and usp.assessmentprogramid=37;
 count │ 8734 
 
--validation
 select count(distinct aartid) from tmp_userole 
 where aartid in (select aartid from tmp_userole group by aartid having count(distinct uspprogramid)=1);---6715

 select count(distinct aartid) from tmp_userole 
 where aartid in (select aartid from tmp_userole group by aartid having count(distinct uspprogramid)>1);---2019


 
--======================================

--1. user role only include AMP role

drop table if exists tmp_onerole;
with tmp_program as (
select aart.id aartid ,count(distinct assessmentprogramid)
from  aartuser aart
inner join usersorganizations ug on ug.aartuserid=aart.id
inner join userorganizationsgroups usg on usg.userorganizationid=ug.id
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id
where aart.activeflag is true and usp.activeflag is true
group by aart.id
having count(distinct assessmentprogramid)=1)

select aartid,usp.id, usg.id usgid, usp.activeflag,usp.assessmentprogramid ,usp.isdefault,usp.userorganizationsgroupsid 
into temp tmp_onerole
--select count(distinct aartid)
from tmp_program tmp
inner join aartuser aart on aart.id=tmp.aartid
inner join usersorganizations ug on ug.aartuserid=aart.id
inner join userorganizationsgroups usg on usg.userorganizationid=ug.id
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id
where usp.activeflag is true and usp.assessmentprogramid =37
order by aartid   --6715
;


begin;
update aartuser 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser=174744
	   where id in (select distinct aartid from tmp_onerole) and activeflag is true  ;
	   
update userassessmentprogram 
set    activeflag =false,
	   modifieddate =now(),
	   modifieduser =174744
	   where activeflag is true and assessmentprogramid =37
	   and aartuserid in (select distinct aartid from tmp_onerole);
	   
update userorganizationsgroups
set    status=3,
       modifieddate=now(),
	   modifieduser=174744
where  id in (select distinct usgid from tmp_onerole ) and status<>3;   


update userorganizationsgroups
set    activeflag =false,
       modifieddate=now(),
	   modifieduser=174744
where  id in (select distinct usgid from tmp_onerole ) and activeflag is true; 
commit;	   

--user role is multiple roles 
drop table if exists tmp_multiplerole;
with tmp_program as (
select aart.id aartid ,count(distinct assessmentprogramid)
from  aartuser aart
inner join usersorganizations ug on ug.aartuserid=aart.id
inner join userorganizationsgroups usg on usg.userorganizationid=ug.id
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id
where aart.activeflag is true and usp.activeflag is true
group by aart.id
having count(distinct assessmentprogramid)>1)

select distinct  aartid,usp.id uspid, usp.assessmentprogramid,usp.activeflag,usp.isdefault,usp.userorganizationsgroupsid 
into temp tmp_multiplerole
--select count(distinct aartid)
from tmp_program tmp
inner join aartuser aart on aart.id=tmp.aartid
inner join usersorganizations ug on ug.aartuserid=aart.id
inner join userorganizationsgroups usg on usg.userorganizationid=ug.id
inner join userassessmentprogram usp on usp.aartuserid=aart.id and usp.userorganizationsgroupsid=usg.id
where usp.activeflag is true and usp.assessmentprogramid =37
order by aartid
;




--update both activeflag and isdefault are false 
begin;
update userassessmentprogram 
set    activeflag =false,
       isdefault=false,
	   modifieddate =now(),
	   modifieduser =174744
	   where activeflag is true  and assessmentprogramid =37
	   and aartuserid in (select distinct aartid from tmp_multiplerole);
commit;



--update isdefault is true and activeflag is true  in assessmentprogram =3 
drop table if exists tmp_doubetrue;
select id, aartuserid,activeflag, isdefault,assessmentprogramid,userorganizationsgroupsid
into temp tmp_doubetrue
from userassessmentprogram where aartuserid in (
     select distinct aartid from tmp_multiplerole  where activeflag is true and isdefault is true) 
 and activeflag is true and isdefault is false;


begin;
 
with tmp_cnt as  (select id,aartuserid, activeflag, isdefault, assessmentprogramid, 
 row_number()over(partition by aartuserid order by assessmentprogramid) num_cnt
 from tmp_doubetrue where assessmentprogramid =3 )
 
update userassessmentprogram 
set    isdefault=true,       
	   modifieddate =now(),
	   modifieduser =174744
       where id in (select id from tmp_cnt where num_cnt=1) and isdefault=false and activeflag is true;

	    
	   
commit;




