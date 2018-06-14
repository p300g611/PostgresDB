DROP TABLE IF EXISTS tmp_scenario5_raw ;
DROP TABLE IF EXISTS tmp_scenario5 ;
CREATE TEMPORARY TABLE tmp_scenario5_raw(Callers_Name          text , 
                                      Callers_Email_Address    text , 
                                      STATE                    text , --should be in statedisplayidentifier
                                      District_ID_Number       text ,
                                      District_Name            text , 
                                      School_ID_Number         text , 
                                      School_Name              text ,
                                      State_Student_Identifier text , 
                                      Student_First_Name       text , 
                                      Student_Last_Name        text ,
                                      Grade_Level              text ,
                                      Gender                   text , 
                                      Date_of_Birth            text , 
                                      Current_School_Year      text ,
                                      Comprehensive_Race       text , 
                                      Hispanic_Ethinicity      text , 
                                      ESOL                     text
                                      );

\COPY tmp_scenario5_raw FROM '/CETE_GENERAL/Technology/helpdesk/scenarios/unprocessed/scenario5.csv' DELIMITER ',' CSV HEADER

SELECT ROW_NUMBER() over()+1 as row_num,cast('' as text) error_msg,* INTO TEMP tmp_scenario5 FROM tmp_scenario5_raw;
DO 
$BODY$ 
DECLARE now_date TIMESTAMP WITH time ZONE;
        tmp_table record ;
         record_cnt integer;
         err_msg TEXT; 
         
BEGIN
      now_date :=now();
      record_cnt:=1;
      err_msg := '';
FOR tmp_table IN   (SELECT row_num,error_msg,Student_First_Name,Student_Last_Name,State_Student_Identifier,upper(STATE) STATE,Hispanic_Ethinicity,Comprehensive_Race,ESOL,School_ID_Number,Current_School_Year,Date_of_Birth,Grade_Level
                         ,case when cast(Gender as varchar(1)) ='M' then '1' 
                               when cast(Gender as varchar(1)) ='F' then '0'
                               else Gender end Gender    FROM tmp_scenario5) 
   LOOP 
   record_cnt:=record_cnt+1;
   RAISE NOTICE 'adding row(%)>> Student_First_Name %: ,Student_Last_Name: %,State_Student_Identifier: %,STATE: % ,Hispanic_Ethinicity: %,Comprehensive_Race: %,ESOL: %,School_ID_Number: %,Current_School_Year: %,Grade_Level: %,Date_of_Birth: %,Gender: %' 
      ,record_cnt,tmp_table.Student_First_Name, tmp_table.Student_Last_Name, tmp_table.State_Student_Identifier,tmp_table.STATE,tmp_table.Hispanic_Ethinicity,tmp_table.Comprehensive_Race,tmp_table.ESOL,tmp_table.School_ID_Number,tmp_table.Current_School_Year,tmp_table.Grade_Level,tmp_table.Date_of_Birth,tmp_table.Gender; 
          BEGIN			  
          select updateStudentDemoGraphics(student_firstName :=tmp_table.Student_First_Name,
                                            student_LastName:=tmp_table.Student_Last_Name,
                                            state_student_identifier:=tmp_table.State_Student_Identifier,
                                            state_displayidentifier:=tmp_table.STATE, 
                                            hispanic_Ethnicity := cast(tmp_table.Hispanic_Ethinicity as boolean) , 
                                            race := tmp_table.Comprehensive_Race, 
                                            esolCode := tmp_table.ESOL,
                                            att_sch_displayidentifier :=tmp_table.School_ID_Number, 
                                            ayp_sch_displayidentifier :=tmp_table.School_ID_Number,
                                            schoolyear:=2016, 
                                            grade_abbrName :=tmp_table.Grade_Level,
                                            birthDate:=cast(tmp_table.Date_of_Birth as date),
                                            student_gender:=cast(tmp_table.Gender as integer) ) INTO err_msg ;
        RAISE NOTICE 'error message is %',err_msg;
            UPDATE tmp_scenario5
            SET error_msg=err_msg
            WHERE row_num=tmp_table.row_num; 
                                                        
          EXCEPTION WHEN others THEN
                RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
                RAISE NOTICE '% %', SQLERRM, SQLSTATE; 
                UPDATE tmp_scenario5
		   SET error_msg='<ERROR>'||SQLERRM||'/'|| SQLSTATE
		   WHERE row_num=tmp_table.row_num;
          END;
          END LOOP; END; $BODY$;

\COPY (select * from tmp_scenario5 where error_msg ilike '%<error>%' ) to '/CETE_GENERAL/Technology/helpdesk/scenarios/scenario5_error.csv' DELIMITER ',' CSV HEADER 
drop table if exists  tmp_scenario5 ;
drop table if exists  tmp_scenario5_raw ;
