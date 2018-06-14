SELECT distinct stu.statestudentidentifier ssid,
stu.id stuid,
en.id enid,
en.activeflag as enflag,
gc.abbreviatedname egrade,
attsch.organizationname school,
st.id AS stid,
st.activeflag as stflag,
st.createddate,
st.modifieddate,
st.enddatetime,
st.modifieduser,
t.id as testid,
ts.id tsid,
ts.name tsname,
tgc.abbreviatedname tgrade,
t.testname,
ts.rosterid,
ts.activeflag as tsflag,
sts.id stsid,
sts.activeflag stsflag,
tca.categorycode stsstatus,
c.categorycode as status,
ca.abbreviatedname AS sub,
sr.activeflag srflag,
iti.id itiid,
iti.activeflag itiflag,
strb.id strbid,strb.activeflag strbflag,
str.id strid,str.status strstatu
FROM studentstests st
INNER JOIN enrollment en ON en.id = st.enrollmentid
INNER JOIN gradecourse gc on gc.id =en.currentgradelevel
INNER JOIN testcollection tc ON tc.id = st.testcollectionid
INNER JOIN test t on t.id =st.testid
INNER JOIN gradecourse tgc on tgc.id =t.gradecourseid
INNER JOIN organization attsch ON attsch.id = en.attendanceschoolid
INNER JOIN organization aypsch ON aypsch.id = en.aypschoolid
INNER JOIN contentarea ca ON ca.id = tc.contentareaid
INNER JOIN student stu ON stu.id = en.studentid
INNER JOIN testsession ts ON ts.id = st.testsessionid
INNER JOIN studentstestsections sts on sts.studentstestid =st.id
INNER JOIN category tca on tca.id=sts.statusid
INNER JOIN category c ON c.id = st.status
left outer join studentsresponses sr on sr.studentid =stu.id and sr.studentstestsid=st.id
left outer join ititestsessionhistory iti on iti.studentid =stu.id and iti.testsessionid=ts.id
left outer join studenttrackerband strb on  strb.testsessionid = ts.id
left outer join studenttracker str on str.id =strb.studenttrackerid and str.studentid=stu.id
where stu.statestudentidentifier in ('473962765');