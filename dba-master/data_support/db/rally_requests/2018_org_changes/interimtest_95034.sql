select count(*) from interimtest where testtestid=95034 and activeflag =true ;
select count(*) from test where id =95034 and activeflag =true ;
select count(*) from testsession where id =5600057 and activeflag =true ;
select count(*) from studentstests  where testid  =95034 and activeflag is true;


begin;
update studentstests
set activeflag =false,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
where testid =95034 and activeflag =true ;

update testsession
set activeflag =false,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
where id =5600057 and activeflag =true ;

update test
set activeflag =false,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
where id =95034 and activeflag =true ;

update interimtest
set activeflag =false,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
where testtestid =95034 and activeflag =true ;

update interimtesttest
set activeflag =false,
 modifieduser =(select id from aartuser where email='ats_dba_team@ku.edu'),
 modifieddate=now()
where id=58760 and activeflag =true ;

delete from testcollectionstests where testid =95034 and testcollectionid=4807;

commit;