--psql -h pg1 -U aart_reader -f "teststatus_by_stage.sql" aart-prod
select otw.windowname,tc.name as testcollection, stg.name as stage, ts.operationaltestwindowid,
(CASE WHEN st.status=86 THEN 'Complete' WHEN st.status=85 THEN 'In Progress' ELSE 'Not Started' END) as status,count(distinct st.id) count,org.organizationname
into temp teststatus_by_stage
from studentstests st 
inner join student s on s.id=st.studentid
inner join  organization org on org.id=s.stateid 
inner join testsession ts on st.testsessionid=ts.id
inner join testcollection tc on ts.testcollectionid=tc.id
inner join stage stg on stg.id=tc.stageid
inner join operationaltestwindow otw on ts.operationaltestwindowid=otw.id
where st.startdatetime::date BETWEEN '2016-09-01'::date AND NOW()::date
and st.status=ANY ('{86,85,84}'::integer[])
and st.activeflag is true and ts.activeflag is true
group by otw.windowname,tc.name,stg.name,st.status, ts.operationaltestwindowid,org.organizationname
order by otw.windowname,tc.name,stg.name,st.status;
\copy (select * from teststatus_by_stage) to 'teststatus_by_stage.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
