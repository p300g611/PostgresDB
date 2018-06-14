
--SSID:  Grade 10
1651499489
5790647855
1738738779
Reset stage 1
Reset stage 2
stage 1 and 2 MATH

BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21287255,21832680,20697019,21835584, 21287495,21834185) and activeflag =true ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21287255,21832680,20697019,21835584, 21287495,21834185)and activeflag =true ;


update studentsresponses
set    activeflag =false ,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (21287255,21832680,20697019,21835584, 21287495,21834185) and activeflag =true  ;


COMMIT;


