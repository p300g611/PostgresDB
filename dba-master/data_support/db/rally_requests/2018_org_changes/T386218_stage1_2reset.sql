select distinct st.id stid,stg.name,st.status,st.activeflag,ts.operationaltestwindowid,ts.name,sts.statusid,s.statestudentidentifier
from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10258,10261)  and s.statestudentidentifier in (
'4864896976',
'8426405134',
'2437359141',
'7797501548',
'1169152759',
'3447599162',
'2689322765',
'7341519681',
'1391952138',
'2620852617',
'4133221435',
'4913402145',
'1570155763',
'6697859601',
'1169270263',
'9797914143',
'3834059714',
'4946800387',
'3158362031',
'8590663272',
'7983580134',
'5835424833',
'7522062721',
'9582759984',
'8461164717',
'2581979143',
'6834675973',
'8830783951',
'2990963561',
'7318317865',
'3302272596',
'6863599449',
'2463253738',
'9853034816',
'1852134038',
'1852147369',
'5512584413',
'6410201478',
'6268839609',
'5139935414',
'4244360484',
'9308080538',
'9641477676',
'2819565212',
'6839034704',
'7087359762',
'6130524064',
'7869266736',
'9147577983',
'8435796582',
'5574962268',
'9924913825') and tc.contentareaid=440;


BEGIN;
--stage2
update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #386218', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (select id from tmp_st_math) and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (select id from tmp_st_math) and activeflag =true;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid in (select id from tmp_st_math) and activeflag =true;

COMMIT;
