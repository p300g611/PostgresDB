--  NOT_DEPLOYED
--  IN_PROGRESS
--  IN_QUEUE_UNDEPLOY
--  FAILED
--  DEPLOYED
--  IN_QUEUE_DEPLOY


BEGIN;

--EP
 select id,externalid ,status,modifieddate from test where externalid= 18476  order by id desc ;
--CB
 select * from cb.contentdeployment where contenttypeid=18476;

 begin;
-- scenarion1:: id EP last status in deployed and CB inprogress 
 update cb.contentdeployment
 set statuscode='DEPLOYED'
 where contenttypeid=18476;
-- UI step:unpblish and re-publish

--scenarion2:: id EP last status in undeployed and CB inprogress/failed
 select * from cb.contentdeployment where contenttypeid=18576;
 update cb.contentdeployment
 set statuscode='IN_QUEUE_DEPLOY'
 where contenttypeid=18576;

-- UI step:not required
 commit;

--count validation:optinal
 select t.id,t.externalid,t.status,t.modifieddate,count(st.studentid)  from studentstests st
 inner join test t on t.id=st.testid
 where t.externalid in (18091,18485,18560,18611,18614,18690,18692) and st.activeflag is true
 group by t.id,t.externalid,t.status,t.modifieddate
 order by t.externalid,t.id desc;


--status changed:
--01/27/2017

-- 18481
-- 18573
-- 18576
-- 18674
-- 18675
-- 18680--inque
-- 18684
-- 18462
-- 18475
-- 18690
-- 18206
-- 18470
-- 18328
-- 18473
-- 18476

--02/01/2017
 18609,18612,18618,18619,18616 - in queue deployed
 18091,18485,18560,18611,18614,18690,18692 - deployed
 





 