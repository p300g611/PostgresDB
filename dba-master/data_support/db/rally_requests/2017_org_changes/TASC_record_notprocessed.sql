-- from audit database
with tmp_ssid as
(
select tasc.* from (
Select state_student_identifier ssid, max(create_date::timestamp with time zone) create_date_tasc_max
from tasc_record_staging where record_type='TASC' and current_school_year='2017'  --and status='NOT PROCESSED'
group by state_student_identifier) tasc
inner join (Select state_student_identifier ssid
from kids_record_staging where record_type='EXIT' and current_school_year='2017'  --and status='NOT PROCESSED'
group by state_student_identifier) ext on ext.ssid=tasc.ssid
)
select tmp.ssid,attendance_bldg_no,ayp_qpa_bldg_no,max(create_date::timestamp with time zone) create_date_exit_max,max(create_date_tasc_max::timestamp with time zone) create_date_tasc_max,
case when  max (case when status='NOT PROCESSED' then 1 else 0 end )=1 then 'NOT PROCESSED' else 'PROCESSED' end  priority_status  
into temp tmp_ext
from tmp_ssid tmp
inner join kids_record_staging src on src.state_student_identifier=tmp.ssid
where record_type='EXIT' and current_school_year='2017'-- and status='NOT PROCESSED'
--and ssid='1035612356'
group by tmp.ssid,attendance_bldg_no,ayp_qpa_bldg_no
;
\copy (select * from tmp_ext) to 'tmp_audit.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
--aart prod
create temp table tmp_ext (ssid text ,attendance_bldg_no text,ayp_qpa_bldg_no text, create_date_exit_max text,create_date_tasc_max text,priority_status text );
\COPY tmp_ext FROM 'tmp_audit.csv' DELIMITER ',' CSV HEADER ;


select count(distinct s.id) from student s
inner join tmp_ext tmp on tmp.ssid=s.statestudentidentifier
inner join enrollment e on e.studentid=s.id
where s.stateid=51 and s.activeflag is true;

-- attendance school= ayp school
select currentschoolyear,districtname,schoolname,tmp.*, s.id studentkiteid,e.sourcetype,e.id enrollid,e.currentgradelevel,e.exitwithdrawaldate,exitwithdrawaltype, 
 case when create_date_exit_max::timestamp with time zone>create_date_tasc_max::timestamp with time zone then 'yes' else 'no' end new_col,
e.createddate,e.modifieddate,e.activeflag enrollmentactive
into temp tmp_enrollments
 from student s
inner join tmp_ext tmp on tmp.ssid=s.statestudentidentifier
inner join enrollment e on e.studentid=s.id 
inner join organizationtreedetail o_att on o_att.schoolid=e.attendanceschoolid and o_att.schooldisplayidentifier=tmp.attendance_bldg_no
where s.stateid=51 and s.activeflag is true -- and coalesce(attendance_bldg_no,'')=coalesce(ayp_qpa_bldg_no,'')
and e.activeflag is true and currentschoolyear=2017
order by districtname,schoolname,tmp.ssid,currentschoolyear;

\copy (select * from tmp_enrollments) to 'tmp_enrollments.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

select distinct ssid into temp tmp_ssid from tmp_enrollments; 
\copy (select * from tmp_ssid) to 'tmp_ssid.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
-- other enrollment list 
select distinct 
e.currentschoolyear,oe.districtname enroll_districtname,oe.schoolname enroll_schoolname,otmp.districtname tasc_districtname,otmp.schoolname tasc_schoolname,
tmp.*,
s.id studentkiteid,e.sourcetype,e.id enrollid,e.currentgradelevel,e.exitwithdrawaldate,e.exitwithdrawaltype,e.createddate,e.modifieddate,e.activeflag enrollmentactive
into temp tmp_enrollments_other
from student s
inner join tmp_ext tmp on tmp.ssid=s.statestudentidentifier
inner join enrollment e on e.studentid=s.id 
inner join organizationtreedetail oe on oe.schoolid=e.attendanceschoolid
left outer join organizationtreedetail otmp on otmp.schoolid=e.attendanceschoolid and otmp.schooldisplayidentifier=tmp.attendance_bldg_no
where s.stateid=51 and s.activeflag is true 
order by oe.districtname,oe.schoolname,tmp.ssid,e.currentschoolyear;

