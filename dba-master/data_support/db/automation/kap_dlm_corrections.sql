drop table if exists  tmp_kap_dlm_corrections ;
drop table if exists  tmp_kap_dlm_corrections_raw ;
create temporary table tmp_kap_dlm_corrections_raw(
                                         statestudentidentifier           text
                                       , programabbreviation              text
                                       , action                           text                                       
                                       , comment                          text
                                       , submittedby                      text                                       
						);

\COPY tmp_kap_dlm_corrections_raw FROM 'kap_dlm_corrections.csv' DELIMITER ',' CSV HEADER ;  

SELECT ROW_NUMBER() over()+1 as row_num,cast('' as text) error_msg,* INTO TEMP tmp_kap_dlm_corrections FROM tmp_kap_dlm_corrections_raw;
  
DO
$BODY$
DECLARE
        err_msg TEXT;
	currentstudentid BIGINT;
	data record;
	
BEGIN

   FOR data IN (SELECT row_num
                     , statestudentidentifier
	             , programabbreviation
	             , action
	        FROM tmp_kap_dlm_corrections)

        LOOP
        BEGIN
		RAISE NOTICE 'Row: '%' ---- Attempting to add ''%'' to ''%'' ----', data.row_num, data.statestudentidentifier, data.programabbreviation; 
	
		SELECT id
		FROM student
		WHERE stateid = (SELECT id FROM organization WHERE displayidentifier = 'KS') AND statestudentidentifier = data.statestudentidentifier
		LIMIT 1
		INTO currentstudentid;
		
		IF currentstudentid IS NOT NULL THEN
			RAISE NOTICE 'Found student ''%'' as studentid %', data.statestudentidentifier, currentstudentid;
			IF (data.action = 'A') THEN 
			   PERFORM reactivate_student_assessment_program(currentstudentid, data.programabbreviation, 2016);
			   err_msg = '<success>Found student '||data.statestudentidentifier||' as studentid '||currentstudentid||'; added '||data.programabbreviation;                            
			END IF;
                        IF (data.action = 'R') THEN 
                           PERFORM remove_student_from_assessment_program(currentstudentid, data.programabbreviation, 2016);
			   err_msg = '<success>Found student '||data.statestudentidentifier||' as studentid '||currentstudentid||'; Removed '||data.programabbreviation;                                
                        END IF;			
		ELSE
			RAISE NOTICE 'State student identifier ''%'' not found in KS, skipping...', data.statestudentidentifier;
			err_msg = '<error>State student identifier '||data.statestudentidentifier||' not found in KS, skipping...';
		END IF;
		
		UPDATE tmp_kap_dlm_corrections
		SET error_msg=err_msg
                WHERE row_num=data.row_num;
        EXCEPTION WHEN OTHERS THEN	
           RAISE NOTICE '% %', SQLERRM, SQLSTATE;
           UPDATE tmp_kap_dlm_corrections
           SET error_msg='<error>'||SQLERRM||'/'|| SQLSTATE
           WHERE row_num=data.row_num;  
        END;      
	END LOOP;
EXCEPTION WHEN OTHERS THEN	
        RAISE NOTICE '% %', SQLERRM, SQLSTATE;
        UPDATE tmp_kap_dlm_corrections
        SET error_msg='<error>'||SQLERRM||'/'|| SQLSTATE
        WHERE row_num=data.row_num;  
END;
$BODY$;
\COPY (select * from tmp_kap_dlm_corrections where error_msg ilike '%<error>%' ) to 'kap_dlm_corrections_error.csv' DELIMITER ',' CSV HEADER ;
drop table if exists  tmp_kap_dlm_corrections ;
drop table if exists  tmp_kap_dlm_corrections_raw ;

    