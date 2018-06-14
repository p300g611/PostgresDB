drop table if exists tmp_curr_school;
select distinct s.id studentid
       ,statestudentidentifier
       ,legallastname
       ,legalfirstname
       ,e.id enrollmentid
       ,ot.schoolid
       ,ot.schoolname  
       ,ot.districtid  
       ,ot.districtname  
     into temp tmp_curr_school  
from student s 
inner join enrollment e on s.id=e.studentid and e.activeflag is true 
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=47 and sub.id=10 and tt.id=50 
and exists (select 1 from studentstests stt where e.studentid=stt.studentid and stt.status =477);
--=============================================================================================================================
--[Kelpa,scenario1]:Student gets tests assigned but doesn’t take any yet,  transfers to new school.
--===============================================================================================================================
drop table if exists tmp_kelpa_transfer_scenarios;
with tmp_kelpa as (select st.studentid,count (distinct ts.id)
from studentstests st 
inner join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on tc.id =st.testcollectionid
inner join enrollment e on e.id =st.enrollmentid
where  st.status=84 and ts.operationaltestwindowid=10252 
group by st.studentid
having count(distinct ts.id)=4
)
select distinct
 s.statestudentidentifier                            "Student SSID"
,s.studentid                                         "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,s.schoolname                                        "CurrentEnrollment School Name"
,s.districtname                                      "Current District Name"
,org.schoolname                                      "School Name_Before Transfer"
,org.districtname                                    "Stage1 District Name_Before Transfer"
,st.id                                               "StudentstestID"
into temp tmp_kelpa_transfer_scenarios
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join tmp_curr_school s on s.studentid=e.studentid 
inner join tmp_kelpa klp on klp.studentid =s.studentid
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where ts.source='BATCHAUTO' and ts.operationaltestwindowid =10252
and tc.contentareaid=451 
and e.currentschoolyear =2018
and st.status=477
and org.schoolid<>s.schoolid
--and not exists (select 1 from studentstests stt where stt.enrollmentid =s.enrollmentid and stt.status in (84,86,659))
limit 1000;

\copy (select * from tmp_kelpa_transfer_scenarios) to 'tmp_kelpa_transfer_scenarios1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=============================================================================================================================
--[Kelpa,scenario2]:Student takes all 4 domains and then transferred.
--===============================================================================================================================
drop table if exists tmp_kelpa_transfer_scenarios;
with tmp_kelpa as (select st.studentid,count (distinct ts.id)
from studentstests st 
inner join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on tc.id =st.testcollectionid
inner join enrollment e on e.id =st.enrollmentid
where  st.status=86 and ts.operationaltestwindowid=10252 
group by st.studentid
having count(distinct ts.id)=4
)
select distinct
 s.statestudentidentifier                            "Student SSID"
,s.studentid                                         "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,s.schoolname                                        "CurrentEnrollment School Name"
,s.districtname                                      "Current District Name"
,org.schoolname                                      "School Name_Before Transfer"
,org.districtname                                    "Stage1 District Name_Before Transfer"
,st.id                                               "StudentstestID"
into temp tmp_kelpa_transfer_scenarios
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join tmp_curr_school s on s.studentid=e.studentid 
inner join tmp_kelpa klp on klp.studentid =s.studentid
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where ts.source='BATCHAUTO' and ts.operationaltestwindowid =10252
and tc.contentareaid=451 
and e.currentschoolyear =2018
and st.status=477
and org.schoolid<>s.schoolid
--and not exists (select 1 from studentstests stt where stt.enrollmentid =s.enrollmentid and stt.status in (84,86,659))
limit 1000;

\copy (select * from tmp_kelpa_transfer_scenarios) to 'tmp_kelpa_transfer_scenarios2.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--=============================================================================================================================
--[Kelpa,scenario3]:3.	Student takes 1-3 domains and then transferred.
--===============================================================================================================================
drop table if exists tmp_kelpa_transfer_scenarios;
with tmp_kelpa as (select st.studentid,count (distinct ts.id)
from studentstests st 
inner join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on tc.id =st.testcollectionid
inner join enrollment e on e.id =st.enrollmentid
where  st.status=86 and ts.operationaltestwindowid=10252 
group by st.studentid
having count(distinct ts.id)<4
)
select distinct
 s.statestudentidentifier                            "Student SSID"
