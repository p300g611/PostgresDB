--validation:aart-prod
select schoolentrydate,e.activeflag,e.sourcetype,count(*) enrollcnt,count(distinct s.id) stdcnt
from enrollment e
inner join student s on s.id=e.studentid
where schoolentrydate is null and s.stateid=51 and s.activeflag is true
group by  schoolentrydate,e.activeflag,e.sourcetype;

select count(*) from (
select e.id,s.statestudentidentifier,e.aypschoolid,ayp.displayidentifier as aypdisplayidentifier,e.attendanceschoolid,ayp.displayidentifier 
as aypdisplayidentifier,e.schoolentrydate from enrollment e join organization ayp on ayp.id=e.aypschoolid 
join organization att on att.id=e.attendanceschoolid 
join student s on s.id=e.studentid and s.stateid=51 and s.activeflag is true
 where e.schoolentrydate is null and e.currentschoolyear=2017) aa limit 10;

select schoolentrydate,e.activeflag,count(*) enrollcnt,count(distinct s.id) stdcnt
select e.id,s.statestudentidentifier
from enrollment e
inner join student s on s.id=e.studentid
inner join organization o on o.id=e.attendanceschoolid and o.activeflag is true
inner join organization oa on oa.id=e.aypschoolid and oa.activeflag is true
inner join enrollmenttesttypesubjectarea ets on ets.enrollmentid=e.id
where schoolentrydate is null and s.stateid=51 and s.activeflag is true
group by  schoolentrydate,e.activeflag;


-- find the list 
select s.statestudentidentifier ssid,o.displayidentifier attendanceschool,
  oa.displayidentifier aypschool, e.id enrollid,s.id studentid,e.sourcetype
   into temp tmp_enroll
from enrollment e
inner join student s on s.id=e.studentid
inner join organization o on o.id=e.attendanceschoolid and o.activeflag is true
inner join organization oa on oa.id=e.aypschoolid and oa.activeflag is true
where schoolentrydate is null and s.stateid=51 and s.activeflag is true and e.currentschoolyear=2017;

\copy (select * from tmp_enroll) to 'tmp_enroll.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--validation:aart-audit
create  table tmp_enroll (ssid text ,attendanceschool text,aypschool text, enrollid bigint,studentid bigint,sourcetype text);
\COPY tmp_enroll FROM 'tmp_enroll.csv' DELIMITER ',' CSV HEADER ;

--enrollment with null school entry 
select count(distinct enrollid) from tmp_enroll ;
--  count
-- -------
--  79404
-- (1 row)

--Note: we are looking only on kids at this point 
--kids table match rows
select count(distinct enrollid) from kids_record_staging kids
inner join tmp_enroll tmp on tmp.ssid =kids.state_student_identifier
where 'COMPLETED'=kids.status;


--  count
-- -------
--   6367
-- (1 row)

select status,record_type ,count(distinct enrollid) from kids_record_staging kids
inner join tmp_enroll tmp on tmp.ssid =kids.state_student_identifier
group by status,record_type;
    status     | record_type | count
---------------+-------------+-------
 COMPLETED     | EXIT        |  4924
 COMPLETED     | TEST        |  2749
 NOT PROCESSED | EXIT        |  4202
 NOT PROCESSED | TEST        |  1515
(4 rows)



select status,record_type ,count(distinct enrollid) from tasc_record_staging kids
inner join tmp_enroll tmp on tmp.ssid =kids.state_student_identifier
group by status,record_type;
    status     | record_type | count
---------------+-------------+-------
 COMPLETED     | EXIT        |  4924
 COMPLETED     | TEST        |  2749
 NOT PROCESSED | EXIT        |  4202
 NOT PROCESSED | TEST        |  1515
(4 rows)

--kids table match rows with building
select count(distinct enrollid) from kids_record_staging kids
inner join tmp_enroll tmp on tmp.ssid =kids.state_student_identifier
  and tmp.attendanceschool=kids.attendance_bldg_no and tmp.aypschool=kids.ayp_qpa_bldg_no
where 'COMPLETED'=kids.status;

--  count
-- -------
--   4870
-- (1 row)

--tasc table match rows(only for check)
select count(distinct enrollid) from tasc_record_staging kids
inner join tmp_enroll tmp on tmp.ssid =kids.state_student_identifier
where 'COMPLETED'=kids.status;
--  count
-- -------
--  79398
-- (1 row)

--tasc table match rows with buiding (only for check)
select count(distinct enrollid) from tasc_record_staging kids
inner join tmp_enroll tmp on tmp.ssid =kids.state_student_identifier
  --and tmp.attendanceschool=kids.attendance_bldg_no --
  and tmp.aypschool=kids.ayp_qpa_bldg_no
where 'COMPLETED'=kids.status ;
--  count
-- -------
--  79401
-- (1 row)

select school_entry_date,count(distinct enrollid) from tasc_record_staging kids
inner join tmp_enroll tmp on tmp.ssid =kids.state_student_identifier
  --and tmp.attendanceschool=kids.attendance_bldg_no --
  and tmp.aypschool=kids.ayp_qpa_bldg_no
where 'COMPLETED'=kids.status
group by school_entry_date;

--  school_entry_date | count
-- -------------------+-------
--                    | 79401
-- (1 row)



--find the school entry date (note:: need to verify if they want sch by daylight)
select enrollid,school_entry_date,ssid,studentid
 ,school_entry_date::timestamp without time zone AT TIME ZONE 'CST6CDT' school_entry_date_daylight,create_date
 ,row_number() over(partition by enrollid order by create_date::timestamp with time zone desc, id desc) row_num 
   into  tmp_kids
  from kids_record_staging kids
inner join tmp_enroll tmp on tmp.ssid =kids.state_student_identifier
and tmp.attendanceschool=kids.attendance_bldg_no and tmp.aypschool=kids.ayp_qpa_bldg_no
where 'COMPLETED'=kids.status;


\copy (select enrollid,school_entry_date,school_entry_date_daylight from tmp_kids where row_num=1) to 'tmp_kids.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);



--validation few records:
 select * from tmp_kids where row_num>3;


 select count(*) from tmp_kids where row_num=1 ;
 select * from tmp_kids where row_num=1 and ssid='2297123957';

 select status,id,create_date,school_entry_date,school_entry_date::timestamp without time zone AT TIME ZONE 'CST6CDT' school_entry_date_daylight,attendance_bldg_no,ayp_qpa_bldg_no
 ,row_number() over(partition by state_student_identifier,attendance_bldg_no,ayp_qpa_bldg_no order by create_date::timestamp with time zone desc, id desc) row_num 
  from kids_record_staging kids where 'COMPLETED'=status and state_student_identifier='2297123957';

--from aart-prod
select * from enrollment where id=2427128;

--validation:aart-prod
create temp table tmp_kids (enrollid bigint ,school_entry_date text,school_entry_date_daylight timestamp with time zone);
\COPY tmp_kids FROM 'tmp_kids.csv' DELIMITER ',' CSV HEADER ;

select count(*) from tmp_kids;


begin;

update enrollment e
set schoolentrydate=tmp.school_entry_date_daylight 
from tmp_kids tmp where tmp.enrollid=e.id and e.schoolentrydate is null;

commit;







