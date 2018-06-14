-- -- see this example if page 12 que are all madatory  ( do not  have sub-madatory que ) -- this apply for only if all questions displayed directly.
-- select * from student  where statestudentidentifier  ='47856412';
-- select * from survey  where studentid=1324300;
-- 
-- --example 
-- SELECT  distinct ssr.id,ssr.activeflag ,sr.activeflag,s.id, --ssr.createddate, ssr.modifieddate,--131089
--         sl.labelnumber AS "Survey Label Number"
-- --         sr.responsevalue  AS "Survey Response"
--        -- ,sr.responseorder
--        ,sp.globalpagenum,sl.optional
--       -- ,sp.*
--  FROM student s
--  JOIN enrollment AS e  ON (e.studentid = s.id)
--  JOIN survey sv ON s.id = sv.studentid
--  JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid --and ssr.activeflag is true
--  JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id --and sr.activeflag is true
--  JOIN surveylabel sl ON sr.labelid = sl.id 
--  left outer join Surveypagestatus sp on sp.surveyid=sv.id and sp.globalpagenum =sl.globalpagenum
--  WHERE  sv.id=8040 and sp.globalpagenum in (12) --and sl.optional is false 
--  order by 3;
-- 
-- -- update studentsurveyresponse
-- -- set activeflag=false
-- -- where id =521336
-- 
-- select * from surveypagestatus  where surveyid =8040
-- -- update surveypagestatus
-- -- set iscompleted=true
-- -- where id =157702
-- select sl.labelnumber,globalpagenum,optional,label::char(10) from surveylabel  sl 
-- left outer join surveylabelprerequisite slp on slp.surveylabelid=sl.id 
-- where  sl.globalpagenum=12
-- order by 1;

 --new***********************************************************************************************************
  -- 12.a find the madatory questions not answered and is completed true (note count zero for now)--12
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=12 --testing for 12th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=12
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
--  and sv.id=131089
 group by sv.id,sp.globalpagenum
)
select count(distinct tgt.surveyid)
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=12  --and sp.surveyid=8040
and coalesce(src.cnt,0)<>coalesce(tgt.cnt,0) and sp.iscompleted is true;  


begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=12 --testing for 12th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=12
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
--  and sv.id=131089
 group by sv.id,sp.globalpagenum
)
select distinct sp.id
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=12  --and sp.surveyid=8040
and coalesce(src.cnt,0)<>coalesce(tgt.cnt,0) and sp.iscompleted is true
);
commit;


 --new***********************************************************************************************************
 -- 12.b all madatory questions answered and is completed false (note count zero for now)
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=12 --testing for 12th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=12
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
 --and sv.id=131089
 group by sv.id,sp.globalpagenum
)
select count(distinct tgt.surveyid)
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=12 
and coalesce(src.cnt,0)=coalesce(tgt.cnt,0) and sp.iscompleted is false;

begin;
update surveypagestatus
set iscompleted =true,
    modifieddate=now(),
    modifieduser=12
where surveyid in (
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=12 --testing for 12th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=12
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
 --and sv.id=131089
 group by sv.id,sp.globalpagenum
)
select distinct sp.id
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=12 
and coalesce(src.cnt,0)=coalesce(tgt.cnt,0) and sp.iscompleted is false
)
commit; 


 --new***********************************************************************************************************
  -- 10.a find the madatory questions not answered and is completed true (note count zero for now)--10
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=10 --testing for 10th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=10
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
--  and sv.id=131089
 group by sv.id,sp.globalpagenum
)
select sp.id
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=10  --and sp.surveyid=8040
and coalesce(src.cnt,0)<>coalesce(tgt.cnt,0) and sp.iscompleted is true;  


begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=10 --testing for 10th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=10
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
--  and sv.id=131089
 group by sv.id,sp.globalpagenum
)
select distinct sp.id
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=10  --and sp.surveyid=8040
and coalesce(src.cnt,0)<>coalesce(tgt.cnt,0) and sp.iscompleted is true
);
commit;


 --new***********************************************************************************************************
 -- 10.b all madatory questions answered and is completed false (note count zero for now)
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=10 --testing for 10th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=10
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
 --and sv.id=131089
 group by sv.id,sp.globalpagenum
)
select count(distinct tgt.surveyid)
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=10 
and coalesce(src.cnt,0)=coalesce(tgt.cnt,0) and sp.iscompleted is false;

begin;
update surveypagestatus
set iscompleted =true,
    modifieddate=now(),
    modifieduser=12
where id in (
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=10 --testing for 10th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=10
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
 --and sv.id=131089
 group by sv.id,sp.globalpagenum
)
select distinct sp.id
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=10 
and coalesce(src.cnt,0)=coalesce(tgt.cnt,0) and sp.iscompleted is false
)
commit; 

 --new***********************************************************************************************************
  -- 14.a find the madatory questions not answered and is completed true (note count zero for now)--14
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=14 --testing for 14th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=14
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
--  and sv.id=131489
 group by sv.id,sp.globalpagenum
)
select count(distinct tgt.surveyid)
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=14  --and sp.surveyid=8040
and coalesce(src.cnt,0)<>coalesce(tgt.cnt,0) and sp.iscompleted is true;  


begin;
update surveypagestatus
set iscompleted =false,
    modifieddate=now(),
    modifieduser=12
where id in (
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=14 --testing for 14th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=14
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
--  and sv.id=131489
 group by sv.id,sp.globalpagenum
)
select distinct sp.id
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=14  --and sp.surveyid=8040
and coalesce(src.cnt,0)<>coalesce(tgt.cnt,0) and sp.iscompleted is true
);
commit;


 --new***********************************************************************************************************
 -- 14.b all madatory questions answered and is completed false (note count zero for now)
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=14 --testing for 14th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=14
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
 --and sv.id=131489
 group by sv.id,sp.globalpagenum
)
select count(distinct tgt.surveyid)
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=14 
and coalesce(src.cnt,0)=coalesce(tgt.cnt,0) and sp.iscompleted is false;

begin;
update surveypagestatus
set iscompleted =true,
    modifieddate=now(),
    modifieduser=12
where id in (
with all_ques as
(
select sv.id surveyid,globalpagenum,count(distinct labelnumber) cnt
from survey sv
inner join student s on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment AS e  ON e.studentid = s.id and e.activeflag is true
inner join organization o on s.stateid=o.id and o.activeflag is true
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true
cross join surveylabel  sl 
where e.currentschoolyear=2017 and fcss.schoolyear=2017 and sl.activeflag is true 
and optional= case when fcss.categoryid=567 then 'f' else optional end
and sl.globalpagenum between 1 and 15 and sl.globalpagenum=14 --testing for 14th page
--and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
group by  sv.id,globalpagenum
)
,all_answ as
(
 select sv.id surveyid,sp.globalpagenum,count(distinct sl.labelnumber) cnt from survey sv
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
 and sl.globalpagenum between 1 and 15 and sl.globalpagenum=14
 --and fcss.scienceflag is true and sl.globalpagenum =16  --uncomment this line comment above line if wnat test only sci
 --and sp.iscompleted is true
 --and sv.id=131489
 group by sv.id,sp.globalpagenum
)
select distinct sp.id
-- select tgt.*,src.*,sp.surveyid,sp.globalpagenum
from all_ques tgt
inner join surveypagestatus sp on sp.surveyid=tgt.surveyid and tgt.globalpagenum=sp.globalpagenum and sp.activeflag is true
left outer join all_answ src on tgt.surveyid=src.surveyid and tgt.globalpagenum=src.globalpagenum
where  tgt.globalpagenum=14 
and coalesce(src.cnt,0)=coalesce(tgt.cnt,0) and sp.iscompleted is false
);
commit; 
 