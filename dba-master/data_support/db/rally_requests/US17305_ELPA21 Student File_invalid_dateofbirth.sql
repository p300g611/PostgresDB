              drop table if exists  temp_upd_dob ;
              Create table temp_upd_dob (statestudentidentifier text, legalfirstname text,legallastname text,id text,Birth_Date text,dummy text) ;
              \COPY temp_upd_dob FROM 'ELP21_students_with_DOB_from_KSDE_development.csv' DELIMITER ',' ;



DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 sid text ;
 sidtf text;
 sdob text;
 row_count integer;
 
BEGIN
now_date :=now();


  
             
              
            FOR sidtf,sid,sdob IN select statestudentidentifier,id,Birth_Date from temp_upd_dob

         LOOP  
                  
		 update student 
		 set dateofbirth=cast(sdob as date),
		     modifieduser=12,
		     modifieddate=now_date
		 WHERE id=cast(sid as integer)
		      and statestudentidentifier=sidtf
		      and dateofbirth is null;

		RAISE NOTICE 'updated for sid : %' , sid;

                RAISE NOTICE 'updated for sidtf : %' ,sidtf;

                RAISE NOTICE 'updated vlaue dob: %' , sdob;	
			
	END LOOP;

        row_count:= (select count(*) from student where modifieddate=now_date and modifieduser=12);

        RAISE NOTICE 'Number of student dob updated : %' ,row_count ;
        
       drop table if exists  temp_upd_dob ;	          
		   
END;
$BODY$; 

