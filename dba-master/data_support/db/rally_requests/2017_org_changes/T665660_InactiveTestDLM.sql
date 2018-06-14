BEGIN;
--studenttestid:17186424,17186381,17173364,17172925,17183219,17183146,17183221,17183149,17183223,17183151,17183590,17183556,17183640,17183615
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17186424,17186381,17173364,17172925,17183219,17183146,17183221,17183149,17183223,17183151,17183590,17183556,17183640,17183615);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17186424,17186381,17173364,17172925,17183219,17183146,17183221,17183149,17183223,17183151,17183590,17183556,17183640,17183615);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17186424,17186381,17173364,17172925,17183219,17183146,17183221,17183149,17183223,17183151,17183590,17183556,17183640,17183615));




update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (17186424,17186381,17173364,17172925,17183219,17183146,17183221,17183149,17183223,17183151,17183590,17183556,17183640,17183615));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where   studentid in (1151940,1357252,971278,1408547,1408550,969340,1408551);



commit;





