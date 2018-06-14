with dup_enrollment 
as 
(
select 
   e.id,
   e.studentid,
   e.currentschoolyear,
   e.createddate,
   e.attendanceschoolid,
   e.aypschoolid,
   first_value(e.id) over (partition by e.studentid,e.currentschoolyear order by e.createddate desc) as recent_enroll,
   coalesce(er.enrollrostercnt,0) enrollrostercount
      from enrollment e
	   inner join student s on s.stateid=(select id from organization where displayidentifier ='MO' and organizationtypeid=2 and activeflag is true ) and s.id=e.studentid and e.activeflag is true 
	   left outer join (select enrollmentid,count(*) enrollrostercnt from enrollmentsrosters group by enrollmentid) er ON e.id=er.enrollmentid
	   inner join (select 
			      s.id,
			      e.currentschoolyear,
			      count(e.attendanceschoolid) dup_cnt
			 from student s
			 inner join enrollment e on s.id=e.studentid and e.activeflag is true 
			      where s.activeflag is true 
				and s.stateid=(select id from organization where displayidentifier ='MO' and organizationtypeid=2 and activeflag is true)
			  group by s.id,e.currentschoolyear
			  having count(e.attendanceschoolid)>1
			) dup on  e.studentid=dup.id
			      and e.currentschoolyear=dup.currentschoolyear) 
select 
    e.studentid,
    s.statestudentidentifier,
    s.legalfirstname,
    s.legallastname,
    e.id enrollmentid,
    e.currentschoolyear,
    e.createddate,
    e.aypschoolid,
    e.attendanceschoolid,
    o.organizationname attendanceschoolname,
    o.displayidentifier attendanceschoolidentify,
    (select  organizationname from organization_parent(o.id) where organizationtypeid=5) districtname,
    e.enrollrostercount
   -- into temp table tmp_dup_enrollment_mo
 from student s
   inner join dup_enrollment e on s.id =e.studentid and s.activeflag is true
   inner join organization o   on e.attendanceschoolid =o.id
   where  s.stateid=(select id from organization where displayidentifier ='MO' and organizationtypeid=2 and activeflag is true)
   order by statestudentidentifier,districtname;

-- \COPY (select * from tmp_dup_enrollment_mo) To 'tmp_dup_enrollment_mo.csv' DELIMITER '|' CSV HEADER;
         

