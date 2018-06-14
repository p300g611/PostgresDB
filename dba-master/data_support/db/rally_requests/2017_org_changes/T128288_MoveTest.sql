/*
--validate information
statestudentidentifier │ 1910803286 
 select st.studentid, st.id studenttestid,st.status,st.activeflag stflag,t.id testid,t.testname, 
 ts.id testsessionid, ts.name testsessioname,ts.activeflag tsflag,ts.rosterid,iti.rosterid, iti.activeflag itiflag, sts.statusid,sts.activeflag
	
      from studentstests st
      join test t on t.id =st.testid
      join testsession ts on ts.id=st.testsessionid
	  join studentstestsections sts on sts.studentstestid =st.id
	  join ititestsessionhistory iti on iti.testsessionid =ts.id
      where st.enrollmentid = 2417831 and st.status in (477,86) order by t.testname; 
*/
BEGIN;




update studentstests
set    status =84,
       activeflag = true,
       modifieddate=now(),
	   modifieduser=12
where id in (14485110,14485120,14476001,14485122,14485127,14485136,14485134,14485129,14485131,14485125,14485133);


update testsession 
set    activeflag = true,
	   modifieddate=now(),
	   modifieduser=12
where id in (select testsessionid from studentstests where id in(14485110,14485120,14476001,14485122,14485127,14485136,14485134,14485129,14485131,14485125,14485133)); 


update ititestsessionhistory
set    activeflag = true,
       modifieddate =now(),
	   modifieduser=12
where testsessionid in (select testsessionid from studentstests where id in(14485110,14485120,14476001,14485122,14485127,14485136,14485134,14485129,14485131,14485125,14485133));


COMMIT;
       