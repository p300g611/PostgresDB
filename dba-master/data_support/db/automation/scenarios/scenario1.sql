drop table if exists  tmp_scenario1_raw ;
drop table if exists  tmp_scenario1 ;
create temporary table tmp_scenario1_raw(   
                                        Callers_Nam                     text ,
                                        Callers_Email_Address           text ,
                                        State                           text , --should be in statedisplayidentifier
                                        District_ID_Number              text ,
                                        District_Name                   text ,
                                        School_ID_Number                text ,
                                        School_Name                     text ,
                                        Roster_Name                     text ,
                                        Subject                         text , --should be in abbreviation name
                                        Course_optional                 text ,
                                        Educator_ID                     text ,
                                        Educators_First_and_Last_Name   text ,
                                        StudentState_ID                 text ,
                                        StudentFirst_Name               text ,
                                        StudentLast_Name                text );


\COPY tmp_scenario1_raw FROM '/CETE_GENERAL/Technology/helpdesk/scenarios/unprocessed/scenario1.csv' DELIMITER ',' CSV HEADER ;   

SELECT ROW_NUMBER() over()+1 as row_num,cast('' as text) error_msg,* INTO TEMP tmp_scenario1 FROM tmp_scenario1_raw;

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
FOR tmp_table IN (SELECT StudentState_ID,School_ID_Number,Subject,Educator_ID,Roster_Name,upper(State) State,Course_optional, row_num FROM tmp_scenario1)
 LOOP   
        record_cnt:=record_cnt+1;
	RAISE NOTICE 'removing row(%)>> Student_State_ID %: ,School_ID_Number: %,Subject: %,Educator_ID_Number: % ,Roster_Name: %,State: %,Course: %'
	                ,record_cnt,tmp_table.StudentState_ID,tmp_table.School_ID_Number,tmp_table.Subject,tmp_table.Educator_ID,tmp_table.Roster_Name,tmp_table.State,tmp_table.Course_optional ;
        BEGIN
        IF (tmp_table.State IN ('OK', 'MS') and tmp_table.Course_optional >'' ) THEN
           RAISE NOTICE 'started removestudentfromrosterwithcourse';
           err_msg = '';
           SELECT  removestudentfromrosterwithcourse(statestudent_identifier := tmp_table.StudentState_ID , 
                                                      ayp_sch_displayidentifier := tmp_table.School_ID_Number , 
                                                      att_sch_displayidentifier := tmp_table.School_ID_Number, 
                                                      stateDisplayidentifier := tmp_table.State ,
                                                      schoolyear := 2016 ,
                                                      subject_abbrName := tmp_table.Subject, 
                                                      course_abbrname:=tmp_table.Course_optional, 
                                                      teacher_uniqueCommonId := tmp_table.Educator_ID ,
                                                      roster_name:=tmp_table.Roster_Name) INTO err_msg;        
           
           RAISE NOTICE 'Error message is %s',err_msg;
	
           UPDATE tmp_scenario1
           SET error_msg=err_msg
           WHERE row_num=tmp_table.row_num;	

	ELSE
	
	   RAISE NOTICE 'started removeStudentFromRosterWithNoCourse';
	   err_msg = '';
	   SELECT removeStudentFromRosterWithNoCourse(statestudent_identifier := tmp_table.StudentState_ID , 
                                                   ayp_sch_displayidentifier := tmp_table.School_ID_Number , 
                                                   att_sch_displayidentifier := tmp_table.School_ID_Number, 
                                                   stateDisplayidentifier := tmp_table.State ,
                                                   schoolyear := 2016 ,
                                                   subject_abbrName := tmp_table.Subject, 
                                                   teacher_uniqueCommonId := tmp_table.Educator_ID ,
                                                   roster_name:=tmp_table.Roster_Name) INTO err_msg ;
                                                   
           UPDATE tmp_scenario1
           SET error_msg=err_msg
           WHERE row_num=tmp_table.row_num;
           
	END IF;
	EXCEPTION WHEN others THEN
           RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
           RAISE NOTICE '% %', SQLERRM, SQLSTATE;
           UPDATE tmp_scenario1
           SET error_msg='<ERROR> on row :' ||cast(record_cnt as text)||','||SQLERRM||'/'|| SQLSTATE
           WHERE row_num=tmp_table.row_num;           
        END;                                                 
 END LOOP;			    
	    		   
END;
$BODY$;
\COPY (select * from tmp_scenario1 where error_msg ilike '%<error>%' ) to '/CETE_GENERAL/Technology/helpdesk/scenarios/scenario1_error.csv' DELIMITER ',' CSV HEADER ;
drop table if exists  tmp_scenario1 ;
drop table if exists  tmp_scenario1_raw ;
