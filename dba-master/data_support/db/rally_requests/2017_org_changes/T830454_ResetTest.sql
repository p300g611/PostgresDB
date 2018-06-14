begin;
--ssid:9272923638,2442390787,6695817545,2832719732-KAP ELA,inactive stage 2

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17347082,17347057,17343015,17346203) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17347082,17347057,17343015,17346203)    ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1157696    and studentstestsid =17347082  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1157707    and studentstestsid =17347057  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1157714    and studentstestsid =17343015  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1157660    and studentstestsid =17346203  ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id in (15922617,15916951,15828518,15922565)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15922617,15916951,15828518,15922565)  ;




COMMIT;

