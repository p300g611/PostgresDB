/*Ticket #463441
Please set the two tests back to Unused status. 
22164234
21173749
*/

--Test1
begin

select * from studentstests where  id=22164234
select * from student where id=1406618

update studentstests
set    status=84, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #463441', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22164234 and studentid=1406618  and activeflag =true;

update studentstestsections
set    statusid =125,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 22164234 and activeflag =true  ;

COMMIT;

--Test2
begin

select * from studentstests where  id=21173749
select * from student where id=1256333

update studentstests
set    status=84, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #463441', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21173749 and studentid=1256333 and activeflag =true;

update studentstestsections
set    statusid =125,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 21173749 and activeflag =true  ;

COMMIT;


