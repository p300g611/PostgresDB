--calculate the number from ep

select assessmentprogramid, contentareaid, count(distinct studentid)from
studentreport 
where schoolyear=2018 and assessmentprogramid in (12,47) and generated is true and stateid =51
group by assessmentprogramid,contentareaid

-----
 assessmentprogramid │ contentareaid │ count  │
├─────────────────────┼───────────────┼────────┤
│                  12 │             3 │ 262888 │
│                  12 │           440 │ 263259 │
│                  12 │           441 │ 110794 │
│                  47 │           451 │  51150 │
└─────────────────────┴───────────────┴────────┘
--
select ca.abbreviatedname,
count(case when sr.generated is true and sr.modifieddate > now() - interval '10 seconds' then sr.id else null end) as last_10_sec,
count(distinct case when sr.generated is true then sr.studentid else null end) as generated,
count(distinct sr.studentid) as total,
round(((count(case when sr.generated is true then sr.id else null end)::numeric / count(sr.id)::numeric) * 100), 3) as percent,
min(sr.modifieddate), max(sr.modifieddate)
from studentreport sr
join contentarea ca on sr.contentareaid = ca.id
where sr.schoolyear = 2018
--and sr.assessmentprogramid = 12
and sr.stateid=51
--and sr.contentareaid = 441
group by ca.abbreviatedname order by ca.abbreviatedname ;


--calculate  the number of students assigned and students all sessions complete  in dashboard
select assessmentprogram, assessmentprogramid, contentarea, contentareaid,
sum(countsessionscompletedtoday) as countsessionscompletedtoday,
sum(countsessionscompletedlastschoolday) as countsessionscompletedlastschoolday, 
sum(countsessionscompletedthisyear) as countsessionscompletedthisyear,
sum(countstudentsassignedthisyear) as countstudentsassignedthisyear, 
sum(countstudentscompletedthisyear) as countstudentscompletedthisyear,
sum(countreactivatedlastschoolday) as countreactivatedlastschoolday, 
sum(countreactivatedthisyear) as countreactivatedthisyear, modifieddate, statename, stateid
from dashboardtestingsummary 
where status = 'COMPLETE'  and stateid=51  and assessmentprogramid = ANY(ARRAY[12])
group by assessmentprogram, assessmentprogramid, contentarea,  contentareaid, statename, stateid,  modifieddate
order by assessmentprogram, assessmentprogramid, contentarea,  contentareaid, statename, stateid;
--another scritp to get same result
select ap.id,ca.abbreviatedname,count(distinct st.studentid)
from studentstests st 
inner join student  s on s.id=st.studentid
inner join enrollment e on st.enrollmentid=e.id and e.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join testsession ts on ts.id=st.testsessionid 
inner join testcollection tc on st.testcollectionid=tc.id
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT outer JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  
left outer join contentarea ca on tc.contentareaid=ca.id
left outer join gradecourse gc on tc.gradecourseid=gc.id
left outer join gradeband gb on tc.gradebandid=gb.id
where s.activeflag is true and e.activeflag is true and s.stateid=51 and  e.currentschoolyear=2018 
and ts.operationaltestwindowid in (10261,10258,10252) and ap.id in (12,47) and st.activeflag is true
group by ca.abbreviatedname,ap.id

│ id │ abbreviatedname │ count  │
├────┼─────────────────┼────────┤
│ 12 │ ELA             │ 262352 │
│ 47 │ ELP             │  50326 │
│ 12 │ M               │ 262911 │
│ 12 │ Sci             │ 110490 │
│ 12 │ SS              │ 109268 │
└────┴─────────────────┴────────┘


--kelpa count
DROP TABLE tmp_reportnumber;
with report_num as (select  st.studentid
from studentstests st 
inner join student  s on s.id=st.studentid
inner join enrollment e on st.enrollmentid=e.id and e.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join testsession ts on ts.id=st.testsessionid 
inner join testcollection tc on st.testcollectionid=tc.id
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT outer JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  
left outer join contentarea ca on tc.contentareaid=ca.id
left outer join gradecourse gc on tc.gradecourseid=gc.id
left outer join gradeband gb on tc.gradebandid=gb.id
where s.activeflag is true and e.activeflag is true and s.stateid=51 and  e.currentschoolyear=2018 
and ts.operationaltestwindowid in (10252) and ap.id in (47) and st.activeflag is true
)

