--Note: need to check if we updated on roster also --select aypschoolid from roster limit 1

-- ERROR script ayp schoolid not column cannot insert null values need to get more info
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
	   set aypschoolidentifier=null,
	       aypschoolid=null,
	       modifieddate=now_date,
	       modifieduser=12,
	       notes= 'Moving aypschoolid from ' ||e.aypschoolid||' to null as per MO-Data clean-up'
	  from student s
		 where s.id =e.studentid
		       and s.stateid =(select id from organization where displayidentifier ='MO' and organizationtypeid=2 and activeflag is true ) ;

	   row_count := (select count(*) from enrollment where  modifieddate=now_date and modifieduser=12);
	   RAISE NOTICE 'total enrollments moved : %' , row_count;	
 			       
		   
END;
$BODY$; 
COMMIT;



