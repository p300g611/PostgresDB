UPDATE studentassessmentprogram
SET activeflag = true
WHERE studentid = (select id from student where statestudentidentifier = '2144960739') AND assessmentprogramid = 3;
