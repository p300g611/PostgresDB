drop table if exists  tmp_scenario8_raw ;
drop table if exists  tmp_scenario8 ;
create temporary table tmp_scenario8_raw(   
						Callers_Name 	        	text ,
						Callers_Email_Address 		text ,
						State	                	text ,
						District_ID_Number		text ,
						District_Name	        	text ,
						School_ID_Number		text ,
						School_Name  	        	text ,
						StudentState_ID	        	text ,
						StudentFirst_Name		text ,
						StudentLast_Name		text ,
						SendingSchool_ExitDate		text,
						Exit_Reason	        	text ,
						ReceivingSchool_Entry_Date	text,
						ReceivingSchool_IDNumber	text ,
						ReceivingSchool_Name	        text ,
						Roster_Name	                text ,
						Subject				text ,
						Course_optional    		text ,
						Educator_ID			text ,
						Educators_First_and_Last_Name	text 
						);

\COPY tmp_scenario8_raw FROM '/CETE_GENERAL/Technology/helpdesk/scenarios/unprocessed/scenario8.csv' DELIMITER ',' CSV HEADER
SELECT ROW_NUMBER() over()+1 as row_num,cast('' as text) error_msg,* INTO TEMP tmp_scenario8 FROM tmp_scenario8_raw; 
DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 tmp_table record ;
 tmp_roster record ;
 record_cnt integer;
 err_msg TEXT; 
