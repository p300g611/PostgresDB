/*Ticket #860902
Please inactivate both studentstests below
-[ RECORD 1 ]-+------------------------------
studentid | 1450452
stid | 22535282
test | Math Grade 5: Session 1
categoryname | Complete
createddate | 2018-04-14 00:25:23.07+00
af | t
e_af | t
eaf | t
startdatetime | 2018-04-16 17:45:36.945022+00
enddatetime |
complete |
-[ RECORD 2 ]-+------------------------------
studentid | 1450452
stid | 22606605
test | Math Grade 5: Session 2
categoryname | Complete
createddate | 2018-04-17 00:25:04.314+00
af | t
e_af | t
eaf | t
startdatetime | 2018-04-17 17:42:59.286512+00
enddatetime | 2018-04-17 17:47:30.283204+00 
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #860902', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22606605,22535282) and studentid=1450452 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22606605,22535282) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22606605,22535282) and studentid =1450452 and activeflag =true ;

COMMIT;

