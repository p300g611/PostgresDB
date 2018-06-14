/*Ticket #783420 
Math reset
Grade 7 
2186581787
2488649805
Reset stage 1 -both
*/

--Student 2186581787

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #783420', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20803896 and studentid=901464 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20803896 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =20803896 and studentid =901464 and activeflag =true ;

COMMIT;

--Student 2488649805

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #783420', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20747916 and studentid=1340691 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20747916 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid =20747916 and studentid =1340691 and activeflag =true ;

COMMIT;
