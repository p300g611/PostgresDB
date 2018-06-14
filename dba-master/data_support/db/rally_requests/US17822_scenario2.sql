DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
BEGIN
now_date :=now();
RAISE NOTICE 'adding student to roster :150625665-ELA';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='150625665',
			    att_sch_displayidentifier:='050160630022012',
			    ayp_sch_displayidentifier:='050160630022012',
			    schoolyear:=2016,
			    subject_abbrname:='ELA',
			    teacher_uniquecommonid :='0492894',
			    roster_name:='hirsch ela',
			    statedisplayidentifier:='IL'); 
RAISE NOTICE 'adding student to roster :150625665-M';
	PERFORM addstudenttorosterwithnocourse(
			    state_student_identifier:='150625665',
			    att_sch_displayidentifier:='050160630022012',
			    ayp_sch_displayidentifier:='050160630022012',
			    schoolyear:=2016,
			    subject_abbrname:='M',
			    teacher_uniquecommonid :='0492894',
			    roster_name:='hirsch math',
			    statedisplayidentifier:='IL');			    
		   
END;
$BODY$; 