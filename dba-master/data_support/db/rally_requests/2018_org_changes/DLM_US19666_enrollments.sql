drop table if exists tmp_reports;
select distinct s.id "student id",
s.statestudentidentifier "state student identifier",
s.legalfirstname "student first name",
s.legallastname "student last name",
ca.abbreviatedname "content area",
ord.statename "state",
ord.districtname "district name",
ord.districtdisplayidentifier "district code",
ord.schoolname "school name",
ord.schooldisplayidentifier "school code",
art.id "education id",
art.firstname "educator first name",
art.surname "educator last name" 
into temp tmp_reports
from student s 
inner join enrollment e on s.id=e.studentid and s.activeflag is true 
inner join enrollmentsrosters er on e.id=er.enrollmentid and er.activeflag is true
inner join roster r on er.rosterid=r.id and r.activeflag is true
inner join organizationtreedetail ord on e.attendanceschoolid=ord.schoolid
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
inner join contentarea ca on r.statesubjectareaid=ca.id
inner join aartuser art on r.teacherid=art.id
where e.currentschoolyear=2018 and e.activeflag is true and assessmentprogramid=3
and ord.statename not in ('DLM QC State','NY Training State','QA QC State','Service Desk QC State')
and ca.abbreviatedname<>'ELP';
\copy (select * from tmp_reports order by 6,7,9,1) to 'DLM_US19666.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

