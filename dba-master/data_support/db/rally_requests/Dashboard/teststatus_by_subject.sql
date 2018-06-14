--psql -h pg1 -U aart_reader -f "teststatus_by_subject.sql" aart-prod
select ca.name subjectname, ts.operationaltestwindowid, tc.name testcollection,stg.name stagename, CASE WHEN st.status=86 THEN 'Complete' WHEN st.status=85 THEN 'In Progress' ELSE 'Not Started' END as status,
count(distinct st.id) count ,org.organizationname
into temp teststatus_by_subject
from studentstests st 
inner join student s on s.id=st.studentid
inner join  organization org on org.id=s.stateid 
inner join testsession ts on st.testsessionid=ts.id
inner join testcollection tc on ts.testcollectionid=tc.id
inner join contentarea ca on tc.contentareaid=ca.id
left outer join stage stg on stg.id=tc.stageid
where st.status in (84,85,86) 
and st.startdatetime::date BETWEEN '2016-09-19'::date AND NOW()::date
and st.activeflag is true and ts.activeflag is true
group by ca.name, ts.operationaltestwindowid, tc.name, st.status,stg.name,org.organizationname
order by ca.name, tc.name, st.status,stg.name;
\copy (select * from teststatus_by_subject) to 'teststatus_by_subject.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