\copy (select * from tmp_enrollments_other) to 'tmp_enrollments_other.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



-- attendance school<> ayp school pending for now

create temp table tmp_ssid (ssid text );
\COPY tmp_ssid FROM 'tmp_ssid.csv' DELIMITER ',' CSV HEADER ;

select * into temp tmp_final from (SELECT kids.ksdexmlaudit_id as ksdexmlaudit_id, kids.sequence_order sequence_order, kids.create_date AS create_date, kids.record_common_id AS record_common_id, kids.record_type AS record_type, 
   	  kids.state_student_identifier AS state_student_identifier, kids.ayp_qpa_bldg_no AS ayp_qpa_bldg_no, kids.legal_last_name AS legal_last_name, kids.legal_first_name AS legal_first_name,
      kids.legal_middle_name AS legal_middle_name, kids.generation_code AS generation_code, kids.gender AS gender, kids.current_grade_level AS current_grade_level, kids.current_school_year AS current_school_year,
      kids.attendance_bldg_no AS attendance_bldg_no, kids.notes AS notes, kids.district_entry_date AS district_entry_date, kids.school_entry_date AS school_entry_date, kids.state_entry_date AS state_entry_date,
      kids.hispanic_ethnicity AS hispanic_ethnicity, kids.emailsent AS emailsent, kids.emailsentto AS emailsentto, kids.status AS status, kids.birth_date AS birth_date, kids.triggeremail AS triggeremail,
      '' AS educator_bldg_no, '' AS state_subj_area_code, '' AS local_course_id, '' AS course_status, '' AS teacher_identifier, '' AS teacher_last_name, '' AS teacher_first_name,
      '' AS teacher_middle_name, '' AS teacher_district_email, kids.comprehensive_race, kids.primary_exceptionality_code, kids.secondary_exceptionality_code, 
      kids.grouping_math_1, kids.grouping_math_2, kids.grouping_reading_1, kids.grouping_reading_2,
      kids.grouping_science_1, kids.grouping_science_2, kids.grouping_history_1, kids.grouping_history_2, kids.state_math_assess,kids.state_science_assess, kids.animal_systems_assess,
      kids.comprehensive_ag_assess, kids.comprehensive_business_assess, kids.design_preconstruction_assess, kids.ela_proctor_id, kids.ela_proctor_name, kids.elpa21_assess, kids.esol_participation_code,
      kids.finance_assess, kids.general_cte_assess, kids.grouping_animal_systems, kids.grouping_comprehensive_ag, kids.grouping_comprehensive_business, kids.grouping_cte_1, kids.grouping_cte_2,
      kids.grouping_design_preconstruction, kids.grouping_elpa21_1, kids.grouping_elpa21_2, kids.grouping_finance, kids.grouping_manufacturing_prod, kids.grouping_plant_systems,
      kids.manufacturing_prod_assess, kids.math_dlm_proctor_id, kids.math_dlm_proctor_name, kids.plant_systems_assess, kids.science_dlm_proctor_id, kids.science_dlm_proctor_name, 
      kids.state_ela_assess, kids.state_hist_gov_assess, kids.av_communications_assess, kids.grouping_av_communications, kids.financial_literacy_assess, kids.grouping_financial_literacy_1,
      kids.grouping_financial_literacy_2, kids.elpa_proctor_id, kids.elpa_proctor_first_name, kids.elpa_proctor_last_name, kids.exit_withdrawal_type, kids.exit_withdrawal_date
    	FROM kids_record_staging as kids where  state_student_identifier in ( select distinct ssid from tmp_ssid) 
		UNION
		SELECT tasc.ksdexmlaudit_id   AS ksdexmlaudit_id, tasc.sequence_order  AS sequence_order, tasc.create_date  AS create_date, tasc.record_common_id  AS record_common_id,
       tasc.record_type  AS record_type, tasc.state_student_identifier  AS state_student_identifier, tasc.ayp_qpa_bldg_no  AS ayp_qpa_bldg_no, tasc.student_legal_last_name  AS legal_last_name,
       tasc.student_legal_first_name  AS legal_first_name, tasc.student_legal_middle_name  AS legal_middle_name, tasc.student_generation_code  AS generation_code, tasc.student_gender  AS gender,
       tasc.current_grade_level  AS current_grade_level, tasc.current_school_year  AS current_school_year, tasc.attendance_bldg_no  AS attendance_bldg_no, tasc.notes  AS notes, 
       tasc.district_entry_date  AS district_entry_date, tasc.school_entry_date  AS school_entry_date, tasc.state_entry_date  AS state_entry_date, tasc.hispanic_ethnicity  AS hispanic_ethnicity,
       tasc.emailsent  AS emailsent, tasc.emailsentto  AS emailsentto, tasc.status  AS status, tasc.birth_date  AS birth_date, tasc.triggeremail  AS triggeremail,
      tasc.educator_bldg_no, tasc.state_subj_area_code, tasc.local_course_id, tasc.course_status, tasc.teacher_identifier, tasc.teacher_last_name, tasc.teacher_first_name,
      tasc.teacher_middle_name, tasc.teacher_district_email, '' AScomprehensive_race, '' ASprimary_exceptionality_code, '' ASsecondary_exceptionality_code, '' ASgrouping_math_1, 
      '' ASgrouping_math_2, '' ASgrouping_reading_1, '' ASgrouping_reading_2,
      '' ASgrouping_science_1, '' ASgrouping_science_2, '' ASgrouping_history_1, '' ASgrouping_history_2, '' ASstate_math_assess,'' ASstate_science_assess, '' ASanimal_systems_assess,
      '' AScomprehensive_ag_assess, '' AScomprehensive_business_assess, '' ASdesign_preconstruction_assess, '' ASela_proctor_id, '' ASela_proctor_name, '' ASelpa21_assess, '' ASesol_participation_code,
      '' ASfinance_assess, '' ASgeneral_cte_assess, '' ASgrouping_animal_systems, '' ASgrouping_comprehensive_ag, '' ASgrouping_comprehensive_business, '' ASgrouping_cte_1, '' ASgrouping_cte_2,
      '' ASgrouping_design_preconstruction, '' ASgrouping_elpa21_1, '' ASgrouping_elpa21_2, '' ASgrouping_finance, '' ASgrouping_manufacturing_prod, '' ASgrouping_plant_systems,
      '' ASmanufacturing_prod_assess, '' ASmath_dlm_proctor_id, '' ASmath_dlm_proctor_name, '' ASplant_systems_assess, '' ASscience_dlm_proctor_id, '' ASscience_dlm_proctor_name, 
      '' ASstate_ela_assess, '' ASstate_hist_gov_assess, '' ASav_communications_assess, '' ASgrouping_av_communications, '' ASfinancial_literacy_assess, '' ASgrouping_financial_literacy_1,
      '' ASgrouping_financial_literacy_2, '' ASelpa_proctor_id, '' ASelpa_proctor_first_name, '' ASelpa_proctor_last_name, '' ASexit_withdrawal_type, '' ASexit_withdrawal_date
		FROM tasc_record_staging as tasc where  state_student_identifier in ( select distinct ssid from tmp_ssid)
    ) as kidstascrecords ORDER BY  state_student_identifier,ksdexmlaudit_id, sequence_order;

