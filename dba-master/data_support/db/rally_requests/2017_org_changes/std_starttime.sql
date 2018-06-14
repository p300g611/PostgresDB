--From EP
select ca.categorycode,sts.status,count(sts.*) from studentstests sts 
join testsession ts on ts.id=sts.testsessionid 
join category ca on ca.id=sts.status 
where sts.activeflag is true and sts.status in (582,495,659,489,86,85) 
and startdatetime is null and ts.operationaltestwindowid in (10172,10174) group by ca.categorycode,sts.status;



--1.1. Validation:Find the studentstests for startdatetime is null
with std as (
select st.studentid,st.id studentstestsid,min(sr.createddate) sr_createddate from studentstests st 
inner join testsession ts on ts.id=st.testsessionid 
inner join category ca on ca.id=st.status
inner join studentsresponses sr on  sr.studentid=st.studentid and sr.studentstestsid=st.id
where st.activeflag is true and st.status in (582,495,659,489,86,85) 
and st.startdatetime is null and ts.operationaltestwindowid in (10172,10174)
group by st.studentid,st.id
)
select studentid,studentstestsid,sr_createddate,sr_createddate-interval '90 sec'  
from std;


select ca.categorycode,st.status,st.id,st.createddate,st.enddatetime,st.startdatetime,action from studentstests st
inner join testsession ts on ts.id=st.testsessionid
inner join category ca on ca.id=st.status
left outer join studentstestshistory sth on sth.studentstestsid=st.id
left outer join studentsresponses sr on  sr.studentid=st.studentid and sr.studentstestsid=st.id
where st.activeflag is true and st.status in (582,495,659,489,86,85)  and sr.studentid is null --and st.enddatetime is not null
and st.startdatetime is null and ts.operationaltestwindowid in (10172,10174) order by st.createddate;

--1.2 Update:Find the studentstests for startdatetime is null
begin;
with std as (
select st.studentid,st.id studentstestsid,min(sr.createddate) sr_createddate from studentstests st 
inner join testsession ts on ts.id=st.testsessionid 
inner join category ca on ca.id=st.status
inner join studentsresponses sr on  sr.studentid=st.studentid and sr.studentstestsid=st.id
where st.activeflag is true and st.status in (582,495,659,489,86,85) 
and st.startdatetime is null and ts.operationaltestwindowid in (10172,10174)
group by st.studentid,st.id)
update studentstests src
set startdatetime =sr_createddate-interval '90 sec'
from std tgt where src.studentid=tgt.studentid and src.id=tgt.studentstestsid;
commit;
