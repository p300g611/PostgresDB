5162935379
4183760119
1346687196
6694864876
1897264127
4417385114
9846148402
9373209906
7683186171
6377129378

select distinct st.id stid,stg.name,status,st.activeflag,ts.name,sts.statusid,e.id eid,st.enrollmentid,e.activeflag,ts.id tsid,st.studentid,tc.contentareaid caid from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.statestudentidentifier='5162935379'
--and tc.contentareaid=441
order by enrollmentid,stg.name,tc.contentareaid;


select distinct st.id stid,stg.name,st.enrollmentid s_eid,ts.id tsid,st.status,st.activeflag stflag,tc.contentareaid sub,ts.name,sts.statusid,e.id eid
,e.activeflag eflag,st.studentid
 from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.statestudentidentifier='6377129378'
--and tc.contentareaid=440
order by tc.contentareaid,stg.name,st.enrollmentid;

begin;
--SSID:5162935379 sid:720343
--ELA 
update studentstests
set    enrollmentid =3412774, 
       testsessionid=5876624,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20932966 and studentid=720343 and activeflag =true and status=86 ;


update studentstests
set    enrollmentid =3412774, 
       testsessionid=6451720,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22219586 and studentid=720343 and activeflag =true and status=86; 

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535348,22535347) and studentid=720343 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535348,22535347) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22535348,22535347) and studentid =720343 and activeflag =true ;


--ss

update studentstests
set    enrollmentid =3412774, 
       testsessionid=5817352,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20250688 and studentid=720343 and activeflag =true and status=86 ;


update studentstests
set    enrollmentid =3412774, 
       testsessionid=5817353,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20250692 and studentid=720343 and activeflag =true and status=86 ;

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535243,22535244) and studentid=720343 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535243,22535244) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22535243,22535244) and studentid =720343 and activeflag =true ;

commit;


---SSID: 4183760119

begin;

--ELA 
update studentstests
set    enrollmentid =3412769, 
       testsessionid=5878680,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20937915 and studentid=409033 and activeflag =true and status=86; 


update studentstests
set    enrollmentid =3412769, 
       testsessionid=6314677,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21895084 and studentid=409033 and activeflag =true and status=86 ;

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535340,22535339) and studentid=409033 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535340,22535339) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22535340,22535339) and studentid =409033 and activeflag =true ;

--math

update studentstests
set    enrollmentid =3412769, 
       testsessionid=5825048,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20638270 and studentid=409033 and activeflag =true and status=86; 




update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535293) and studentid=409033 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535293) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22535293) and studentid =409033 and activeflag =true ;




--ssid:1346687196 student 1419479

--math 
update studentstests
set    enrollmentid =3412770, 
       testsessionid=5822722,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21725761 and studentid=1419479 and activeflag =true and status=86 ;


update studentstests
set    enrollmentid =3412770, 
       testsessionid=6498861,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22252473 and studentid=1419479 and activeflag =true and status=86 ;

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535307,22535306) and studentid=1419479 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535307,22535306) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22535307,22535306) and studentid =1419479 and activeflag =true ;

commit;

--ssid:6694864876 student 1393389
--math
update studentstests
set    enrollmentid =3412776, 
       testsessionid=5822745,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20630987 and studentid=1393389 and activeflag =true and status=86 ;


update studentstests
set    enrollmentid =3412776, 
       testsessionid=6504661,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22297884 and studentid=1393389 and activeflag =true and status=86 ;

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535338,22535337) and studentid=1393389 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535338,22535337) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22535338,22535337) and studentid =1393389 and activeflag =true ;

--ssid:1897264127  student 1419381
--ELA

update studentstests
 set      enrollmentid =3412771,
       testsessionid=5876555,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20930636 and studentid=1419381 and activeflag =true and status=86; 


update studentstests
 set      enrollmentid =3412771,
       testsessionid=6361100,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22152428 and studentid=1419381 and activeflag =true and status=86;


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535327,22535326) and studentid=1419381 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535327,22535326) and activeflag =true  ;

