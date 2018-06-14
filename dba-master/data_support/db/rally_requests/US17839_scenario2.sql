DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
BEGIN
now_date :=now();
RAISE NOTICE 'adding student to roster :Nancy MATH';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000757964',
			    att_sch_displayidentifier:='16_7320',
			    ayp_sch_displayidentifier:='16_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='143795',
			    roster_name:='Nancy MATH',
			    statedisplayidentifier:='MS'); 
RAISE NOTICE 'adding student to roster :Nancy MATH';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='000890210',
			    att_sch_displayidentifier:='16_7320',
			    ayp_sch_displayidentifier:='16_7320',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='143795',
			    roster_name:='Nancy MATH',
			    statedisplayidentifier:='MS');
	    		   
END;
$BODY$; 
