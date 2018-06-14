select distinct t.id from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id = tv.tasktypeid
inner join taskvariantsfoils tvf on tvf.taskvariantid = tv.id
where tt.code in ('MC-S','MC-K','T-F') and tvf.responsescore is null and tvf.correctresponse=true;


select count(*) from testjson 
where testid in (select distinct t.id from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id = tv.tasktypeid
inner join taskvariantsfoils tvf on tvf.taskvariantid = tv.id
where tt.code in ('MC-S','MC-K','T-F') and tvf.responsescore is null and tvf.correctresponse=true) 


begin;

delete from testjson
where  testid in (select distinct t.id from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id = tv.tasktypeid
inner join taskvariantsfoils tvf on tvf.taskvariantid = tv.id
where tt.code in ('MC-S','MC-K','T-F') and tvf.responsescore is null and tvf.correctresponse=true);



update taskvariantsfoils tvf set responsescore=subquery.maxscore from 
(select tv.id,tv.maxscore from taskvariant tv
inner join tasktype tt on tt.id = tv.tasktypeid
where tt.code in ('MC-S','MC-K','T-F') order by tv.externalid) subquery 
where tvf.taskvariantid=subquery.id and tvf.responsescore is null and tvf.correctresponse=true;


update cb.taskvariantresponse tvr set responsescore=subquery.maxscore from 
(select tv.taskvariantid,t.maxscore from cb.taskvariant tv
inner join cb.task t on t.taskid = tv.taskid
inner join cb.tasktype tt on tt.tasktypeid = t.tasktypeid
inner join cb.systemrecord sc on sc.id = tt.systemrecordid
where sc.abbreviation in ('MC-S','MC-K','T-F') and tv.inuse=true and tv.status<>2) subquery 
where tvr.taskvariantid=subquery.taskvariantid and tvr.responsescore is null and tvr.correctresponse=true;

commit;


select tv.scoringdata,tvf.responsescore,subquery.maxscore from  taskvariantsfoils tvf inner join
(select tv.id,tv.maxscore from taskvariant tv
inner join tasktype tt on tt.id = tv.tasktypeid
where tt.code in ('MC-S','MC-K','T-F') order by tv.externalid) subquery 
on tvf.taskvariantid=subquery.id and tvf.responsescore is null and tvf.correctresponse=true
inner join taskvariant tv on tv.id=tvf.taskvariantid;


with tmp_test as(
select st.id stid,tv.id tvid,tvf.foilid,responsescore from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id = tv.tasktypeid
inner join taskvariantsfoils tvf on tvf.taskvariantid = tv.id
inner join studentstests st on st.testid=t.id
where tt.code in ('MC-S','MC-K','T-F') and tvf.responsescore is null and tvf.correctresponse=true)
select count(*) from studentsresponses sr
inner join tmp_test tmp on sr.studentstestsid=tmp.stid and sr.taskvariantid=tmp.tvid and tmp.foilid=sr.foilid
where sr.score::int<>tmp.responsescore::int;



drop table tmp_tvf;




select  *
into temp tmp_stdres
from studentsresponses 
where studentid in (
   1438898,
    481676,
    481669,
   1433739,
    481677,
    481668,
    481569,
    481670,
    481679,
    481667,
   1417092,
    481678);

select tv.id,tvf.foilid,responsescore into temp tmp_tvf from test t
inner join testsection ts on ts.testid = t.id
inner join testsectionstaskvariants tstv on tstv.testsectionid = ts.id
inner join taskvariant tv on tv.id = tstv.taskvariantid
inner join tasktype tt on tt.id = tv.tasktypeid
inner join taskvariantsfoils tvf on tvf.taskvariantid = tv.id
where tt.code in ('MC-S','MC-K','T-F')  and tvf.correctresponse=true
and tvf.foilid in (select distinct foilid from tmp_stdres);
    

select studentstestsectionsid,taskvariantid  from tmp_stdres  tmp
inner join tmp_tvf tvf on tmp.foilid=tvf.foilid
where tvf.responsescore::int<>tmp.score::int;


begin;
update studentsresponses sr
set score=1 
from ( select studentstestsectionsid,taskvariantid  from tmp_stdres  tmp
inner join tmp_tvf tvf on tmp.foilid=tvf.foilid
where tvf.responsescore::int<>tmp.score::int) tmp where tmp.studentstestsectionsid=sr.studentstestsectionsid and tmp.taskvariantid=sr.taskvariantid;
commit;