\copy (select * from tmp_final) to 'tmp_final.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


-------------------------------------------------------------------------------------------
-- only for yes students after helpdesk validation
create temp table tmp_enrollment
(id bigint);
\COPY tmp_enrollment FROM 'tmp_emrollment.csv' DELIMITER ',' CSV HEADER ;

-- test validation
select statestudentidentifier,e.id,st.status,ts.schoolyear,count(*) from enrollment  e
inner join student s on s.id=e.studentid
 inner join tmp_enrollment tmp on e.id=tmp.id and e.activeflag is true
 inner join studentstests st on e.id=st.enrollmentid and st.activeflag is true
 inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true
-- where st.status=86
group by  e.id,st.status,ts.schoolyear,statestudentidentifier
order by st.status;

update enrollment
set  activeflag= false ,
modifieddate=now(),
modifieduser=12,
notes='Defect Cleanup for Exits not being processed'
where id in (select id from tmp_enrollment) and activeflag is true;


-----------------------------
9413973776
4428523653
3657793437
2083988612
3069334652


select distinct substring( notes,12,1000) from kids_record_staging where status='NOT PROCESSED' 
and state_student_identifier in ('9413973776',
'4428523653',
'3657793437',
'2083988612',
'3069334652');


select distinct substring( notes,12,1000) from tasc_record_staging where status='NOT PROCESSED' 
and state_student_identifier in ('9413973776',
'4428523653',
'3657793437',
'2083988612',
'3069334652');


