drop table if exists tmp_no_response;
with no_response_cnt as (
select st.studentid, st.id studentstestsid,tstv.taskvariantid,gc.id gradeid,stg.code code
from studentstests st
inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true
inner join testcollection tc on tc.id =st.testcollectionid and tc.activeflag is true 
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestsections sts ON sts.studentstestid = st.id
inner JOIN testsection tsec ON sts.testsectionid = tsec.id
inner JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid--duplicate
where st.activeflag is true and ts.operationaltestwindowid in (10258)  and ts.schoolyear=2018  and st.status in (86,85,659)
and tc.contentareaid=443 and ts.source='BATCHAUTO' and stg.code in ('Stg1','Prfrm') 
)
select tmp.studentid, tmp.studentstestsid
,count(distinct case when sr.score is not null  and exld.id is null  and tmp.code='Stg1' then  sr.taskvariantid  
                     when exld.id is null  and tmp.code='Prfrm' then  sr.taskvariantid end ) no_incl_answer

into temp tmp_no_response
from no_response_cnt  tmp
left outer join studentsresponses sr on sr.studentid=tmp.studentid and sr.studentstestsid =tmp.studentstestsid and sr.taskvariantid=tmp.taskvariantid and sr.activeflag is true
left outer join (select distinct tv.id, gc.id gradeid from taskvariant tv 
                join excludeditems exld on exld.taskvariantid =tv.externalid
                join gradecourse gc on gc.id=exld.gradeid
                where exld.schoolyear=2018 and exld.subjectid=443 and exld.assessmentprogramid=12) exld on exld.id=sr.taskvariantid AND exld.gradeid=tmp.gradeid 
group by tmp.studentid, tmp.studentstestsid;

create index inx_sr_studentid on tmp_no_response (studentid,studentstestsid);
--=============================================================================================================================
--[SS,KS,KAP,scenario1]:stage1:Complete < 5 included answered. stage2:In Progress or In Progress Timed Out => 5 included answered
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and sr.no_incl_answer >=5 and st.status in (659,85) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer<5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios1.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[SS,KS,KAP,scenario2]:stage1:Complete < 5 included answered. stage2:Complete => 5 included answered
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and sr.no_incl_answer >=5 and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer<5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1 
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios2.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[SS,KS,KAP,scenario3]:stage1:Complete >= 5 included anwered. stage2:In Progress or In Progress Timed Out < 5 included answered
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and sr.no_incl_answer <5 and st.status in (659,85) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer>=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1 
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios3.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[SS,KS,KAP,scenario4]:stage1:Complete >= 5 included anwered. stage2:Complete < 5 included answered
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and sr.no_incl_answer <5 and st.status=86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer>=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1 
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios4.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[SS,KS,KAP,scenario5]:stage1:Complete >= 5 included anwered. stage2:In Progress or In Progress Timed Out >= 5 answered
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and sr.no_incl_answer >=5 and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer>=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                      "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                      "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1 
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios5.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--=============================================================================================================================
--[SS,KS,KAP,scenario6]:stage1:Complete < 5 included answered. stage2:unused
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and  st.status=84 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer<5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                      "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1 
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios6.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[SS,KS,KAP,scenario7]:stage1:Complete >= 5 included answered. stage2:unused
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and  st.status=84 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer>=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                      "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1 
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios7.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[SS,KS,KAP,scenario8]:In Progress or In Progress Timed Out < 5 included answered. stage2:unused
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and  st.status=84 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer<5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                      "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1 
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios8.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[SS,KS,KAP,scenario9]:In Progress or In Progress Timed Out >= 5 included answered. stage2:unused
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and  st.status=84 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
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
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)  --UNUSED, IN PROGRESS, COMPLETED,  IN PROGRESS TIMED OUT
and  no_incl_answer>=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                      "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1 
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios9.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario10]:stage1:Generic In Progress or In Progress Timed Out < 5 included answered stage2: Complete - Scored
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.nonscorereason is null and scr.score is not null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios10.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario11]:stage1:In Progress or In Progress Timed Out >= 5 included answered  stage2: Complete - Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.nonscorereason is null and scr.score is not null 
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios11.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario12]:stage1:In Progress or In Progress Timed Out < 5 included answered   stage2: Complete - Not Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios12.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario13]:stage1:In Progress or In Progress Timed Out >= 5 included answered    stage2: Complete - Not Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios13.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--=============================================================================================================================
--[Math,KS,KAP,scenario14]:stage1:Generic In Progress or In Progress Timed Out < 5 included answered stage2: In Progress or In Progress Timed Out - Scored
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.nonscorereason is null and scr.score is not null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios14.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario15]:stage1:In Progress or In Progress Timed Out >= 5 included answered	stage2: In Progress or In Progress Timed Out - Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.nonscorereason is null and scr.score is not null 
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios15.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario16]:stage1:In Progress or In Progress Timed Out < 5 included answered stage2:In Progress or In Progress Timed Out - Not Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios16.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario17]:stage1:In Progress or In Progress Timed Out >= 5 included answered	stge2: In Progress or In Progress Timed Out - Not Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status in (85,659)
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios17.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario18]:stage1:Complete < 5 included answered stage	Complete - Scored - Regular Score
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is not null  and scr.nonscorereason is null
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios18.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario19]:stage1:Complete >= 5 included answered stage	Complete - Scored - Regular Score
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is not null  and scr.nonscorereason is null
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios19.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario20]:stage1:Complete < 5 included answered stage	stg2 Complete - Not Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is null 
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios20.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario21]:stage1:Complete >= 5 included answered stage	Complete - stage2 completed - not Scoreed
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios21.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--=============================================================================================================================
--[Math,KS,KAP,scenario22]:stage1:Complete < 5 included answered stage	stg2:Completed - Scored with Non Score reason that is not HSO
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.nonscorereason is not null and scr.nonscorereason<>646
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios22.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario23]:stage1:Complete >= 5 included answered stage	Completed - Scored with Non Score reason that is not HSO
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.nonscorereason is not null  AND  scr.nonscorereason<>646
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios23.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario24]:stage1:Complete < 5 included answered stage	stg2 Completed - Scored above 0 with Non Score reason HSO
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.score>0  AND  scr.nonscorereason=646
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios24.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario25]:stage1:Complete >= 5 included answered stage	Complete - stage2 Completed - Scored above 0 with Non Score reason HSO
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.score>0  AND  scr.nonscorereason=646 
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios25.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--=============================================================================================================================
--[Math,KS,KAP,scenario26]:stage1:Complete < 5 included answered stage	stg2 Completed - Scored 0 with Non Score reason HSO
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.score=0  AND  scr.nonscorereason=646
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios26.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario27]:stage1:Complete >= 5 included answered stage	Complete - stage2 Completed - Scored 0 with Non Score reason HSO
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status =86 --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.score=0  AND  scr.nonscorereason=646 
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios27.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--=============================================================================================================================
--[Math,KS,KAP,scenario28]:stage1:Complete < 5 included answered  stage2: In Progress or In Progress Timed Out - Scored
--===============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.nonscorereason is null 
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;

