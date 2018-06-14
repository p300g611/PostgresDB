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
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=19 and tt.id=2 
and exists (select 1 from studentstests stt where e.studentid=stt.studentid and stt.status =477);

drop table if exists tmp_no_response;
with no_response_cnt as (
select st.studentid, st.id studentstestsid,tstv.taskvariantid,gc.id gradeid
from studentstests st
inner join tmp_curr_school stt on st.studentid=stt.studentid
inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true
inner join testcollection tc on tc.id =st.testcollectionid and tc.activeflag is true 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid 
where st.activeflag is true and ts.operationaltestwindowid in (10258)  and ts.schoolyear=2018  and st.status in (86,85,659)
and tc.contentareaid=441 and ts.source='BATCHAUTO'   and stg.code in ('Stg1','Stg2') 
)
select tmp.studentid, tmp.studentstestsid
,count(distinct case when sr.score is not null  and exld.id is null then  sr.taskvariantid end ) no_incl_answer
,count(distinct case when sr.score is not null  then sr.taskvariantid end) no_answer
into temp tmp_no_response
from no_response_cnt  tmp
left outer join studentsresponses sr on sr.studentid=tmp.studentid and sr.studentstestsid =tmp.studentstestsid and sr.taskvariantid=tmp.taskvariantid and sr.activeflag is true
left outer join (select distinct tv.id, gc.id gradeid from taskvariant tv 
                join excludeditems exld on exld.taskvariantid =tv.externalid
                join gradecourse gc on gc.id=exld.gradeid
                where exld.schoolyear=2018 and exld.subjectid=441 and exld.assessmentprogramid=12) exld on exld.id=sr.taskvariantid AND exld.gradeid=tmp.gradeid 
