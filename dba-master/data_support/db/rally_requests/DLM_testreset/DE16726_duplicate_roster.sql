/*
select er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,er.modifieddate,r.coursesectionname,
 statesubjectareaid,teacherid,e.attendanceschoolid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=2018
inner join roster r on r.id=er.rosterid
where studentid=1398743
order by statesubjectareaid,er.activeflag;

select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,st.id ,ts.source,st.status
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
where studentid =1398743 order by contentareaid,enrollmentid,rosterid;

*/

--studentid = 165063

--M
update testsession
set rosterid=1166878,attendanceschoolid=1372,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select testsessionid from ititestsessionhistory where studentid=165063 and rosterid in (1165485));
--ELA
update testsession
set rosterid=1166877,attendanceschoolid=1372,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select testsessionid from ititestsessionhistory where studentid=165063 and rosterid in (1165484));
--M
update studentstests
set enrollmentid=3151221,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from ititestsessionhistory where studentid=165063 and rosterid in (1165485));
--ELA
update studentstests
set enrollmentid=3151221,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from ititestsessionhistory where studentid=165063 and rosterid in (1165484));

--M
update ititestsessionhistory
set rosterid=1166878, studentenrlrosterid=16008743,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select id from ititestsessionhistory where studentid=165063 and rosterid in (1165485));
--ELA
update ititestsessionhistory
set rosterid=1166877, studentenrlrosterid=16008742,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select id from ititestsessionhistory where studentid=165063 and rosterid in (1165484));

--studentid = 1216302

--M
update testsession
set rosterid=1186421,attendanceschoolid=82795,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select testsessionid from ititestsessionhistory where studentid=1216302 and rosterid in (1173106));
--ELA
update testsession
set rosterid=1186420,attendanceschoolid=82795,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select testsessionid from ititestsessionhistory where studentid=1216302 and rosterid in (1173101));
--M
update studentstests
set enrollmentid=3180118,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from ititestsessionhistory where studentid=1216302 and rosterid in (1173106));
--ELA
update studentstests
set enrollmentid=3180118,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from ititestsessionhistory where studentid=1216302 and rosterid in (1173101));
--M
update ititestsessionhistory
set rosterid=1186421, studentenrlrosterid=16052649,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select id from ititestsessionhistory where studentid=1216302 and rosterid in (1173106));
--ELA
update ititestsessionhistory
set rosterid=1186420, studentenrlrosterid=16052644,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select id from ititestsessionhistory where studentid=1216302 and rosterid in (1173101));

--studentid = 853439

--M
update testsession
set rosterid=1164617,attendanceschoolid=21343,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select testsessionid from ititestsessionhistory where studentid=853439 and rosterid in (1163373));
--ELA
update testsession
set rosterid=1164618,attendanceschoolid=21343,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select testsessionid from ititestsessionhistory where studentid=853439 and rosterid in (1163374));
--M
update studentstests
set enrollmentid=3163264,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where testsesionid in (select testsessionid from ititestsessionhistory where studentid=853439 and rosterid in (1163373));
--ELA
update studentstests
set enrollmentid=3163264,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from ititestsessionhistory where studentid=853439 and rosterid in (1163374));
--M
update ititestsessionhistory
set rosterid=1164617, studentenrlrosterid=16032032,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select id from ititestsessionhistory where studentid=853439 and rosterid in (1163373));
--ELA
update ititestsessionhistory
set rosterid=1164618, studentenrlrosterid=16032031,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select id from ititestsessionhistory where studentid=853439 and rosterid in (1163374));


--studentid = 1398743 (one test in unused status other in completed status)


--ELA
update testsession
set rosterid=1202579,attendanceschoolid=2425,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select testsessionid from ititestsessionhistory where studentid=1398743 and rosterid in (1172823));

--ELA
update studentstests
set enrollmentid=3187987,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where testsessionid in (select testsessionid from ititestsessionhistory where studentid=1398743 and rosterid in (1172823));

--ELA
update ititestsessionhistory
set rosterid=1202579, studentenrlrosterid=16069661,modifieddate=now(), modifieduser=(select id from aartuser where email ='ats_dba_team@ku.edu')
where id in (select id from ititestsessionhistory where studentid=1398743 and rosterid in (1172823));