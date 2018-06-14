with tmp_stu as (select id from student where id=1393629),
sr_man as (select 
  scs.studentid
 ,scs.studentstestsid
 ,stg.id stageid
 ,stg.code stagecode
 ,ccqi.taskvariantid
 ,tv.externalid taskvariantexternalid 
 ,ccqi.nonscoringreason
 ,ccqi.score
 ,t.id testid
 ,t.externalid testexternalid
 ,row_number() over (partition by scs.studentid,scs.studentstestsid,ccqi.taskvariantid order by ccqi.createddate desc) row_num 
 from studentstests st
 inner join tmp_stu s on s.id=st.studentid
 inner join testsession ts on ts.id = st.testsessionid and ts.activeflag is true and st.activeflag is true
 inner join scoringassignmentstudent scs on st.id=scs.studentstestsid  and scs.activeflag is true
 inner join scoringassignment sc on scs.scoringassignmentid=sc.id and sc.activeflag is true and ts.id = sc.testsessionid
 inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
 inner join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and ccq.scoringassignmentscorerid=sccq.id and ccq.activeflag is true
 inner join ccqscoreitem ccqi on ccqi.ccqscoreid=ccq.id and ccqi.activeflag is true
 inner join stage stg  on stg.id=ts.stageid
 inner JOIN taskvariant tv ON tv.id = ccqi.taskvariantid
 inner join test t on t.id=st.testid 
 --where scs.studentid=1393629 --and ts.operationaltestwindowid=10171
 ),
 sr_std as (select distinct st.studentid
 ,st.id studentstestsid
 ,stg.id stageid
 ,str.studentstestsectionsid
 ,tv.id taskvariantid
 ,tv.externalid taskvariantexternalid
 ,null::bigint nonscoringreason
 ,str.score
 ,stg.code stagecode
 ,t.id testid
 ,t.externalid testexternalid
from studentstests st
inner join tmp_stu s on s.id=st.studentid
inner join testsession ts on ts.id = st.testsessionid and ts.activeflag is true and st.activeflag is true
INNER JOIN testcollection tc ON tc.id=st.testcollectionid
INNER JOIN stage stg ON tc.stageid = stg.id
INNER JOIN studentsresponses str ON str.studentstestsid=st.id
INNER JOIN taskvariant tv ON tv.id = str.taskvariantid
INNER JOIN test t on t.id = st.testid
INNER JOIN enrollment en ON en.studentid = st.studentid and st.enrollmentid=en.id and st.activeflag is true 
LEFT outer JOIN studentresponsescore srs ON str.studentstestsectionsid = srs.studentstestsectionsid AND tv.externalid = srs.taskvariantexternalid
where st.testid in (select id from test t where t.externalid in (18666,18726,18667,18665,18647,18950,18648,18725,18664,18645,18644,
 18646,18689,18669,18668,18727,18670,18678,18679,18729,18681,18676,18677,18671,18728)) and str.score is not null --and ts.operationaltestwindowid=10171
--  and st.studentid in (1393629)
 )     
select studentid,studentstestsid,testid,testexternalid,taskvariantid,taskvariantexternalid,stageid,stagecode,nonscoringreason,score from sr_man where row_num=1 
union all
select studentid,studentstestsid,testid,testexternalid,taskvariantid,taskvariantexternalid,stageid,stagecode,nonscoringreason,score from sr_std order by studentid,stageid,taskvariantid;

      