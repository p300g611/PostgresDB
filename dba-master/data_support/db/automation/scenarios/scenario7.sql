--TODO: alter template to include current schoolyear so we don't have to edit this script every year.
--
drop table if exists  tmp_scenario7_raw ;
drop table if exists  tmp_scenario7 ;
create temporary table tmp_scenario7_raw( Callers_Name              text
                                     ,Callers_Email_Address     text
                                     ,State                     text  --should be in statedisplayidentifier
                                     ,District_ID_Number        text
                                     ,District_Name             text
                                     ,School_ID_Number          text
                                     ,Student_State_ID          text
                                     ,Student_First_Name        text
                                     ,Student_Last_Name         text
                                     ,ExitReason                text                                     
                                     ,ExitDate                  text 
                                      );

\COPY tmp_scenario7_raw FROM '/CETE_GENERAL/Technology/helpdesk/scenarios/unprocessed/scenario7.csv' DELIMITER ',' CSV HEADER

SELECT ROW_NUMBER() over()+1 as row_num,cast('' as text) error_msg,* INTO TEMP tmp_scenario7 FROM tmp_scenario7_raw;

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
FOR tmp_table IN (SELECT Student_State_ID,School_ID_Number,District_ID_Number,ExitDate,ExitReason,upper(State) State, row_num FROM tmp_scenario7)
 LOOP
        record_cnt:=record_cnt+1;
        RAISE NOTICE 'exiting student(%)>> Student_State_ID %: ,School_ID_Number: %,District_ID_Number: %,CurrentSchoolYear: % ,ExitDate: %,ExitReason: % ,State: %',record_cnt,tmp_table.Student_State_ID,tmp_table.School_ID_Number,tmp_table.District_ID_Number,'2016',tmp_table.ExitDate,tmp_table.ExitReason,tmp_table.State ;
        err_msg = '';
        BEGIN
           SELECT  exitStudent(
                     statestudent_identifier := tmp_table.Student_State_ID
                   , ayp_sch_displayidentifier := tmp_table.School_ID_Number
                   , att_sch_displayidentifier := tmp_table.School_ID_Number
                   , exitReason := cast(tmp_table.ExitReason as numeric)
                   , exitDate := cast(tmp_table.ExitDate as date)
                   , schoolyear := 2016
                   , stateDisplayidentifier := tmp_table.State
                       ) INTO err_msg ;
                       
           RAISE NOTICE 'error message is %',err_msg;
            UPDATE tmp_scenario7
            SET error_msg=err_msg
            WHERE row_num=tmp_table.row_num;                       
                    
        EXCEPTION WHEN others THEN 
         
           RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
           RAISE NOTICE '% %', SQLERRM, SQLSTATE;  
           UPDATE tmp_scenario7
	   SET error_msg='<ERROR>'||SQLERRM||'/'|| SQLSTATE
           WHERE row_num=tmp_table.row_num;
        
        END;
        
 END LOOP;
	    		   
END;
$BODY$;
\COPY (select * from tmp_scenario7 where error_msg ilike '%<error>%' ) to '/CETE_GENERAL/Technology/helpdesk/scenarios/scenario7_error.csv' DELIMITER ',' CSV HEADER
drop table if exists  tmp_scenario7 ;
drop table if exists  tmp_scenario7_raw ;