TASC does NOT match the school on the TEST record


select distinct  from tasc_record_staging where status='NOT PROCESSED' 
and state_student_identifier in (
'2083988612');


select distinct state_student_identifier from tasc_record_staging 
where notes='ATT school on the TASC does NOT match the school on the TEST record';



select * into temp tmp_final_all from (SELECT kids.ksdexmlaudit_id as ksdexmlaudit_id, kids.sequence_order sequence_order, kids.create_date AS create_date, kids.record_common_id AS record_common_id, kids.record_type AS record_type, 
   	  kids.state_student_identifier AS state_student_identifier, kids.ayp_qpa_bldg_no AS ayp_qpa_bldg_no, kids.legal_last_name AS legal_last_name, kids.legal_first_name AS legal_first_name,
      kids.legal_middle_name AS legal_middle_name, kids.generation_code AS generation_code, kids.gender AS gender, kids.current_grade_level AS current_grade_level, kids.current_school_year AS current_school_year,
      kids.attendance_bldg_no AS attendance_bldg_no, kids.notes AS notes, kids.district_entry_date AS district_entry_date, kids.school_entry_date AS school_entry_date, kids.state_entry_date AS state_entry_date,
      kids.hispanic_ethnicity AS hispanic_ethnicity, kids.emailsent AS emailsent, kids.emailsentto AS emailsentto, kids.status AS status, kids.birth_date AS birth_date, kids.triggeremail AS triggeremail,
      '' AS educator_bldg_no, '' AS state_subj_area_code, '' AS local_course_id, '' AS course_status, '' AS teacher_identifier, '' AS teacher_last_name, '' AS teacher_first_name,
      '' AS teacher_middle_name, '' AS teacher_district_email, kids.comprehensive_race, kids.primary_exceptionality_code, kids.secondary_exceptionality_code, 
      kids.grouping_math_1, kids.grouping_math_2, kids.grouping_reading_1, kids.grouping_reading_2,
      kids.grouping_science_1, kids.grouping_science_2, kids.grouping_history_1, kids.grouping_history_2, kids.state_math_assess,kids.state_science_assess, kids.animal_systems_assess,
      kids.comprehensive_ag_assess, kids.comprehensive_business_assess, kids.design_preconstruction_assess, kids.ela_proctor_id, kids.ela_proctor_name, kids.elpa21_assess, kids.esol_participation_code,
      kids.finance_assess, kids.general_cte_assess, kids.grouping_animal_systems, kids.grouping_comprehensive_ag, kids.grouping_comprehensive_business, kids.grouping_cte_1, kids.grouping_cte_2,
      kids.grouping_design_preconstruction, kids.grouping_elpa21_1, kids.grouping_elpa21_2, kids.grouping_finance, kids.grouping_manufacturing_prod, kids.grouping_plant_systems,
      kids.manufacturing_prod_assess, kids.math_dlm_proctor_id, kids.math_dlm_proctor_name, kids.plant_systems_assess, kids.science_dlm_proctor_id, kids.science_dlm_proctor_name, 
      kids.state_ela_assess, kids.state_hist_gov_assess, kids.av_communications_assess, kids.grouping_av_communications, kids.financial_literacy_assess, kids.grouping_financial_literacy_1,
      kids.grouping_financial_literacy_2, kids.elpa_proctor_id, kids.elpa_proctor_first_name, kids.elpa_proctor_last_name, kids.exit_withdrawal_type, kids.exit_withdrawal_date
    	FROM kids_record_staging as kids where  state_student_identifier in ( select distinct state_student_identifier from tasc_record_staging 
where notes='ATT school on the TASC does NOT match the school on the TEST record') 
		UNION
		SELECT tasc.ksdexmlaudit_id   AS ksdexmlaudit_id, tasc.sequence_order  AS sequence_order, tasc.create_date  AS create_date, tasc.record_common_id  AS record_common_id,
       tasc.record_type  AS record_type, tasc.state_student_identifier  AS state_student_identifier, tasc.ayp_qpa_bldg_no  AS ayp_qpa_bldg_no, tasc.student_legal_last_name  AS legal_last_name,
       tasc.student_legal_first_name  AS legal_first_name, tasc.student_legal_middle_name  AS legal_middle_name, tasc.student_generation_code  AS generation_code, tasc.student_gender  AS gender,
       tasc.current_grade_level  AS current_grade_level, tasc.current_school_year  AS current_school_year, tasc.attendance_bldg_no  AS attendance_bldg_no, tasc.notes  AS notes, 
       tasc.district_entry_date  AS district_entry_date, tasc.school_entry_date  AS school_entry_date, tasc.state_entry_date  AS state_entry_date, tasc.hispanic_ethnicity  AS hispanic_ethnicity,
       tasc.emailsent  AS emailsent, tasc.emailsentto  AS emailsentto, tasc.status  AS status, tasc.birth_date  AS birth_date, tasc.triggeremail  AS triggeremail,
      tasc.educator_bldg_no, tasc.state_subj_area_code, tasc.local_course_id, tasc.course_status, tasc.teacher_identifier, tasc.teacher_last_name, tasc.teacher_first_name,
      tasc.teacher_middle_name, tasc.teacher_district_email, '' AScomprehensive_race, '' ASprimary_exceptionality_code, '' ASsecondary_exceptionality_code, '' ASgrouping_math_1, 
      '' ASgrouping_math_2, '' ASgrouping_reading_1, '' ASgrouping_reading_2,
      '' ASgrouping_science_1, '' ASgrouping_science_2, '' ASgrouping_history_1, '' ASgrouping_history_2, '' ASstate_math_assess,'' ASstate_science_assess, '' ASanimal_systems_assess,
      '' AScomprehensive_ag_assess, '' AScomprehensive_business_assess, '' ASdesign_preconstruction_assess, '' ASela_proctor_id, '' ASela_proctor_name, '' ASelpa21_assess, '' ASesol_participation_code,
      '' ASfinance_assess, '' ASgeneral_cte_assess, '' ASgrouping_animal_systems, '' ASgrouping_comprehensive_ag, '' ASgrouping_comprehensive_business, '' ASgrouping_cte_1, '' ASgrouping_cte_2,
      '' ASgrouping_design_preconstruction, '' ASgrouping_elpa21_1, '' ASgrouping_elpa21_2, '' ASgrouping_finance, '' ASgrouping_manufacturing_prod, '' ASgrouping_plant_systems,
      '' ASmanufacturing_prod_assess, '' ASmath_dlm_proctor_id, '' ASmath_dlm_proctor_name, '' ASplant_systems_assess, '' ASscience_dlm_proctor_id, '' ASscience_dlm_proctor_name, 
      '' ASstate_ela_assess, '' ASstate_hist_gov_assess, '' ASav_communications_assess, '' ASgrouping_av_communications, '' ASfinancial_literacy_assess, '' ASgrouping_financial_literacy_1,
      '' ASgrouping_financial_literacy_2, '' ASelpa_proctor_id, '' ASelpa_proctor_first_name, '' ASelpa_proctor_last_name, '' ASexit_withdrawal_type, '' ASexit_withdrawal_date
		FROM tasc_record_staging as tasc where  state_student_identifier in ( select distinct state_student_identifier from tasc_record_staging 
where notes='ATT school on the TASC does NOT match the school on the TEST record')
    ) as kidstascrecords ORDER BY  state_student_identifier,ksdexmlaudit_id, sequence_order;

