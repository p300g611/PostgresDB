begin;
--ssid:2829776402-ELA,inactive stage 2

update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #129258', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17422755) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17422755)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17422755)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #129258', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16195061)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16195061) ;

--SSID:2829776402,4287967135,1531345794,9505881479,7852485103,9690246615,3786991146,9715262449--Math.
update studentstests
set    activeflag =false,
      manualupdatereason ='as for ticket #129258', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17414253,17416319,17414318,17415332,17414286,17414273,17415339,17415348) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17414253,17416319,17414318,17415332,17414286,17414273,17415339,17415348)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17414253,17416319,17414318,17415332,17414286,17414273,17415339,17415348)  and activeflag is true ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #129258', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15687790,15938652,15687947,15717479,15687863,15687831,15717612,15717674)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15687790,15938652,15687947,15717479,15687863,15687831,15717612,15717674) ;

COMMIT;





