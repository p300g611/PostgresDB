-- aart-prod database 
 drop table if exists  tmp_enrollment_inactive_exit ;
 Select o.displayidentifier attendanceschool,
        oayp.displayidentifier aypschool,
        e.id enrollmentid,
        s.statestudentidentifier
               INTO temp tmp_enrollment_inactive_exit
   from enrollment e 
    inner join student s on e.studentid=s.id and s.activeflag is true
    inner join organization o on o.id=attendanceschoolid
    inner join organization oayp on oayp.id=aypschoolid
    where e.currentschoolyear=2016 and e.activeflag is false 
           and (e.attendanceschoolid in (1275,1545,2263,2798,5982,6335) or e.attendanceschoolid in (select id from organization_children(199) where organizationtypeid=7));



\COPY tmp_enrollment_inactive_exit TO 'tmp_enrollment_inactive_exit.csv' DELIMITER '|' CSV HEADER ;     

-- aart-audit database  
 drop table if exists  tmp_enrollment_inactive_exit ;
              Create temp table tmp_enrollment_inactive_exit (attendanceschool text,aypschool text ,enrollmentid integer,statestudentidentifier text ) ;
\COPY tmp_enrollment_inactive_exit FROM 'tmp_enrollment_inactive_exit.csv' DELIMITER '|' CSV HEADER ; 
          
     WITH max_val as (select state_student_identifier,
			     attendance_bldg_no,
			     ayp_qpa_bldg_no, count(*) max_record_type
		    from kids_record_staging stg
		   where exists (select 1 from tmp_enrollment_inactive_exit e where e.statestudentidentifier=stg.state_student_identifier)
		    group by state_student_identifier,
			     attendance_bldg_no,
			     ayp_qpa_bldg_no)
	  ,row_val as ( select  state_student_identifier,
			     attendance_bldg_no,
			     ayp_qpa_bldg_no,
			     record_type,
			     row_number() over (partition by state_student_identifier,attendance_bldg_no,ayp_qpa_bldg_no order by id ) row_num,
			     lag(record_type) over (partition by state_student_identifier,attendance_bldg_no,ayp_qpa_bldg_no order by id ) lag_row
       from  kids_record_staging  stg
       where exists (select 1 from tmp_enrollment_inactive_exit e where e.statestudentidentifier=stg.state_student_identifier)
       )              
 SELECT  
     e.* from row_val stg 
            inner join max_val tmp  ON tmp.state_student_identifier=stg.state_student_identifier
					  and  tmp.attendance_bldg_no=stg.attendance_bldg_no
					  and  tmp.ayp_qpa_bldg_no=stg.ayp_qpa_bldg_no
					  and  tmp.max_record_type=stg.row_num
           inner join tmp_enrollment_inactive_exit e on e.statestudentidentifier=stg.state_student_identifier
						   and  e.attendanceschool=stg.attendance_bldg_no
					           and  e.aypschool=stg.ayp_qpa_bldg_no                                
           where stg.record_type='TEST' and stg.lag_row='EXIT';                       

