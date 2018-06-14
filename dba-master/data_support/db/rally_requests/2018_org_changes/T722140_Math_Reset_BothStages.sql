/* Ticket #722140
Math test Reset Grade 7
studentid:657729,688814,778795,1258736,1432648
Stage 1 - reset
Stage 2 - reset
*/


begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #722140 ', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21355434,22688014,21355204,22739004,21355168,22680123,21355406,22680153,21355186,22680130)  and activeflag =true;

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21355434,22688014,21355204,22739004,21355168,22680123,21355406,22680153,21355186,22680130) and activeflag =true  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (21355434,22688014,21355204,22739004,21355168,22680123,21355406,22680153,21355186,22680130)and activeflag =true ;

COMMIT;



