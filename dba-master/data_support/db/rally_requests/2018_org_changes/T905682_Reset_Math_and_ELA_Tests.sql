/*Ticket #905682
Please reset the following student's tests:
State: NY District: West Babylon School: West Babylon Junior High
SSID: 7489011553
Name: N'Riyah Price
Grade: 7
Subjects: ELA and M
Math: DLM-PriceN'Riyah-1269986-YE M 7.4 IP
ELA: DLM-PriceN'Riyah-1269986-YE ELA 7.4 PP
*/

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #905682', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (23139911,23140047,23171216) and studentid=1269986 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (23139911,23140047,23171216) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid in (23139911,23140047,23171216) and studentid =1269986 and activeflag =true ;


---------
update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id  in (select testsessionid from studentstests where id in (23139911,23140047,23171216));


update ititestsessionhistory
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1269986 and testsessionid in (select testsessionid from studentstests where id in (23139911,23140047,23171216));
--
update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where  testsessionid in (select testsessionid from studentstests where id in (23139911,23140047,23171216));

--For reset

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where   studentid =1269986;

COMMIT;
