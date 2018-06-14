
BEGIN;

--ssid:2824527986,5242181389，9403387459  reset stage 2-- ELA 

--inactive stage 2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16881920,16956521,17001826)  ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16881920,16956521,17001826)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 524871      and studentstestsid =16881920  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1105431      and studentstestsid =16956521  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1037818      and studentstestsid =17001826  ;

--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id in (15777549,15769760,15774085)  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15777549,15769760,15774085)   ;

--ssid:6731563552 inactive stage 2--math  
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id = 17430764  ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17430764   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1234666      and studentstestsid =17430764  ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =15777146  ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =15777146  ;

--ssid:5441173394,8920490252 inactive stage1 and stage 2--ELA
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id IN (15774981,15777838,17091857,17099792)  ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid IN (15774981,15777838,17091857,17099792)   ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 513405      and studentstestsid IN (15777838,17091857) ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1036899      and studentstestsid IN (15774981,17099792) ;
COMMIT;

