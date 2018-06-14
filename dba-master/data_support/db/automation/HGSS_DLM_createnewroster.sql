-- Author : Rohit Yadav

DROP TABLE IF EXISTS tmp_hgss_dlm_roster_raw;

DROP TABLE IF EXISTS tmp_hgss_dlm_roster;

CREATE
TEMPORARY TABLE tmp_hgss_dlm_roster_raw( Roster_Name TEXT 
                               , Subject TEXT 
                               , Course TEXT                                  
                               , Accountability_School TEXT 
                               , Testing_School TEXT 
                               , School_Year TEXT 
                               , StudentState_ID TEXT
                               , StudentFirst_Name TEXT 
                               , StudentLast_Name TEXT                                 
                               , Educator_ID TEXT 
                               , Educators_First_Name TEXT 
                               , Educators_Last_Name TEXT 
);

\COPY tmp_hgss_dlm_roster_raw FROM '/CETE_GENERAL/Technology/helpdesk/datasupport/unprocessed/hgss_dlm_roster.csv' DELIMITER ',' CSV HEADER

SELECT ROW_NUMBER() over()+1 AS row_num, cast('' AS TEXT) error_msg,* INTO TEMP tmp_hgss_dlm_roster FROM tmp_hgss_dlm_roster_raw;

DO
$BODY$

DECLARE 

   now_date TIMESTAMP WITH time ZONE; 
   tmp_table record ; 
   record_cnt integer;
   err_msg TEXT;
   
BEGIN now_date :=now(); record_cnt:=1; 
FOR tmp_table IN
  (SELECT  row_num
         , StudentState_ID::TEXT
         , Testing_School::TEXT
         , Accountability_School::TEXT
         , Subject::TEXT
         , Course::TEXT
         , Educator_ID::TEXT
         , Roster_Name::TEXT
         , 'KS'::TEXT AS state
   FROM tmp_hgss_dlm_roster) 
    
   LOOP record_cnt:=record_cnt+1; 
      RAISE NOTICE 'adding row(%)>> Student_State_ID %: ,School_ID_Number: %,Subject: %,Educator_ID_Number: % ,Roster_Name: %,State: %',
                                                                       record_cnt,
                                                                       tmp_table.StudentState_ID,
                                                                       tmp_table.Testing_School,
                                                                       tmp_table.Subject,
                                                                       tmp_table.Educator_ID,
                                                                       tmp_table.Roster_Name,
                                                                       tmp_table.state ; 
                                                                       
BEGIN 

   IF tmp_table.course IS NULL THEN

      SELECT createNewRosterWithNoCourse(state_student_identifiers := array[tmp_table.StudentState_ID]
                                       , att_sch_displayidentifier := tmp_table.Testing_School
                                       , ayp_sch_displayidentifier := tmp_table.Accountability_School
                                       , schoolyear := 2016
                                       , subject_abbrName := tmp_table.Subject
                                       , teacher_uniqueCommonId := tmp_table.Educator_ID
                                       , roster_name := tmp_table.Roster_Name
                                       , stateDisplayidentifier := tmp_table.state) INTO err_msg;
                                    
      RAISE NOTICE 'Error message is %s',err_msg;
      
      UPDATE tmp_hgss_dlm_roster
      SET error_msg=err_msg 
      WHERE row_num=tmp_table.row_num; 
      
   ELSE
   
      SELECT createNewRosterWithSubAndCourse(state_student_identifiers := array[tmp_table.StudentState_ID] 
                                           , att_sch_displayidentifier := tmp_table.Testing_School 
                                           , ayp_sch_displayidentifier := tmp_table.Accountability_School 
                                           , schoolyear := 2016 
                                           , subject_abbrName := tmp_table.Subject 
                                           , course_abbrName := tmp_table.Course 
                                           , teacher_uniqueCommonId := tmp_table.Educator_ID 
                                           , roster_name := tmp_table.Roster_Name 
                                           , stateDisplayidentifier := tmp_table.STATE) INTO err_msg;
                                           
      RAISE NOTICE 'Error message is %s',err_msg;
      
      UPDATE tmp_hgss_dlm_roster
      SET error_msg=err_msg 
      WHERE row_num=tmp_table.row_num;
      
   END IF;
     
EXCEPTION WHEN others THEN RAISE NOTICE 'ERROR on row(%)>>', record_cnt ; RAISE NOTICE '% %', SQLERRM, SQLSTATE;
   
   UPDATE tmp_hgss_dlm_roster
   SET error_msg='<error> on row :'||SQLERRM||'/'|| cast(SQLSTATE as text)
   WHERE row_num=tmp_table.row_num;

END; 

END LOOP; 

END; 

$BODY$;

\COPY (SELECT * FROM tmp_hgss_dlm_roster WHERE error_msg ilike '%<error>%') TO 'hgss_dlm_roster_error.csv' DELIMITER ',' CSV HEADER

DROP TABLE IF EXISTS tmp_hgss_dlm_roster;

DROP TABLE IF EXISTS tmp_hgss_dlm_roster_raw ;