,s.studentid                                         "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,s.schoolname                                        "CurrentEnrollment School Name"
,s.districtname                                      "Current District Name"
,org.schoolname                                      "School Name_Before Transfer"
,org.districtname                                    "Stage1 District Name_Before Transfer"
,st.id                                               "StudentstestID"
into temp tmp_kelpa_transfer_scenarios
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join tmp_curr_school s on s.studentid=e.studentid 
inner join tmp_kelpa klp on klp.studentid =s.studentid
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where  ts.operationaltestwindowid =10252
and tc.contentareaid=451 
and e.currentschoolyear =2018
and st.status=477
and org.schoolid<>s.schoolid
--and not exists (select 1 from studentstests stt where stt.enrollmentid =s.enrollmentid and stt.status in (84,86,659))
limit 1000;
\copy (select * from tmp_kelpa_transfer_scenarios) to 'tmp_kelpa_transfer_scenarios3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--=============================================================================================================================
--[Kelpa,scenario1]:Student completed all 4 domains and then exits.  Not reenrolled.
--===============================================================================================================================
drop table if exists tmp_kelpa_exit_scenarios;
with tmp_kelpa as (select st.studentid,count (distinct ts.id)
from studentstests st 
inner join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on tc.id =st.testcollectionid
inner join enrollment e on e.id =st.enrollmentid
where  e.currentschoolyear =2018 and st.status=86 and ts.operationaltestwindowid=10252 
group by st.studentid
having count(distinct ts.id)=4
),
tmp_enrollment as (select e.studentid,count(distinct e.id)
from enrollment e
inner join studentstests st on st.studentid=e.studentid
inner join testsession ts on ts.id =st.testsessionid
where e.currentschoolyear =2018 and ts.operationaltestwindowid=10252 
group by e.studentid
having count(distinct e.id)=1 
)
select distinct
 s.statestudentidentifier                            "Student SSID"
,s.id                                                 "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,org.schoolname                                        "School Name"
,org.districtname                                      "District Name"
into temp tmp_kelpa_exit_scenarios
from  tmp_kelpa tmp 
inner join student s on s.id=tmp.studentid
inner join enrollment e on s.id=e.studentid and coalesce(e.exitwithdrawaltype,0)<>0 
inner join tmp_enrollment enl on enl.studentid=e.studentid
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=47 and sub.id=10 and tt.id=50 
--and exists (select 1 from studentstests stt where stt.enrollmentid =s.enrollmentid and stt.status in (84,86,659))
limit 1000;

\copy (select * from tmp_kelpa_exit_scenarios) to 'tmp_kelpa_exit_scenarios1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Kelpa,scenario2]:Student completed all 4 domains and then exits.  Reenrolled in same school.
--===============================================================================================================================
drop table if exists tmp_kelpa_exit_scenarios;
with tmp_kelpa as (select st.studentid,count (distinct ts.id)
from studentstests st 
inner join testsession ts on ts.id =st.testsessionid
inner join testcollection tc on tc.id =st.testcollectionid
inner join enrollment e on e.id =st.enrollmentid
where  st.status=86 and ts.operationaltestwindowid=10252 
group by st.studentid
having count(distinct ts.id)=4
)
select distinct
 s.statestudentidentifier                            "Student SSID"
,s.studentid                                         "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,s.schoolname                                        "CurrentEnrollment School Name"
,s.districtname                                      "Current District Name"
,org.schoolname                                      "School Name_Before Transfer"
,org.districtname                                    "Stage1 District Name_Before Transfer"
,st.id                                               "StudentstestID"
into temp tmp_kelpa_exit_scenarios
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid and coalesce(e.exitwithdrawaltype,0)<>0
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join tmp_curr_school s on s.studentid=e.studentid 
inner join tmp_kelpa klp on klp.studentid =s.studentid
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where  ts.operationaltestwindowid =10252
and tc.contentareaid=451 
and e.currentschoolyear =2018
and st.status=477
and org.schoolid=s.schoolid
--and not exists (select 1 from studentstests stt where stt.enrollmentid =s.enrollmentid and stt.status in (84,86,659))
limit 1000;

\copy (select * from tmp_kelpa_exit_scenarios) to 'tmp_kelpa_exit_scenarios2.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);