--math 
update studentstests
set    enrollmentid =3412771, 
       testsessionid=5822721,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20628789 and studentid=1419381 and activeflag =true and status=86 ;


update studentstests
set    enrollmentid =3412771, 
       testsessionid=6391521,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22265804 and studentid=1419381 and activeflag =true and status=86; 

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535309,22535308) and studentid=1419381 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535309,22535308) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (22535309,22535308) and studentid =1419381 and activeflag =true ;

--SSID:6377129378 sid:76865
begin;

--ELA

update studentstests
set    enrollmentid =3412775, 
       testsessionid=5876610,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20938067 and studentid=76865 and activeflag =true and status=86 ;



update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535342) and studentid=76865 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535342) and activeflag =true  ;

--SSID:7683186171 sid:318977
--ELA

update studentstests
 set      enrollmentid =3412778,
       testsessionid=5876618,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21156450 and studentid=318977 and activeflag =true and status=86 ;


update studentstests
set       enrollmentid =3412778,
       testsessionid=6489016,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22307840 and studentid=318977 and activeflag =true and status=86;


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535321,22535320) and studentid=318977 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535321,22535320) and activeflag =true  ;

--Sci
update studentstests
 set      enrollmentid =3412778,
       testsessionid=5817450,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20605988 and studentid=318977 and activeflag =true and status=86 ;


update studentstests
set       enrollmentid =3412778,
       testsessionid=5817451,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20605991 and studentid=318977 and activeflag =true and status=86;


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535253,22535254) and studentid=318977 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535253,22535254) and activeflag =true  ;

--ss
update studentstests
set       enrollmentid =3412778,
       testsessionid=5817378,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20573074 and studentid=318977 and activeflag =true and status=86 ;


update studentstests
 set      enrollmentid =3412778,
       testsessionid=5817379,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20573078 and studentid=318977 and activeflag =true and status=86;


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535232,22535231) and studentid=318977 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535232,22535231) and activeflag =true  ;

--SSID:9373209906 sid:1170578
--ELA

update studentstests
set       enrollmentid =3412779,
       testsessionid=5876587,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20932650 and studentid=1170578 and activeflag =true and status=86 ;


update studentstests
set       enrollmentid =3412779,
       testsessionid=6302546,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21878109 and studentid=1170578 and activeflag =true and status=86;


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535350,22535349) and studentid=1170578 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535350,22535349) and activeflag =true  ;

--SSID:9846148402 sid:316226
--sci
update studentstests
 set      enrollmentid =3412780,
       testsessionid=5817452,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20256206 and studentid=316226 and activeflag =true and status=86 ;


update studentstests
 set      enrollmentid =3412780,
       testsessionid=5817453,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20256210 and studentid=316226 and activeflag =true and status=86;


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535255,22535256) and studentid=316226 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535255,22535256) and activeflag =true  ;

--ss
update studentstests
 set      enrollmentid =3412780,
       testsessionid=5817382,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20251687 and studentid=316226 and activeflag =true and status=86 ;


update studentstests
set       enrollmentid =3412780,
       testsessionid=5817383,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20251689 and studentid=316226 and activeflag =true and status=86;


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535234,22535233) and studentid=316226 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535234,22535233) and activeflag =true  ;


--SSID:4417385114
--ELA

update studentstests
 set      enrollmentid =3412773,
       testsessionid=5876626,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =20932638 and studentid=721729 and activeflag =true and status=86 ;


update studentstests
 set      enrollmentid =3412773,
       testsessionid=6453854,
       modifieddate=now(),
       manualupdatereason ='as for ticket #406759', 
       modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =22365839 and studentid=721729 and activeflag =true and status=86;


update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #406759', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (22535346,22535345) and studentid=721729 and activeflag =true and status=84;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (22535346,22535345) and activeflag =true ;


commit;