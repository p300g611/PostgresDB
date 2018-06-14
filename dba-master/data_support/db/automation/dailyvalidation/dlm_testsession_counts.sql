Create temp table tmp_orgyear (orgid bigint,state character varying(100));
insert into tmp_orgyear(orgid,state)
select schoolid orgid,statedisplayidentifier from organizationtreedetail 
where coalesce(organization_school_year(stateid),extract(year from now()))=2018 
and stateid not in (select id from organization where  organizationtypeid=2 
and organizationname in ('cPass QC State','ARMM QC State','NY Training State','ATEA QC State','AMP QC State','Playground QC State'
,'MY ORGANIZATION ','KAP QC State','PII Deactivation','Demo State','Training Program','DLM QC State'
,'ARMM','DLM QC EOY State','DLM QC YE State','DLM QC IM State ','ATEA','Flatland','Service Desk QC State','QA QC State')); 

-- drop table if exists dlm_student_testsession_today;
with dlm_tc as (select distinct tc.id  from testcollection tc 
INNER JOIN contentarea ca ON ca.id = tc.contentareaid
INNER JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
INNER JOIN assessment a ON atc.assessmentid = a.id
INNER JOIN testingprogram tp ON a.testingprogramid = tp.id
INNER JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
WHERE ap.id=3)
SELECT st.studentid,ot.state,count(distinct ts.id) testsession_cnt,array_agg(distinct currentgradelevel) gradedbids
into temp dlm_student_testsession_today
FROM studentstests st
INNER JOIN test t ON st.testid = t.id
INNER JOIN studentstestsections sts ON sts.studentstestid = st.id
INNER JOIN testcollectionstests tct ON st.testid = tct.testid
INNER JOIN dlm_tc tc ON tc.id = tct.testcollectionid
INNER JOIN testsession ts ON st.testsessionid = ts.id AND ts.testcollectionid = tc.id
INNER JOIN enrollment e ON st.enrollmentid = e.id
inner join tmp_orgyear ot on ot.orgid=e.attendanceschoolid
WHERE e.currentschoolyear=2018 AND st.activeflag=true and st.status=86 
and ts.activeflag is true 
group by st.studentid,ot.state;

\copy (select * from dlm_student_testsession_today) to '/srv/extracts/helpdesk/dailyvalidation/data/dlm_testsession_counts.csv' (FORMAT CSV,header true, FORCE_QUOTE *); 

