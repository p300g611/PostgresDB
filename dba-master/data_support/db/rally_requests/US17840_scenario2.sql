DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
BEGIN
now_date :=now();
RAISE NOTICE 'adding student to roster :Amee Math';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000935128',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee Math',
			    statedisplayidentifier:='MS'); 
RAISE NOTICE 'adding student to roster :Amee ELA';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='001174060',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee ELA',
			    statedisplayidentifier:='MS');
RAISE NOTICE 'adding student to roster :Amee Math';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000858866',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee Math',
			    statedisplayidentifier:='MS');
RAISE NOTICE 'adding student to roster :Amee ELA';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000858866',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee ELA',
			    statedisplayidentifier:='MS');
RAISE NOTICE 'adding student to roster :Amee Math';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='001174060',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee Math',
			    statedisplayidentifier:='MS');
RAISE NOTICE 'adding student to roster :Amee Math';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000622862',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee Math',
			    statedisplayidentifier:='MS');
RAISE NOTICE 'adding student to roster :Amee ELA';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000672250',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee ELA',
			    statedisplayidentifier:='MS');	
RAISE NOTICE 'adding student to roster :Amee ELA';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000715764',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee ELA',
			    statedisplayidentifier:='MS');
RAISE NOTICE 'adding student to roster :Amee Math';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000672250',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee Math',
			    statedisplayidentifier:='MS');	
RAISE NOTICE 'adding student to roster :Amee ELA';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000780619',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee ELA',
			    statedisplayidentifier:='MS');	
RAISE NOTICE 'adding student to roster :Amee Math';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000780619',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee Math',
			    statedisplayidentifier:='MS');	
RAISE NOTICE 'adding student to roster :Amee Math';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000715764',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee Math',
			    statedisplayidentifier:='MS');	
RAISE NOTICE 'adding student to roster :Amee ELA';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000622862',
			    att_sch_displayidentifier:='8_7320',
			    ayp_sch_displayidentifier:='8_7320',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='158126',
			    roster_name:='Amee ELA',
			    statedisplayidentifier:='MS');			    
END;
$BODY$; 
