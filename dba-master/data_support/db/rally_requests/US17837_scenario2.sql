DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
BEGIN
now_date :=now();
RAISE NOTICE 'adding student to roster :Hayes Feather ELA8';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='001010730',
			    att_sch_displayidentifier:='8_5500',
			    ayp_sch_displayidentifier:='8_5500',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='238823',
			    roster_name:='Hayes Feather ELA8',
			    statedisplayidentifier:='MS'); 
RAISE NOTICE 'adding student to roster :Hayes Feather Math8';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='001010730',
			    att_sch_displayidentifier:='8_5500',
			    ayp_sch_displayidentifier:='8_5500',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='238823',
			    roster_name:='Hayes Feather Math8',
			    statedisplayidentifier:='MS');
RAISE NOTICE 'adding student to roster :Hayes Feather SCI8';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='001010730',
			    att_sch_displayidentifier:='8_5500',
			    ayp_sch_displayidentifier:='8_5500',
			    schoolyear:=2016,
			    subject_abbrname:='SCI',
			    teacher_uniquecommonid :='238823',
			    roster_name:='Hayes Feather SCI8',
			    statedisplayidentifier:='MS');			    
		   
END;
$BODY$; 