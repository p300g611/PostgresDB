select distinct
st.studentid,
 st.id studenttestid,st.status ststatus,st.activeflag stflag,
ts.id testsessionid,ts.name, ts.activeflag tsflag,
sas.id scorstuid,sas.activeflag sasflag,stc.id stscoreid, stc.score, stc.activeflag
FROM studentstests st
JOIN testsession ts ON ts.id = st.testsessionid
JOIN testcollection tc ON tc.id = st.testcollectionid
JOIN test t on t.id =st.testid
JOIN studentstestsections sts on sts.studentstestid=st.id
left outer join scoringassignmentstudent sas on sas.studentstestsid = st.id and sas.studentid=st.studentid
left outer join scoringassignment sg on sg.testsessionid=ts.id
left outer join studentstestscore stc on stc.studenttestid=st.id 
where st.studentid = 530676 and st.id in (19598568,20172736);


--deactive kelpa  original score. ssid: 8956415358. test:speaking  
begin;
update scoringassignmentstudent
set   activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
	   where id in (318739,387200) and activeflag is true;
	   
update studentstestscore
set   activeflag =false,
       modifieddate=now(),
	   modifieduser=(select id from aartuser where email='ats_dba_team@ku.edu')
	   where id in (1302976,1347919) and activeflag is true;
	   
commit;
