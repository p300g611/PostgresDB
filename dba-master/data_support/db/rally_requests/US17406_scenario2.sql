DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
BEGIN
now_date :=now();
RAISE NOTICE 'adding student to roster :DLM';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='001240947',
			    att_sch_displayidentifier:='12_7320',
			    ayp_sch_displayidentifier:='12_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='202716',
			    roster_name:='DLM',
			    statedisplayidentifier:='MS'); 
RAISE NOTICE 'adding student to roster :DLM';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='001240947',
			    att_sch_displayidentifier:='12_7320',
			    ayp_sch_displayidentifier:='12_7320',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='202716',
			    roster_name:='DLM',
			    statedisplayidentifier:='MS');
	    		   
END;
$BODY$; 
