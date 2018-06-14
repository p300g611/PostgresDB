BEGIN;
--SSID: update any test tracker to untracked
update studenttracker
set    status ='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744	   
where id in (370623,369981);

--SSID:702150089 AND 338081778. update Math and ELA tracker to untracked
--Math
update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in(16666709,16405903,16711562,16719498,16667940,16376663,16879634));



update studenttracker
set    status ='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744	   
where id in (383015,352084);

--ELA
update studenttracker
set    status ='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744	   
where id in (383476,352219);


update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  id in (2337324,2199461,2312044,2436578,2168204,2342897,2313470);
COMMIT;