/*Ticket #863317
 has been assigned to you by Connie B. 
ELA reset
Grade 5
2464604186
8669291665
Reset stage 1 (for both)
*/

--Student 2464604186

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #863317', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21040234 and studentid=279484 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21040234 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =21040234 and studentid =279484 and activeflag =true ;

COMMIT;

--Student 8669291665

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #863317', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21121541 and studentid=508588 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21121541 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =21121541 and studentid =508588 and activeflag =true ;

COMMIT;
