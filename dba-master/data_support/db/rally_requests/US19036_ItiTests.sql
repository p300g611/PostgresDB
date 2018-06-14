/*
Student: 3201658869

Extract should include

    Test name
    Test status
    Roster name
    Plan create date
    Plan modified date
    Test complete date
*/

BEGIN;
select  t.testname                      TestName,
        c.categorycode                  TestStatus,
        r.coursesectionname             RosterName,
        iti.createddate                 PlanCreateDate,
        iti.confirmdate                 PlanModifiedDate,
        st.enddatetime                  TestCompleteDate
   into temp tmp		
   from studentstests st
   join testsession ts on st.testsessionid=ts.id
   inner join test t on t.id=st.testid
   inner JOIN category c ON c.id = st.status
   inner join aartuser art on art.id=st.createduser
   inner join roster r on r.id=ts.rosterid
   inner join ititestsessionhistory iti on iti.testsessionid=ts.id and st.studentid=iti.studentid
   where st.studentid=1204246  
   
 \COPY tmp to 'US19036_ititests.csv' DELIMITER ',' CSV HEADER;
ROLLBACK;

			
			
			
