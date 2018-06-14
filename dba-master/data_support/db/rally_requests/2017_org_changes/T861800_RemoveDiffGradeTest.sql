/*
--backup (T_861800_RemoveTestBackup.csv) before update
select distinct stu.statestudentidentifier ssid, stu.id stuid, en.id enid,egc.abbreviatedname engrade,
st.id stid, st.status ststatus,
ts.id tsid,--ts.name tsname,
sts.id stsid, sts.activeflag stsflag,
sr.activeflag srflag,
t.id testid, tgc.abbreviatedname tgrade,
iti.id itiid, iti.activeflag itiflag,
strb.id strbid, strb.activeflag strbflag,
str.id strid,  str.status strstatus

from student stu
join enrollment en on en.studentid = stu.id
join gradecourse egc on egc.id=en.currentgradelevel
join studentstests st on st.enrollmentid=en.id
join testsession ts on ts.id=st.testsessionid
join studentstestsections sts on sts.studentstestid=st.id
join test t on t.id =st.testid
join gradecourse tgc on tgc.id=t.gradecourseid
left outer join studentsresponses sr on sr.studentid =stu.id and sr.studentstestsid=st.id
left outer join ititestsessionhistory iti on iti.studentid =stu.id and iti.testsessionid=ts.id
left outer join studenttrackerband strb on  strb.testsessionid = ts.id
left outer join studenttracker str on str.id =strb.studenttrackerid and str.studentid=stu.id
where stu.activeflag is true and en.activeflag is true and egc.abbreviatedname<>tgc.abbreviatedname and tgc.abbreviatedname<>'OTH'
and stu.statestudentidentifier ='9244798646'
order by egc.abbreviatedname, tgc.abbreviatedname

*/
BEGIN;

--SSID:1001153745

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16382785,16382106);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16382785,16382106);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16382785,16382106));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (372744,380818);



--SSID:1001873315

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16395917,16399659);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16395917,16399659);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16395917,16399659));



update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1042839 and studentstestsid in (16395917,16399659);

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  id in (2180140,2189007);

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where id in (2180140,2189007));  
  
--SSID:1001954316

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16370392,16369600);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16370392,16369600);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16370392,16369600));

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  id in (2177455,2166338);

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where id in (2177455,2166338)); 

--SSID:1002023866
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16405847,16405809);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16405847,16405809);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16405847,16405809));

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16405847,16405809));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16405847,16405809))); 


--SSID:1002077047
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16402726,16402685);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16402726,16402685);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16402726,16402685));

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16402726,16402685));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16402726,16402685))); 

--SSID:1002263567

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16405843,16405805);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16405843,16405805);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16405843,16405805));

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16405843,16405805));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16405843,16405805))); 
--SSID:1002429332

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16394882,16390808);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16394882,16390808);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16394882,16390808));

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16394882,16390808));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16394882,16390808))); 

--SSID:1002438114
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16382745,16382060);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16382745,16382060);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16382745,16382060));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1315549 and studentstestsid in (16382745,16382060);

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16382745,16382060));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16382745,16382060))); 

--SSID:1002552113
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16382759,16382077);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16382759,16382077);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16382759,16382077));

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16382759,16382077));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16382759,16382077))); 

--SSID:1002694375
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16376371,16375483);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16376371,16375483);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16376371,16375483));

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16376371,16375483));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16376371,16375483))); 

--SSID:1002697893

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (16373148,16372364);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (16373148,16372364);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (16373148,16372364));

update studenttrackerband
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744 
where  testsessionid in (select testsessionid from studentstests where id in (16373148,16372364));

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (select studenttrackerid from studenttrackerband where testsessionid in (select testsessionid from studentstests where id in (16373148,16372364))); 

--SSID:1453069321
update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (15503619,15503712,15503714,15503715,15503717,15503720,15503721,15503722,15503726,15503730,15503735);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (15503619,15503712,15503714,15503715,15503717,15503720,15503721,15503722,15503726,15503730,15503735);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (15503619,15503712,15503714,15503715,15503717,15503720,15503721,15503722,15503726,15503730,15503735));

update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 853299 and studentstestsid in (15503619,15503712,15503714,15503715,15503717,15503720,15503721,15503722,15503726,15503730,15503735);

update ititestsessionhistory
set   activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 853299 and testsessionid in (select testsessionid from studentstests where id in (15503619,15503712,15503714,15503715,15503717,15503720,15503721,15503722,15503726,15503730,15503735));


--9096924672

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in ( 14492751,
 14492753,
 14492755,
 14492759,
 14492765,
 14492767,
 14492773,
 14492775,
 14777958,
 14777960,
 14777962,
 14777977,
 14777993,
 14778004,
 14778005,
 14778006,
 14778008,
 15481896);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in ( 14492751,
 14492753,
 14492755,
 14492759,
 14492765,
 14492767,
 14492773,
 14492775,
 14777958,
 14777960,
 14777962,
 14777977,
 14777993,
 14778004,
 14778005,
 14778006,
 14778008,
 15481896);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in ( 14492751,
 14492753,
 14492755,
 14492759,
 14492765,
 14492767,
 14492773,
 14492775,
 14777958,
 14777960,
 14777962,
 14777977,
 14777993,
 14778004,
 14778005,
 14778006,
 14778008,
 15481896));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 863508 and studentstestsid in ( 14492751,
 14492753,
 14492755,
 14492759,
 14492765,
 14492767,
 14492773,
 14492775,
 14777958,
 14777960,
 14777962,
 14777977,
 14777993,
 14778004,
 14778005,
 14778006,
 14778008,
 15481896);

update ititestsessionhistory
set   activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 863508 and testsessionid in (select testsessionid from studentstests where id in ( 14492751,
 14492753,
 14492755,
 14492759,
 14492765,
 14492767,
 14492773,
 14492775,
 14777958,
 14777960,
 14777962,
 14777977,
 14777993,
 14778004,
 14778005,
 14778006,
 14778008,
 15481896));
 


 --SSID:9244798646

update studentstests
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id in (14548902,
14548903,
14548904,
14548907,
14548972,
14549254,
14549255,
14549256,
14549257,
14549259,
14549260);


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentstestid in (14548902,
14548903,
14548904,
14548907,
14548972,
14549254,
14549255,
14549256,
14549257,
14549259,
14549260);


update testsession
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where id  in (select testsessionid from studentstests where id in (14548902,
14548903,
14548904,
14548907,
14548972,
14549254,
14549255,
14549256,
14549257,
14549259,
14549260));


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1205469 and studentstestsid in (14548902,
14548903,
14548904,
14548907,
14548972,
14549254,
14549255,
14549256,
14549257,
14549259,
14549260);

update ititestsessionhistory
set   activeflag =false,
      modifieddate=now(),
	  modifieduser =174744
where studentid = 1205469 and testsessionid in (select testsessionid from studentstests where id in (14548902,
14548903,
14548904,
14548907,
14548972,
14549254,
14549255,
14549256,
14549257,
14549259,
14549260));


