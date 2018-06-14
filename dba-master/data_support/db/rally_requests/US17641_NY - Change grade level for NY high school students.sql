/*
BEGIN;
--////////////validation count for each grade///////////////////
 select 
        gc.id    gradeid
       ,gc.name  gradename 
       ,abbreviatedname
       ,(select organizationname from organization where id=s.stateid) statename
       ,count(*) count_enrollment 
 from student s
	 inner join enrollment e on s.id =e.studentid and e.activeflag is true
	 inner join gradecourse gc on gc.id = e.currentgradelevel
	 where s.stateid =(select id from organization where organizationtypeid=2 and organizationname='New York' and activeflag is true )
	       and gc.abbreviatedname in ('10','11','12','9') and gc.activeflag is true 
group by gc.id,gc.name,(select organizationname from organization where id=s.stateid),abbreviatedname;


--//////////move the report to user story////////////////// 

drop table if exists tmp_ny_students_grade10_11_12;

 select s.id         studentid
       ,s.statestudentidentifier 
       ,e.id         enrollmentid
       ,gc.id        gradeid
       ,gc.name      current_gradename 
       ,'Grade 9'    updated_gradename
         into tmp_ny_students_grade10_11_12
 from student s
	 inner join enrollment e on s.id =e.studentid and e.activeflag is true
	 inner join gradecourse gc on gc.id = e.currentgradelevel 
	 where s.stateid =(select id from organization where organizationtypeid=2 and organizationname='New York' and activeflag is true )
	       and gc.abbreviatedname in ('10','11','12') and gc.activeflag is true ;
	       
\COPY (select *from tmp_ny_students_grade10_11_12  ) To 'ny_students_grade10_11_12.csv' DELIMITER '|' CSV HEADER;
	       
drop table if exists tmp_ny_students_grade10_11_12;

ROLLBACK;


--//////////update the enrollment grade course to 9 (if 10,11,12)////////////////// 


*/


BEGIN;
DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 art_userid integer;
 row_count integer;
BEGIN
now_date :=now();

	 update enrollment e
	   set currentgradelevel=31,
	       modifieddate=now_date,
	       modifieduser=12,
	       notes= 'Moving currentgradelevel from ' ||gc.name||' to Grade 9 as per US17641'
	  from student s,gradecourse gc 
		 where s.id =e.studentid and gc.activeflag is true 
		       and gc.id = e.currentgradelevel
		       and s.stateid =(select id from organization where organizationtypeid=2 and organizationname='New York' and activeflag is true )
		       and gc.abbreviatedname in ('10','11','12') ;

	   row_count := (select count(*) from enrollment where  modifieddate=now_date and modifieduser=12);
	   RAISE NOTICE 'total enrollments moved to 9 grade : %' , row_count;	
 			       
		   
END;
$BODY$; 
COMMIT;
 