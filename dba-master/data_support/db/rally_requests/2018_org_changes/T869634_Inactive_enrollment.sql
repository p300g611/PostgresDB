begin;

update enrollment 
set  activeflag =false,
     modifieddate=now(),
	 modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu'),
	 notes='per T869634'
	 where id =3153897;

update enrollmentsrosters 
set    enrollmentid = 3237142,
       activeflag =true,
       modifieddate =now(),
       modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')	 
where id in (16013923,16013922);

commit;
	   