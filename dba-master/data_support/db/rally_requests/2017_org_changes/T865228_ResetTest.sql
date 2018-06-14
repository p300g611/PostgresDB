begin;
/*
--ssid:
7133034808
8293684356
3686908905
4330780631
5475461996
5204117946
2899755617
3779344548
2936368553
3309157725
2149772167
6268950895
9434746698
--  math 
*/

--reset test stage 1
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #865228', 
      modifieddate=now(),
	  modifieduser =174744
where id in (15994193,15993366,15993821,15994116,17000815,15993809,15992586,15993210,15993060,15994239,15991761,15992013,15994463);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15994193,15993366,15993821,15994116,17000815,15993809,15992586,15993210,15993060,15994239,15991761,15992013,15994463);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (15994193,15993366,15993821,15994116,17000815,15993809,15992586,15993210,15993060,15994239,15991761,15992013,15994463)  and activeflag is true ;

--reset stage 2149772167
update studentstests
set    activeflag =false,
       manualupdatereason ='as for ticket #865228', 
      modifieddate=now(),
	  modifieduser =174744
where id in (17997833,17997780,17997818,18000969,17997704,17997815,18004923,18000927,18000909,18000982,17997651,18000846,17997848);

update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (17997833,17997780,17997818,18000969,17997704,17997815,18004923,18000927,18000909,18000982,17997651,18000846,17997848);


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestsid in (17997833,17997780,17997818,18000969,17997704,17997815,18004923,18000927,18000909,18000982,17997651,18000846,17997848)  and activeflag is true ;




commit;