/*
	select er.rosterid,er.id erid,e.studentid,er.enrollmentid ,er.activeflag er_active,r.coursesectionname, statesubjectareaid,teacherid,r.attendanceschoolid from enrollment e
	inner join enrollmentsrosters er on er.enrollmentid=e.id and currentschoolyear=2018
	inner join roster r on r.id=er.rosterid
	where studentid=1157785
	order by statesubjectareaid,er.activeflag;

	select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,st.id ,ts.source
	from studentstests st 
	inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018
	inner join testcollection tc on tc.id=ts.testcollectionid
	where studentid =1157785 order by contentareaid,enrollmentid,rosterid;

*/


begin;

select  dlm_duplicate_roster_update(2018, 864821,3,'for ticket#DE17282' );
select  dlm_duplicate_roster_update(2018, 864821,440,'for ticket#DE17282');

select  dlm_duplicate_roster_update(2018, 864486,3,'for ticket#DE17282' );
select  dlm_duplicate_roster_update(2018, 864486,440,'for ticket#DE17282');
select  dlm_duplicate_roster_update(2018, 864486,441,'for ticket#DE17282');

select  dlm_duplicate_roster_update(2018, 1325136,3,'for ticket#DE17282' );
select  dlm_duplicate_roster_update(2018, 1325136,440,'for ticket#DE17282');

commit;

-- 864821
-- 864486
-- 1325136
-- 1157785 -- looks like interim preditive tests

