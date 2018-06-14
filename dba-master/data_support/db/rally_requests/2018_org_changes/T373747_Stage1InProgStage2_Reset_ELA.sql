/*Ticket #373747 
Reset request:
ELA Grade 10
2824126914
1020532432
(same for both)

Stage 1 - In progress
Stage 2 - reset
*/

-- Sudent 2824126914
--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #373747', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21963576 and studentid=53219 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21963576 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21963576 and studentid =53219 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #373747', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id= 20928244
and studentid=53219;

update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20928244;

COMMIT;

--student 1020532432

--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #373747', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21965266 and studentid=292282 and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21965266 and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21965266 and studentid =292282 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #373747', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id= 21100078
and studentid=292282;

update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21100078;

COMMIT;
