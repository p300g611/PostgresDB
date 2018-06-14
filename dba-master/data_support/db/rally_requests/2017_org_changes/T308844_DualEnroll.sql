BEGIN;
/*
check the student with same attendanceschoolid and same aypschoolidentifier.

with dup_enroll as (

select en.studentid,en.aypschoolidentifier,en.attendanceschoolid,count(*) 
from student stu
join enrollment en on stu.id = en.studentid
where en.activeflag is true and stu.activeflag is true and en.currentschoolyear = 2017
group by en.studentid,en.aypschoolidentifier,en.attendanceschoolid
having count(*)>1)

select stu.statestudentidentifier ssid, stu.id studentid, en.aypschoolidentifier,en.attendanceschoolid 
into temp dualenrollment
from student stu
join enrollment en on en.studentid = stu.id
where stu.id in (select studentid from dup_enroll);

\copy (select * from dualenrollment) to 'duplicateenroll.csv' DELIMITER ',' CSV HEANDER;
*/
update enrollment 
 set activeflag = false,
     modifieddate = now(),
	 modifieduser =12
  where id in (2421242,2421239) and activeflag is true;
  
  
COMMIT;
