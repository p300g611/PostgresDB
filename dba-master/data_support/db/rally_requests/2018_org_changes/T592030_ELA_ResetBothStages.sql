/*Ticket #592030
Please inactivate both tests below

-[ RECORD 1 ]-+-----------------------------------------
studentid | 530365
stid | 20960640
test | English Language Arts Grade 6: Session 1
categoryname | Complete
createddate | 2018-03-11 17:39:58.793+00
af | t
e_af | t
eaf | t
startdatetime | 2018-04-10 14:14:12.757601+00
enddatetime | 2018-04-10 14:16:04.449446+00
complete |
-[ RECORD 2 ]-+-----------------------------------------
studentid | 530365
stid | 22237023
test | English Language Arts Grade 6: Session 2
categoryname | Complete
createddate | 2018-04-10 14:25:31.297+00
af | t
e_af | t
eaf | t
startdatetime | 2018-04-11 14:08:20.537211+00
enddatetime | 2018-04-11 14:08:29.609546+00
complete |
*/


begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #592030', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22237023, 20960640) and studentid=530365 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22237023, 20960640) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22237023, 20960640) and studentid =530365 and activeflag =true ;

COMMIT;

