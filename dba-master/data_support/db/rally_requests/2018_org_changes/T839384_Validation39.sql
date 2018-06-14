select er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,r.coursesectionname,
 statesubjectareaid,teacherid,e.attendanceschoolid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=2018
inner join roster r on r.id=er.rosterid
where studentid=864425
order by statesubjectareaid,er.activeflag;

select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,st.id ,ts.source,st.status
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
inner join testcollection tc on tc.id=ts.testcollectionid
where studentid =864425 order by contentareaid,enrollmentid,rosterid;

--Student 864425

begin;
select dlm_duplicate_roster_update(2018,864425,3,'for ticket #839384'); 
select dlm_duplicate_roster_update(2018,864425,440,'for ticket #839384'); 

commit;

--Student 1300318

begin;
select dlm_duplicate_roster_update(2018,1300318,3,'for ticket #839384'); 
select dlm_duplicate_roster_update(2018,1300318,440,'for ticket #839384'); 
select dlm_duplicate_roster_update(2018,1300318,441,'for ticket #839384'); 

commit;


--Student 864415

begin;
select dlm_duplicate_roster_update(2018,864415,3,'for ticket #839384'); 
select dlm_duplicate_roster_update(2018,864415,440,'for ticket #839384'); 
select dlm_duplicate_roster_update(2018,864415,441,'for ticket #839384'); 

commit;



