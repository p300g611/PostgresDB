-- Author : Rohit Yadav

DROP TABLE IF EXISTS tmp_scenario3_raw;
DROP TABLE IF EXISTS tmp_scenario3;

create temporary table tmp_scenario3_raw( Callers_Name              text
                                     ,Callers_Email_Address     text
                                     ,State                     text  --should be in statedisplayidentifier
                                     ,District_ID_Number        text
                                     ,District_Name             text
                                     ,School_ID_Number          text
                                     ,School_Name               text
                                     ,Subject                   text
                                     ,Course                    text
                                     ,RosterName                text
                                     ,CurrentEducatorID         text
                                     ,CurrentEducatorFullName   text
                                     ,NewEducatorID             text
                                     ,NewEducatorFullName       text
                                       );

\COPY tmp_scenario3_raw FROM '/CETE_GENERAL/Technology/helpdesk/scenarios/unprocessed/scenario3.csv' DELIMITER ',' CSV HEADER

SELECT ROW_NUMBER() over()+1 AS row_num, cast('' AS TEXT) error_msg,* INTO TEMP tmp_scenario3 FROM tmp_scenario3_raw;

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
FOR tmp_table IN (SELECT row_num,District_ID_Number,District_Name,School_ID_Number,School_Name,Subject,Course,RosterName,CurrentEducatorID,NewEducatorID,upper(State) State FROM tmp_scenario3)
 LOOP
        record_cnt:=record_cnt+1;
        RAISE NOTICE 'changing educator on roster(%)>> District_ID_Number: %, District_Name: %, School_ID_Number: %, School_Name: %, Subject: %, Course: %, RosterName: %, CurrentEducatorID: %, NewEducatorID: %, State: %',record_cnt,tmp_table.District_ID_Number,tmp_table.District_Name,tmp_table.School_ID_Number,tmp_table.School_Name,tmp_table.Subject,tmp_table.Course,tmp_table.RosterName,tmp_table.CurrentEducatorID,tmp_table.NewEducatorID,tmp_table.State ;
        BEGIN
           IF (tmp_table.State IN ('OK', 'MS') and tmp_table.Course>'' ) THEN
              RAISE NOTICE 'started changeEductorOnRosterWithCourse';
              err_msg = '';
              SELECT changeEductorOnRosterWithCourse(
                            att_sch_displayidentifier := tmp_table.School_ID_Number
                          , schoolyear := 2016
                          , subject_abbrName := tmp_table.Subject
                          , course_Abbrname := tmp_table.Course
                          , old_teacher_uniqueCommonId := tmp_table.CurrentEducatorID
                          , new_teacher_uniqueCommonId := tmp_table.NewEducatorID
                          , roster_name := tmp_table.RosterName
                          , stateDisplayidentifier := tmp_table.State
                                                     ) INTO err_msg;
              RAISE NOTICE 'Error message is %s',err_msg;
              UPDATE tmp_scenario3
              SET error_msg=err_msg
              WHERE row_num=tmp_table.row_num;
           ELSE
              RAISE NOTICE 'started changeEductorOnRosterWithNoCourse';
              err_msg = '';
              SELECT changeEductorOnRosterWithNoCourse(
                            att_sch_displayidentifier := tmp_table.School_ID_Number
                          , schoolyear := 2016
                          , subject_abbrName := tmp_table.Subject
                          , old_teacher_uniqueCommonId := tmp_table.CurrentEducatorID
                          , new_teacher_uniqueCommonId := tmp_table.NewEducatorID
                          , roster_name := tmp_table.RosterName
                          , stateDisplayidentifier := tmp_table.State
                                                     )INTO err_msg;
              RAISE NOTICE 'Error message is %s',err_msg;
              UPDATE tmp_scenario3
              SET error_msg=err_msg
              WHERE row_num=tmp_table.row_num;
           END IF;

        EXCEPTION WHEN others THEN

           RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
           RAISE NOTICE '% %', SQLERRM, SQLSTATE;
           UPDATE tmp_scenario3
           SET error_msg='<ERROR>'||SQLERRM||'/'|| SQLSTATE
           WHERE row_num=tmp_table.row_num;
        END;

 END LOOP;

END;
$BODY$;
\COPY (select * from tmp_scenario3 where error_msg ilike '%<error>%' ) to '/CETE_GENERAL/Technology/helpdesk/scenarios/scenario3_error.csv' DELIMITER ',' CSV HEADER
drop table if exists  tmp_scenario3 ;
drop table if exists  tmp_scenario3_raw ;
