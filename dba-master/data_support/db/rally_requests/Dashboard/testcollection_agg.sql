--psql -h pg1 -U aart_reader -f "testcollection_agg.sql" aart-prod
select ot.statename,ot.districtname,districtid districtdbid, ot.schoolname,schoolid schooldbid,gc.name grade,ca.name contentarea,
r.coursesectionname roster, r.id rosterdbid,a.firstname || ' '||a.surname Teacher,a.id teacherdbid,ts.operationaltestwindowid, tc.name testcollectionname,
CASE WHEN st.status=86 THEN 'Complete' WHEN st.status=85 THEN 'In Progress' ELSE 'Not Started' END as status, count(distinct st.id) nooftests
into temp tmp_testcollection_agg  
from studentstests st 
inner join student s on s.id=st.studentid
inner join enrollment e on s.id=e.studentid and st.enrollmentid=e.id 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
inner join testsession ts on st.testsessionid=ts.id
inner join testcollection tc on ts.testcollectionid=tc.id
left outer join roster r on ts.rosterid =r.id
left outer join aartuser a on a.id=r.teacherid
inner join contentarea ca on tc.contentareaid=ca.id
inner join gradecourse gc on tc.gradecourseid=gc.id
where st.status in (84,85,86) 
and st.startdatetime::date BETWEEN '2016-09-19'::date AND NOW()::date
and st.activeflag is true and ts.activeflag is true
group by ca.name, ts.operationaltestwindowid, tc.name, st.status,gc.name,ot.statename,districtid,schoolid,r.id,a.id,
ot.districtname,ot.schoolname,r.coursesectionname,roster,a.firstname,a.surname;
\copy (select * from tmp_testcollection_agg order by 1,2,4,6,7) to 'testcollection_agg.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


