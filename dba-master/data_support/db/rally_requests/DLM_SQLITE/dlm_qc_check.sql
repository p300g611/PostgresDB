--1) Validation for masterpull_item
--DE17012: Missing educator information
select count(distinct id) from masterpull_item where educatorkiteid is null and teststatus is not null;

--DE17011: Duplicate item records 2018-03-15
select id,taskvariantid,nodecode,count(*) from masterpull_item
where taskvariantid is not null
group by id,taskvariantid,nodecode
having count(*)>1;

-- select id,taskvariantid,nodecode,createddate,count(*) from masterpull_item
-- where taskvariantid is not null
-- group by id,taskvariantid,nodecode,createddate
-- having count(*)>1;

--DE17025: Need to verify any new windowids has been created. 
select * from masterpull_item where source='ITI' and window<>'ITI';
select * from masterpull_item where source='ITI' and window='Spring';

--select distinct studentid,grade,itemgrade from masterpull_item where grade<>itemgrade limit 100;  --grade band tests are showing
--select distinct studentid,grade,itemgrade from masterpull_item where grade<>itemgrade limit 10;  
select distinct grade,itemgrade from masterpull_item where grade<>itemgrade;   --Need to see if any grade outside of the gradebands 


--testssession counts decreases validation 17 and 39 
-- Duplicates rosters ckeck
select id,contentareaname,count(distinct educatorstateid) from masterpull_item 
where contentareaname is not null
group by id,contentareaname
having count(distinct educatorstateid)>1;

-- Tests counts ckeck for validation 17 and 39
-- Before fix copy the files to archive location S:\ATS001\DBA\archive_ValidationLists
-- count the noof tests completed in SQLite script and compare with day after sqlite --using below script
/*
select id,teststatus,contentareaname,count(*) from masterpull_item 
where id in (1406070,1206937,1406068)
group by id,teststatus,contentareaname;
*/
--2) Validation for masterpull_dcps

select count(distinct id) from masterpull_dcps where educatorkiteid is null and teststatus is not null;

--DE17011: Duplicate item records 2018-03-15
select id,taskvariantid,nodecode,count(*) from masterpull_dcps
where taskvariantid is not null
group by id,taskvariantid,nodecode
having count(*)>1;

-- select id,taskvariantid,nodecode,createddate,count(*) from masterpull_dcps
-- where taskvariantid is not null
-- group by id,taskvariantid,nodecode,createddate
-- having count(*)>1;

--DE17025: Need to verify any new windowids has been created. 
--select * from masterpull_dcps where source='ITI' and window<>'ITI';
--select * from masterpull_dcps where source='ITI' and window='Spring';

--select distinct studentid,grade,itemgrade from masterpull_dcps where grade<>itemgrade limit 100;  --grade band tests are showing
--select distinct studentid,grade,itemgrade from masterpull_dcps where grade<>itemgrade limit 10;  
--select distinct grade,itemgrade from masterpull_dcps where grade<>itemgrade;   --Need to see if any grade outside of the gradebands 


--testssession counts decreases validation 17 and 39 
-- Duplicates rosters ckeck
select id,contentareaname,count(distinct educatorstateid) from masterpull_dcps 
where contentareaname is not null
group by id,contentareaname
having count(distinct educatorstateid)>1;


---EP check 
--duplicate tests
--https://code.cete.us/svn/dlm/aart/trunk/aart-web-dependencies/data_support/db/rally_requests/2018_org_changes/DLM_fieldtest_duplicates.sql


