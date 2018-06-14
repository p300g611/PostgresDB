begin;

update surveypagestatus 
set    activeflag =false, 
       modifieddate=now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where surveyid =181897 and activeflag =true;



update survey
set    activeflag =false, 
       modifieddate=now(),
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =181897 and activeflag =true;

commit;

