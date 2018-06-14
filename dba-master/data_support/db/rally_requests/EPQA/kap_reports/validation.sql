SELECT tsec.testid,Count(*) 
FROM   taskvariant tv 
inner JOIN testsectionstaskvariants tstv ON tstv.taskvariantid = tv.id 
inner JOIN testsection tsec ON tstv.testsectionid = tsec.id 
inner JOIN tasktype tt ON tv.tasktypeid = tt.id 
where testid=63761
group by tsec.testid;


select * from subjectarea;

select * from stage;