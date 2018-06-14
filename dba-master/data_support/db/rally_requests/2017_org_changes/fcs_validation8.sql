/*
-- testing
select labelnumber,globalpagenum,optional  from surveylabel  sl 
where activeflag is true and  optional is false ; 

select count(*) from survey sv
cross join surveylabel  sl 
where sl.activeflag is true and sl.optional is false ; 

select globalpagenum,count(*) from surveypagestatus sp
where activeflag is true
group by globalpagenum
order by 1;

with all_ques as
(
select sv.id,labelnumber,globalpagenum,optional
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true --and optional is true 
)
select count(*) from all_ques limit 100;
*/
----------------------------------------------------------------------------------------------------------------
-- find the unanswered questions for all is completed true


with all_ques as
(
select sv.id,labelnumber,globalpagenum
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,labelnumber,globalpagenum
)
,all_answ as
(
 select o.organizationname,sv.id surveyid,sp.id pageid,sp.globalpagenum,sl.labelnumber from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id and sl.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017
 and sl.globalpagenum between 1 and 15
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 and sp.iscompleted is true
 group by o.organizationname,sv.id,sp.id,sp.globalpagenum,sl.labelnumber 
)
select distinct tgt.id surveyid,tgt.globalpagenum 
--select tgt.globalpagenum,count(distinct tgt.id)
from all_ques tgt
left outer join all_answ src on tgt.id=src.surveyid and tgt.labelnumber=src.labelnumber
where src.labelnumber is null


--group by tgt.globalpagenum;


-- from the above script we will find by surveyid,pagenum were not answered for mandatory questions.
-- need to find out if this ok for all update iscompleted to false for sci and other (1-15)pages
-- one of the example from prod 23931=surveyid page 2 last yaer he is in core set now swith to all question -IA and unanswered page2.

--  globalpagenum | count
-- ---------------+-------
--              1 |  1076
--              2 |  6921
--              3 |  6921
--              4 |  6916
--              5 |  6921
--              6 |  4408
--              7 | 16185
--              8 | 13690
--              9 | 16534
--             10 |   516
--             11 |  3663
--             12 |   595
--             13 |    73
--             14 |   605
--             15 |  2511
-- (15 rows)

-- globalpagenum | count
-- ---------------+-------
--             16 |  4618
-- (1 row)

------------------------------------------------------------------------------------------------------------------------
/*
--example
SELECT  distinct ssr.id,ssr.activeflag ,sr.activeflag,s.id, --ssr.createddate, ssr.modifieddate,
        sl.labelnumber AS "Survey Label Number"
--         sr.responsevalue  AS "Survey Response"
       -- ,sr.responseorder
       ,sp.globalpagenum,sl.optional
      -- ,sp.*
       ,ssr.activeflag,sr.activeflag
 FROM student s
 JOIN enrollment AS e  ON (e.studentid = s.id)
 JOIN survey sv ON s.id = sv.studentid
 JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid --and ssr.activeflag is true
 JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id --and sr.activeflag is true
 JOIN surveylabel sl ON sr.labelid = sl.id 
 left outer join Surveypagestatus sp on sp.surveyid=sv.id and sp.globalpagenum =sl.globalpagenum
 WHERE  sv.id=23931 and sp.globalpagenum in (2) and sl.optional is false 
 order by 3;


select sl.labelnumber,globalpagenum,optional from surveylabel  sl 
left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
where  sl.globalpagenum=2
order by 1;

*/

----------------------------------------------------------------------------------------------------------------
-- find the mandatory question are answred


