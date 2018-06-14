BEGIN;


--ssid:9792456236,4567859952,9603095044,3146176793,5812411689,2143658559,deactiviate test assigned different grade 

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17071373,17070474,15749363,16051469,15910330,17405574,16310432,16310435,15945464,17337348,16114899,16114902,16300367,16300364,15749542,16051536) ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17071373,17070474,15749363,16051469,15910330,17405574,16310432,16310435,15945464,17337348,16114899,16114902,16300367,16300364,15749542,16051536);

--ssid:3146176793
update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1091857    and studentstestsid in (15910330,17405574,16310432,16310435,15945464,17337348) ;


--ssid:3146176793
update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1401244    and studentstestsid in (16300367,16300364) ;

--DLM SSID:510035762 
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (15392185,15379412,15379448,15392186,15362087,15362111,15392195,15392191,15379446,15362110,15379440,15362084,15379435,15379443);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15392185,15379412,15379448,15392186,15362087,15362111,15392195,15392191,15379446,15362110,15379440,15362084,15379435,15379443);

update testsession 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where id in (select testsessionid from studentstests where id in (15392185,15379412,15379448,15392186,15362087,15362111,15392195,15392191,15379446,15362110,15379440,15362084,15379435,15379443));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1209330   and studentstestsid in (15392185,15379412,15379448,15392186,15362087,15362111,15392195,15392191,15379446,15362110,15379440,15362084,15379435,15379443);


update ititestsessionhistory
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentid = 1209330 and testsessionid  in (select testsessionid from studentstests where id in (15392185,15379412,15379448,15392186,15362087,15362111,15392195,15392191,15379446,15362110,15379440,15362084,15379435,15379443));


update studenttracker
set    status ='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744	   
where id in (510840,510784);

COMMIT;



