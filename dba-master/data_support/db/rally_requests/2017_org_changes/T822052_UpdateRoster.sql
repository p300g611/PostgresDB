BEIGN;

update enrollmentsrosters 
set   activeflag =true,
      modifieddate =now(),
	  modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where  rosterid =1101847;

update roster 
set   activeflag =true,
      statecoursecode='',
	  modifieddate=now(),
	  modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where id =1101847;

update enrollmentsrosters 
set   activeflag =true,
      modifieddate =now(),
	  modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where  rosterid =1142792;

update roster 
set   activeflag =true,
      statecoursecode='',
	  modifieddate=now(),
	  modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where id =1142792;



COMMIT;