--=====================================================================================================
--validation
--=====================================================================================================
select distinct tv.externalid,taskname,ccqi.score
from scoringassignmentstudent scs
inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
inner join testsession ts on ts.id = sc.testsessionid and ts.activeflag is true
inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
inner join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and ccq.scoringassignmentscorerid=sc.id and ccq.activeflag is true
inner join ccqscoreitem ccqi on ccqi.ccqscoreid=ccq.id and ccqi.activeflag is true
inner join taskvariant tv on tv.id=ccqi.taskvariantid
left outer join rubriccategory rc on rc.id=ccqi.rubriccategoryid
where taskname in ('VH198677','VH198687','VH198700')
order by tv.externalid,score;

select distinct tv.externalid,taskname,ccqi.score
from scoringassignmentstudent scs
inner join scoringassignment sc on scs.scoringassignmentid=sc.id and scs.activeflag is true and sc.activeflag is true
inner join testsession ts on ts.id = sc.testsessionid and ts.activeflag is true
inner join scoringassignmentscorer sccq on sccq.scoringassignmentid=sc.id and sccq.activeflag is true
inner join ccqscore ccq on ccq.scoringassignmentstudentid=scs.id and ccq.scoringassignmentscorerid=sc.id and ccq.activeflag is true
inner join ccqscoreitem ccqi on ccqi.ccqscoreid=ccq.id and ccqi.activeflag is true
inner join taskvariant tv on tv.id=ccqi.taskvariantid
left outer join rubriccategory rc on rc.id=ccqi.rubriccategoryid
where taskname in ('VH199929')
order by tv.externalid,score;

select taskname,externalid,tv.id taskvariantid,maxscore,scoringmethod,score,count(*)  from studentsresponses sr
inner join taskvariant tv on tv.id=sr.taskvariantid
where tv.taskname ='VH199929'
group by taskname,externalid,tv.id,maxscore,scoringmethod,score
order by taskvariantid desc,score;

select operationaltestwindowid,score,count(*)  from studentsresponses sr
inner join taskvariant tv on tv.id=sr.taskvariantid
inner join studentstests st on st.id=sr.studentstestsid 
inner join testsession ts on ts.id=st.testsessionid
where tv.taskname ='VH199929'
group by operationaltestwindowid,score
order by taskvariantid desc,score;

select taskname,externalid,tv.id taskvariantid,maxscore,scoringmethod,score,count(*)  from studentsresponses sr
inner join taskvariant tv on tv.id=sr.taskvariantid
where tv.taskname in ('VH198677', 'VH198687', 'VH198700') 
group by taskname,externalid,tv.id,maxscore,scoringmethod,score
order by taskvariantid desc,score;

select taskname,externalid,tv.id taskvariantid,ccqi.score,count(*)
from ccqscoreitem ccqi 
inner join taskvariant tv on tv.id=ccqi.taskvariantid
where taskname in ('VH198677','VH198687','VH198700')
group by taskname,externalid,tv.id,ccqi.score 
order by tv.externalid,ccqi.score;

select taskname,externalid,tv.id,studentid,studentstestsid,count(distinct ccqi.score)
from ccqscoreitem ccqi 
inner join ccqscore ccq on ccqi.ccqscoreid=ccq.id 
inner join scoringassignmentstudent scs on ccq.scoringassignmentstudentid=scs.id
inner join taskvariant tv on tv.id=ccqi.taskvariantid
where taskname in ('VH198677','VH198687','VH198700')
group by taskname,externalid,tv.id,studentid,studentstestsid
having count(distinct ccqi.score)>1;

select taskname,externalid,tv.id taskvariantid,ccqi.score,ccqi.id ccqscoreitem_id,studentid,studentstestsid
from ccqscoreitem ccqi 
inner join ccqscore ccq on ccqi.ccqscoreid=ccq.id 
inner join scoringassignmentstudent scs on ccq.scoringassignmentstudentid=scs.id
inner join taskvariant tv on tv.id=ccqi.taskvariantid
where taskname in ('VH198677','VH198687','VH198700') and studentid=1038353
order by studentid,studentstestsid,tv.id;

--=====================================================================================================
--ITEM='VH199929'
--=====================================================================================================

select taskname,externalid,tv.id tv_id,maxscore,scoringmethod,studentstestsectionsid,studentid,taskvariantid,score,
case when score is null then '0.000' 
     when score<'5.000' then '0.000' 
     when score='5.000' then '1.000'
     else score end score_updated 
into temp tmp_kelpa_VH199929
from studentsresponses sr
inner join taskvariant tv on tv.id=sr.taskvariantid
where tv.taskname ='VH199929';

\copy (select * from tmp_kelpa_VH199929 ) to 'tmp_kelpa_VH199929.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


--Need to run on both aart and aartdw

begin;

update studentsresponses
set score= case when score is null then '0.000' 
     when score<'5.000' then '0.000' 
     when score='5.000' then '1.000'
     else score end
where  taskvariantid in ( select id from taskvariant tv where  tv.taskname ='VH199929');

commit; 

--=====================================================================================================
--ITEMs =  'VH198677', 'VH198687', 'VH198700'
--=====================================================================================================
     