\copy (select * from tmp_final_all) to 'tmp_final_all.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


select distinct state_student_identifier,ayp_qpa_bldg_no 
 into temp tmp_final from(
SELECT state_student_identifier,ayp_qpa_bldg_no
    	        FROM kids_record_staging as kids where  state_student_identifier in ( select distinct state_student_identifier from tasc_record_staging 
where notes='ATT school on the TASC does NOT match the school on the TEST record') 
		UNION
SELECT state_student_identifier,ayp_qpa_bldg_no
		FROM tasc_record_staging as tasc where  state_student_identifier in ( select distinct state_student_identifier from tasc_record_staging 
where notes='ATT school on the TASC does NOT match the school on the TEST record')
    ) aa;

\copy (select * from tmp_final) to 'tmp_final.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



create temp table tmp (ssid text, ayp text);
\COPY tmp FROM 'tmp_final.csv' DELIMITER ',' CSV HEADER ;


select districtid,districtname,count(distinct s.id) studentcount from student s
inner join tmp tmp on tmp.ssid=s.statestudentidentifier
inner join enrollment e on e.studentid=s.id 
inner join organizationtreedetail o_att on o_att.schoolid=e.attendanceschoolid and o_att.schooldisplayidentifier=tmp.ayp
where s.stateid=51 and e.activeflag is true and e.currentschoolyear=2017
group by districtid,districtname
order by 3 desc;


