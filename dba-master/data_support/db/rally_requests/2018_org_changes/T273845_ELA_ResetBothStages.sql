/*Ticket #273845
ELA Grade 3
7417167314
Stage 1 - reset
Stage 2 - reset
*/

select * from student where statestudentidentifier='7417167314' -->> id=1468259
---------------------------------------------------------
SELECT    distinct stu.statestudentidentifier ssid,
       stu.id stuid,
           en.activeflag as enflag,
    gc.abbreviatedname egrade,
           st.id AS stid,
           st.activeflag as stflag,
           st.manualupdatereason,
       tgc.abbreviatedname tgrade,
    ts.activeflag as tsflag,
          sts.id stsid,
          t.testname,
          ts.name,
    sts.activeflag stsflag,
    tca.categorycode stsstatus,
           c.categorycode as status,
           ca.abbreviatedname AS sub
       ,sr.activeflag srflag
     ,iti.id itiid
      ,iti.activeflag itiflag
   ,iti.testcollectionname
     ,strb.id strbid,strb.activeflag strbflag
     ,str.id strid,str.status strstatu
     FROM studentstests st
     JOIN enrollment en ON en.id = st.enrollmentid
  join gradecourse gc on gc.id =en.currentgradelevel
     JOIN testcollection tc ON tc.id = st.testcollectionid
  JOIN test t on t.id =st.testid
  left outer join   gradecourse tgc on tgc.id =t.gradecourseid
     JOIN organization attsch ON attsch.id = en.attendanceschoolid
     JOIN contentarea ca ON ca.id = tc.contentareaid
     JOIN student stu ON stu.id = en.studentid
     JOIN testsession ts ON ts.id = st.testsessionid
  join studentstestsections sts on sts.studentstestid =st.id
  join category tca on tca.id=sts.statusid
     JOIN category c ON c.id = st.status
  left outer join studentsresponses sr on sr.studentid =stu.id and sr.studentstestsid=st.id
     left outer join ititestsessionhistory iti on iti.studentid =stu.id and iti.testsessionid=ts.id
     left outer join studenttrackerband strb on  strb.testsessionid = ts.id
     left outer join studenttracker str on str.id =strb.studenttrackerid and str.studentid=stu.id
  where stu.statestudentidentifier='7417167314' and en.currentschoolyear=2018
-------------------------stid from above i sused in the update statements below



begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='for ticket #273845', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id in (21142949,22627243) and studentid=1468259 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid in (21142949,22627243) and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  in (21142949,22627243) and studentid =1468259 and activeflag =true ;

COMMIT;

