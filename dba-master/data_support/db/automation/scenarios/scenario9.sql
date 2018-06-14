-- Author : Rohit Yadav

drop table if exists  tmp_scenario9_raw ;
drop table if exists  tmp_scenario9 ;
create temporary table tmp_scenario9_raw( Callers_Name          text
                                     ,Callers_Email_Address     text
                                     ,State                     text  --should be in statedisplayidentifier
                                     ,District_ID_Number        text
                                     ,District_Name             text
                                     ,AYPSchoolIdentifier       text
                                     ,School_ID_Number          text
                                     ,School_Name               text
                                     ,Student_State_ID          text
                                     ,Student_First_Name        text
                                     ,Student_Last_Name         text
                                     ,Gender                    text
                                     ,DateOfBirth               text
                                     ,CurrentGradeLevel         text
                                     ,CurrentSchoolYear         text
                                     ,SchoolEntryDate           text
                                     ,ComprehensiveRace         text
                                     ,HispanicEthnicity         text
                                     ,ESOLParticipationCode     text
                                    );

\COPY tmp_scenario9_raw FROM '/CETE_GENERAL/Technology/helpdesk/scenarios/unprocessed/scenario9.csv' DELIMITER ',' CSV HEADER

SELECT ROW_NUMBER() over()+1 as row_num,cast('' as text) error_msg,* INTO TEMP tmp_scenario9 FROM tmp_scenario9_raw;

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
FOR tmp_table IN (SELECT row_num,Student_State_ID,School_ID_Number,District_ID_Number,CurrentSchoolYear,SchoolEntryDate,CurrentGradeLevel,upper(State) State,AYPSchoolIdentifier FROM tmp_scenario9)
 LOOP
        record_cnt:=record_cnt+1;
        RAISE NOTICE 'adding enrollment(%)>> Student_State_ID %: ,School_ID_Number: %,District_ID_Number: %,CurrentSchoolYear: % ,SchoolEntryDate: %,CurrentGradeLevel: % ,State: %',record_cnt,tmp_table.Student_State_ID,tmp_table.School_ID_Number,tmp_table.District_ID_Number,tmp_table.CurrentSchoolYear,tmp_table.SchoolEntryDate,tmp_table.CurrentGradeLevel,tmp_table.State ;
        BEGIN
           err_msg = '';
           SELECT addNewEnrollment(
                             statestudent_identifier := tmp_table.Student_State_ID
                           , localState_StuId := NULL
                           , aypSch := tmp_table.AYPSchoolIdentifier
                           , attSch := tmp_table.School_ID_Number
                           , district := tmp_table.District_ID_Number
                           , schoolyear := cast(tmp_table.CurrentSchoolYear as bigint)
                           , schEntryDate := cast(tmp_table.SchoolEntryDate as date)
                           , distEntryDate := NULL
                           , state_EntryDate := NULL
                           , grade := tmp_table.CurrentGradeLevel
                           , stateDisplayidentifier := tmp_table.State
                         ) INTO err_msg;
        RAISE NOTICE 'Error message is %',err_msg;

        UPDATE tmp_scenario9
        SET error_msg=err_msg
        WHERE row_num=tmp_table.row_num;

        EXCEPTION WHEN others THEN

           RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
           RAISE NOTICE '% %', SQLERRM, SQLSTATE;
           UPDATE tmp_scenario9
           SET error_msg='<ERROR>'||SQLERRM||'/'|| SQLSTATE
           WHERE row_num=tmp_table.row_num;

        END;

 END LOOP;

END;
$BODY$;
\COPY (select * from tmp_scenario9 where error_msg ilike '%<error>%' ) to '/CETE_GENERAL/Technology/helpdesk/scenarios/scenario9_error.csv' DELIMITER ',' CSV HEADER
drop table if exists  tmp_scenario9 ;
drop table if exists  tmp_scenario9_raw ;
