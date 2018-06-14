--1) validation : Dropdown issue --process i)
select s.id,a.id ,count(distinct selectedvalue) cnt 
FROM student s
inner JOIN enrollment e ON (e.studentid = s.id)
inner join organizationtreedetail ot on ot.schoolid=e.attendanceschoolid
inner JOIN studentassessmentprogram sap ON sap.studentid = s.id and sap.activeflag is true
inner JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
LEFT JOIN studentprofileitemattributevalue spiav ON s.id = spiav.studentid
LEFT JOIN profileitemattributenameattributecontainer pianc ON spiav.profileitemattributenameattributecontainerid =pianc.id
LEFT JOIN profileitemattribute pia ON pianc.attributenameid = pia.id
LEFT JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
WHERE spiav.activeflag is true
and s.activeflag is true and e.activeflag is true
and e.currentschoolyear=2018 --and a.id=12
and attributecontainer='Magnification'
and (( attributename='activateByDefault' and selectedvalue='true')
or ( attributename='magnification' and selectedvalue='null'))
group by s.id,a.id
having count(distinct selectedvalue)>1;

--1) validation : Dropdown issue --process ii)  
select count(distinct spj.studentid)
from studentpnpjson spj
join student s on s.id = spj.studentid
join enrollment e on e.studentid = spj.studentid
where e.activeflag is true and e.currentschoolyear = 2018 and
spj.jsontext ilike '%{"attrName":"activatebydefault","attrContainer":"magnification","attrContainerId":27,"attrValue":"true"}%' and
spj.jsontext ilike '%{"attrName":"magnification","attrContainer":"magnification","attrContainerId":27,"attrValue":"null"}%' ;

--solution updated 2x for  attributename='magnification' and selectedvalue='null' 


-- DLM students has grade band tests assigned with outside gradegrades
select distinct en.studentid
from enrollment en
inner join tmp_orgyear tmp on en.attendanceschoolid=tmp.orgid and en.currentschoolyear=tmp.orgyear and en.activeflag is true
inner join studentstests st on en.id = st.enrollmentid
inner join student s on s.id=st.studentid and s.activeflag is true
inner join test t on st.testid = t.id
inner join testsession ts on ts.id=st.testsessionid and ts.schoolyear=2018 and ts.activeflag is true 
left outer join gradecourse tgc on tgc.id=t.gradecourseid and tgc.abbreviatedname<>'OTH'
inner join gradecourse egc on egc.id=en.currentgradelevel
left outer join testcollectionstests tct ON t.id = tct.testid
left outer join testcollection tc ON tc.id = tct.testcollectionid
left outer join gradebandgradecourse gbc on tc.gradebandid=gbc.gradebandid 
left outer join gradecourse ggc on ggc.id=gbc.gradecourseid and ggc.abbreviatedname<>'OTH'
left outer join assessmentstestcollections atc ON tc.id = atc.testcollectionid
left outer join assessment a ON atc.assessmentid = a.id
left outer join testingprogram tp ON a.testingprogramid = tp.id
inner join assessmentprogram ap ON tp.assessmentprogramid = ap.id
where  ap.id=3
group by en.studentid,st.id,(replace(egc.abbreviatedname,'K','0'))::int
having (replace(egc.abbreviatedname,'K','0'))::int <min(regexp_replace(replace(ggc.abbreviatedname,'K','0'), '[^0-9]+', '', 'g')::int) or 
       (replace(egc.abbreviatedname,'K','0'))::int >max(regexp_replace(replace(ggc.abbreviatedname,'K','0'), '[^0-9]+', '', 'g')::int);

