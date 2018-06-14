-- inactive roles
select id  from groups
where lower(groupname) in  (
'building principal'
,'consortium assessment program administrator'
,'hs'
--,'pd admin'
,'pd district admin'
,'pd state admin'
,'pd user'
,'scorer'
,'scoring building lead'
,'scoring district lead'
,'scoring state lead'
,'state scorer'
,'teacher: pnp read only'
,'technology director');


-- find the the other roles for user
select distinct ugo.id,a.email,groupname, ugo.activeflag,ugo.isdefault
from aartuser a 
inner join usersorganizations uo on a.id=uo.aartuserid
inner join userorganizationsgroups ugo on ugo.userorganizationid=uo.id
inner join groups g on g.id=ugo.groupid
where email=' pam.mattes@ku.edu'
order by ugo.isdefault

-- default true for inactive role 
with user_role as (
select distinct a.id,a.email,groupname, ugo.activeflag,ugo.isdefault 
from aartuser a 
inner join usersorganizations uo on a.id=uo.aartuserid
inner join userorganizationsgroups ugo on ugo.userorganizationid=uo.id
inner join groups g on g.id=ugo.groupid
where a.internaluserindicator is true and groupid in (
9701,
9713,
9700,
9718,
9711,
9717,
9682,
9715,
9710,
9714,
--9699,
9716,
9694,
9567) and ugo.activeflag is true and ugo.isdefault is true )
select distinct a.email,ugo.id from user_role a
inner join usersorganizations uo on a.id=uo.aartuserid
inner join userorganizationsgroups ugo on ugo.userorganizationid=uo.id
inner join groups g on g.id=ugo.groupid
where groupid not in (
9701,
9713,
9700,
9718,
9711,
9717,
9682,
9715,
9710,
9714,
--9699,
9716,
9694,
9567) and ugo.activeflag is true
order by 1,2 desc;


begin;
update userorganizationsgroups
set    isdefault =true,
          modifieddate=now(),
	   modifieduser=174744
where  id in (254283, 15056,15691,166172,23039); 
commit;

begin;

update userorganizationsgroups
set    activeflag =False,isdefault =False,
          modifieddate=now(),
	   modifieduser=174744
where  activeflag is true and 
id in (
select distinct ugo.id
from aartuser a 
inner join usersorganizations uo on a.id=uo.aartuserid
inner join userorganizationsgroups ugo on ugo.userorganizationid=uo.id
inner join groups g on g.id=ugo.groupid
where a.internaluserindicator is true and groupid in (
9701,
9713,
9700,
9718,
9711,
9717,
9682,
9715,
9710,
9714,
--9699,
9716,
9694,
9567) and ugo.activeflag is true);

commit;