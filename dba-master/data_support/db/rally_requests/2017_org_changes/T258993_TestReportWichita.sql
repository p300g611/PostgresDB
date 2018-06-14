
--ep-prod
SELECT distinct stu.statestudentidentifier ssid
into temp tmp_wichita
from student stu

inner join enrollment en on en.studentid = stu.id and en.activeflag is true
inner join organizationtreedetail ort on ort.schoolid = en.attendanceschoolid
where en.currentschoolyear=2017 and ort.districtid = 261 and stu.activeflag is true;


 \copy (select * from tmp_wichita ) to 'tmp_ssid.csv' DELIMITER ',' CSV HEADER;
 
 
 



--ep-audit
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
		and kids.create_date::timestamp with time zone  >= '2017-01-17 18:59:59.933016+00'
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
		and tasc.create_date::timestamp with time zone  >= '2017-01-17 18:59:59.933016+00' 
    ) as kidstascrecords ORDER BY  state_student_identifier,ksdexmlaudit_id, sequence_order;


\copy (select * from tmp_final) to 'tmp_final.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);