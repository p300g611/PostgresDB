begin;
with cte_cb 
as (
select  
       t.id TestId,
       t.externalid cbtestid,
       t.testname TestName,
       csts.categoryname TestStatus,
       tv.id TaskId,
       tv.externalid cbTaskId,
       tt.name ItemType,
       tv.scoringdata  ScoringData,
       tv.scoringmethod ScoringMethod,
       tst.name SubtaskTypeName,
       t.maxscore TestMaxscore,
       tv.maxscore TaskMaxscore,
       max(case when tvf.correctresponse is true then tvf.responsescore
                when tvf.responsescore is null then tvf.responsescore
                 else 0 end) taskvariantmaxresponsescore,
       tv.scoringneeded ScoringNeeded,
       sum(case when tvf.correctresponse is true then 1 else 0 end)  CorrectResponsecount,
       tc.name TestCollectionName,
       row_number() over (partition by t.externalid,tv.externalid order by t.id desc ,tv.id desc ) row_mun
     from test t 
 	    JOIN testsection as ts ON t.id = ts.testid
 	    JOIN testsectionstaskvariants AS tstv ON ts.id = tstv.testsectionid
 	    JOIN taskvariant AS tv ON tstv.taskvariantid = tv.id
 	    left outer join taskvariantsfoils tvf on tv.id = tvf.taskvariantid
            LEFT OUTER JOIN tasktype tt ON tv.tasktypeid = tt.id
            left outer join category csts on csts.id=t.status 
            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
            LEFT JOIN tasksubtype tst ON tv.tasksubtypeid = tst.id
        WHERE ap.abbreviatedname ='KAP' and tp.programname ='Interim'-- and t.testname='10 Smart Routes to Bicycle Safety'
        group by t.id ,
		       t.testname ,
		       csts.categoryname ,
		       tv.id ,
		       tt.name ,
		       tv.scoringdata  ,
		       tv.scoringmethod ,
		       tst.name ,
		       t.maxscore ,
		       tv.scoringneeded ,
		       tc.name 
        ) 
        select   TestId,
        cbtestid,
        TestName,
        TestStatus,
        TaskId,
        cbTaskId,
        ItemType,
        ScoringData,
        ScoringMethod,
        SubtaskTypeName,
        TestMaxscore,
        TaskMaxscore,
        taskvariantmaxresponsescore,
        ScoringNeeded,
        CorrectResponsecount,
         TestCollectionName into temp tmp_kap from cte_cb where row_mun=1;
\copy (select * from tmp_kap) to 'kap.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
 rollback;



        