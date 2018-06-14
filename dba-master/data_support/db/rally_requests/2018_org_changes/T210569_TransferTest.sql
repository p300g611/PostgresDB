--ssid:8236689956 sid:503631 
begin;
update student 
set legallastname='Rochat',
       modifieddate=now(),
 	   modifieduser=174744
where id =503631;     


update enrollment 
set  activeflag =true,
     modifieddate=now(),
	 modifieduser=174744,
	 notes ='active for ticket#210569'
	 where id = 3126785;

update enrollmentsrosters 
set    activeflag =true,
       modifieddate=now(),
 	   modifieduser=174744
where id in (15983794,15983793);  


update studentstests
set   enrollmentid =3126785, 
     modifieddate=now(),
	 modifieduser=174744,
	 manualupdatereason ='for ticket#210569'
	 where studentid=503631 and enrollmentid =3406949;


update studentstests
set   testsessionid = 5824661,
      modifieddate=now(),
	  modifieduser=174744
 where id =21504660;
 
 
update studentstests
set   testsessionid = 6132047,
      modifieddate=now(),
	  modifieduser=174744
 where id =21512482;

 
update studentstests
set   testsessionid = 5878568,
      modifieddate=now(),
	  modifieduser=174744
 where id =21504974;
 
 
update studentstests
set   testsessionid = 6150572,
      modifieddate=now(),
	  modifieduser=174744
 where id =21541132;
 
commit;
 
 

SELECT    distinct stu.statestudentidentifier ssid,stu.id stuid,en.id enid,en.activeflag as enflag,
st.id AS stid,st.activeflag as stflag,ts.id tsid,ts.name tsname,
ts.activeflag as tsflag,sts.id stsid,sts.activeflag stsflag,tca.categorycode stsstatus,c.categorycode as status,
ca.abbreviatedname AS sub,sr.activeflag srflag


FROM studentstests st
JOIN enrollment en ON en.id = st.enrollmentid
join gradecourse gc on gc.id =en.currentgradelevel
JOIN testcollection tc ON tc.id = st.testcollectionid
left outer join gradeband gb on gb.id=gradebandid
JOIN test t on t.id =st.testid
left outer join   gradecourse tgc on tgc.id =t.gradecourseid
JOIN organization attsch ON attsch.id = en.attendanceschoolid
JOIN contentarea ca ON ca.id = tc.contentareaid
JOIN student stu ON stu.id = en.studentid
JOIN testsession ts ON ts.id = st.testsessionid
left outer join gradecourse tsgc on tsgc.id =ts.gradecourseid 
join studentstestsections sts on sts.studentstestid =st.id
join category tca on tca.id=sts.statusid
JOIN category c ON c.id = st.status
left outer join studentsresponses sr on sr.studentid =stu.id and sr.studentstestsid=st.id
left outer join ititestsessionhistory iti on iti.studentid =stu.id and iti.testsessionid=ts.id
left outer join studenttrackerband strb on  strb.testsessionid = ts.id
left outer join studenttracker str on str.id =strb.studenttrackerid and str.studentid=stu.id
left outer join scoringassignmentstudent scs on scs.studentid=st.studentid and scs.studentstestsid=st.id
left outer join studentstestscore stsc on stsc.studenttestid=st.id	 
--where stu.statestudentidentifier='9684769725' and en.currentschoolyear=2018
where stu.id=503631   and en.currentschoolyear=2018


─
┬─────────────────────┬─────────────────────┬─────┬────────┐
│    ssid    │ stuid  │  enid   │ enflag │   stid   │ stflag │  tsid   │                         tsname                         │ tsflag │  stsid   │ stsflag
│      stsstatus      │       status        │ sub │ srflag │
├────────────┼────────┼─────────┼────────┼──────────┼────────┼─────────┼────────────────────────────────────────────────────────┼────────┼──────────┼─────────
┼─────────────────────┼─────────────────────┼─────┼────────┤
│ 8236689956 │ 503631 │ 3126785 │ f      │ 19246941 │ t      │ 5671136 │ Predictive_December_7177_Grade 4_English Language Arts │ t      │ 30326662 │ t
│ unused              │ unused              │ ELA │ NULL   │
│ 8236689956 │ 503631 │ 3126785 │ f      │ 19333075 │ t      │ 5672811 │ Predictive_December_7177_Grade 4_Mathematics           │ t      │ 30414702 │ t
│ unused              │ unused              │ M   │ NULL   │
│ 8236689956 │ 503631 │ 3126785 │ f      │ 19918204 │ t      │ 5776006 │ Predictive_February_7177_Grade 4_Mathematics           │ t      │ 31063679 │ t
│ unused              │ unused              │ M   │ NULL   │
│ 8236689956 │ 503631 │ 3126785 │ f      │ 19918811 │ t      │ 5776015 │ Predictive_February_7177_Grade 4_English Language Arts │ t      │ 31064344 │ t
│ unused              │ unused              │ ELA │ NULL   │
│ 8236689956 │ 503631 │ 3126785 │ f      │ 20725956 │ f      │ 5824661 │ 2018_7177_Grade 4_Mathematics_Stage 1                  │ t      │ 32039106 │ f
│ exitclearunenrolled │ exitclearunenrolled │ M   │ NULL   │
│ 8236689956 │ 503631 │ 3126785 │ f      │ 21032092 │ f      │ 5878568 │ 2018_7177_Grade 4_English Language Arts_Stage 1        │ t      │ 32422822 │ f
│ exitclearunenrolled │ exitclearunenrolled │ ELA │ NULL   │
│ 8236689956 │ 503631 │ 3406949 │ f      │ 21504660 │ t      │ 5823924 │ 2018_5936_Grade 4_Mathematics_Stage 1                  │ t      │ 33067146 │ t
│ complete            │ complete            │ M   │ t      │
│ 8236689956 │ 503631 │ 3406949 │ f      │ 21504974 │ t      │ 5877866 │ 2018_5936_Grade 4_English Language Arts_Stage 1        │ t      │ 33067474 │ t
│ complete            │ complete            │ ELA │ t      │
│ 8236689956 │ 503631 │ 3406949 │ f      │ 21512482 │ t      │ 6131267 │ 2018_5936_Grade 4_Mathematics_Stage 2                  │ t      │ 33078125 │ t
│ complete            │ complete            │ M   │ t      │
│ 8236689956 │ 503631 │ 3406949 │ f      │ 21541132 │ t      │ 6150573 │ 2018_5936_Grade 4_English Language Arts_Stage 2        │ t      │ 33112736 │ t
│ complete            │ complete            │ ELA │ t   