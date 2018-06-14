begin;
--ssid:3911338597,7386949782 , 1941421709 ,4871441814  math 

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #458006', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17312814,17312771,17312832,17312805);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17312814,17312771,17312832,17312805);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17312814,17312771,17312832,17312805)  and activeflag is true ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #458006', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15922897,15916848,15924578,15921775)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15922897,15916848,15924578,15921775) ;

--SSID:3911338597  ELA

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #458006', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17781779);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17781779);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17781779)  and activeflag is true ;
--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
	   manualupdatereason ='as for ticket #458006', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15886846)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15886846) ;

commit;