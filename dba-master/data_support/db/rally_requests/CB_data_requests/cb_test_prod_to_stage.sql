-- 0. CB application services stop (ALL cb service)
-- 1. Identify all the tests in CB Stage that doesn't match with CB Prod based on test id, test name, organization id
-- 2. Inactivate all the students tests that are associated with these tests in EP Stage.
-- 3. Un-publish these tests in CB Stage.
-- 4. Migrate the CB Prod data to CB Stage.
-- 5. Update tests status
-- 6. Update test collection data
-- 7. Update stage data
-- 8. innovativetaskpackagepath compare


--cb-prod
\copy (select testdevelopmentid,name,organizationid,createdate,modifieddate from cb.testdevelopment  where inuse is true) to 'test_prod.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--switch to cb.stage
drop table if exists tmp_test_prod;
create  temp table  tmp_test_prod  (testdevelopmentid bigint,name character varying(100),organizationid bigint,
createdate timestamp with time zone,modifieddate timestamp with time zone );
\COPY tmp_test_prod FROM 'test_prod.csv' DELIMITER ',' CSV HEADER ;
select count(*) from cb.testdevelopment stg
left outer join tmp_test_prod prod 
on stg.testdevelopmentid=prod.testdevelopmentid and stg.NAME=prod.NAME and stg.organizationid=prod.organizationid 
and stg.createdate=prod.createdate --and stg.modifieddate=prod.modifieddate
where stg.inuse is true and
 prod.testdevelopmentid is null;


select distinct stg.testdevelopmentid into temp tmp_stg from cb.testdevelopment stg
left outer join tmp_test_prod prod 
on stg.testdevelopmentid=prod.testdevelopmentid and stg.NAME=prod.NAME and stg.organizationid=prod.organizationid 
and stg.createdate=prod.createdate --and stg.modifieddate=prod.modifieddate
where stg.inuse is true and
 prod.testdevelopmentid is null;


 \copy (select * from tmp_stg) to 'tmp_stg.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

---swith to pg3.ep
create  temp table  tmp_stg  (testdevelopmentid bigint);
\COPY tmp_stg FROM 'tmp_stg.csv' DELIMITER ',' CSV HEADER ;

select id into temp tmp_test_ep from test where externalid in (select testdevelopmentid from tmp_stg);


begin;


update studentsresponses
set activeflag =false,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
--  select count(*) from studentsresponses
where studentstestsid in (select id from studentstests where testid in (select id from tmp_test_ep) and activeflag =true and status in (84,85)) and activeflag =true ;

update studentstestsections
set activeflag =false,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
--  select count(*) from studentstestsections
where studentstestid in (select id from studentstests where testid in (select id from tmp_test_ep) and activeflag =true and status in (84,85)) and activeflag =true;


select createddate::date,count(*) from studentstestsections
where studentstestid in (select id from studentstests where testid in (select id from tmp_test_ep) and activeflag =true and status in (84,85)) and activeflag =true
group by createddate::date;

update studentstests
set activeflag =false,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
 --select count(*) from studentstests
where testid in (select id from tmp_test_ep) and activeflag =true and status in (84,85) ;

 update test
 set status =65,
  modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
  modifieddate=now()
  --select count(*) from test
 where id in (select id from tmp_test_ep) and activeflag =true  and status=64;

commit;
-- prod cb prod data to stage 

-- vaildation cb test status not mached ep
--EP
\copy (select t.id,t.externalid,t.status from test t inner join ( select max(id) id,externalid from test group by externalid) tm on tm.id=t.id ) to 'tmp_ep_stg3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--CB
create  temp table  tmp_ep_stg3  (id bigint,externalid bigint,status bigint);
\COPY tmp_ep_stg3 FROM 'tmp_ep_stg3.csv' DELIMITER ',' CSV HEADER ;


select count(distinct cb.contenttypeid) from cb.contentdeployment cb
inner join (select id,externalid,case when status=64 then 'DEPLOYED' else 'NOT_DEPLOYED'   
end status from tmp_ep_stg3  where externalid is not null) ep on ep.externalid=cb.contenttypeid
where coalesce(cb.statuscode,'') <>coalesce(ep.status,'') ;


