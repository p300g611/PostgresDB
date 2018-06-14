--make inactive for duplicate enrollment associated active roster 
--move the enrollment rosters to active enrollment ( ****IMPROTANT NOTE****: Need to confirm this step is necessary or not) 
BEGIN;
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
update enrollmentsrosters er
   set  activeflag=false
       ,modifieddate=now()
       ,modifieduser=12
   from dup_enrollment e 
      where er.enrollmentid=e.id 
        and er.activeflag is true
        and e.recent_enroll<>e.id ;


COMMIT;     

--make inactive for dupicate enrollment 
BEGIN;
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
update enrollment er
   set  activeflag=false
       ,modifieddate=now()
       ,modifieduser=12
   from dup_enrollment e 
      where er.id=e.id 
        and er.activeflag is true
        and e.recent_enroll<>e.id ;


COMMIT;   
