BEGIN;

BEGIN;
/*
--ssid:9486218242
1962784789
4430647224
5766281706
5806313158
6285878358
6368313005
7720102673
7782570735
7004231216
5726727673  --10th ELA stage 1 and stage 2
*/
--inactive stage 1 and stage 2
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (15877344,17151813,15877336,17151810,15916409,17142862,
15877391,17142860,15877292,17151808,15877364,17142858,15877264,17142852,15877301,17142856,15916399,17151822,15877400,17152652,15877408,17151816)  ;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in  (15877344,17151813,15877336,17151810,15916409,17142862,
15877391,17142860,15877292,17151808,15877364,17142858,15877264,17142852,15877301,17142856,15916399,17151822,15877400,17152652,15877408,17151816) ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 725912      and studentstestsid in (15877344,17151813)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 725953      and studentstestsid in (15877336,17151810)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 909825      and studentstestsid in (15916409,17142862)  ;



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 725967      and studentstestsid in (15877391,17142860)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 725968      and studentstestsid in (15877292,17151808)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 725980      and studentstestsid in (15877364,17142858)  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 725981      and studentstestsid in (15877264,17142852)  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 772576      and studentstestsid in (15877301,17142856)  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 726003      and studentstestsid in (15916399,17151822)  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 726004      and studentstestsid in (15877400,17152652)  ;

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 572539      and studentstestsid in (15877408,17151816)  ;
COMMIT;