-- Find the students missing blueprint reports 
drop table if exists tmp_report;
with std as (
select st.studentid,count(distinct contentcode)
from studentstests st 
inner join student s on s.id=st.studentid
inner join enrollment e on e.studentid=s.id and e.id = st.enrollmentid and s.activeflag is true
inner join gradecourse gc on gc.id=e.currentgradelevel and gc.abbreviatedname='10'
inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true 
inner join testcollection tc on tc.id=st.testcollectionid 
inner join ititestsessionhistory iti on iti.testsessionid=ts.id and iti.activeflag is true 
inner join contentframeworkdetail ee on ee.id=iti.essentialelementid
-- inner join blueprintessentialelements bpee on iti.essentialelementid = bpee.essentialelementid
inner join category c on c.id=st.status 
where st.activeflag is true and  categorycode ~* 'complete' and ts.activeflag is true 
and e.currentschoolyear=2018 and ts.schoolyear=2018 and tc.contentareaid=440 and 
    o.statedisplayidentifier  in ('ND','IA','KS','MO') and 
    contentcode in ('M.EE.HS.S.CP.1-5','M.EE.HS.G.CO.4-5','M.EE.HS.N.Q.1-3','M.EE.HS.S.ID.1-2','M.EE.HS.S.ID.4',
     'M.EE.HS.A.CED.1','M.EE.HS.A.CED.2-4','M.EE.HS.A.REI.10-12','M.EE.HS.F.BF.1')    
group by st.studentid
having count(distinct contentcode)>=6)
select statename,districtname,schoolname,s.id studentid,gc.abbreviatedname grade,
array_to_string(array_agg(distinct ee.contentcode  ), ',') contentcodes_all,
array_to_string(array_agg(distinct ee_3.contentcode  ), ',') contentcodes_claim3
into temp tmp_report
from studentstests st 
inner join student s on s.id=st.studentid
inner join enrollment e on e.studentid=s.id and e.id = st.enrollmentid and s.activeflag is true
inner join gradecourse gc on gc.id=e.currentgradelevel and gc.abbreviatedname='10'
inner join organizationtreedetail o on o.schoolid = e.attendanceschoolid
inner join testsession ts on ts.id=st.testsessionid and ts.activeflag is true 
inner join testcollection tc on tc.id=st.testcollectionid 
inner join ititestsessionhistory iti on iti.testsessionid=ts.id and iti.activeflag is true 
inner join contentframeworkdetail ee on ee.id=iti.essentialelementid
left outer join  contentframeworkdetail ee_3 on ee_3.id=iti.essentialelementid and ee_3.contentcode in ('M.EE.HS.N.Q.1-3','M.EE.HS.S.ID.1-2','M.EE.HS.S.ID.4')
-- inner join blueprintessentialelements bpee on iti.essentialelementid = bpee.essentialelementid
inner join category c on c.id=st.status 
where st.activeflag is true and  categorycode ~* 'complete' and ts.activeflag is true 
and e.currentschoolyear=2018 and ts.schoolyear=2018 and tc.contentareaid=440 and 
    o.statedisplayidentifier  in ('ND','IA','KS','MO')  and 
     ee.contentcode in ('M.EE.HS.S.CP.1-5','M.EE.HS.G.CO.4-5','M.EE.HS.N.Q.1-3','M.EE.HS.S.ID.1-2','M.EE.HS.S.ID.4',
     'M.EE.HS.A.CED.1','M.EE.HS.A.CED.2-4','M.EE.HS.A.REI.10-12','M.EE.HS.F.BF.1')     
and exists (select 1 from std where std.studentid=s.id)
group by statename,districtname,schoolname,s.id,gc.abbreviatedname;

\COPY (select * from tmp_report order by 1,2,3) to 'ee_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *)