group by tmp.studentid, tmp.studentstestsid;
--=============================================================================================================================
--[Sci,KS,KAP,scenario3]:Transfer In or Out of district:IN. Transfer before after Stage 1 or Stage 2:Before Stage 1
--===============================================================================================================================
drop table if exists tmp_sci_transfer_scenarios;
with cte_stg2 as (
select 
 st.studentid
,st.status as stg2_status
,st.enrollmentid as stg2_enrollmentid
,ot.schoolid as stg2_schoolid
,ot.districtid as stg2_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=441 and stg.code='Stg2' 
and sr.no_incl_answer >=5 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.schoolname as stg1_schoolname
,ot.districtid as stg1_districtid
,ot.districtname as stg1_districtname
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=441 and stg.code='Stg1' 
 --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer>=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
 s.statestudentidentifier                            "Student SSID"
,s.id                                                "studentid"
,s.legallastname                                     "Student Last Name"
,s.legalfirstname                                    "Student First Name"
,gc.abbreviatedname                                  "Grade"
,ca.abbreviatedname                                  "Subject"
,tmp.no_incl_answer                                  "Stage1 #Responded"
,tmp2.no_incl_answer                                 "Stage2 #Responded"
,tmp.stg1_schoolname                                 "CurrentEnrollment School Name"
,tmp.stg1_districtname                               "Current District Name"
,org.schoolname                                      "School Name_Before Transfer"
,org.districtname                                    "Stage1 District Name_Before Transfer"
,st.id                                               "StudentstestID"
into temp tmp_sci_transfer_scenarios
from studentstests st 
inner join student s on s.id =st.studentid 
inner join enrollment e on e.id =st.enrollmentid 
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join  cte_stg1 tmp on tmp.studentid=e.studentid
inner join cte_stg2 tmp2 on tmp2.studentid=tmp.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id 
inner join contentarea ca on ca.id =tc.contentareaid
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where ts.source='BATCHAUTO' and ts.operationaltestwindowid =10258
and tc.contentareaid=441
and e.currentschoolyear =2018 and stg.code='Stg1'
and st.status=477
and org.districtid=tmp.stg1_districtid and org.schoolid<>tmp.stg1_schoolid and tmp.stg1_schoolid=tmp2.stg2_schoolid
--and not exists (select 1 from studentstests stt where stt.enrollmentid =tmp.stg1_enrollmentid and stt.status in (84,86,659))
limit 1000;

\copy (select * from tmp_sci_transfer_scenarios) to 'tmp_sci_transfer_scenarios3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=============================================================================================================================
--[Sci,KS,KAP,scenario7]:Transfer In or Out of district:Out. Transfer before after Stage 1 or Stage 2:Before Stage 1
--===============================================================================================================================
drop table if exists tmp_sci_transfer_scenarios;
with cte_stg2 as (
select 
 st.studentid
,st.status as stg2_status
,st.enrollmentid as stg2_enrollmentid
,ot.schoolid as stg2_schoolid
,ot.districtid as stg2_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=441 and stg.code='Stg2' 
and sr.no_incl_answer >=5 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.schoolname as stg1_schoolname
,ot.districtid as stg1_districtid
,ot.districtname as stg1_districtname
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=441 and stg.code='Stg1' 
 --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer>=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
 s.statestudentidentifier                            "Student SSID"
,s.id                                                "studentid"
,s.legallastname                                     "Student Last Name"
,s.legalfirstname                                    "Student First Name"
,gc.abbreviatedname                                  "Grade"
,ca.abbreviatedname                                  "Subject"
,tmp.no_incl_answer                                  "Stage1 #Responded"
,tmp2.no_incl_answer                                 "Stage2 #Responded"
,tmp.stg1_schoolname                                 "CurrentEnrollment School Name"
,tmp.stg1_districtname                               "Current District Name"
,org.schoolname                                      "School Name_Before Transfer"
,org.districtname                                    "Stage1 District Name_Before Transfer"
,st.id                                               "StudentstestID"
into temp tmp_sci_transfer_scenarios
from studentstests st 
inner join student s on s.id =st.studentid 
inner join enrollment e on e.id =st.enrollmentid 
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join  cte_stg1 tmp on tmp.studentid=e.studentid
inner join cte_stg2 tmp2 on tmp2.studentid=tmp.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id 
inner join contentarea ca on ca.id =tc.contentareaid
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where ts.source='BATCHAUTO' and ts.operationaltestwindowid =10258
and tc.contentareaid=441
and e.currentschoolyear =2018 and stg.code='Stg1'
and st.status=477
and org.districtid<>tmp.stg1_districtid and tmp.stg1_schoolid=tmp2.stg2_schoolid
--and not exists (select 1 from studentstests stt where stt.enrollmentid =tmp.stg1_enrollmentid and stt.status in (84,86,659))
limit 1000;

\copy (select * from tmp_sci_transfer_scenarios) to 'tmp_sci_transfer_scenarios7.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--transferedenrollmentid<>enrollmentid is different condition 
--=============================================================================================================================
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
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=19 and tt.id=2 
and exists (select 1 from studentstests stt where e.studentid=stt.studentid and transferedenrollmentid<>enrollmentid and transferedenrollmentid is not null);

--=============================================================================================================================
--[Sci,KS,KAP,scenario11]:Transfer In or Out of district:In. Transfer before after Stage 1 or Stage 2:After Stage 1
--===============================================================================================================================
drop table if exists tmp_sci_transfer_scenarios;
with tmp_dup as(
select st.studentid,count(distinct ts.stageid) 
from studentstests st 
inner join tmp_curr_school tmp on tmp.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id
where ts.source='BATCHAUTO' and ts.operationaltestwindowid =10258
and tc.contentareaid=441 and st.status in (85,86,659)
group by st.studentid
having count(distinct ts.stageid)=1
)
select
 s.statestudentidentifier                            "Student SSID"
,s.studentid                                         "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,gc.abbreviatedname                                  "Grade"
,ca.abbreviatedname                                  "Subject"
,s.schoolname                                        "CurrentEnrollment School Name"
,s.districtname                                      "Current District Name"
,org.schoolname                                      "Stage1 School Name"
,org.districtname                                    "Stage1 District Name"
,st.id                                               "StudentstestID"
into temp tmp_sci_transfer_scenarios
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join tmp_curr_school s on s.studentid=e.studentid 
inner join tmp_dup tmp on tmp.studentid=s.studentid
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id
inner join contentarea ca on ca.id =tc.contentareaid 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where st.status in (85,86,659)
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10258
and tc.contentareaid=441 and stg.code='Stg1' 
and e.currentschoolyear =2018
and st.transferedenrollmentid<>st.enrollmentid and transferedenrollmentid is not null
and org.districtid=s.districtid and org.schoolid<>s.schoolid
limit 1000;
\copy (select * from tmp_sci_transfer_scenarios) to 'tmp_sci_transfer_scenarios11.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=============================================================================================================================
--[Sci,KS,KAP,scenario15]:Transfer In or Out of district:In. Transfer before after Stage 1 or Stage 2:After Stage 2
--===============================================================================================================================
drop table if exists tmp_sci_transfer_scenarios;
select
 s.statestudentidentifier                            "Student SSID"
,s.studentid                                         "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,gc.abbreviatedname                                  "Grade"
,ca.abbreviatedname                                  "Subject"
,s.schoolname                                        "CurrentEnrollment School Name"
,s.districtname                                      "Current District Name"
,org.schoolname                                      "Stage2 School Name"
,org.districtname                                    "Stage2 District Name"
,st.id                                               "StudentstestID"
into temp tmp_sci_transfer_scenarios
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join tmp_curr_school s on s.studentid=e.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id 
inner join contentarea ca on ca.id =tc.contentareaid
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where st.status in (85,86,659)
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10258
and tc.contentareaid=441 and stg.code='Stg2' 
and e.currentschoolyear =2018
and st.transferedenrollmentid<>st.enrollmentid and transferedenrollmentid is not null
and org.districtid=s.districtid and org.schoolid<>s.schoolid
limit 1000;
\copy (select * from tmp_sci_transfer_scenarios) to 'tmp_sci_transfer_scenarios15.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Sci,KS,KAP,scenario19]:Transfer In or Out of district:Out. Transfer before after Stage 1 or Stage 2:After Stage 1
--===============================================================================================================================
drop table if exists tmp_sci_transfer_scenarios;
with tmp_dup as(
select st.studentid,count(distinct ts.stageid) 
from studentstests st 
inner join tmp_curr_school tmp on tmp.studentid=st.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id
where ts.source='BATCHAUTO' and ts.operationaltestwindowid =10258
and tc.contentareaid=441 and st.status in (85,86,659)
group by st.studentid
having count(distinct ts.stageid)=1)
select
 s.statestudentidentifier                            "Student SSID"
,s.studentid                                         "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,gc.abbreviatedname                                  "Grade"
,ca.abbreviatedname                                  "Subject"
,s.schoolname                                        "CurrentEnrollment School Name"
,s.districtname                                      "Current District Name"
,org.schoolname                                      "Stage1 School Name"
,org.districtname                                    "Stage1 District Name"
,st.id                                               "StudentstestID"
into temp tmp_sci_transfer_scenarios
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join tmp_curr_school s on s.studentid=e.studentid 
inner join tmp_dup tmp on tmp.studentid=s.studentid
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id
inner join contentarea ca on ca.id =tc.contentareaid 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where st.status in (85,86,659)
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10258
and tc.contentareaid=441 and stg.code='Stg1' 
and e.currentschoolyear =2018
and st.transferedenrollmentid<>st.enrollmentid and transferedenrollmentid is not null
and org.districtid<>s.districtid
limit 1000;

\copy (select * from tmp_sci_transfer_scenarios) to 'tmp_sci_transfer_scenarios19.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Sci,KS,KAP,scenario23]:Transfer In or Out of district:Out. Transfer before after Stage 1 or Stage 2:After Stage 2
--===============================================================================================================================
drop table if exists tmp_sci_transfer_scenarios;
select
 s.statestudentidentifier                            "Student SSID"
,s.studentid                                         "studentid"
,legallastname                                       "Student Last Name"
,legalfirstname                                      "Student First Name"
,gc.abbreviatedname                                  "Grade"
,ca.abbreviatedname                                  "Subject"
,s.schoolname                                        "CurrentEnrollment School Name"
,s.districtname                                      "Current District Name"
,org.schoolname                                      "Stage2 School Name"
,org.districtname                                    "Stage1 District Name"
,st.id                                               "StudentstestID"
into temp tmp_sci_transfer_scenarios
from studentstests st 
inner join enrollment e on e.id =st.enrollmentid
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organizationtreedetail org on org.schoolid=e.attendanceschoolid 
inner join tmp_curr_school s on s.studentid=e.studentid 
inner join testsession ts on st.testsessionid=ts.id 
inner join testcollection tc on ts.testcollectionid=tc.id 
inner join contentarea ca on ca.id =tc.contentareaid
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
where st.status in (85,86,659)
and ts.source='BATCHAUTO' and ts.operationaltestwindowid =10258
and tc.contentareaid=441 and stg.code='Stg2' 
and e.currentschoolyear =2018
and st.transferedenrollmentid<>st.enrollmentid and transferedenrollmentid is not null
and org.districtid<>s.districtid
limit 1000;

\copy (select * from tmp_sci_transfer_scenarios) to 'tmp_sci_transfer_scenarios23.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);






