select districtid,districtname,schoolname ,count(distinct s.id) studentcount from student s
inner join tmp tmp on tmp.ssid=s.statestudentidentifier
inner join enrollment e on e.studentid=s.id 
inner join organizationtreedetail o_att on o_att.schoolid=e.attendanceschoolid and o_att.schooldisplayidentifier=tmp.ayp
where s.stateid=51
group by districtid,districtname,schoolname
order by 4 desc;



select districtid,districtname,schoolname ,s.id studentid,s.statestudentidentifier,e.id enrollid ,e.sourcetype enrollsource ,er.id enrollrosterid,r.id rosterid,
r.coursesectionname,r.statesubjectareaid,r.sourcetype rostersource
into temp tmp_enrollmentsrosters
from student s
inner join tmp tmp on tmp.ssid=s.statestudentidentifier
inner join enrollment e on e.studentid=s.id 
inner join enrollmentsrosters er on er.enrollmentid=e.id and er.activeflag is true 
inner join roster r on er.rosterid=r.id and r.activeflag is true 
inner join organizationtreedetail o_att on o_att.schoolid=e.attendanceschoolid and o_att.schooldisplayidentifier=tmp.ayp
where s.stateid=51 and e.activeflag is true and e.currentschoolyear=2017
order by 2,3;


\copy (select * from tmp_enrollmentsrosters) to 'tmp_enrollmentsrosters.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



select 
e.studentid into temp dup_enroll
from enrollment e
inner join student s on e.studentid=s.id
inner join studentassessmentprogram sap on sap.studentid=s.id and sap.activeflag is true 
where currentschoolyear=2017 and s.stateid=51
and e.activeflag is true
and s.activeflag is true
and assessmentprogramid=12
group by e.studentid
having count(*)>1;

select e.studentid,s.statestudentidentifier ssid,e.currentschoolyear,schoolname,districtname,statename,e.id enrollid,e.activeflag enrollactive,
er.id enrollrosterid,er.activeflag enrollrosteractive,r.coursesectionname,statesubjectareaid,statecoursecode,statecourseid ,e.modifieddate enrollmod, er.modifieddate enrollrostermod 
   into temp dup_enroll_kap
                                             from enrollment e 
						 inner join student s on s.id=e.studentid and s.activeflag is true and e.activeflag is true
						 join organizationtreedetail o on o.schoolid=e.attendanceschoolid and e.currentschoolyear=2017
						 left outer join  enrollmentsrosters er on e.id=er.enrollmentid and er.activeflag is true
                                                 left outer join roster r on r.id=er.rosterid and r.activeflag is true
where s.id in ( select studentid from dup_enroll);

\copy (select * from dup_enroll_kap order by studentid ) to 'dup_enroll_kap.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 


select distinct ssid into temp tmp_ssid from dup_enroll_kap; 
\copy (select * from tmp_ssid) to 'tmp_ssid.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);