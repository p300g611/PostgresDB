--1.e:Validation: Find mismatch on Sci page active Sci pages and state Sci flag false
update surveypagestatus
set activeflag=false,
    modifieddate=now(),
    modifieduser=12
where id in (
select sp.id
from survey sv
inner join surveypagestatus sp             on sp.surveyid=sv.id 
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017  --and cafcss.categorycode='ALL_QUESTIONS'
and fcss.scienceflag is false and sp.globalpagenum =16 and sp.activeflag is true
);

--1.f:validation: Find the non-mandatory pages is completed set false in CORE_SET_QUESTIONS (only for 1,2,3,4,5,10,11)
update surveypagestatus
set iscompleted =true,
    modifieddate=now(),
    modifieduser=12
where id in (
select sp.id
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
and iscompleted is false
);

--1.b:Validation: Find incomplete pages and status in completed
update survey
set status =223,
    modifieddate=now(),
    modifieduser=12
where id in (   
select sv.id 
from survey sv
inner join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category ca                     on ca.id=sv.status 
where e.currentschoolyear=2017  
and sp.iscompleted is false and ca.categorycode in ('READY_TO_SUBMIT','COMPLETE'));


-- page 15 insert for missing pages(need to run this first)
insert into surveypagestatus 
(iscompleted,surveyid,globalpagenum,createddate,createduser,activeflag,modifieddate,modifieduser)
select 
false iscompleted, src.surveyid surveyid,15 globalpagenum,now() createddate,
12 createduser,true activeflag,now() modifieddate,12 modifieduser 
from surveypagestatus  src 
left outer join surveypagestatus tgt on src.surveyid=tgt.surveyid and tgt.globalpagenum=15
where src.globalpagenum=14 and tgt.surveyid is null;

-- page 16 insert for missing pages(need to run this first)
insert into surveypagestatus 
(iscompleted,surveyid,globalpagenum,createddate,createduser,activeflag,modifieddate,modifieduser)
select distinct 
false iscompleted, sv.id surveyid,16 globalpagenum,now() createddate,
12 createduser,true activeflag,now() modifieddate,12 modifieduser 
from survey sv
left outer join surveypagestatus sp             on sp.surveyid=sv.id and sp.activeflag is true and sp.globalpagenum =16
inner join student s                       on s.id=sv.studentid and s.activeflag is true and sv.activeflag is true
inner JOIN enrollment e                    ON e.studentid = s.id and e.activeflag is true
inner join organization o                  on s.stateid=o.id and o.activeflag is true
inner join organizationtreedetail ot       on ot.schoolid=e.attendanceschoolid and ot.stateid=o.id 
inner join firstcontactsurveysettings fcss on fcss.organizationid=o.id and fcss.activeflag is true and e.currentschoolyear=fcss.schoolyear
inner join category cafcss                 on fcss.categoryid=cafcss.id 
where e.currentschoolyear=2017  --and cafcss.categorycode='ALL_QUESTIONS'
and fcss.scienceflag is true and sp.id is null;


--1.i:Validation: Find all completed pages and status in inprogress -- (update to 522 this script need to run end)
update survey
set status =522,
    modifieddate=now(),
    modifieduser=12
where id in (
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
where tgt.surveyid is null and sv.status =223);
