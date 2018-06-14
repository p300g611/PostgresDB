drop table if exists  tmp_correct_student ;
create temporary table tmp_correct_student(   
					State_Student_Id text ,
					Current_School text ,
					New_School text ,
					Subject text
					 );


\COPY tmp_correct_student FROM 'correct_student_enrollment.csv' DELIMITER ',' CSV HEADER ;    

DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 tmp_table record ;
 record_cnt integer;
BEGIN
now_date :=now();
record_cnt:=0;
FOR tmp_table IN (SELECT State_Student_Id,Subject,Current_School ,New_School FROM tmp_correct_student)
 LOOP   
    record_cnt:=record_cnt+1;
	RAISE NOTICE 'Moving row(%)>> State_Student_ID : %,Subject: %,Current_school: %,New_School: %',record_cnt,tmp_table.State_Student_Id,tmp_table.Subject,tmp_table.Current_School,tmp_table.New_School;
	BEGIN
	 PERFORM correct_student_enrollment(_state_student_identifier := tmp_table.State_Student_Id, 
						_subject := tmp_table.Subject,
						_current_school := tmp_table.Current_School,
						_future_school := tmp_table.New_School,
						_schoolyear := 2016);        
	
	EXCEPTION WHEN others THEN
           RAISE NOTICE 'error row';
    END;                                                 
 END LOOP;			    
	    		   
END;
$BODY$;
drop table if exists  tmp_correct_student ;