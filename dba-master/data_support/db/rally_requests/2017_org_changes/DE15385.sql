 /*
 select distinct stu.statestudentidentifier ssid, stu.id stuid, en.id enid, en.activeflag enflag, egc.abbreviatedname engrade,
-- ett.id ettid, 
 --sb.subjectareacode ettsubject, 
st.id stid,
  st.status ststatus, st.activeflag stflag,
  sts.id stsid, sts.activeflag stsflag,
 -- ts.id tsid,
   ts.name tsname,
-- t.id testid,
 tgc.abbreviatedname testgrade, 
 tca.abbreviatedname testsubject

 from student stu
 join enrollment en on en.studentid=stu.id
 join gradecourse egc on egc.id=en.currentgradelevel
 join studentstests st on st.enrollmentid =en.id 
 join studentstestsections sts on sts.studentstestid=st.id
 join testsession ts on ts.id =st.testsessionid
 join test t on t.id=st.testid
 join gradecourse tgc on tgc.id=t.gradecourseid
 join contentarea tca on tca.id =t.contentareaid
where stu.statestudentidentifier ='1764363663' 
order by tca.abbreviatedname; 
---
 select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,--ts.name,
 attendanceschoolid schoolid,contentareaid,st.activeflag,st.id ,ts.source,ts.name,
 row_number() over(partition by contentareaid,st.studentid,st.testid order by st.status desc,ts.rosterid desc) row_num
 from studentstests st 
 inner join student stu on stu.id =st.studentid
 inner join testsession ts on ts.id=st.testsessionid
 inner join testcollection tc on tc.id=ts.testcollectionid
 where stu.statestudentidentifier='1764363663' 
 and st.activeflag is true
 order by contentareaid,st.studentid,st.testid;
*/
BEGIN;
--all tests are unused. 
--SSID:1764363663

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	   manualupdatereason='As for DE15385,inactive different test grade', 
	   modifieduser=174744
where id in (16307579,16010811);

update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (16307579,16010811);

--SSID:4143314134

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	   manualupdatereason='As for DE15385,inactive different test grade',
	   modifieduser=174744
where id in (16199328,16199323);

update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (16199328,16199323);

--SSID:9665175211
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	   manualupdatereason='As for DE15385,inactive different test grade',
	   modifieduser=174744
where id in (15963992,16297192);

update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (15963992,16297192);


--SSID:4373734828

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	   manualupdatereason='As for DE15385,inactive different test grade',
	   modifieduser=174744
where id in (15856110,16105174);

update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (15856110,16105174);

--SSID:3427788431
update studentstests
set    activeflag =false, 
       manualupdatereason='As for DE15385,inactive different test grade',
       modifieddate=now(),
	   modifieduser=174744
where id in (15954256,16281740);

update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (15954256,16281740);


--SSID:4130511912
update studentstests
set    activeflag =false, 
       manualupdatereason='As for DE15385,inactive different test grade',
       modifieddate=now(),
	   modifieduser=174744
where id in (15954644,16282378);

update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (15954644,16282378);


--SSID:6375665809
update studentstests
set    activeflag =false,
       manualupdatereason='As for DE15385,inactive different test grade', 
       modifieddate=now(),
	   modifieduser=174744
where id in (16329447,16329442);


update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (16329447,16329442);


--SSID:5078540377

update studentstests
set    activeflag =false, 
       manualupdatereason='As for DE15385,inactive different test grade',
       modifieddate=now(),
	   modifieduser=174744
where id in (15954884,16282808);

update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (15954884,16282808);



--SSID:6277917471
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	   manualupdatereason='As for DE15385,inactive different test grade',
	   modifieduser=174744
where id in (15752959,16056652);

update studentstestsections
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =174744
where studentstestid in (15752959,16056652);

commit;