select taskname,externalid,tv.id taskvariantid,ccqi.score,ccqi.id ccqscoreitem_id,studentid,studentstestsid,
case when score=4 then 3
     when score=5 then 3
     when score=6 then 3
     when score=7 then 3
     when score=8 then 3
     when score=9 then 3
     when score=211 then 3
     when score=221 then 3
     when score=232 then 3
     when score=233 then 3
     when score=322 then 3
     when score=332 then 3
     when score=333 then 3
     else score end score_updated 
     into temp tmp_kelpa_VH198677_VH198687_VH198700
from ccqscoreitem ccqi 
inner join ccqscore ccq on ccqi.ccqscoreid=ccq.id 
inner join scoringassignmentstudent scs on ccq.scoringassignmentstudentid=scs.id
inner join taskvariant tv on tv.id=ccqi.taskvariantid
where taskname in ('VH198677','VH198687','VH198700')
order by studentid,studentstestsid,tv.id;


\copy (select * from tmp_kelpa_VH198677_VH198687_VH198700 ) to 'tmp_kelpa_VH198677_VH198687_VH198700.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);


begin;

update ccqscoreitem
set score= case when score=4 then 3
     when score=5 then 3
     when score=6 then 3
     when score=7 then 3
     when score=9 then 3
     when score=211 then 2
     when score=221 then 2
     when score=232 then 3
     when score=233 then 3
     when score=322 then 3
     when score=332 then 3
     when score=333 then 3
     else score end
where  taskvariantid in (select id from taskvariant tv where  tv.taskname in ('VH198677','VH198687','VH198700'));

commit;

/*
-- BRAD FIX TO MODIFIED DATE

alter table ccqscoreitem disable trigger modifieddate;

update ccqscoreitem
set modifieddate = createddate
where modifieddate > ('2017-05-22 00:00:40.911653+00'::timestamp with time zone)
and taskvariantid in (
    select id from taskvariant tv where tv.taskname in ('VH198677', 'VH198687', 'VH198700')
)
and ccqscoreid not in (
    select ccq.id
    from studentstests st
    join test t on st.testid = t.id
    join scoringassignmentstudent sas on st.id = sas.studentstestsid
    join ccqscore ccq on sas.id = ccq.scoringassignmentstudentid
    where t.testname ~* 'speaking'
    and st.studentid in (
        533351, 565717, 828153, 828154, 828155, 828156, 828158, 828160, 828161, 828163, 828164, 870720, 1094657, 1095075, 1095097, 1095167, 1095233, 
        1095238, 1095276, 1095289, 1095297, 1095300, 1095313, 1095401, 1095472, 1095590, 1095690, 1229252, 1229393, 1229624, 1393096
    )
);

-- these were different in the backup, so our May 22nd script did not update these
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:05.193725+00'::timestamp with time zone) where id = 54708;
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:05.193725+00'::timestamp with time zone) where id = 54709;
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:05.193725+00'::timestamp with time zone) where id = 54710;
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:08.017994+00'::timestamp with time zone) where id = 114425;
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:08.017994+00'::timestamp with time zone) where id = 114426;
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:08.017994+00'::timestamp with time zone) where id = 114427;
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:00.769506+00'::timestamp with time zone) where id = 243403;
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:00.769506+00'::timestamp with time zone) where id = 243404;
update ccqscoreitem set modifieddate = ('2017-02-26 23:04:00.769506+00'::timestamp with time zone) where id = 243405;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:00.407496+00'::timestamp with time zone) where id = 269842;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:00.407496+00'::timestamp with time zone) where id = 269843;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:00.407496+00'::timestamp with time zone) where id = 269844;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:00.975117+00'::timestamp with time zone) where id = 269867;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:00.975117+00'::timestamp with time zone) where id = 269868;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:00.975117+00'::timestamp with time zone) where id = 269869;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:01.513895+00'::timestamp with time zone) where id = 269875;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:01.513895+00'::timestamp with time zone) where id = 269876;
update ccqscoreitem set modifieddate = ('2017-03-09 22:24:01.513895+00'::timestamp with time zone) where id = 269877;
update ccqscoreitem set modifieddate = ('2017-03-08 13:46:00.876+00'::timestamp with time zone) where id = 600295;
update ccqscoreitem set modifieddate = ('2017-03-09 21:24:02.056+00'::timestamp with time zone) where id = 722429;
update ccqscoreitem set modifieddate = ('2017-03-09 21:25:51.469+00'::timestamp with time zone) where id = 723323;
update ccqscoreitem set modifieddate = ('2017-03-10 21:09:03.382566+00'::timestamp with time zone) where id = 760368;
update ccqscoreitem set modifieddate = ('2017-03-10 21:09:03.382566+00'::timestamp with time zone) where id = 760369;
update ccqscoreitem set modifieddate = ('2017-03-10 21:09:03.382566+00'::timestamp with time zone) where id = 760370;
update ccqscoreitem set modifieddate = ('2017-03-22 17:05:04.924+00'::timestamp with time zone) where id = 939596;

update ccqscoreitem
set modifieddate = createddate
where modifieddate is null;

alter table ccqscoreitem enable trigger modifieddate;

*/

