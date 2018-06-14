update studentstests
set    enrollmentid= 3411077,
       testsessionid=5879794, 
       modifieddate=now(),
       manualupdatereason ='Ticket #267522', 
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
    where id=21157505;

