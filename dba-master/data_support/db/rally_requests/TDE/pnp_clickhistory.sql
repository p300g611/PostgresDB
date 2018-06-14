-- Add to status report query which will compare PNP identified for a student vs PNP used   
with tmp_response as (
SELECT assessmentprogramid,studentid, task.tools
from tdeclickhistory 
cross join unnest (tdeclickhistory.tasks) as t1(task)
)
select distinct studentid,respond.name
from tmp_response 
cross join unnest(tmp_response.tools) as t2(respond)
where assessmentprogramid=12  
and respond.name in ('auditorycalming','screenoverlay','screencontrast','magnification')
order by studentid;


with tmp_response as (
SELECT assessmentprogramid,studentid,task.buttons
from tdeclickhistory 
cross join unnest (tdeclickhistory.tasks) as t1(task)
)
select distinct studentid,respond.name
from tmp_response 
cross join unnest(tmp_response.buttons) as t2(respond)
where assessmentprogramid=12 and respond.name in ('Text To Speech Play','Text To Speech Pause')
order by studentid;

---move to ep aws
drop table if exists tmp_aws;
create temporary table tmp_aws (studentid bigint,name text);
\copy  tmp_aws from 'tmp_tool.csv' DELIMITER ',' CSV HEADER;
\copy  tmp_aws from 'tmp_button.csv' DELIMITER ',' CSV HEADER;

drop table if exists tmp_color;
create temporary table tmp_color (code text, name text);
\copy  tmp_color from 'tmp_color.csv' DELIMITER ',' CSV HEADER;

update tmp_aws
set  name ='AuditoryBackground'
where name='auditorycalming';

update tmp_aws
set  name ='ColourOverlay'
where name='screenoverlay';

update tmp_aws
set  name ='InvertColourChoice'
where name='screencontrast';

update tmp_aws
set  name ='Magnification'
where name='magnification';


update tmp_aws
set name ='Spoken'
where name='Text To Speech Play' or name='Text To Speech Pause';

 DELETE FROM tmp_aws
 WHERE ctid IN (SELECT min(ctid)
                   FROM tmp_aws tmp
                   GROUP BY studentid,name
                   HAVING count(*)>1);


				   

drop table if exists tmp_table;
with tmp_pnp as (
select stu.statestudentidentifier ssid,stu.id studentid
from student stu
join enrollment en on en.studentid =stu.id 
join organizationtreedetail ot on ot.schoolid=en.attendanceschoolid
JOIN studentassessmentprogram sap ON sap.studentid = stu.id and sap.activeflag is true
JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
where stu.activeflag is true and en.activeflag is true 
and en.currentschoolyear =2018 and  stu.profilestatus = 'CUSTOM'
and stu.stateid =51 and a.id =12
order by stu.id
),
tmp_value as (select tmp1.studentid,piac.id
 from tmp_pnp tmp1 
left outer JOIN studentprofileitemattributevalue spiav ON tmp1.studentid = spiav.studentid
left outer JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
left outer JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
left outer JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
where  pia.attributename ='assignedSupport' and spiav.selectedvalue='true'
and piac.attributecontainer in ('AuditoryBackground','ColourOverlay','InvertColourChoice','Magnification','Spoken')
) 
select distinct tmp.ssid,tmp.studentid,piac.id piacid,piac.attributecontainer,pia.id piaid,pia.attributename,spiav.selectedvalue
,case when tmp1.name=piac.attributecontainer then 'Yes' else 'No' end as aws_value
into temp tmp_table
from tmp_pnp tmp
join tmp_value tmp2 on tmp2.studentid=tmp.studentid
JOIN studentprofileitemattributevalue spiav ON tmp.studentid = spiav.studentid
JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id and piac.id=tmp2.id
Full outer join tmp_aws tmp1 on tmp1.studentid=tmp.studentid and piac.attributecontainer=tmp1.name
where spiav.selectedvalue<>''
order by tmp.studentid,piac.attributecontainer,pia.attributename,spiav.selectedvalue;


