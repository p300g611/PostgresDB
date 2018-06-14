/*
--sqlite script
select count(*)
FROM aartuser au
        JOIN usersorganizations uo ON uo.aartuserid = au.id
        JOIN organization o ON uo.organizationid = o.id
        JOIN organizationrelation por ON o.id = por.organizationid
        JOIN organization po ON por.parentorganizationid = po.id
        LEFT JOIN organizationrelation gpor ON po.id = gpor.organizationid
        LEFT JOIN organization gpo ON gpor.parentorganizationid = gpo.id
        lEFT JOIN organizationrelation gpor1 ON gpo.id = gpor1.organizationid
        LEFT JOIN organization gpo1 ON gpor1.parentorganizationid = gpo1.id
        LEFT JOIN organizationrelation gpor2 ON gpo1.id = gpor2.organizationid
        LEFT JOIN organization gpo2 ON gpor2.parentorganizationid = gpo2.id
        LEFT JOIN organizationrelation gpor3 ON gpo2.id = gpor3.organizationid
        LEFT JOIN organization gpo3 ON gpor3.parentorganizationid = gpo3.id
        LEFT JOIN organizationrelation gpor4 ON gpo3.id = gpor4.organizationid
        LEFT JOIN organization gpo4 ON gpor4.parentorganizationid = gpo4.id
        LEFT JOIN usersecurityagreement usa ON au.id = usa.aartuserid
        JOIN userorganizationsgroups uog ON uo.id = uog.userorganizationid
        JOIN groups g ON uog.groupid = g.id
    WHERE au.activeflag = TRUE AND uog.isdefault = TRUE and  au.id=64723  

--validation for dlm file
--Find the teachers that are missing 
select studentid,teacherid from enrollment en
inner join enrollmentsrosters er on en.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where studentid in (734135,858167,860425,860489,860552,865599,882209,882210,900684,948342,954527,958234,958243,958671,958702,969185,969228,1039316,
1045569,1060462,1092886,1092889,1140267,1140271,1140272,1140275,1140276,1150000,1208700,1231341,1300025,1300026,1300044,1300046,
1309260,1309267,1321555,1322938,1335726,1350045,1350046,1350062,1357605,1394085,1405112,1409332,1409337);


select distinct teacherid from enrollment en
inner join enrollmentsrosters er on en.id=er.enrollmentid
inner join roster r on r.id=er.rosterid
where studentid in (734135,858167,860425,860489,860552,865599,882209,882210,900684,948342,954527,958234,958243,958671,958702,969185,969228,1039316,
1045569,1060462,1092886,1092889,1140267,1140271,1140272,1140275,1140276,1150000,1208700,1231341,1300025,1300026,1300044,1300046,
1309260,1309267,1321555,1322938,1335726,1350045,1350046,1350062,1357605,1394085,1405112,1409332,1409337);



select distinct uog.isdefault userorganizationsgroups,au.id,uog.status  FROM aartuser au
 JOIN usersorganizations uo ON uo.aartuserid = au.id
 JOIN organization o ON uo.organizationid = o.id
 JOIN organizationrelation por ON o.id = por.organizationid
 JOIN organization po ON por.parentorganizationid = po.id
 JOIN userorganizationsgroups uog ON uo.id = uog.userorganizationid
 JOIN groups g ON uog.groupid = g.id
WHERE au.activeflag = TRUE 
and au.id in (96628,168189,64723,155188,77732,86554,75894,75754,76501,80514,88317,98652,78278,70328,97647,179045,79302,169186,88123,82990,69007)
order by au.id; 


*/
--===============================================================================================
--find the all users missing default
--===============================================================================================
begin;
drop table if exists tmp_users_all; 
select distinct au.id into temp tmp_users_all  FROM aartuser au
 JOIN usersorganizations uo ON uo.aartuserid = au.id
 JOIN organization o ON uo.organizationid = o.id
 JOIN organizationrelation por ON o.id = por.organizationid
 JOIN organization po ON por.parentorganizationid = po.id
 JOIN userorganizationsgroups uog ON uo.id = uog.userorganizationid
 JOIN groups g ON uog.groupid = g.id
WHERE au.activeflag = TRUE;

drop table if exists tmp_users; 
select distinct au.id into temp tmp_users  FROM aartuser au
 JOIN usersorganizations uo ON uo.aartuserid = au.id
 JOIN organization o ON uo.organizationid = o.id
 JOIN organizationrelation por ON o.id = por.organizationid
 JOIN organization po ON por.parentorganizationid = po.id
 JOIN userorganizationsgroups uog ON uo.id = uog.userorganizationid
 JOIN groups g ON uog.groupid = g.id
WHERE au.activeflag = TRUE and uog.isdefault is true;

select 
src.id from tmp_users_all src 
left outer join tmp_users tgt on src.id=tgt.id
where tgt.id is null
order by 1;


with uog_df as (
select aartuserid,min(userorganizationsgroupsid) id
from userassessmentprogram usm
inner join (select src.id from tmp_users_all src 
left outer join tmp_users tgt on src.id=tgt.id
where tgt.id is null) a on a.id=usm.aartuserid 
-- and usm.assessmentprogramid =3 
and usm.activeflag is true
and usm.isdefault is true
group by aartuserid)
update userorganizationsgroups 
set isdefault = true,
    modifieddate=now(),
    modifieduser=174744
