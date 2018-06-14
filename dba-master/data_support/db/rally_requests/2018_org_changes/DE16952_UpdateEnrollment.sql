
--studentid:505360
update studentstests 
set    enrollmentid = 3343099,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   manualupdatereason='as enrollment_old:3080052'
	   where studentid=505360 and enrollmentid = 3080052 and status=86 and activeflag is true;
	   

--studentid:783327
update studentstests 
set    enrollmentid = 3082268,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   manualupdatereason='as enrollment_old:3004309'
	   where studentid=783327 and enrollmentid = 3004309 and status=86 and activeflag is true;
	   
	   
--studentid:857904
update studentstests 
set    enrollmentid = 2949653,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   manualupdatereason='as enrollment_old:3162590'
	   where studentid=857904 and enrollmentid = 3162590 and status=86 and activeflag is true;
	   
--studentid:1204951

update studentstests 
set    enrollmentid = 3082270,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   manualupdatereason='as enrollment_old:3004315'
	   where studentid=1204951 and enrollmentid = 3004315 and status=86 and activeflag is true;
	   
	   
--studentid:1324499
update studentstests 
set    enrollmentid = 3082269,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   manualupdatereason='as enrollment_old:3004308'
	   where studentid=1324499 and enrollmentid = 3004308 and status=86 and activeflag is true;
	   
	   
--studentid:1423806 .  
update studentstests 
set    enrollmentid = 3082271,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   manualupdatereason='as enrollment_old:3004316'
	   where studentid=1423806 and enrollmentid = 3004316 and status=86 and activeflag is true;
	   
	   
--studentid:1438989
update studentstests 
set    enrollmentid = 3237142,
       modifieddate =now(),
	   modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
	   manualupdatereason='as enrollment_old:3153897'
	   where studentid=1438989 and enrollmentid = 3153897 and status=86 and activeflag is true;