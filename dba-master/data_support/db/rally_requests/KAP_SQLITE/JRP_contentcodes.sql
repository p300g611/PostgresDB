--JRP script
select distinct
 c.externalid as externaltaskid
,c.contentareaname
,c.contentframeworkdetailcode
,c.primarycontentframeworkdetail
from taskvariant c

--Data team updated script 
select distinct
 c.id maxepid
,c.externalid as externaltaskid
,c.contentareaname
,c.contentframeworkdetailcode
,c.primarycontentframeworkdetail
from taskvariant c
inner join (select max(id) maxepid,externalid from taskvariant group by externalid) tv_max ON c.externalid = tv_max.externalid AND c.id = tv_max.maxepid;