select ep.id, ep.externalid,coalesce(cb.statuscode,'') cb_statuscode,coalesce(ep.status,'') ep_status
into temp tmp_cb_not_deployed
 from cb.contentdeployment cb
inner join (select id,externalid,case when status=64 then 'DEPLOYED' else 'NOT_DEPLOYED'
end status from tmp_ep_stg3  where externalid is not null) ep on ep.externalid=cb.contenttypeid
where coalesce(cb.statuscode,'') <>coalesce(ep.status,'') and coalesce(ep.status,'')='DEPLOYED' and coalesce(cb.statuscode,'')='NOT_DEPLOYED';

\copy (select * from tmp_cb_not_deployed) to 'tmp_cb_not_deployed.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


update cb.contentdeployment
set statuscode='NOT_DEPLOYED'
where contenttypeid in (select ep.externalid from cb.contentdeployment cb
inner join (select id,externalid,case when status=64 then 'DEPLOYED' else 'NOT_DEPLOYED'
end status from tmp_ep_stg3  where externalid is not null) ep on ep.externalid=cb.contenttypeid
where coalesce(cb.statuscode,'') <>coalesce(ep.status,'') and coalesce(ep.status,'')='NOT_DEPLOYED' and coalesce(cb.statuscode,'')='DEPLOYED'
);

--ep


create  temp table  tmp_cb_not_deployed  (id bigint,externalid bigint,cb_statuscode text,ep_status text);
\COPY tmp_cb_not_deployed FROM 'tmp_cb_not_deployed.csv' DELIMITER ',' CSV HEADER ;



update test 
set status=65,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
where id in (select id from tmp_cb_not_deployed) and status=64;

----------------------------
\copy (select t.id,t.externalid,t.status from test t inner join ( select max(id) id ,externalid from test group by externalid) tm on tm.id=t.id ) to 'tmp_ep_stg3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--CB
create  temp table  tmp_ep_stg3  (id bigint,externalid bigint,status bigint);
\COPY tmp_ep_stg3 FROM 'tmp_ep_stg3.csv' DELIMITER ',' CSV HEADER ;


select count(distinct cb.contenttypeid) from cb.contentdeployment cb
left outer join (select id,externalid,case when status=64 then 'DEPLOYED' else 'NOT_DEPLOYED'   
end status from tmp_ep_stg3  where externalid is not null) ep on ep.externalid=cb.contenttypeid
where coalesce(cb.statuscode,'')='DEPLOYED' and ep.externalid is null;


update cb.contentdeployment
set statuscode='NOT_DEPLOYED'
where contenttypeid in (select distinct cb.contenttypeid from cb.contentdeployment cb
left outer join (select id,externalid,case when status=64 then 'DEPLOYED' else 'NOT_DEPLOYED'   
end status from tmp_ep_stg3  where externalid is not null) ep on ep.externalid=cb.contenttypeid
where coalesce(cb.statuscode,'')='DEPLOYED' and ep.externalid is null
);

--test
--EP (few has  FAILED   | NOT_DEPLOYED ok )


\copy (select t.id,t.externalid,t.status from test t inner join ( select max(id) id ,externalid from test group by externalid) tm on tm.id=t.id ) to 'tmp_ep_stg4.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--CB
create  temp table  tmp_ep_stg4  (id bigint,externalid bigint,status bigint);
\COPY tmp_ep_stg4 FROM 'tmp_ep_stg4.csv' DELIMITER ',' CSV HEADER ;


select  coalesce(cb.statuscode,'') ,coalesce(ep.status,'')  from cb.contentdeployment cb
inner join (select id,externalid,case when status=64 then 'DEPLOYED' else 'NOT_DEPLOYED'
end status from tmp_ep_stg4  where externalid is not null) ep on ep.externalid=cb.contenttypeid
where coalesce(cb.statuscode,'') <>coalesce(ep.status,'') ;


