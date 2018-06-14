/*ticket #316746 
Set stage 1 to inprogress and stage 2 inactive
-[ RECORD 1 ]-+------------------------------
studentid | 902047
stid | 20809548
test | Math Grade 6: Session 1
categoryname | Complete
createddate | 2018-03-10 19:40:18.025+00
af | t
e_af | t
eaf | t
startdatetime | 2018-04-16 12:52:33.68031+00
enddatetime | 2018-04-16 13:53:40.527105+00
complete |
-[ RECORD 2 ]-+------------------------------
studentid | 902047
stid | 22544254
test | Math Grade 6: Session 2
categoryname | Complete
createddate | 2018-04-16 13:55:28.875+00
af | t
e_af | t
eaf | t
startdatetime | 2018-04-18 12:53:09.196153+00
enddatetime | 2018-04-18 14:10:07.082648+00 
*/

begin

--stage2

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #316746', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 22544254 and studentid=902047  and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid = 22544254 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  = 22544254 and studentid =902047 and activeflag =true ;

--stage1


update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='for ticket #316746', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id=20809548
and studentid=902047;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =20809548;

COMMIT;

