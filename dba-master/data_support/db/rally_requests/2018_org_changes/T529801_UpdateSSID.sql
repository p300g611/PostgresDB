--Need the tests, PNP, and FCS moved from the wrong SSID to the correct SSID. 
--Wrong SSID: 000002269   Correct SSID: 4116827505

begin;

update student 
set  statestudentidentifier='4116827505',
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id =1431402;
	 
update student 
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
	 where id =1344592;
	 
	 
update enrollment
set  activeflag =false,
     modifieddate=now(),
	 modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu'),
	 notes='For ticket #529801'
	 where id =3184514;
	 
commit;

