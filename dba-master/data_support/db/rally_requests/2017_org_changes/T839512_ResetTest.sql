begin;
--ssid:7240719219-KAP MATH,inactive stage 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id = 17406364 ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17406364   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 673211    and studentstestsid =17406364  ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =17000912  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17000912  ;


--7460261386--DLM-CoatsUri-738699-SP ELA RL.3.5 DP
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =16399541;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16399541;


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id =16399541);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 738699 and studentstestsid =16399541;

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id =16399541);

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id =16399541)) and studentid= 738699;

COMMIT;