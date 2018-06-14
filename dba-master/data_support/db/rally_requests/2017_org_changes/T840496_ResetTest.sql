BEGIN;

-SSID:8072894773 Reset test: ELA
begin;

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #840496', 
      modifieddate=now(),
	  modifieduser =174744
where id in (18166990 );


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (18166990 );


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (18166990 )  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #840496', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15731675)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15731675 ) ;




COMMIT;