with all_ques as
(
select sv.id,labelnumber,globalpagenum
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,labelnumber,globalpagenum
)
,all_answ as
(
 select o.organizationname,sv.id surveyid,sp.id pageid,sp.globalpagenum,sl.labelnumber from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id and sl.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017
 and sl.globalpagenum between 1 and 15
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 and sp.iscompleted is true
 group by o.organizationname,sv.id,sp.id,sp.globalpagenum,sl.labelnumber 
)
select * from surveypagestatus sp 
left outer join (select distinct tgt.id surveyid,tgt.globalpagenum 
--select tgt.globalpagenum,count(distinct tgt.id)
from all_ques tgt
left outer join all_answ src on tgt.id=src.surveyid and tgt.labelnumber=src.labelnumber
where src.labelnumber is null) fal on sp.surveyid=fal.surveyid and fal.globalpagenum=sp.globalpagenum
where fal.globalpagenum is null and iscompleted is false;
--------------------------------------------------------------
-- find any mandatory questions unanswered and status not in progress
with all_ques as
(
select sv.id,labelnumber,globalpagenum
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,labelnumber,globalpagenum
)
,all_answ as
(
 select o.organizationname,sv.id surveyid,sp.id pageid,sp.globalpagenum,sl.labelnumber from survey sv
 inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
 inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
 inner join organization o on s.stateid=o.id and o.activeflag is true
 inner join organization o1 on e.attendanceschoolid=o1.id and o1.activeflag is true
 inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
 inner JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid and ssr.activeflag is true
 inner JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id and sr.activeflag is true
 inner JOIN surveylabel sl ON sr.labelid = sl.id and sl.activeflag is true
 inner join surveypagestatus sp on sp.surveyid=sv.id and sl.globalpagenum=sp.globalpagenum and sp.activeflag is true
 inner join category ca on ca.id = sv.status
 where e.currentschoolyear=2017 and fcss.schoolyear=2017
 and sl.globalpagenum between 1 and 15
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 and sp.iscompleted is true
 group by o.organizationname,sv.id,sp.id,sp.globalpagenum,sl.labelnumber 
)
select ca.categorycode,count(distinct sv.id) from survey sv 
inner join category ca on ca.id = sv.status
inner join (select distinct tgt.id
from all_ques tgt
left outer join all_answ src on tgt.id=src.surveyid and tgt.labelnumber=src.labelnumber
where src.labelnumber is null) tmp on tmp.id=sv.id
group by ca.categorycode;
--  categorycode   | count
-- -----------------+-------
--  COMPLETE        |  8705
--  READY_TO_SUBMIT |  4132
--  IN_PROGRESS     |  4771
-- (3 rows)
--for sci 
--  categorycode | count
-- --------------+-------
--  COMPLETE     |     4
--  IN_PROGRESS  |  4589
-- (2 rows)
--------------------------------------------------------------
-- it is required for all.
-- c.If any of the page status (active) entries iscompleted flag is false including science page, then the FCS survey status should be “In Progress”. 

--- find all status
select ca.categorycode,count(distinct sv.id)
from survey sv
inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join category ca on ca.id = sv.status
where e.currentschoolyear=2017 and fcss.schoolyear=2017 --and sp.iscompleted is false 
group by ca.categorycode;

-- find all status for iscompleted is false
select sv.status,ca.categorycode,count(distinct sv.id)
from survey sv
inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join category ca on ca.id = sv.status
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false 
group by sv.status,ca.categorycode;


-- find all status for iscompleted is false and update to inprogress
select ca.categorycode,count(distinct sv.id)
from survey sv
inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join category ca on ca.id = sv.status
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false --and status<>223
group by ca.categorycode;

-- Rajendra : This script is good.
-- update script : uncomment if want to run this after validation
-- datateam : script executed on stage
-- UPDATE 0

begin;
update survey
set status =223,
    modifieddate=now(),
    modifieduser=12
where id in (   
select distinct sv.id   
from survey sv
inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join category ca on ca.id = sv.status
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false and status<>223);
 commit;
----------------------------------------------------------------------------------------------------------
--This is just for validation if all iscompleted is true the what is the status
with svid_false as
(
select distinct sv.id
from survey sv
inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join category ca on ca.id = sv.status
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sp.iscompleted is false --and status<>223
)
select ca.categorycode,count(distinct sv.id) 
from survey sv
inner join surveypagestatus sp on sp.surveyid=sv.id and sp.activeflag is true
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
inner join category ca on ca.id = sv.status
left outer join svid_false f on f.id=sv.id
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and f.id is null 
group by sv.status,ca.categorycode;
------------------------------------------------------------------------------------------------------------