BEGIN
now_date :=now();
record_cnt:=0;
FOR tmp_table IN (SELECT                        row_num                          ,
                                                error_msg                        ,
                                                upper(State) State             	 ,
						District_ID_Number		 ,
						District_Name	        	 ,
						School_ID_Number		 ,
						School_Name  	        	 ,
						StudentState_ID	        	 ,
						StudentFirst_Name		 ,
						StudentLast_Name		 ,
						SendingSchool_ExitDate		 ,
						Exit_Reason	        	 ,
						ReceivingSchool_Entry_Date	 ,
						ReceivingSchool_IDNumber	 ,
						ReceivingSchool_Name	         ,
						Roster_Name	                 ,
						Subject				 ,
						Course_optional    		 ,
						Educator_ID			 ,
						Educators_First_and_Last_Name	  FROM tmp_scenario8)
 LOOP   
        record_cnt:=record_cnt+1;
	RAISE NOTICE 'transfer row(%)>> StudentState_ID %: ,School_ID_Number: %,SendingSchool_ExitDate: %,ReceivingSchool_IDNumber: % ,ReceivingSchool_Entry_Date: %,State: %,Educator_ID: %'
	                     ,record_cnt,tmp_table.StudentState_ID,tmp_table.School_ID_Number,tmp_table.SendingSchool_ExitDate,tmp_table.ReceivingSchool_IDNumber,tmp_table.ReceivingSchool_Entry_Date,tmp_table.State,tmp_table.Educator_ID  ;
        BEGIN
        SELECT transferstudent         (statestudent_identifier := tmp_table.StudentState_ID , 
                                                   old_aypSch := tmp_table.School_ID_Number , 
                                                   old_attSch := tmp_table.School_ID_Number, 
                                                   exitReason := cast(tmp_table.Exit_Reason as numeric) ,
                                                   exitDate := cast(tmp_table.SendingSchool_ExitDate as date),
                                                   schoolyear := 2016 , 
                                                   new_AypSch := tmp_table.ReceivingSchool_IDNumber ,
                                                   new_attSch:=tmp_table.ReceivingSchool_IDNumber,
                                                   new_Dist := tmp_table.District_ID_Number,
                                                   new_schEntryDate := cast(tmp_table.ReceivingSchool_Entry_Date as date),
                                                   new_DistEntryDate := cast(tmp_table.ReceivingSchool_Entry_Date as date),
                                                   stateDisplayidentifier := tmp_table.State                                                  
                                                   ) INTO err_msg ; 
          RAISE NOTICE 'error message is %',err_msg;
            UPDATE tmp_scenario8
            SET error_msg=err_msg
            WHERE row_num=tmp_table.row_num;                                           
  IF((select count(*) from student s 
             inner join enrollment en on s.id=en.studentid
             inner join organization o on o.id=en.attendanceschoolid
            where upper(statestudentidentifier)=upper(tmp_table.StudentState_ID) 
               and upper(o.displayidentifier) =upper(tmp_table.ReceivingSchool_IDNumber)
               AND en.currentschoolyear=2016)<=0)
            
     
   THEN    
    RAISE NOTICE 'started transferstudent not done';      
      ELSE                                                    
   IF (tmp_table.State IN ('OK', 'MS') and tmp_table.Course_optional >'' ) THEN
                     RAISE NOTICE 'started createNewRosterWithSubAndCourse';
                     PERFORM createNewRosterWithSubAndCourse(state_student_identifiers := array[tmp_table.StudentState_ID]
                                                           , att_sch_displayidentifier := tmp_table.ReceivingSchool_IDNumber
                                                           , ayp_sch_displayidentifier := tmp_table.ReceivingSchool_IDNumber
                                                           , schoolyear := 2016
                                                           , subject_abbrName := tmp_table.Subject
                                                           , course_abbrName := tmp_table.Course_optional
                                                           , teacher_uniqueCommonId := tmp_table.Educator_ID
                                                           , roster_name := tmp_table.Roster_Name
                                                           , stateDisplayidentifier := tmp_table.State ); 
          
               FOR tmp_roster IN (select r.coursesectionname, au.uniquecommonidentifier, ca.abbreviatedname, gc.abbreviatedname coursename 
						from roster r
						join aartuser au on r.teacherid = au.id
						join enrollmentsrosters er on er.rosterid = r.id
						join enrollment en on en.id = er.enrollmentid
						join contentarea ca on ca.id = r.statesubjectareaid
						join student stu on stu.id = en.studentid
						join organization org on en.attendanceschoolid = org.id
						join gradecourse gc on gc.id = r.statecoursesid
						join organization orgst on stu.stateid = orgst.id
						where er.activeflag is true 
							and en.currentschoolyear = 2016 
							and r.statecoursesid  is not null
							and stu.statestudentidentifier = tmp_table.StudentState_ID
							and org.displayidentifier = tmp_table.School_ID_Number
							and ca.abbreviatedname = tmp_table.Subject
							and orgst.displayidentifier = tmp_table.State
							and gc.abbreviatedname = tmp_table.Course_optional)
								
				 LOOP   
				    RAISE NOTICE 'transfer row(%)>> StudentState_ID %: ,School_ID_Number: %,SendingSchool_ExitDate: %,ReceivingSchool_IDNumber: % ,ReceivingSchool_Entry_Date: %,State: %,Educator_ID: %,uniquecommonidentifier:%,coursesectionname:%,coursename:%'
	                                    ,record_cnt,tmp_table.StudentState_ID,tmp_table.School_ID_Number,tmp_table.SendingSchool_ExitDate,tmp_table.ReceivingSchool_IDNumber,tmp_table.ReceivingSchool_Entry_Date,tmp_table.State,tmp_table.Educator_ID,tmp_roster.uniquecommonidentifier,tmp_roster.coursesectionname ,tmp_roster.coursename ;   
					 PERFORM moveCTSFromRosterWithCourse(	   statestudent_identifier := tmp_table.StudentState_ID , 
										   old_aypsch := tmp_table.School_ID_Number , 
										   old_attsch := tmp_table.School_ID_Number, 
										   old_roster_teacherIdentifier := tmp_roster.uniquecommonidentifier ,
										   schoolyear := 2016 , 
										   new_aypsch := tmp_table.ReceivingSchool_IDNumber ,
										   new_attsch:=tmp_table.ReceivingSchool_IDNumber,
										   sub_abbrName := tmp_roster.abbreviatedname,
										   course_abbrName:=tmp_roster.coursename,
										   old_roster_name := tmp_roster.coursesectionname,
										   new_roster_teacherIdentifier :=tmp_table.Educator_ID,
										   new_roster_name :=tmp_table.Roster_Name,
										   statedisplayidentifier := tmp_table.State  ); 
					END LOOP;          
           
     ELSE
          RAISE NOTICE 'started addstudenttorosterwithnocourse';  
          PERFORM createNewRosterWithNoCourse(state_student_identifiers := array[tmp_table.StudentState_ID],
	                                          att_sch_displayidentifier := tmp_table.ReceivingSchool_IDNumber,
	                                          ayp_sch_displayidentifier := tmp_table.ReceivingSchool_IDNumber,
	                                          schoolyear := 2016,
                                                  subject_abbrName := tmp_table.Subject,
                                                  teacher_uniqueCommonId := tmp_table.Educator_ID,
                                                  roster_name := tmp_table.Roster_Name,
                                                  stateDisplayidentifier := tmp_table.State);                                                                                           
              FOR tmp_roster IN (select r.coursesectionname, au.uniquecommonidentifier, ca.abbreviatedname 
						from roster r
						join aartuser au on r.teacherid = au.id
						join enrollmentsrosters er on er.rosterid = r.id
						join enrollment en on en.id = er.enrollmentid
						join contentarea ca on ca.id = r.statesubjectareaid
						join student stu on stu.id = en.studentid
						join organization org on en.attendanceschoolid = org.id
						join organization orgst on stu.stateid = orgst.id
						where er.activeflag is true 
							and en.currentschoolyear = 2016 
							and r.statecoursesid  is null
							and stu.statestudentidentifier = tmp_table.StudentState_ID
							and org.displayidentifier = tmp_table.School_ID_Number
							and ca.abbreviatedname = tmp_table.Subject
							and orgst.displayidentifier = tmp_table.State)	
												
				 LOOP   
				    RAISE NOTICE 'transfer row(%)>> StudentState_ID %: ,School_ID_Number: %,SendingSchool_ExitDate: %,ReceivingSchool_IDNumber: % ,ReceivingSchool_Entry_Date: %,State: %,Educator_ID: %,uniquecommonidentifier:%,coursesectionname:%'
	                                    ,record_cnt,tmp_table.StudentState_ID,tmp_table.School_ID_Number,tmp_table.SendingSchool_ExitDate,tmp_table.ReceivingSchool_IDNumber,tmp_table.ReceivingSchool_Entry_Date,tmp_table.State,tmp_table.Educator_ID,tmp_roster.uniquecommonidentifier,tmp_roster.coursesectionname  ;   
					 PERFORM moveCTSFromRosterWithNoCourse(
										   statestudent_identifier := tmp_table.StudentState_ID , 
										   old_aypsch := tmp_table.School_ID_Number , 
										   old_attsch := tmp_table.School_ID_Number, 
										   old_roster_teacherIdentifier := tmp_roster.uniquecommonidentifier ,
										   schoolyear := 2016 , 
										   new_aypsch := tmp_table.ReceivingSchool_IDNumber ,
										   new_attsch:=tmp_table.ReceivingSchool_IDNumber,
										   sub_abbrName := tmp_roster.abbreviatedname,
										   old_roster_name := tmp_roster.coursesectionname,
										   new_roster_teacherIdentifier :=tmp_table.Educator_ID,
										   new_roster_name :=tmp_table.Roster_Name,
										   statedisplayidentifier := tmp_table.State  ); 
					END LOOP;					   				    
	END IF;
	END IF;	
	EXCEPTION WHEN others THEN
                RAISE NOTICE 'ERROR on row(%)>>' ,record_cnt ;
                RAISE NOTICE '% %', SQLERRM, SQLSTATE; 
                UPDATE tmp_scenario8
		   SET error_msg='<ERROR>'||SQLERRM||'/'|| SQLSTATE
		   WHERE row_num=tmp_table.row_num;
        END;
                                                         
 END LOOP;     			    
    		   
END;
$BODY$;
\COPY (select * from tmp_scenario8 where error_msg ilike '%<error>%' ) to '/CETE_GENERAL/Technology/helpdesk/scenarios/scenario8_error.csv' DELIMITER ',' CSV HEADER
drop table if exists  tmp_scenario8 ;
drop table if exists  tmp_scenario8_raw ;
