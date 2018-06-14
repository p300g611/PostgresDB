

BEGIN;

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (17314190,
17317422,
17317429,
17317441,
17317447,
17314228,
17317456,
17317464,
17317480,
17317487,
17317497,
17317502,
17365721,
17314253,
17317511,
17314269,
17317520,
17319839,
17317529,
17317537,
17317548,
17317565,
17314294,
17317571,
17314302,
17057016,
17196783
);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17314190,
17317422,
17317429,
17317441,
17317447,
17314228,
17317456,
17317464,
17317480,
17317487,
17317497,
17317502,
17365721,
17314253,
17317511,
17314269,
17317520,
17319839,
17317529,
17317537,
17317548,
17317565,
17314294,
17317571,
17314302,
17057016,
17196783
);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where  studentstestsid IN (17314190,
17317422,
17317429,
17317441,
17317447,
17314228,
17317456,
17317464,
17317480,
17317487,
17317497,
17317502,
17365721,
17314253,
17317511,
17314269,
17317520,
17319839,
17317529,
17317537,
17317548,
17317565,
17314294,
17317571,
17314302,
17057016,
17196783
);

-- set stage 1 to in process
update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id in (16035397,
16035418,
16035449,
16035488,
16035564,
16035583,
16035648,
16035822,
16035840,
16035847,
16035974,
16035994,
16036029,
16036042,
16036063,
16036155,
16036254,
16036329,
16036359,
16036399,
16036406,
16036512,
16036574,
16036688,
16036695,
15733425,
16049470
);


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16035397,
16035418,
16035449,
16035488,
16035564,
16035583,
16035648,
16035822,
16035840,
16035847,
16035974,
16035994,
16036029,
16036042,
16036063,
16036155,
16036254,
16036329,
16036359,
16036399,
16036406,
16036512,
16036574,
16036688,
16036695,
15733425,
16049470
);
--ssid:6413390158,9685317739 --ELA

-inactive stage 2 and stage 1
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id =17311598;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =17311598  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 53239    and studentstestsid =17311598 ;



--set stage 1 status to in process

update studentstests
set    status =85,
       enddatetime=null,
      modifieddate=now(),
	  modifieduser =174744
where id =16035475 ;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid =16035475 ;

commit;
