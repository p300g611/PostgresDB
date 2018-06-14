--studentid:762191
begin;

update enrollment 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744,
	   notes='inactive for tickete#285337'
	   where id =3400717;
	   
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #285337', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (20855289,21150060) and studentid=762191 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (20855289,21150060) and activeflag =true ;

commit;
