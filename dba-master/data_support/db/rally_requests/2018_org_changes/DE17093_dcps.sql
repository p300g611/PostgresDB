--deactivate the student test student 1436048,Winter DCPS Conventional Communication Learner

begin;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  manualupdatereason='for DE17093',
	  modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where id =19505194 and studentid=1436048 and activeflag is true ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =19505194 and activeflag is true ;


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id =19505194) and activeflag is true;




update studentsresponses 
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsid=19505194 and studentid=1436048 and activeflag is true ;

commit;

