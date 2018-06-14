Drop table if exists raw_student;
create temporary table raw_student(ssid text);
\copy raw_student from 'raw_roster.csv' DELIMITER ',' CSV HEADER;

   select   s.statestudentidentifier    "SSID",
     o.schoolname                "School Name",
     o.schooldisplayidentifier   "Building display identifier",
     o.districtname              "District Name",
     o.districtdisplayidentifier "District display identifier",
     enr.activeflag              "enrollmentrosters active flag",
	 en.currentschoolyear        "current school year"
	 
  into temp tmp_student
       from raw_student  tmp
 left outer join student s on tmp.ssid = s.statestudentidentifier
 left outer join enrollment en on en.studentid = s.id
 left outer join organizationtreedetail o on o.schoolid = en.attendanceschoolid
 left outer join enrollmentsrosters enr on enr.enrollmentid =en.id  
    where s.stateid = 51 and s.activeflag is true and en.activeflag is true 
 group by s.statestudentidentifier,o.schoolname,o.schooldisplayidentifier,o.districtname,o.districtdisplayidentifier, enr.activeflag,en.currentschoolyear 
 order by s.statestudentidentifier;

\copy (select * from tmp_student) to 'tmp_student_new.csv' DELIMITER ',' CSV HEADER;

DROP TABLE IF EXISTS raw_student;
DROP TABLE IF EXISTS tmp_student;


rollback;

		  
   