--- test collection compare 
--CB


select testcollectionid,t.name tcname,gc.name grade,ca.name contentarea,stt.name gradeband
into temp tc_cb from cb.testcollection t
left outer join cb.gradecourse gc on t.gradecourseid=gc.gradecourseid and t.organizationid=gc.organizationid and gc.inuse is true 
left outer join cb.contentarea ca on t.contentareaid=ca.contentareaid and t.organizationid=ca.organizationid and ca.inuse is true 
left outer join cb.systemrecord stt on stt.id=t.gradebandid  and stt.inuse is true
where t.inuse is true;


\copy (select * from tc_cb) to 'tc_cb.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--EP

create  temp table  tc_cb  (testcollectionid bigint,tcname text,grade text,contentarea text,gradeband text);
\COPY tc_cb FROM 'tc_cb.csv' DELIMITER ',' CSV HEADER 

select t.id testcollectionid,t.externalid,t.name tcname,gc.name grade,ca.name contentarea,stt.name gradeband
into temp tc_ep
 from testcollection t
left outer join gradecourse gc on t.gradecourseid=gc.id 
left outer join contentarea ca on t.contentareaid=ca.id 
left outer join gradeband stt on stt.id=t.gradebandid  
where t.activeflag is true;



select ep.externalid,coalesce(ep.tcname,''),coalesce(cb.tcname,''),
coalesce(ep.grade,''),coalesce(cb.grade,'')
-- select count(*) 
from tc_ep ep
 join tc_cb cb on ep.externalid=cb.testcollectionid  
 where coalesce(ep.tcname,'')<>coalesce(cb.tcname,'') or 
 coalesce(ep.grade,'')<>coalesce(cb.grade,'') or
 coalesce(ep.contentarea,'')<>coalesce(cb.contentarea,'');

begin;
update testcollection 
set externalid=externalid+1000000
where externalid in (select ep.externalid 
from tc_ep ep
 join tc_cb cb on ep.externalid=cb.testcollectionid  
 where coalesce(ep.tcname,'')<>coalesce(cb.tcname,'') or 
 coalesce(ep.grade,'')<>coalesce(cb.grade,'') or
 coalesce(ep.contentarea,'')<>coalesce(cb.contentarea,''));

 commit;



--compare the stage name should stage1=stage1 ( ep stage.externalid=cb.systemrecord.id)

--cb
select id,name,abbreviation from cb.systemrecord where type='STAGE' order by id;
--EP
select * from stage;


begin;
delete from stage where id=10 and code='Plcmt';
commit;



-- innovativetaskpackagepath compare 
select taskvariantid,innovativetaskpackagepath from cb.taskvariant where innovativetaskpackagepath IS NOT NULL;
\copy (select taskvariantid,innovativetaskpackagepath from cb.taskvariant where innovativetaskpackagepath IS NOT NULL) to 'cb_data.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

create  temp table  cb_data  (taskvariantid bigint,idata text );
\COPY cb_data FROM 'cb_data.csv' DELIMITER ',' CSV HEADER ;


select count(*) from taskvariant tv
inner join (select max(id ) id,externalid  from taskvariant ep  group by externalid) epmax on epmax.id=tv.id
inner join cb_data cb on cb.taskvariantid=tv.externalid 
where tv.innovativeitempackagepath<>cb.idata;


begin;

update taskvariant tvup
set innovativeitempackagepath =tmp.idata
from (select tv.id,idata from taskvariant tv
inner join (select max(id ) id,externalid  from taskvariant ep  group by externalid) epmax on epmax.id=tv.id
inner join cb_data cb on cb.taskvariantid=tv.externalid 
where tv.innovativeitempackagepath<>cb.idata) tmp
where tvup.id=tmp.id;


update taskvariant tv
set innovativeitempackagepath =cb.idata,modifieddate=now()
from cb_data cb where cb.taskvariantid=tv.externalid 
and  tv.innovativeitempackagepath<>cb.idata;

delete from testjson;	
commit;
