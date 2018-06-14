--Student ID 1585296414. reset science grade 5 stage 1 

begin;
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #684606', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20326499  and studentid=1068373 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20326499  and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =20326499 and studentid =1068373 and  activeflag =true ;

commit;
