

--duplicate tests because of the merge student request
-- query would show you the tests you want to delete...the ones with null for stbid
select distinct
    st.studentid, ca.abbreviatedname as subject, egc.abbreviatedname as egrade, gc.abbreviatedname as grade, gb.name as grades, st.testid, t.testname, st.id as stid, st.activeflag::text as stactive,
    ststatus.categoryname as status, st.testsessionid, ts.activeflag::text as tsactive, ts.name as sessionname, stb.id as stbid
from student s
join studentstests st on s.id = st.studentid
join enrollment e on st.enrollmentid = e.id
join gradecourse egc on e.currentgradelevel = egc.id
join testsession ts on st.testsessionid = ts.id
join testcollection tc on st.testcollectionid = tc.id
join test t on st.testid = t.id
join contentarea ca on tc.contentareaid = ca.id
join category ststatus on st.status = ststatus.id
left join gradecourse gc on tc.gradecourseid = gc.id
left join gradeband gb on tc.gradebandid = gb.id
left join gradebandgradecourse gbgc on gb.id = gbgc.gradebandid
left join gradecourse bgc on gbgc.gradecourseid = bgc.id
left join aartuser cu on st.createduser = cu.id
left join aartuser mu on st.modifieduser = mu.id
left join studenttracker strack on s.id = strack.studentid and strack.contentareaid = ca.id and strack.schoolyear = e.currentschoolyear and strack.activeflag is true
left join studenttrackerband stb on strack.id = stb.studenttrackerid and ts.id = stb.testsessionid and stb.activeflag is true
where st.createddate > '2017-08-01'
and st.activeflag is true
and s.id in (950996, 1216824)
and t.testname !~* 'iti'
and ca.abbreviatedname ~* 'm|ela'
order by st.studentid, ca.abbreviatedname, gc.abbreviatedname;