select en.studentid, en.id enid, en.activeflag enflag, en.exitwithdrawaltype,ort.schoolid, ort.districtid,st.status st_status, st.activeflag stflag, ts.name
into temp tmp_reportnumber
from studentreport sr
left outer join enrollment en on  en.studentid=sr.studentid and en.id=sr.enrollmentid
left outer join organizationtreedetail ort on ort.schoolid =en.attendanceschoolid
left outer join studentstests st on st.enrollmentid=en.id
left outer join testsession ts on ts.id=st.testsessionid
where sr.schoolyear=2018 and sr.assessmentprogramid in (47) and sr.generated is true and sr.stateid =51
and ts.operationaltestwindowid in (10252)
and not exists (select 1 from report_num tmp where tmp.studentid=en.studentid)
order by en.studentid, en.id;


\copy (select * from tmp_reportnumber) to 'tmp_kelpa_number.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);


--kap number count 
DROP TABLE tmp_reportnumber;
with report_num as (select  st.studentid
from studentstests st 
inner join student  s on s.id=st.studentid
inner join enrollment e on st.enrollmentid=e.id and e.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join testsession ts on ts.id=st.testsessionid 
inner join testcollection tc on st.testcollectionid=tc.id
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT outer JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  
left outer join contentarea ca on tc.contentareaid=ca.id
left outer join gradecourse gc on tc.gradecourseid=gc.id
left outer join gradeband gb on tc.gradebandid=gb.id
where s.activeflag is true and e.activeflag is true and s.stateid=51 and  e.currentschoolyear=2018 
and ts.operationaltestwindowid in (10261) and ap.id in (12) and st.activeflag is true and ca.abbreviatedname='ELA'
)
select en.studentid, en.id enid, en.activeflag enflag,en.exitwithdrawaltype, ort.schoolid, ort.districtid,st.status st_status, st.activeflag stflag, ts.name
into temp tmp_reportnumber
from studentreport sr
left outer join enrollment en on  en.studentid=sr.studentid and en.id=sr.enrollmentid
left outer join organizationtreedetail ort on ort.schoolid =en.attendanceschoolid
left outer join studentstests st on st.enrollmentid=en.id
left outer join testsession ts on ts.id=st.testsessionid
left outer join testcollection  tc on tc.id=st.testcollectionid
left outer join contentarea ca on ca.id=tc.contentareaid
left outer join report_num tmp on tmp.studentid=sr.studentid 
where sr.schoolyear=2018 and sr.assessmentprogramid in (12) and sr.generated is true and sr.stateid =51 and sr.contentareaid=3
and ts.operationaltestwindowid in (10261) and ca.abbreviatedname ='ELA' and tmp.studentid is null
order by en.studentid, en.id;

\copy (select * from tmp_reportnumber) to 'tmp_kap_ELA_number.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);

--Kap math number
DROP TABLE tmp_reportnumber;
with report_num as (select  st.studentid
from studentstests st 
inner join student  s on s.id=st.studentid
inner join enrollment e on st.enrollmentid=e.id and e.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join testsession ts on ts.id=st.testsessionid 
inner join testcollection tc on st.testcollectionid=tc.id
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT outer JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  
left outer join contentarea ca on tc.contentareaid=ca.id
left outer join gradecourse gc on tc.gradecourseid=gc.id
left outer join gradeband gb on tc.gradebandid=gb.id
where s.activeflag is true and e.activeflag is true and s.stateid=51 and  e.currentschoolyear=2018 
and ts.operationaltestwindowid in (10261) and ap.id in (12) and st.activeflag is true and ca.abbreviatedname='M'
)
select en.studentid, en.id enid, en.activeflag enflag,en.exitwithdrawaltype, ort.schoolid, ort.districtid,st.status st_status, st.activeflag stflag, ts.name
into temp tmp_reportnumber
from studentreport sr
left outer join enrollment en on  en.studentid=sr.studentid and en.id=sr.enrollmentid
left outer join organizationtreedetail ort on ort.schoolid =en.attendanceschoolid
left outer join studentstests st on st.enrollmentid=en.id
left outer join testsession ts on ts.id=st.testsessionid
left outer join testcollection  tc on tc.id=st.testcollectionid
left outer join contentarea ca on ca.id=tc.contentareaid
left outer join report_num tmp on tmp.studentid=sr.studentid
where sr.schoolyear=2018 and sr.assessmentprogramid in (12) and sr.generated is true and sr.stateid =51 and sr.contentareaid=440
and ts.operationaltestwindowid in (10261) and ca.abbreviatedname ='M' and tmp.studentid is null
order by en.studentid, en.id;

