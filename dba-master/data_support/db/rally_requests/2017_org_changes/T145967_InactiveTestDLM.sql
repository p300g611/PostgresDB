BEGIN;
--  ssid:5788443941   inactive test with grade 5
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #145967', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17571848,17558121,17182583,17549663,17516114,17495819,17182661);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17571848,17558121,17182583,17549663,17516114,17495819,17182661);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17571848,17558121,17182583,17549663,17516114,17495819,17182661));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17571848,17558121,17182583,17549663,17516114,17495819,17182661)  and activeflag is true ;


--  ssid:8769182475    inactive test with grade 7


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17628125,17628220,17584914,17633196,17584919,17633201,17630662)  and activeflag is true ;


--  ssid:120047838     inactive test with grade 6

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #145967', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17164582,17164632);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17164582,17164632);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17164582,17164632));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17164582,17164632)  and activeflag is true ;


--  ssid:1018193197      inactive test with grade 5

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #145967', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17768193,17954095,17768170);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17768193,17954095,17768170);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17768193,17954095,17768170));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17768193,17954095,17768170)  and activeflag is true ;

update studenttrackerband
set  activeflag =false, 
      modifieddate=now(),
	  modifieduser=174744
where id in (2807146,2898250,2806410);
	
	
update studenttracker
set    status='UNTRACKED',
       modifieddate=NOW(),
	   modifieduser=174744
where id in (540499,541235);

--ssid:1013623541      inactive test with grade 10

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #145967', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16837424,17963184,17963010,16837382);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16837424,17963184,17963010,16837382);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16837424,17963184,17963010,16837382));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16837424,17963184,17963010,16837382)  and activeflag is true ;

--ssid:1013623665      inactive test with grade 10

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #145967', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17748093,17950997,17950627,17760323,17947761,16837435,17748273,16837392,17759683);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17748093,17950997,17950627,17760323,17947761,16837435,17748273,16837392,17759683);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (17748093,17950997,17950627,17760323,17947761,16837435,17748273,16837392,17759683));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17748093,17950997,17950627,17760323,17947761,16837435,17748273,16837392,17759683)  and activeflag is true ;

update studenttrackerband
set  activeflag =false, 
      modifieddate=now(),
	  modifieduser=174744
where id in (2799444,2896846,2896827,2803400,2895676,2411688,2799506,2410998,2803201);

--ssid:1013623878       inactive test with grade 9

update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #145967', 
      modifieddate=now(),
	  modifieduser =174744
where id in (16837907,17754402,17826084,17826420,17756937,17823981,17829684,17751299,16837869,17828104,18076406,17756910);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16837907,17754402,17826084,17826420,17756937,17823981,17829684,17751299,16837869,17828104,18076406,17756910);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16837907,17754402,17826084,17826420,17756937,17823981,17829684,17751299,16837869,17828104,18076406,17756910));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (16837907,17754402,17826084,17826420,17756937,17823981,17829684,17751299,16837869,17828104,18076406,17756910)  and activeflag is true ;

update studenttrackerband
set  activeflag =false, 
      modifieddate=now(),
	  modifieduser=174744
where id in (2411868,2802061,2831683,2831461,2802590,2830568,2832733,2801000,2411341,2832469,2958777,2802891);
commit;