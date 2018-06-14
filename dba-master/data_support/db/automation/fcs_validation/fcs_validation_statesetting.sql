--1.a:Validation: Find mismatch setting for state and student level
-- \f ',' \a  \o 'validation_statesetting.csv' 
select o.organizationname,sv.studentid,sv.id surveyid,
fcss.scienceflag statescienceflag,includescienceflag studentscienceflag,
case when  cafcss.categorycode='ALL_QUESTIONS' then true else false end stateallquestionsflag,sv.allquestionsflag studentallquestionsflag,
fcss.categoryid stateoption,sv.lasteditedoption studentlastoption
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017 and 
(coalesce(sv.includescienceflag,'f')<>coalesce(fcss.scienceflag,'f') or                                   
 coalesce(sv.lasteditedoption,0)<>coalesce(fcss.categoryid,0) or                                         
 coalesce(sv.allquestionsflag,'f')<> case when  cafcss.categorycode='ALL_QUESTIONS' then true else false end
);

--1.b:Validation: Find incomplete pages and status in completed
-- \f ',' \a  \o 'validation_incomplete.csv' 
select o.organizationname,sv.studentid,sv.id surveyid,sp.id pageid,sp.globalpagenum,ca.categorycode
from survey sv
inner join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category ca                     on ca.id=sv.status 
where e.currentschoolyear=2017  
and sp.iscompleted is false and ca.categorycode in ('READY_TO_SUBMIT','COMPLETE');

--1.c:Validation: Find mismatch active survey pages count and survey count
with sv_cnt as
(
select count(distinct s.id) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017 --and cafcss.categorycode='ALL_QUESTIONS'
)
,sp_cnt as
(
select sp.globalpagenum,count(distinct s.id) cnt
from survey sv
inner join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017 
and sp.globalpagenum between 1 and 15 --and cafcss.categorycode='ALL_QUESTIONS'
group by sp.globalpagenum
)
select sp_cnt.globalpagenum 
,sp_cnt.cnt page_count
,sv_cnt.cnt survey_count from sp_cnt
cross join sv_cnt;

--1.d:Validation: Find mismatch active survey pages count and survey count for Sci
with sv_cnt as
(
select count(distinct s.id) cnt
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017 --and cafcss.categorycode='ALL_QUESTIONS'
and fcss.scienceflag is true 
)
,sp_cnt as
(
select sp.globalpagenum,count(distinct s.id) cnt
from survey sv
inner join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017  --and cafcss.categorycode='ALL_QUESTIONS'
and fcss.scienceflag is true and sp.globalpagenum =16
group by sp.globalpagenum
)
select sp_cnt.globalpagenum 
,sp_cnt.cnt page_count
,sv_cnt.cnt survey_count from sp_cnt
cross join sv_cnt;

--1.e:Validation: Find mismatch on Sci page active Sci pages and state Sci flag false
select o.organizationname,sv.studentid,sv.id surveyid,
fcss.scienceflag statescienceflag,includescienceflag studentscienceflag,
sp.globalpagenum,sp.globalpagenum
from survey sv
inner join surveypagestatus sp             on sp.surveyid=sv.id 
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017  --and cafcss.categorycode='ALL_QUESTIONS'
and fcss.scienceflag is false and sp.globalpagenum =16 and sp.activeflag is true ;

--1.f:validation: Find the non-mandatory pages is completed set false in CORE_SET_QUESTIONS (only for 1,2,3,4,5,10,11)
select sv.id surveyid,sp.globalpagenum,sp.id pageid,o.id stateid,s.id studentid
from survey sv
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
inner join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true
where e.currentschoolyear=2017
and cafcss.categorycode='CORE_SET_QUESTIONS' 
and sp.globalpagenum not in (select distinct globalpagenum from surveylabel where activeflag is true  and optional is false)
and iscompleted is false;

--1.g find the missnig 15 page not in inprogess (this update move to page 15)
select count(*)
from survey sv
left outer join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true and sp.globalpagenum = 15
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017 
and sp.surveyid is null and sv.status<>223


--1.i:Validation: Find all completed pages and status in inprogress -- (update to 522 this script need to run end)
with src_all as
(
select sv.id surveyid,ca.categorycode
from survey sv
inner join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category ca                     on ca.id=sv.status 
where e.currentschoolyear=2017  
and ca.categorycode ='IN_PROGRESS'
and sp.globalpagenum <= case when fcss.scienceflag is false then 15 else 16 end
group by sv.id,ca.categorycode
)
,tgt_all as 
(
select sv.id surveyid
from survey sv
inner join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category ca                     on ca.id=sv.status 
where e.currentschoolyear=2017  
and sp.iscompleted is false
and sp.globalpagenum <= case when fcss.scienceflag is false then 15 else 16 end
group by sv.id
)
select sv.id from survey sv 
inner join src_all src on src.surveyid=sv.id
left outer join tgt_all tgt on tgt.surveyid=sv.id
where tgt.surveyid is null and sv.status =223; 


