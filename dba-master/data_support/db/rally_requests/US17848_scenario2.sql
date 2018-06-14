DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
BEGIN
now_date :=now();
RAISE NOTICE 'adding student to roster 510986186:DLM:M';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='510986186',
			    att_sch_displayidentifier:='60160970022006',
			    ayp_sch_displayidentifier:='60160970022006',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='10367',
			    roster_name:='Saliny, Lauren',
			    statedisplayidentifier:='IL'); 
RAISE NOTICE 'adding student to roster 510986186:DLM:ELA';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='510986186',
			    att_sch_displayidentifier:='60160970022006',
			    ayp_sch_displayidentifier:='60160970022006',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='10367',
			    roster_name:='Saliny, Lauren',
			    statedisplayidentifier:='IL');
	    		   
END;
$BODY$;