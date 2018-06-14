drop table if exists  tmp_hgss_rosters ;
create temporary table tmp_hgss_rosters( Roster_Name                    text
                                        ,Subject                        text
                                        ,Course                         text
                                        ,AYP_School_ID_Number           text
                                        ,School_ID_Number               text
                                        ,School_Year                    integer
                                        ,StudentState_ID                text
                                        ,Local_Student_ID               text
                                        ,StudentFirst_Name              text
                                        ,StudentLast_Name               text
                                        ,Educator_ID                    text
                                        ,Educators_First_Name           text
                                        ,Educators_Last_Name            text
                                         );


\COPY tmp_hgss_rosters FROM 'hgss_rosters.csv' DELIMITER ',' CSV HEADER ;    

ALTER TABLE tmp_hgss_rosters ADD COLUMN State text DEFAULT 'KS';

DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 tmp_table record ;
 record_cnt integer;
BEGIN
now_date :=now();
record_cnt:=1;
FOR tmp_table IN (SELECT StudentState_ID,AYP_School_ID_Number,School_ID_Number,Subject,Course,Educator_ID, Roster_Name, upper(State) State FROM tmp_hgss_rosters)
 LOOP   
        record_cnt:=record_cnt+1;
	RAISE NOTICE 'adding row(%)>> StudentState_ID %: ,School_ID_Number: %,Subject: %,Educator_ID: % ,Roster_Name: %,State: %',record_cnt,tmp_table.StudentState_ID,tmp_table.School_ID_Number,tmp_table.Subject,tmp_table.Educator_ID,tmp_table.Roster_Name,tmp_table.State ;
        BEGIN
              RAISE NOTICE 'process statrted for createNewRosterWithNoCourse';
	      PERFORM createNewRosterWithNoCourse(state_student_identifiers := array[tmp_table.StudentState_ID],
	                                          att_sch_displayidentifier := tmp_table.School_ID_Number,
	                                          ayp_sch_displayidentifier := tmp_table.AYP_School_ID_Number,
	                                          schoolyear := 2016,
                                                  subject_abbrName := tmp_table.Subject,
                                                  teacher_uniqueCommonId := tmp_table.Educator_ID,
                                                  roster_name := tmp_table.Roster_Name,
                                                  stateDisplayidentifier := tmp_table.State); 
	EXCEPTION WHEN others THEN
              RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
              RAISE NOTICE '% %', SQLERRM, SQLSTATE;
        END;               
        
 END LOOP;			    
	    		   
END;
$BODY$;
drop table if exists  tmp_hgss_rosters ;


