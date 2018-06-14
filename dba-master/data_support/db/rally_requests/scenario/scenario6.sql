drop table if exists  tmp_scenario6_raw ;
drop table if exists   tmp_scenario6 ;
create temporary table tmp_scenario6_raw(   
					Callers_Name 	                text ,
					Callers_Email_Address 	        text ,
					State	                        text , --should be in statedisplayidentifier
					District_ID_Number	        text ,
					District_Name	                text ,
					School_ID_Number	        text ,
					School_Name                     text ,
					StudentState_ID			text ,
					StudentFirst_Name		text ,
					StudentLast_Name		text ,
					Incorrect_Grade_Level		text ,
					Correct_Grade_Level		text ,
					Current_School_Year		text
					);


\COPY tmp_scenario6_raw FROM 'scenario6.csv' DELIMITER ',' CSV HEADER ; 
SELECT ROW_NUMBER() over()+1 as row_num,cast('' as text) error_msg,* INTO TEMP tmp_scenario6 FROM tmp_scenario6_raw;    

DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 tmp_table record ;
 record_cnt integer;
 err_msg TEXT; 
BEGIN
now_date :=now();
record_cnt:=1;
FOR tmp_table IN (SELECT row_num,error_msg,StudentState_ID,upper(State) State,Current_School_Year,Incorrect_Grade_Level,Correct_Grade_Level,School_ID_Number FROM tmp_scenario6)
 LOOP   
        record_cnt:=record_cnt+1;
	RAISE NOTICE 'changing row(%)>> Student_State_ID %: ,School_ID_Number: %,State: %,Current_School_Year: %,Incorrect_Grade_Level: % ,correct_Grade_Level: %',record_cnt,tmp_table.StudentState_ID,tmp_table.School_ID_Number,tmp_table.State,tmp_table.Current_School_Year,tmp_table.Incorrect_Grade_Level,tmp_table.Correct_Grade_Level ;
        BEGIN
        select  updateStudentGrade(       state_student_identifier := tmp_table.StudentState_ID 
					 , state_displayidentifier := tmp_table.State
					 , att_sch_displayidentifier := tmp_table.School_ID_Number
					 , ayp_sch_displayidentifier := tmp_table.School_ID_Number
					 , schoolyear := cast(tmp_table.Current_School_Year as bigint)
					 , old_grade := tmp_table.Incorrect_Grade_Level
					 , new_grade := tmp_table.Correct_Grade_Level  ) INTO err_msg ; 
		RAISE NOTICE 'error message is %',err_msg;
            UPDATE tmp_scenario6
            SET error_msg=err_msg
            WHERE row_num=tmp_table.row_num; 			                                                          
	
	EXCEPTION WHEN others THEN
                 RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
                RAISE NOTICE '% %', SQLERRM, SQLSTATE; 
                UPDATE tmp_scenario6
		   SET error_msg='<ERROR>'||SQLERRM||'/'|| SQLSTATE
		   WHERE row_num=tmp_table.row_num;
        END;                                                 
 END LOOP;			    
	    		   
END;
$BODY$;
\COPY (select * from tmp_scenario6 where error_msg ilike '%<error>%' ) to 'scenario6_error.csv' DELIMITER ',' CSV HEADER ;
drop table if exists  tmp_scenario6 ;
drop table if exists  tmp_scenario6_raw ;