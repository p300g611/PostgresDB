--DLM
drop table if exists tmp_dlm;
with dlm_std as
(
select distinct
(select displayidentifier from organization_parent(o.id) where organizationtypeid=5 limit 1) "District ID",
o.displayidentifier "School ID",
s.statestudentidentifier "Student Id",
gc.name "Grade",
ap.abbreviatedname "Assessment Program",
e.id enrollid,
r.id rosterid
from student s 
inner join enrollment e on s.id=e.studentid and e.currentschoolyear=2016 --and e.activeflag is true 
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on er.rosterid=r.id and r.statesubjectareaid=441
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organization o on o.id=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.assessmentprogramid=3 
inner join assessmentprogram ap on sap.assessmentprogramid=ap.id 
where gc.abbreviatedname in ('5','8','11')
and s.stateid=51
)
select distinct "District ID","School ID","Student Id","Grade","Assessment Program"
into temp tmp_dlm
from dlm_std tmp
inner join studentstests st on st.enrollmentid=tmp.enrollid and st.activeflag is true and st.status in (85,86)
inner join testsession ts on ts.id=st.testsessionid and ts.rosterid=tmp.rosterid and ts.schoolyear=2016 and ts.activeflag is true
join operationaltestwindow otw on otw.id=ts.operationaltestwindowid where ts.schoolyear=2016 and ts.source='BATCHAUTO' and otw.id=10153;


 

--KAP
drop table if exists tmp_kap;
with dlm_std as
(
select distinct
(select displayidentifier from organization_parent(o.id) where organizationtypeid=5 limit 1) "District ID",
o.displayidentifier "School ID",
s.statestudentidentifier "Student Id",
gc.name "Grade",
ap.abbreviatedname "Assessment Program",
e.id enrollid
from student s 
inner join enrollment e on s.id=e.studentid and e.currentschoolyear=2016 --and e.activeflag is true 
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organization o on o.id=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.assessmentprogramid=12
inner join assessmentprogram ap on sap.assessmentprogramid=ap.id 
where gc.abbreviatedname in ('5','8','11')
and s.stateid=51
)
select distinct "District ID","School ID","Student Id","Grade","Assessment Program" into temp tmp_kap
from dlm_std tmp
inner join studentstests st on st.enrollmentid=tmp.enrollid and st.activeflag is true and st.status in (85,86)
inner join testsession ts on ts.id=st.testsessionid and  ts.schoolyear=2016 and ts.activeflag is true
where ts.schoolyear=2016 and ts.source='BATCHAUTO' and ts.operationaltestwindowid=10132
and subjectareaid=19;

select * into temp tmp_all from 
(
select * from tmp_kap
union all
select * from  tmp_dlm
) ta;

\copy (select  * from tmp_all order by 1,2,4,5) to 'tmp_all.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


-------------------------------------------------------------------------------
--DLM
drop table if exists tmp_dlm;
with dlm_std as
(
select distinct
(select organizationname from organization_parent(o.id) where organizationtypeid=5 limit 1) "District",
o.organizationname "School",
s.statestudentidentifier "Student Id",
gc.name "Grade",
ap.abbreviatedname "Assessment Program",
e.id enrollid,
r.id rosterid
from student s 
inner join enrollment e on s.id=e.studentid and e.currentschoolyear=2016 --and e.activeflag is true 
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on er.rosterid=r.id and r.statesubjectareaid=441
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organization o on o.id=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.assessmentprogramid=3 
inner join assessmentprogram ap on sap.assessmentprogramid=ap.id 
where gc.abbreviatedname in ('5','8','11')
and s.stateid=51
)
select  "District","School","Student Id","Grade","Assessment Program",max(st.status) status
into temp tmp_dlm
from dlm_std tmp
inner join studentstests st on st.enrollmentid=tmp.enrollid and st.activeflag is true and st.status in (85,86)
inner join testsession ts on ts.id=st.testsessionid and ts.rosterid=tmp.rosterid and ts.schoolyear=2016 and ts.activeflag is true
join operationaltestwindow otw on otw.id=ts.operationaltestwindowid where ts.schoolyear=2016 and ts.source='BATCHAUTO' and otw.id=10153
group by  "District","School","Student Id","Grade","Assessment Program";


--KAP
drop table if exists tmp_kap;
with dlm_std as
(
select distinct
(select organizationname from organization_parent(o.id) where organizationtypeid=5 limit 1) "District",
o.organizationname "School",
s.statestudentidentifier "Student Id",
gc.name "Grade",
ap.abbreviatedname "Assessment Program",
e.id enrollid
from student s 
inner join enrollment e on s.id=e.studentid and e.currentschoolyear=2016 --and e.activeflag is true 
inner join gradecourse gc on gc.id=e.currentgradelevel
inner join organization o on o.id=e.attendanceschoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.assessmentprogramid=12
inner join assessmentprogram ap on sap.assessmentprogramid=ap.id 
where gc.abbreviatedname in ('5','8','11')
and s.stateid=51
)
select  "District","School","Student Id","Grade","Assessment Program",max(st.status) status into temp tmp_kap
from dlm_std tmp
inner join studentstests st on st.enrollmentid=tmp.enrollid and st.activeflag is true and st.status in (85,86)
inner join testsession ts on ts.id=st.testsessionid and  ts.schoolyear=2016 and ts.activeflag is true
where ts.schoolyear=2016 and ts.source='BATCHAUTO' and ts.operationaltestwindowid=10132
and subjectareaid=19
group by  "District","School","Student Id","Grade","Assessment Program";


select src.*, tgt.*  from tmp_kap src
inner join  tmp_dlm tgt on src."Student Id"=tgt."Student Id";

select src.* from tmp_all src
inner join (
select "Student Id",count(*)   from tmp_all
 group by "Student Id"
 having count(*)>1) tgt on src."Student Id"=tgt."Student Id";


\copy (select  * from tmp_all order by 1,2,4,5) to 'tmp_all.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
