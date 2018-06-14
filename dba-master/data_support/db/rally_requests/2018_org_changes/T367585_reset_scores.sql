
select distinct id,studenttestid,activeflag from studentstestscore
where studenttestid in (19592127,19592120,19594327,19594333,19591453,19591441,19591391,19591401,19600015);


select distinct id,kelpascoringstatus,studentstestsid from scoringassignmentstudent
where studentstestsid in (19592127,19592120,19594327,19594333,19591453,19591441,19591391,19591401,19600015) ;


begin;
update studentstestscore
set    activeflag =false,
       modifieddate=now(),
       modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where studenttestid in (19592127,19592120,19594327,19594333,19591453,19591441,19591391,19591401,19600015) and  activeflag =true;

update scoringassignmentstudent
set    kelpascoringstatus =null,
       modifieddate=now(),
       modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestsid in (19592127,19592120,19594327,19594333,19591453,19591441,19591391,19591401,19600015) and kelpascoringstatus is not null ;	  
commit;