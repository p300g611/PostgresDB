-- Author : Rohit Yadav

DROP TABLE IF EXISTS tmp_scenario4_raw;


DROP TABLE IF EXISTS tmp_scenario4;


CREATE
TEMPORARY TABLE tmp_scenario4_raw( Callers_Name TEXT , Callers_Email_Address TEXT , STATE TEXT , --should be in statedisplayidentifier
 District_ID_Number TEXT , District_Name TEXT , School_ID_Number TEXT , School_Name TEXT , Roster_Name TEXT , Educator_ID TEXT , Educators_First_and_Last_Name TEXT , Subject TEXT , Course TEXT , StudentState_ID TEXT , StudentFirst_Name TEXT , StudentLast_Name TEXT);

\COPY tmp_scenario4_raw FROM 'scenario4.csv' DELIMITER ',' CSV HEADER ;

SELECT ROW_NUMBER() over()+1 AS row_num, cast('' AS TEXT) error_msg,* INTO TEMP tmp_scenario4 FROM tmp_scenario4_raw;

DO
$BODY$
DECLARE now_date TIMESTAMP WITH time ZONE; tmp_table record ; record_cnt integer;err_msg TEXT;
BEGIN now_date :=now(); record_cnt:=1;
FOR tmp_table IN
  (SELECT row_num,StudentState_ID,
          School_ID_Number,
          Subject,
          Course,
          Educator_ID,
          Roster_Name,
          upper(STATE) STATE
   FROM tmp_scenario4) LOOP record_cnt:=record_cnt+1; RAISE NOTICE 'adding row(%)>> Student_State_ID %: ,School_ID_Number: %,Subject: %,Educator_ID_Number: % ,Roster_Name: %,State: %',
                                                                       record_cnt,
                                                                       tmp_table.StudentState_ID,
                                                                       tmp_table.School_ID_Number,
                                                                       tmp_table.Subject,
                                                                       tmp_table.Educator_ID,
                                                                       tmp_table.Roster_Name,
                                                                       tmp_table.STATE ; BEGIN IF (tmp_table.STATE IN ('OK',
                                                                                                                       'MS')
                                                                                                   AND tmp_table.Course>'') THEN RAISE NOTICE 'process statrted for createNewRosterWithCourse'; err_msg = '';
SELECT createNewRosterWithSubAndCourse(state_student_identifiers := array[tmp_table.StudentState_ID] , att_sch_displayidentifier := tmp_table.School_ID_Number , ayp_sch_displayidentifier := tmp_table.School_ID_Number , schoolyear := 2016 , subject_abbrName := tmp_table.Subject , course_abbrName := tmp_table.Course , teacher_uniqueCommonId := tmp_table.Educator_ID , roster_name := tmp_table.Roster_Name , stateDisplayidentifier := tmp_table.STATE) INTO err_msg;
RAISE NOTICE 'Error message is %s',err_msg;

UPDATE tmp_scenario4
SET error_msg=err_msg
WHERE row_num=tmp_table.row_num; ELSE RAISE NOTICE 'process statrted for createNewRosterWithNoCourse'; err_msg = '';

SELECT createNewRosterWithNoCourse(state_student_identifiers := array[tmp_table.StudentState_ID], att_sch_displayidentifier := tmp_table.School_ID_Number, ayp_sch_displayidentifier := tmp_table.School_ID_Number, schoolyear := 2016, subject_abbrName := tmp_table.Subject, teacher_uniqueCommonId := tmp_table.Educator_ID, roster_name := tmp_table.Roster_Name, stateDisplayidentifier := tmp_table.STATE) INTO err_msg;
RAISE NOTICE 'Error message is %s',err_msg;
UPDATE tmp_scenario4
SET error_msg=err_msg WHERE row_num=tmp_table.row_num; END IF; EXCEPTION WHEN others THEN RAISE NOTICE 'ERROR on row(%)>>',
                                                                                                       record_cnt ; RAISE NOTICE '% %',
                                                                                                                                 SQLERRM,
                                                                                                                                 SQLSTATE;
 UPDATE tmp_scenario4
            set error_msg='<ERROR> on row :'||SQLERRM||'/'|| cast(SQLSTATE as text)
              where row_num=tmp_table.row_num;

 END; END LOOP; END; $BODY$;

\COPY (SELECT * FROM tmp_scenario4 WHERE error_msg ilike '%<error>%') TO 'scenario4_error.csv' DELIMITER ',' CSV HEADER ;

DROP TABLE IF EXISTS tmp_scenario4;


DROP TABLE IF EXISTS tmp_scenario4_raw ;