drop table if exists tmp_newtable;
select distinct s.statestudentidentifier  "StateStudentIdentifier"
,otd.schoolname            "SchoolName"
,otd.districtname          "DistrictName"
,otd.statename             "StateName"
,Max(case when attributecontainer='Spoken'and attributename='assignedSupport' then selectedvalue end ) as "Spoken-assignedSupport"
,Max(case when attributecontainer='Spoken'and attributename='activateByDefault' then selectedvalue end ) as "Spoken-activateByDefault"
,Max(case when attributecontainer='Spoken'and attributename='directionsOnly' then selectedvalue end ) as "Spoken-directionsOnly"
,Max(case when attributecontainer='Spoken'and attributename='preferenceSubject' then selectedvalue end ) as "Spoken-preferenceSubject"
,Max(case when attributecontainer='Spoken'and attributename='ReadAtStartPreference' then selectedvalue end ) as "Spoken-ReadAtStartPreference"
,Max(case when attributecontainer='Spoken'and attributename='SpokenSourcePreference' then selectedvalue end ) as "Spoken-SpokenSourcePreference"
,Max(case when attributecontainer='Spoken'and attributename='UserSpokenPreference' then selectedvalue end ) as "Spoken-UserSpokenPreference"
,Max(case when attributecontainer='Spoken'and attributename='assignedSupport' then aws_value end ) as "Aws_Spoken"
,Max(case when attributecontainer='AuditoryBackground'and attributename='assignedSupport' then selectedvalue end ) as "AuditoryBackground-assignedSupport"
,Max(case when attributecontainer='AuditoryBackground'and attributename='activateByDefault' then selectedvalue end ) as "AuditoryBackground-activateByDefault"
,Max(case when attributecontainer='AuditoryBackground'and attributename='assignedSupport' then aws_value end ) as "Aws_AuditoryBackground"
,Max(case when attributecontainer='ColourOverlay'and attributename='assignedSupport' then selectedvalue end ) as "ColourOverlay-assignedSupport"
,Max(case when attributecontainer='ColourOverlay'and attributename='activateByDefault' then selectedvalue end ) as "ColourOverlay-activateByDefault"
,Max(case when attributecontainer='ColourOverlay'and attributename='colour' then cl.name end ) as "ColourOverlay-colour"
,Max(case when attributecontainer='ColourOverlay'and attributename='assignedSupport' then aws_value end ) as "Aws_ColourOverlay"
,Max(case when attributecontainer='InvertColourChoice'and attributename='assignedSupport' then selectedvalue end ) as "InvertColourChoice-assignedSupport"
,Max(case when attributecontainer='InvertColourChoice'and attributename='activateByDefault' then selectedvalue end ) as "InvertColourChoice-activateByDefault"
,Max(case when attributecontainer='InvertColourChoice'and attributename='assignedSupport' then aws_value end ) as "Aws_InvertColourChoice"
,Max(case when attributecontainer='Magnification'and attributename='assignedSupport' then selectedvalue end ) as "Magnification-assignedSupport"
,Max(case when attributecontainer='Magnification'and attributename='activateByDefault' then selectedvalue end ) as "Magnification-activateByDefault"
,Max(case when attributecontainer='Magnification'and attributename='magnification' then selectedvalue end ) as "Magnification-magnification"
,Max(case when attributecontainer='Magnification'and attributename='assignedSupport' then aws_value end ) as "Aws_Magnification"
into temp tmp_newtable
FROM tmp_table tmp
inner join student s on s.id=tmp.studentid
inner join enrollment e on e.studentid=s.id 
inner join organizationtreedetail otd on otd.schoolid=e.attendanceschoolid
left outer join tmp_color cl on cl.code=tmp.selectedvalue 
where e.activeflag is true and s.activeflag is true and e.currentschoolyear=2018
group by s.statestudentidentifier,otd.schoolname ,otd.districtname,  otd.statename
order by  otd.schoolname,otd.districtname,s.statestudentidentifier ;


\copy (select * from tmp_newtable) to 'pnp_clickhistory_3_13.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

/*
--how to connect from dbutil2
athena --region us-east-1
use tdestage;
select * from tdeclickhistory limit 1;
--------------------------------------------------
   aws athena start-query-execution \
   --query-string " with tmp_response as (
SELECT assessmentprogramid,studentid, task.tools
from tdeclickhistory 
cross join unnest (tdeclickhistory.tasks) as t1(task)
)
select distinct studentid,respond.name
from tmp_response 
cross join unnest(tmp_response.tools) as t2(respond)
where assessmentprogramid=12  
and respond.name in ('auditorycalming','screenoverlay','screencontrast','magnification')
order by studentid;" \
   --region us-east-1 \
   --query-execution-context Database=tdestage \
   --result-configuration OutputLocation=s3://kite-sqlite-extracts/tmp \
   --output text

*/