\copy (select * from tmp_reportnumber) to 'tmp_kap_math_number.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);



--Sci number
DROP TABLE tmp_reportnumber;
with report_num as (select  st.studentid
from studentstests st 
inner join student  s on s.id=st.studentid
inner join enrollment e on st.enrollmentid=e.id and e.activeflag is true
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner join testsession ts on ts.id=st.testsessionid 
inner join testcollection tc on st.testcollectionid=tc.id
left outer join stage stg on stg.id=tc.stageid and stg.activeflag is true
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id 
left outer join testingprogram tp ON a.testingprogramid = tp.id 
LEFT outer JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id  
left outer join contentarea ca on tc.contentareaid=ca.id
left outer join gradecourse gc on tc.gradecourseid=gc.id
left outer join gradeband gb on tc.gradebandid=gb.id
where s.activeflag is true and e.activeflag is true and s.stateid=51 and  e.currentschoolyear=2018 
and ts.operationaltestwindowid in (10258) and ap.id in (12) and st.activeflag is true and ca.abbreviatedname='Sci'
)
select en.studentid, en.id enid, en.activeflag enflag,en.exitwithdrawaltype, ort.schoolid, ort.districtid,st.status st_status, st.activeflag stflag, ts.name
into temp tmp_reportnumber
from studentreport sr
left outer join enrollment en on  en.studentid=sr.studentid and en.id=sr.enrollmentid
left outer join organizationtreedetail ort on ort.schoolid =en.attendanceschoolid
left outer join studentstests st on st.enrollmentid=en.id
left outer join testsession ts on ts.id=st.testsessionid
left outer join testcollection  tc on tc.id=st.testcollectionid
left outer join contentarea ca on ca.id=tc.contentareaid
left outer join report_num tmp on tmp.studentid=sr.studentid
where sr.schoolyear=2018 and sr.assessmentprogramid in (12) and sr.generated is true and sr.stateid =51 and sr.contentareaid=441
and ts.operationaltestwindowid in (10258) and ca.abbreviatedname ='Sci' and tmp.studentid is null
order by en.studentid, en.id;

\copy (select * from tmp_reportnumber) to 'tmp_kap_Sci_number.csv' (FORMAT CSV,HEADER TRUE,FORCE_QUOTE *);


--validation the script 

select s.id studentid, s.activeflag sflag, en.id enid, en.activeflag, ort.schoolid,ort.districtid, st.id stid,st.status st_status, st.activeflag stflag,ts.name
from student s
left outer join enrollment en on en.studentid=s.id
left outer join organizationtreedetail ort on ort.schoolid=en.attendanceschoolid
left outer join studentstests st on st.enrollmentid=en.id
left outer join testsession ts on ts.id=st.testsessionid
left outer join testcollection  tc on tc.id=st.testcollectionid
left outer join contentarea ca on ca.id=tc.contentareaid 
where ts.operationaltestwindowid in (10261) and ca.abbreviatedname='ELA' and en.currentschoolyear=2018
and s.id=662524


select studentid,enrollmentid,contentareaid,attendanceschoolid,districtid,status,generated
from studentreport 
where schoolyear=2018 and contentareaid=3 
and studentid=662524










