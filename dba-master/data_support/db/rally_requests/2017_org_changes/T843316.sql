begin;

select statename,schoolid,schoolname,schooldisplayidentifier,replace(schooldisplayidentifier,'9990','3456') newschoolid from organizationtreedetail 
where districtdisplayidentifier='9990' and statename in ('Colorado','Colorado-cPass') order by schoolname,statename;


update organization 
set displayidentifier='3456',modifieddate=now(),modifieduser=12
where id in (64342,64548) and displayidentifier='9990';

update organization o
set displayidentifier=newschoolid,modifieddate=now(),modifieduser=12
from (select schoolid,schoolname,schooldisplayidentifier
,replace(schooldisplayidentifier,'9990','3456')
 newschoolid from organizationtreedetail 
 where districtdisplayidentifier='9990' and statename='Colorado' ) src where  src.schoolid=o.id;

 update organization o
set displayidentifier=newschoolid,modifieddate=now(),modifieduser=12
from (select schoolid,schoolname,schooldisplayidentifier
,replace(schooldisplayidentifier,'9990','3456')
 newschoolid from organizationtreedetail 
 where districtdisplayidentifier='9990' and statename='Colorado-cPass' ) src where  src.schoolid=o.id;

 select refresh_organization_detail();

 
select statename,schoolid,schoolname,schooldisplayidentifier from organizationtreedetail 
where districtdisplayidentifier='3456' and statename in ('Colorado','Colorado-cPass') order by schoolname,statename;

commit;