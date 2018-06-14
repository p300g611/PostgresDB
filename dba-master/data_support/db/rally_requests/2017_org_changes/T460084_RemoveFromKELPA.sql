--ep-audit
select state_student_identifier
into  temp tmp_elpa21
from kids_record_staging 
where elpa21_assess is null OR elpa21_assess='0' or elpa21_assess='C'
group by state_student_identifier;

with dups as 
(
select state_student_identifier,count(distinct enroll) from (select state_student_identifier
,case when elpa21_assess is null OR elpa21_assess='0' or elpa21_assess='C' then 1 
 else 0 end enroll
from kids_record_staging ) bb
group by state_student_identifier
 having count(distinct enroll)>1
 ) 
 select src.state_student_identifier,coalesce(elpa21_assess,'0') elpa21_assess  
 into temp tmp_dual from kids_record_staging src
 inner join dups tmp on src.state_student_identifier=tmp.state_student_identifier
 inner join ( select state_student_identifier,max(create_date::timestamp with time zone) create_date from kids_record_staging
 -- where state_student_identifier='9713633148'
 group by state_student_identifier ) tgt on src.state_student_identifier=tgt.state_student_identifier and 
tgt.create_date=src.create_date::timestamp with time zone;

 \copy (select * from tmp_elpa21 where state_student_identifier not in ( select distinct state_student_identifier from tmp_dual where elpa21_assess in ('1','2') )) to 'elpa_assess.csv' DELIMITER ',' CSV HEADER;


--ep-prod
drop table if exists tmp_elpa_assess;
create temporary table tmp_elpa_assess ( ssid text );
\copy tmp_elpa_assess from 'elpa_assess.csv' DELIMITER ',' CSV HEADER;




BEGIN;
 

select distinct statestudentidentifier,s.id studentid,schoolname,districtname,statename,currentschoolyear,assessmentprogramid
into temp tmp_report
from student s
inner join enrollment en on s.id=en.studentid and s.activeflag is true
inner join tmp_elpa_assess tmp on tmp.ssid=s.statestudentidentifier and stateid=51
inner join organizationtreedetail o on o.schoolid = en.attendanceschoolid 
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
where assessmentprogramid =47 
order by  currentschoolyear desc,schoolname,districtname desc;

\copy (select * from tmp_report ) to 'studentassessmentprogram_removed_enroll.csv' DELIMITER ',' CSV HEADER;


select stu.id studentid,assessmentprogramid,sap.activeflag into temp tmp_report_all from student stu  
inner join tmp_elpa_assess tmp on tmp.ssid=stu.statestudentidentifier and stateid=51
inner join studentassessmentprogram sap on sap.studentid=stu.id and assessmentprogramid =47 and sap.activeflag is true;

\copy (select * from tmp_report_all ) to 'studentassessmentprogram_removed_all.csv' DELIMITER ',' CSV HEADER;
 

update studentassessmentprogram
set    activeflag =false,
       modifieddate='2017-01-20 06:51:24.227684+00',
	   modifieduser =12
where studentid in (select id from student stu  inner join tmp_elpa_assess tmp on tmp.ssid=stu.statestudentidentifier and stateid=51) 
and assessmentprogramid =47 and activeflag =true;

END;



\copy (select * from studentassessmentprogram  where assessmentprogramid=47) to 'studentassessmentprogram.csv' DELIMITER ',' CSV HEADER;

drop table if exists tmp_elpa_assess;

--=============================================================================================================================
-- need to remove all student except we received the 
-- we need to keep QC states

with active_elpa as
(
select 
state_student_identifier,elpa21_assess,
row_number() over (partition by state_student_identifier order by  create_date::timestamp with time zone  desc ) row_num
from kids_record_staging
-- where state_student_identifier='9713633148'
)
select 
state_student_identifier
into  temp tmp_elpa21 
from active_elpa
where coalesce(elpa21_assess,'0') in ('1','2')
and row_num=1;

\copy (select * from tmp_elpa21 ) to 'elpa_assess.csv' DELIMITER ',' CSV HEADER;

BEGIN;

drop table if exists tmp_elpa_assess;
create temporary table tmp_elpa_assess ( ssid text );
\copy tmp_elpa_assess from 'elpa_assess.csv' DELIMITER ',' CSV HEADER;


select count(*) from tmp_elpa_assess;--20898

select distinct s.id studentid
  into temp tmp_exclude_kelpa
from  student s --20898
-- inner join enrollment en on s.id=en.studentid  and s.activeflag is true
inner join tmp_elpa_assess tmp on tmp.ssid=s.statestudentidentifier and stateid=51
-- inner join organizationtreedetail o on o.schoolid = en.attendanceschoolid 
inner join studentassessmentprogram sap on sap.studentid=s.id-- and sap.activeflag is true
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
where assessmentprogramid =47;


update studentassessmentprogram
set    activeflag =false,
       modifieddate=now(),
       modifieduser =12
-- 	   select count(*) from studentassessmentprogram
where studentid not in (select studentid from tmp_exclude_kelpa) 
and assessmentprogramid =47 and activeflag =true;



select count(distinct s.id) studentid
from  student s --20898
-- inner join enrollment en on s.id=en.studentid  and s.activeflag is true
inner join tmp_elpa_assess tmp on tmp.ssid=s.statestudentidentifier and stateid=51
-- inner join organizationtreedetail o on o.schoolid = en.attendanceschoolid 
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true
inner join assessmentprogram ap on ap.id=sap.assessmentprogramid and ap.activeflag is true
where assessmentprogramid =47;


END;



\copy (select * from studentassessmentprogram  where assessmentprogramid=47) to 'studentassessmentprogram.csv' DELIMITER ',' CSV HEADER;

drop table if exists tmp_elpa_assess; 

 

 
 
 
 