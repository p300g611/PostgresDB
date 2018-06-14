DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
BEGIN
now_date :=now();
RAISE NOTICE 'adding rosters for M';
	PERFORM createNewRosterWithNoCourse(state_student_identifiers := array['539921067','145800176','393508320','360524419','406958535'],
	                                        att_sch_displayidentifier := '350500400170001',
	                                        ayp_sch_displayidentifier := '350500400170001',
	                                        schoolyear := 2016,
                                                subject_abbrName := 'M',
                                                teacher_uniqueCommonId := 'crobart@streatorhs.org',
                                                roster_name := 'ROBART MATH',
                                                stateDisplayidentifier := 'IL'); 
RAISE NOTICE 'adding roster for ELA';
	PERFORM createNewRosterWithNoCourse(state_student_identifiers := array['539921067','145800176','393508320','360524419','406958535'],
	                                        att_sch_displayidentifier := '350500400170001',
	                                        ayp_sch_displayidentifier := '350500400170001',
	                                        schoolyear := 2016,
                                                subject_abbrName := 'M',
                                                teacher_uniqueCommonId := 'crobart@streatorhs.org',
                                                roster_name := 'ROBART ELA',
                                                stateDisplayidentifier := 'IL');
RAISE NOTICE 'adding roster for sci';                                                
	PERFORM createNewRosterWithNoCourse(state_student_identifiers := array['539921067','145800176','393508320','360524419','406958535'],
	                                        att_sch_displayidentifier := '350500400170001',
	                                        ayp_sch_displayidentifier := '350500400170001',
	                                        schoolyear := 2016,
                                                subject_abbrName := 'Sci',
                                                teacher_uniqueCommonId := 'crobart@streatorhs.org',
                                                roster_name := 'ROBART SCIENCE',
                                                stateDisplayidentifier := 'IL');                                                 
                                                     
                                                 
	    		   
END;
$BODY$;