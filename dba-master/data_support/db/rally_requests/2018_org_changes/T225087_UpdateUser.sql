create temporary table tmp_user(uniqid text, useremail text,userorg text);
\COPY tmp_user from 'tmp_role.csv' DELIMITER ',' CSV HEADER;

--validation userorganizationsgroups
select tmp.uniqid,au.id,au.activeflag auflag,g.groupcode,uo.id uoid,uo.activeflag uoflag,uo.isdefault uodefault
,org.schooldisplayidentifier orgid
,uog.id uogid,uog.status uogstatus,uog.activeflag uogflag, uog.isdefault uogfdefault
,usp.id uspid,usp.activeflag uspflag, usp.isdefault usgdefault,usp.assessmentprogramid pgamid

select uog.id uogid,uog.status

--into temp tmp_status
from tmp_user tmp
join aartuser au on au.uniquecommonidentifier=tmp.uniqid and au.email=tmp.useremail 
join usersorganizations uo ON uo.aartuserid = au.id 
join organizationtreedetail org on org.schoolid=uo.organizationid and org.schooldisplayidentifier=tmp.userorg
join userorganizationsgroups uog ON uo.id = uog.userorganizationid
join  groups g ON uog.groupid = g.id
join userassessmentprogram usp on usp.aartuserid=au.id and usp.userorganizationsgroupsid=uog.id
where uog.activeflag is true and au.activeflag is true and uo.activeflag is true and usp.activeflag is true and g.activeflag is true 
and uog.status<>2 
order by au.id,org.schooldisplayidentifier,usp.assessmentprogramid;

\copy (select * from tmp_role) to 'tmp_role_tikcet225087.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 


begin;
update userorganizationsgroups 
 set   status=2,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu')
	   where id in (select uogid from tmp_status);
commit;




 
 /*
 aartprod-> WHERE  au.id =89077;Barrett Branting 6682325983
┌───────┬────────┬───────────┬────────┬────────┬────────────┬───────────┬────────┬────────┐
│  id   │ auflag │ groupcode │ uogid  │ status │ activeflag │ isdefault │  uoid  │ uoflag │
├───────┼────────┼───────────┼────────┼────────┼────────────┼───────────┼────────┼────────┤
│ 89077 │ t      │ TEA       │ 259903 │      1 │ f          │ f         │ 203306 │ t      │
│ 89077 │ t      │ TEA       │ 259902 │      1 │ f          │ f         │ 203305 │ t      │
│ 89077 │ t      │ TEA       │ 259901 │      1 │ f          │ f         │ 203304 │ t      │
│ 89077 │ t      │ TEA       │ 259899 │      1 │ f          │ f         │ 203302 │ t      │
│ 89077 │ t      │ BTC       │ 263014 │      1 │ f          │ f         │  92117 │ t      │
│ 89077 │ t      │ SCO       │ 222073 │      2 │ t          │ f         │  92117 │ t      │
│ 89077 │ t      │ TEA       │  94274 │      1 │ f          │ f         │  92117 │ t      │
│ 89077 │ t      │ TEA       │ 259898 │      1 │ f          │ f         │ 203301 │ t      │
│ 89077 │ t      │ TEA       │ 259900 │      1 │ f          │ f         │ 203303 │ t      │
│ 89077 │ t      │ TEA       │ 259896 │      1 │ f          │ f         │ 203299 │ t      │
│ 89077 │ t      │ TEA       │ 259897 │      1 │ f          │ f         │ 203300 │ t      │
│ 89077 │ t      │ TEA       │ 302321 │      2 │ t          │ f         │ 235027 │ t      │
│ 89077 │ t      │ PRO       │ 302320 │      2 │ t          │ t         │ 235027 │ t      │
│ 89077 │ t      │ TEA       │ 259615 │      1 │ f          │ f         │ 203087 │ t      │
│ 89077 │ t      │ TEA       │ 259839 │      1 │ f          │ f         │ 203246 │ t      │
└───────┴────────┴───────────┴────────┴────────┴────────────┴───────────┴────────┴────────┘
(15 rows)
aartprod-> WHERE  au.id =133807;Kayla Adney 9759713144
┌────────┬────────┬───────────┬────────┬────────┬────────────┬───────────┬────────┬────────┐
│   id   │ auflag │ groupcode │ uogid  │ status │ activeflag │ isdefault │  uoid  │ uoflag │
├────────┼────────┼───────────┼────────┼────────┼────────────┼───────────┼────────┼────────┤
│ 133807 │ t      │ PRO       │ 300948 │      3 │ t          │ f         │ 146195 │ t      │
│ 133807 │ t      │ TEA       │ 175020 │      3 │ t          │ t         │ 146195 │ t      │
└────────┴────────┴───────────┴────────┴────────┴────────────┴───────────┴────────┴────────┘
(2 rows)
aartprod-> WHERE  au.id =17551;Karen Adney 5987947243
┌───────┬────────┬───────────┬────────┬────────┬────────────┬───────────┬───────┬────────┐
│  id   │ auflag │ groupcode │ uogid  │ status │ activeflag │ isdefault │ uoid  │ uoflag │
├───────┼────────┼───────────┼────────┼────────┼────────────┼───────────┼───────┼────────┤
│ 17551 │ t      │ PRO       │ 300884 │      3 │ t          │ f         │ 17484 │ t      │
│ 17551 │ t      │ TEA       │ 175220 │      3 │ t          │ t         │ 17484 │ t      │
└───────┴────────┴───────────┴────────┴────────┴────────────┴───────────┴───────┴────────┘
(2 rows)
*/

begin;
update userorganizationsgroups
set    status =2,
modifieddate=now(),
modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (select distinct uog.id 
from aartuser au
left outer join usersorganizations uo ON uo.aartuserid = au.id
left outer join userorganizationsgroups uog ON uo.id = uog.userorganizationid
left outer join  groups g ON uog.groupid = g.id
WHERE  au.id =89077 and uog.status <>2);


update userorganizationsgroups
set    status =2,
modifieddate=now(),
modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (select distinct uog.id 
from aartuser au
left outer join usersorganizations uo ON uo.aartuserid = au.id
left outer join userorganizationsgroups uog ON uo.id = uog.userorganizationid
left outer join  groups g ON uog.groupid = g.id
WHERE  au.id =133807 and uog.status <>2);


update userorganizationsgroups
set    status =2,
modifieddate=now(),
modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where id in (select distinct uog.id 
from aartuser au
left outer join usersorganizations uo ON uo.aartuserid = au.id
left outer join userorganizationsgroups uog ON uo.id = uog.userorganizationid
left outer join  groups g ON uog.groupid = g.id
WHERE  au.id =17551 and uog.status <>2);

commit;





