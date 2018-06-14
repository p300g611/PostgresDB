begin;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #466280'
where id in (19664324,19664328,19664332,19664339) and studentid=1403814 and activeflag is true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
                  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (19664324,19664328,19664332,19664339) and activeflag is true;

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1403814 and studentstestsid in (19664324,19664328,19664332,19664339) and activeflag is true;


update scoringassignmentstudent
set   activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
	   where studentstestsid in (19664324,19664328,19664332,19664339) and studentid =1403814 and  activeflag is true;
	   
update studentstestscore
set   activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
	   where studenttestid in (19664324,19664328,19664332,19664339) and  activeflag is true;
	   


commit;
