/*Ticket #293595 
Please reset the following student's test:
Student ID # 3239934728
Subject: ELA 
Grade 3
District: Piper Kansas City
School: Piper Elementary School
Inactivate Stage 2, set Stage 1 to Unused, and clear all responses from Stage 1.
*/

begin

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #293595', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22283393 and studentid=528148  and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 22283393 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  = 22283393 and studentid =528148 and activeflag =true ;

--stage1

update studentstests
set    status =84,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #293595', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id=20968137
and studentid=528148;

update studentstestsections
set    statusid =125,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20968137;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =20968137 and studentid =528148 and activeflag =true ;

COMMIT;
