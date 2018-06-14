-- Author : Rohit Yadav
drop table if exists  tmp_scenario2_raw ;
drop table if exists  tmp_scenario2 ;
create temporary table tmp_scenario2_raw(
                                                                           Callers_Name                     text ,
                                                                           Callers_Email_Address            text ,
                                                                           State                            text ,
                                                                           District_ID_Number               text ,
                                                                           District_Name                    text ,
                                                                           School_ID_Number                 text ,
                                                                           School_Name                      text ,
                                                                           Student_First_Name               text ,
                                                                           Student_Last_Name                text ,
                                                                           Student_State_ID                 text ,
                                                                           Educator_ID_Number               text ,
									    Educator_First_and_Last_Name    text ,
									    Roster_Name                     text ,
									    Subject                         text ,
									    Course_Name                     text );

\COPY tmp_scenario2_raw FROM 'scenario2.csv' DELIMITER ',' CSV HEADER ;

SELECT ROW_NUMBER() over()+1 as row_num,cast('' as text) error_msg,* INTO TEMP tmp_scenario2 FROM tmp_scenario2_raw;

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
FOR tmp_table IN (SELECT row_num,Student_State_ID,School_ID_Number,Subject,Educator_ID_Number,Roster_Name,upper(State) State,Course_Name FROM tmp_scenario2)
LOOP
        record_cnt:=record_cnt+1;
               RAISE NOTICE 'adding row(%)>> Student_State_ID %: ,School_ID_Number: %,Subject: %,Educator_ID_Number: % ,Roster_Name: %,State: %,Course_Name : %'
                   ,record_cnt,tmp_table.Student_State_ID,tmp_table.School_ID_Number,tmp_table.Subject,tmp_table.Educator_ID_Number,tmp_table.Roster_Name,tmp_table.State,tmp_table.Course_Name ;
        BEGIN
        IF (tmp_table.State IN ('OK', 'MS') and tmp_table.Course_Name >'' ) THEN
        RAISE NOTICE 'started addstudenttorosterwithcourse';
              err_msg = '';
              SELECT addstudenttorosterwithcourse(
                                                                state_student_identifier:=tmp_table.Student_State_ID,
                                                                att_sch_displayidentifier:=tmp_table.School_ID_Number,
                                                                ayp_sch_displayidentifier:=tmp_table.School_ID_Number,
                                                                schoolyear:=2016,
                                                                subject_abbrname:=tmp_table.Subject,
                                                                course_abbrname:=tmp_table.Course_Name,
                                                                teacher_uniquecommonid :=tmp_table.Educator_ID_Number,
                                                                roster_name:=tmp_table.Roster_Name,
                                                                statedisplayidentifier:=tmp_table.State) INTO err_msg ;
              RAISE NOTICE 'Error message is %s',err_msg;

            UPDATE tmp_scenario2
            set error_msg=err_msg
            where row_num=tmp_table.row_num;

        ELSE
        RAISE NOTICE 'started addstudenttorosterwithnocourse';
            err_msg = '';
            SELECT addstudenttorosterwithnocourse(
                                                                state_student_identifier:=tmp_table.Student_State_ID,
                                                                att_sch_displayidentifier:=tmp_table.School_ID_Number,
                                                                ayp_sch_displayidentifier:=tmp_table.School_ID_Number,
                                                                schoolyear:=2016,
                                                                subject_abbrname:=tmp_table.Subject,
                                                                teacher_uniquecommonid :=tmp_table.Educator_ID_Number,
                                                                roster_name:=tmp_table.Roster_Name,
                                                                statedisplayidentifier:=tmp_table.State) INTO err_msg ;
            RAISE NOTICE 'error message is %s',err_msg;
            UPDATE tmp_scenario2
            set error_msg=err_msg
              where row_num=tmp_table.row_num;
        END IF;
               EXCEPTION WHEN others THEN
           RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
           RAISE NOTICE '% %', SQLERRM, SQLSTATE;
            UPDATE tmp_scenario2
            set error_msg='<ERROR>'||SQLERRM||'/'|| SQLSTATE
              where row_num=tmp_table.row_num;
        END;

 END LOOP;

END;
$BODY$;
\COPY (select * from tmp_scenario2 where error_msg ilike '%<error>%' ) to 'scenario2_error.csv' DELIMITER ',' CSV HEADER ;
drop table if exists  tmp_scenario2 ;
drop table if exists  tmp_scenario2_raw ;