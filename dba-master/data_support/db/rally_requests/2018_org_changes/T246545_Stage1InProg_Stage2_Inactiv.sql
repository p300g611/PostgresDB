/*Ticket #246545
Please inactivate the Stage 2 ELA test for the following student and set the Stage 1 ELA test to In Progress. 
SSID: 1624847757
*/
select * from student where statestudentidentifier='1624847757' -->> id=1058293
-------------------------
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
  where stu.statestudentidentifier='1624847757' and en.currentschoolyear=2018
-------------------------stid from above i sused in the update statements below
--stage2
--SSID:1624847757 .reset stage1 in progress and stage2 is unused for ELA
--stage2

begin

update studentstests
set    activeflag =false, 
       modifieddate=now(),
	  manualupdatereason ='as for ticket #246545', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id = 21745439 and studentid=1058293 and activeflag =true;


update studentstestsections
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21745439 and activeflag =true  ;


update studentsresponses
set    activeflag =false,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where  studentstestsid  =21745439 and studentid =1058293 and activeflag =true ;

--stage1
update studentstests
set    status =85,  
       modifieddate=now(),
	  manualupdatereason ='as for ticket #246545', 
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where id =21042836
and studentid=1058293;


update studentstestsections
set    statusid =126,
      modifieddate=now(),
	  modifieduser =(select id from aartuser where username ='ats_dba_team@ku.edu')
where studentstestid =21042836 ;


COMMIT;
