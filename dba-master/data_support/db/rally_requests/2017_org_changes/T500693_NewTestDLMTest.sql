begin;
--  ssid: 9767854945   active studenttracker so that new tests will be assigned. 


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18402306,17768069,17768075,18403059)  and activeflag is true ;


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where  id in (3208276,2807306,2807309,3208867,3209823,3209837);

update  studenttracker
set     status ='UNTRACKED',
        modifieddate=now(),
	    modifieduser =174744
where  id in (541395,541398);

COMMIT;
