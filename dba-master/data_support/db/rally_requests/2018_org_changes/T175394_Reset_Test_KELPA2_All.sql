/* Ticket 175394
KELPA2 Test Reset for all four domains. Reading, writing, listening, and speaking. 
State Student ID: 3145196456
District: Emporia
School: Riverside Elementary
Grade:1
Domain: ALL FOUR.
*/
begin;

update studentstests
set   activeflag =false,
      modifieddate=now(),
      modifieduser = (select id from aartuser where username ='ats_dba_team@ku.edu'),
      manualupdatereason='Ticket #175394'
where id in (19517875,19517885,19517894,19517901);

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (19517875,19517885,19517894,19517901);

update studentsresponses 
set   activeflag =false, 
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentid = 1388620 and studentstestsid in (19517875,19517885,19517894,19517901) and activeflag is true;

commit;


