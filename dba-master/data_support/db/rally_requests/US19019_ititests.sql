BEGIN;
select  t.testname                      TestName,
        art.firstname||'.'||art.surname UserThatCreatedPlan,
        ts.rosterid         RosterID,
        r.coursesectionname RosterName,
        otd.districtname    District,
        otd.schoolname      school,
        iti.createddate     PlanCreationDatetime,
        iti.confirmdate     PlanConfirmationDatetime,
        st.enddatetime      PlanCompletionDatetime
   into temp tmp		
 from studentstests st
   inner join testsession ts on st.testsessionid=ts.id
   inner join test t on t.id=st.testid
   inner join ititestsessionhistory iti on iti.testsessionid=ts.id and st.studentid=iti.studentid
   inner join enrollment e on st.enrollmentid=e.id
   left outer join organizationtreedetail otd on e.attendanceschoolid=otd.schoolid
   left outer join roster r on r.id=ts.rosterid
   inner join aartuser art on art.id=st.createduser
   where st.studentid=679267 and st.activeflag is true; 
   
 \COPY tmp TO 'US19019_ititests.csv' DELIMITER ',' CSV HEADER;
ROLLBACK;