where id in (select  id from uog_df) ;


select aartuserid,userorganizationsgroupsid,count(*)
from userassessmentprogram usm
inner join (select src.id from tmp_users_all src 
left outer join tmp_users tgt on src.id=tgt.id
where tgt.id is null) a on a.id=usm.aartuserid
inner join userorganizationsgroups uog on uog.id=usm.userorganizationsgroupsid 
-- and usm.assessmentprogramid =3 
and usm.activeflag is true
and uog.isdefault is true
group by aartuserid,userorganizationsgroupsid
having count(*)>1;

commit;

begin;
drop table if exists tmp_users_all; 
select distinct au.id into temp tmp_users_all  FROM aartuser au
 JOIN usersorganizations uo ON uo.aartuserid = au.id
 JOIN organization o ON uo.organizationid = o.id
 JOIN organizationrelation por ON o.id = por.organizationid
 JOIN organization po ON por.parentorganizationid = po.id
 JOIN userorganizationsgroups uog ON uo.id = uog.userorganizationid
 JOIN groups g ON uog.groupid = g.id
WHERE au.activeflag = TRUE;

drop table if exists tmp_users; 
select distinct au.id into temp tmp_users  FROM aartuser au
 JOIN usersorganizations uo ON uo.aartuserid = au.id
 JOIN organization o ON uo.organizationid = o.id
 JOIN organizationrelation por ON o.id = por.organizationid
 JOIN organization po ON por.parentorganizationid = po.id
 JOIN userorganizationsgroups uog ON uo.id = uog.userorganizationid
 JOIN groups g ON uog.groupid = g.id
WHERE au.activeflag = TRUE and uog.isdefault is true;

select 
src.id from tmp_users_all src 
left outer join tmp_users tgt on src.id=tgt.id
where tgt.id is null
order by 1;


with uog_df as (
select aartuserid,min(userorganizationsgroupsid) id
from userassessmentprogram usm
inner join (select src.id from tmp_users_all src 
left outer join tmp_users tgt on src.id=tgt.id
where tgt.id is null) a on a.id=usm.aartuserid 
-- and usm.assessmentprogramid =3 
-- and usm.activeflag is true
-- and usm.isdefault is true
group by aartuserid)
update userorganizationsgroups 
set isdefault = true,
    modifieddate=now(),
    modifieduser=174744
where id in (select  id from uog_df) ;

select aartuserid,userorganizationsgroupsid,count(*)
from userassessmentprogram usm
inner join (select src.id from tmp_users_all src 
left outer join tmp_users tgt on src.id=tgt.id
where tgt.id is null) a on a.id=usm.aartuserid
inner join userorganizationsgroups uog on uog.id=usm.userorganizationsgroupsid 
-- and usm.assessmentprogramid =3 
and usm.activeflag is true
and uog.isdefault is true
group by aartuserid,userorganizationsgroupsid
having count(*)>1;

commit;



/*

-------------------------------------------------------------------
-- 2.student 155188 :with dual roster example

select e.studentid,er.enrollmentid ,er.activeflag er_active,er.modifieddate,er.rosterid,r.coursesectionname, statesubjectareaid,teacherid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
where studentid=1390062;
 select ts.id tsid,ts.rosterid,st.id stid,st.enrollmentid,st.testid,st.status,attendanceschoolid,contentareaid,st.activeflag,st.id ,ts.source
 from studentstests st 
 inner join testsession ts on ts.id=st.testsessionid
 inner join testcollection tc on tc.id=ts.testcollectionid
 where studentid =1390062 order by contentareaid,enrollmentid,rosterid;



select e.studentid,er.enrollmentid,er.rosterid,er.activeflag enrollmentsrosters,er.createddate,er.modifieddate,r.coursesectionname,teacherid from enrollment e
inner join enrollmentsrosters er on er.enrollmentid=e.id
inner join roster r on r.id=er.rosterid
where studentid=1390062 and statesubjectareaid=3;

 select studentid,st.enrollmentid,rosterid,st.id studenttest,st.testid,st.status,ts.source
 from studentstests st 
 inner join testsession ts on ts.id=st.testsessionid
 inner join testcollection tc on tc.id=ts.testcollectionid
 where studentid =1390062 and contentareaid=3 order by contentareaid,enrollmentid,rosterid;





  select ts.id tsid,ts.rosterid,st.id itiid,st.rosterid,st.testid,st.status,ts.name,attendanceschoolid,contentareaid,st.activeflag,st.id 
 from ititestsessionhistory st 
 inner join testsession ts on ts.id=st.testsessionid 
 inner join testcollection tc on tc.id=ts.testcollectionid
 where st.studentid=1395644 order by contentareaid,st.rosterid;

 select e.id enrollid,e.activeflag enrollactive,er.enrollmentid,er.activeflag,r.id,r.coursesectionname,r.teacherid,r.statesubjectareaid,r.activeflag
 from enrollmentsrosters er inner join roster r on r.id=er.rosterid
 inner join enrollment e on e.id=er.enrollmentid
 where e.studentid =1395644;


*/
