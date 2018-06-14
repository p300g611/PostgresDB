--remove sc 

--ssid:4747881301,7347869137,5447519454,4058610727,3734519497,1249927757,1135205388,4221558539,6913446764

begin;

update studentspecialcircumstance
set    activeflag=false,
       modifieddate=now(),
	   createduser=(select id from aartuser where email='ats_dba_team@ku.edu')
where studenttestid in (
select st.id 
from enrollment en 
join student stu on stu.id =en.studentid
join gradecourse  eg on eg.id=en.currentgradelevel
join studentstests st on st.enrollmentid =en.id 
join test  t on t.id =st.testid							  
join testsession ts on ts.id =st.testsessionid
join studentstestsections  sts on sts.studentstestid =st.id
join testcollection tc on tc.id=st.testcollectionid
join contentarea ca on ca.id=tc.contentareaid
join studentspecialcircumstance sp on sp.studenttestid=st.id
join specialcircumstance spc on spc.id =sp.specialcircumstanceid
where en.currentschoolyear=2018 
and stu.statestudentidentifier in ('4747881301'
,'7347869137'
,'5447519454'
,'4058610727'
,'3734519497'
,'1249927757'
,'1135205388'
,'4221558539'
,'6913446764'))and activeflag is true ;

commit;

