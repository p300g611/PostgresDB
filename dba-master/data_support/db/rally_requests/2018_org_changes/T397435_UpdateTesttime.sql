select distinct sts.id,statestudentidentifier,sts.startdatetime,st.id stid,st.startdatetime,stg.code
from studentstests st 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join student s on s.id=st.studentid
inner join testsession ts on ts.id=st.testsessionid
inner join studentstestsections sts on sts.studentstestid=st.id
inner join testcollection tc on tc.id=st.testcollectionid
inner join stage stg on stg.id=tc.stageid
where ts.schoolyear=2018 and ts.operationaltestwindowid in (10261) and  tc.contentareaid=440 and stg.code='Stg1'
 and s.statestudentidentifier in
 ('6436471855',
'6949892985',
'3202921509',
'2581326263',
'4357028698',
'8056342907',
'8642185414',
'8399627461',
'5692906007',
'5878771217',
'5595657154'
)order by statestudentidentifier


begin;
--sci '4899700547'
update studentstests
set   startdatetime='2018-04-18 15:28:24.76464+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')    
where id =20548263;	  

--ELA Stage1 '3132176338','9289089032' 
update studentstests
set   startdatetime='2018-04-19 17:11:35.95793+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =20981801;

update studentstests
set   startdatetime='2018-03-27 13:54:37.572301+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =21075302;

--Math 
begin;

update studentstests 
set   startdatetime='2018-03-27 14:49:42.886076+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =20611041;

update studentstests 
set   startdatetime='2018-04-17 15:18:49.072772+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =20618925;


update studentstests 
set   startdatetime='2018-04-17 14:51:55.17403+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =20649226;


update studentstests 
set   startdatetime='2018-04-11 15:06:08.02934+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =20751667;


update studentstests 
set   startdatetime='2018-04-10 13:26:04.797605+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =20754839;


update studentstests 
set   startdatetime='2018-04-19 13:44:41.690253+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =21354304;


update studentstests 
set   startdatetime='2018-04-17 18:03:46.866985+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =21355038;


update studentstests 
set   startdatetime='2018-04-18 17:54:36.15845+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =21654285;


update studentstests 
set   startdatetime='2018-04-04 15:51:25.375222+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =21932659;

update studentstests 
set   startdatetime='2018-04-24 13:45:49.305953+00',
      modifieddate=now(),
      modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu') 
where id =22210846;


3202921509