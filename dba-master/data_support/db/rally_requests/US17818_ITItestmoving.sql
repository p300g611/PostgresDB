--==================================================================================
--student1:Incorrect Student State ID: 321006794 Correct Student State ID: 3210069794
--==================================================================================
DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 old_studentid bigint;
 new_studentid bigint;
 row_count integer;
BEGIN
now_date :=now();
select id into new_studentid from student where statestudentidentifier in ('3210069794') and activeflag is true limit 1;
select id into old_studentid from student where statestudentidentifier in ('321006794') and activeflag is true limit 1;

RAISE NOTICE 'ITI test moving for student : %  to student : %' ,old_studentid,new_studentid;

with update_count as 
	(
	update enrollment
	 set    modifieduser=12,
	     modifieddate=now_date,
	     notes='update studentid as per US 17818',
	     studentid =new_studentid
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated enrollment : %' , row_count;

with update_count as 
	(
	update ititestsessionhistory
	set studentid =new_studentid,
	     modifieduser=12,
	     modifieddate=now_date
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated ititestsessionhistory : %' , row_count;

with update_count as 
	(
	update studentsresponses
	set studentid =new_studentid,
	     modifieduser=12,
	     modifieddate=now_date
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated studentsresponses : %' , row_count;

with update_count as 
	(
	update studentstests
	set studentid =new_studentid,
	     modifieduser=12,
	     modifieddate=now_date
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated studentstests : %' , row_count;   
		   
END;
$BODY$; 
--==================================================================================
--student2:Incorrect Student State ID: 211932946 Correct Student State ID: 2119232946
--==================================================================================
DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 old_studentid bigint;
 new_studentid bigint;
 row_count integer;
BEGIN
now_date :=now();
select id into new_studentid from student where statestudentidentifier in ('2119232946') and activeflag is true limit 1;
select id into old_studentid from student where statestudentidentifier in ('211932946') and activeflag is true limit 1;

RAISE NOTICE 'ITI test moving for student : % to student : %' ,old_studentid,new_studentid;

with update_count as 
	(
	update enrollment
	 set    modifieduser=12,
	     modifieddate=now_date,
	     notes='update studentid as per US 17818',
	     studentid =new_studentid
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated enrollment : %' , row_count;

with update_count as 
	(
	update ititestsessionhistory
	set studentid =new_studentid,
	     modifieduser=12,
	     modifieddate=now_date
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated ititestsessionhistory : %' , row_count;

with update_count as 
	(
	update studentsresponses
	set studentid =new_studentid,
	     modifieduser=12,
	     modifieddate=now_date
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated studentsresponses : %' , row_count;

with update_count as 
	(
	update studentstests
	set studentid =new_studentid,
	     modifieduser=12,
	     modifieddate=now_date
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated studentstests : %' , row_count;   

with update_count as 
	(
	update studentprofileitemattributevalue
	set studentid =new_studentid,
	     modifieduser=12,
	     modifieddate=now_date
	where studentid =old_studentid and activeflag is true
	 RETURNING 1 )
select count(*) into row_count from update_count;
RAISE NOTICE 'rows updated studentprofileitemattributevalue : %' , row_count; 
		   
END;
$BODY$; 