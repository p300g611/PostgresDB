begin;
--ssid:4781325882 -ela and math inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #182052', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17872380,17697375) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17872380,17697375)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17872380,17697375)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #182052', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15941789,15988339)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15941789,15988339)  ;

--update stage 1 to complete and deactive. so reset stage 1 

update studentstests
set    status =86,
       activeflag =false,
       enddatetime=now(),
	   manualupdatereason ='as for ticket #182052', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15941789,15988339)  ;


update studentstestsections
set    statusid =127,
      activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15941789,15988339)  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (15941789,15988339)  and activeflag is true ;

commit;