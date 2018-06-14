select statestudentidentifier "StateStudentIdentifier",progressiontext "ProgressionText"
into temp tmp_report 
from studentreport sr
inner join student s on s.id=sr.studentid
where schoolyear=2018 and assessmentprogramid=47 and sr.stateid=51;

\copy (select * from tmp_report)  to  'KELPA2_ProgressionText.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 