--Validation(41) For DLM duplicated special circumstance code
with tmp_dup as (
select st.id,count(distinct ssc.id)
from studentstests st 
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join studentassessmentprogram sap on e.studentid=sap.studentid and sap.activeflag is true and sap.assessmentprogramid=3
inner join studentspecialcircumstance ssc on ssc.studenttestid=st.id and ssc.activeflag is true  
group by st.id
having count(distinct ssc.id)>1
)
select distinct e.studentid "41:For DLM duplicated special circumstance code",schoolname,districtname, statename,
spc.specialcircumstancetype
into temp dailyvalidation41
from tmp_dup tmp
inner join studentstests st on st.id =tmp.id
inner join testsession ts on ts.id=st.testsessionid and schoolyear=2018 
inner join enrollment e on e.id=st.enrollmentid and e.studentid=st.studentid
inner join organizationtreedetail ort on ort.schoolid =e.attendanceschoolid
inner join studentassessmentprogram sap on e.studentid=sap.studentid and sap.activeflag is true and sap.assessmentprogramid=3
inner join studentspecialcircumstance ssc on ssc.studenttestid=st.id and ssc.activeflag is true
left outer join specialcircumstance spc on spc.id =ssc.specialcircumstanceid;
\copy (select * from dailyvalidation41) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation41.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--Validation(42) FOR DLM missing educator information
with tmp_role as (select au.id
FROM aartuser au
join usersorganizations uo ON uo.aartuserid = au.id
join userorganizationsgroups uog ON uo.id = uog.userorganizationid
join groups g ON uog.groupid = g.id
WHERE au.activeflag = TRUE and g.groupcode ='TEA')
,tmp_teacher as (
select au.id,count(uog.isdefault)
FROM aartuser au
join usersorganizations uo ON uo.aartuserid = au.id 
join userorganizationsgroups uog ON uo.id = uog.userorganizationid
join groups g ON uog.groupid = g.id
WHERE au.activeflag is true
and exists (select 1 from tmp_role where tmp_role.id=au.id)
group by au.id
having count(uog.isdefault)=1
)
,tmp_sigle as (
 select au.id
from aartuser au
join usersorganizations uo ON uo.aartuserid = au.id
join userorganizationsgroups uog ON uo.id = uog.userorganizationid
join  groups g ON uog.groupid = g.id 
WHERE  uog.isdefault is false
and exists (select 1 from tmp_teacher where au.id =tmp_teacher.id)
)
select distinct en.studentid,r.teacherid,r.statesubjectareaid,schoolname, districtname,statename
into temp dailyvalidation42
from enrollment en
join organizationtreedetail ort on ort.schoolid=en.attendanceschoolid
join enrollmentsrosters er on er.enrollmentid =en.id 
join roster r on r.id=er.rosterid 
join studentassessmentprogram sap on sap.studentid =en.studentid 
where en.activeflag is true and en.currentschoolyear =2018 and sap.assessmentprogramid =3
and er.activeflag is true and r.activeflag is true and r.statesubjectareaid in (3,440,441)
and exists (select 1 from tmp_sigle where tmp_sigle.id=r.teacherid); 
\copy (select * from dailyvalidation42) to '/srv/extracts/helpdesk/dailyvalidation/data/dailyvalidation42.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);  


--kelpa one item has multiple scores 
 select st.studentid,st.id,taskvariantid,count(distinct score) from studentstestscore sc 
 inner join studentstests st on st.id=sc.studenttestid and st.activeflag is true 
 where sc.activeflag is true group by st.studentid,st.id,taskvariantid having count(distinct score)>1;

--item not mapped to rubric (this issue bacuse of cluster scoring not deleted for speaking) 
select case when sa.ccqtestname ~* 'writing' then 'writing' when sa.ccqtestname ~* 'speaking' then 'speaking' else '' end,
    count(distinct st.studentid) 
from scoringassignment sa
join scoringassignmentstudent sas on sa.id = sas.scoringassignmentid and sas.activeflag is true
join studentstestscore sts on sas.studentstestsid = sts.studenttestid and sts.activeflag is true
join studentstests st on sts.studenttestid = st.id and st.activeflag is true
join rubriccategory rc on sts.rubriccategoryid = rc.id
where sa.ccqtestname ~* '^2018'
and sts.taskvariantid is distinct from rc.taskvariantid
group by 1;

--Find the missing students responses for LCS students
SELECT distinct st.studentid||'-'||sts.id||'-click.json' as clickhistory, st.id as "studentsTestId",st.studentid,t.testname,(select count(*) from testsectionstaskvariants where testsectionid = tsec.id) as tstvcount, (select count(*) from studentsresponses where studentstestsid = st.id) as srcount, sr.taskvariantid,
sr.foilid as foilid,sr.response as response
FROM studentstests st
JOIN lcsstudentstests lcs ON lcs.studentstestsid = st.id
JOIN studentsresponses sr ON sr.studentstestsid = st.id
JOIN testsession ts on st.testsessionid = ts.id
JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
JOIN test t ON t.id = st.testid
JOIN studentstestsections sts on st.id = sts.studentstestid
JOIN testsection tsec ON tsec.testid = t.id and sts.testsectionid = tsec.id
join testsectionstaskvariants tstv on tsec.id = tstv.testsectionid and sr.taskvariantid = tstv.taskvariantid
WHERE otw.id in (10261,10258) 
AND st.status = 86 
and st.activeflag
and foilid is null 
and response is null;