\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios28.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario29]:stage1:Complete >= 5 included answered	stage2:In Progress or In Progress Timed Out - Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.nonscorereason is null 
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios29.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario30]:stage1:In Progress or In Progress Timed Out < 5 included answered stage2:In Progress or In Progress Timed Out - Not Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status=86
and sr.no_incl_answer <5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios30.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--=============================================================================================================================
--[Math,KS,KAP,scenario31]:stage1:Complete >= 5 included answered stage2:In Progress or In Progress Timed Out - Not Scored
--=============================================================================================================================
drop table if exists tmp_ss_scenarios;
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
inner join testcollection tc on ts.testcollectionid=tc.id --and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
left outer join studentstestscore scr on scr.studenttestid=st.id and scr.activeflag is true
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true and ts.source='BATCHAUTO' 
and ts.operationaltestwindowid in (10258) and tc.contentareaid=443 and stg.code='Prfrm' 
and st.status in (85,659) --84:UNUSED, 85:IN PROGRESS, 86:COMPLETED,  659:IN PROGRESS TIMED OUT
and scr.studenttestid is null  
)
,cte_stg1 as (
select 
 st.studentid
,st.status as stg1_status
,st.enrollmentid as stg1_enrollmentid
,ot.schoolid as stg1_schoolid
,ot.districtid as stg1_districtid
,sr.no_incl_answer
from studentstests st 
inner join testsession ts on st.testsessionid=ts.id 
inner join organizationtreedetail ot on ot.schoolid=ts.attendanceschoolid 
inner join testcollection tc on ts.testcollectionid=tc.id and tc.activeflag is true
inner join stage stg on stg.id=tc.stageid and stg.activeflag is true
inner join gradecourse gc on tc.gradecourseid=gc.id and gc.activeflag is true 
inner join tmp_no_response sr on sr.studentid=st.studentid and sr.studentstestsid=st.id
where  ts.activeflag is true and ts.schoolyear=2018 and st.activeflag is true 
and ts.source='BATCHAUTO' and ts.operationaltestwindowid in (10258)
and tc.contentareaid=443 and stg.code='Stg1' 
and st.status =86
and sr.no_incl_answer >=5
and exists (select 1 from cte_stg2 stg2 where stg2.studentid=st.studentid )
limit 1000
)
select distinct
s.statestudentidentifier                 "Student SSID"
,s.id                                     studentid
,legallastname                            "Student Last Name"
,legalfirstname                           "Student First Name"
,ot.schoolname                            "CurrentEnrollment School"
,ot.districtname                          "District"
,gc.name                                  "Grade"
,'SS'::Char(10)                            "Subject"
,otstg1.districtname                      "Stage1 District"
,otstg1.schoolname                        "Stage1 School"
,stg1.stg1_status                         "Stage1 Status"
,stg1.no_incl_answer                        "Stage1 #Responded"  
,otstg2.districtname                      "Stage2 District"
,otstg2.schoolname                        "Stage2 School"
,stg2.stg2_status                         "Stage2 Status"
,stg2.no_incl_answer                        "Stage2 #Responded" 
into temp tmp_ss_scenarios
from cte_stg1 stg1
join cte_stg2 stg2 on stg2.studentid=stg1.studentid 
inner join student s on stg1.studentid=s.id and s.activeflag is true
left join enrollment e on s.id=e.studentid  and e.activeflag is true 
left join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid 
left outer join organizationtreedetail otstg2 on otstg2.schoolid=stg2.stg2_schoolid
inner join organizationtreedetail otstg1 on otstg1.schoolid=stg1.stg1_schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id  and sap.activeflag is true 
inner join gradecourse gc on e.currentgradelevel=gc.id and gc.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
inner join subjectarea sub on ets.subjectareaid=sub.id and sub.activeflag is true and ets.activeflag is true
inner join testtype tt on ets.testtypeid=tt.id and tt.activeflag is true  
where e.currentschoolyear=2018 and sap.assessmentprogramid=12 and sub.id=20 and tt.id=2;
\copy (select * from tmp_ss_scenarios) to 'tmp_ss_scenarios31.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);






