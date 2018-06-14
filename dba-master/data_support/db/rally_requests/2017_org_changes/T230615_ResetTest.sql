begin;
--ssid:7125905260  sid:1357317 ELA  test:SP ELA 3.1.C PP 4469 
--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #230615', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17258794)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17258794) ;

commit;


