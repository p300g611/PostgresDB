-- To generate the math performance tests responses for the Kids are in Metametrics Math response file

DROP TABLE IF EXISTS metametricsstudentsresponses;
DROP TABLE IF EXISTS mathperfdata;
DROP TABLE IF EXISTS questar_data;

CREATE TEMP TABLE metametricsstudentsresponses(student_id character varying(50),item_id BIGINT, stage CHARACTER VARYING(20), item_number INTEGER, response INTEGER, score numeric(6,3));

\COPY metametricsstudentsresponses FROM 'KS_Metametrics_Student_Responses_M.csv' WITH (FORMAT CSV, HEADER);

SELECT * INTO  temp mathperfdata FROM metametricsstudentsresponses WHERE stage = 'Performance';

SELECT stu.statestudentidentifier,srsc.studentstestsectionsid, srsc.taskvariantexternalid,
       sum(srsc.score) as totalscore INTO temp questar_data
       from mathperfdata mpd
       join student stu on stu.statestudentidentifier = mpd.student_id
       join studentstests st on st.studentid = stu.id
       join testsession ts on ts.id = st.testsessionid
       join testcollection tc on tc.id = st.testcollectionid
       join contentarea ca on ca.id = tc.contentareaid
       join stage stage on stage.id = ts.stageid      
       join studentstestsections stsc on stsc.studentstestid = st.id
       join studentresponsescore srsc on srsc.studentstestsectionsid = stsc.id and srsc.taskvariantexternalid = mpd.item_id
       where st.activeflag IS true AND st.status IN (85, 86)
              AND ca.abbreviatedname IN ('M')
              AND stage.code = 'Prfrm'
              AND ts.operationaltestwindowid IN (10131, 10133) 
              AND ts.schoolyear = 2016 AND ts.activeflag IS true
              and srsc.raterorder = 1 and srsc.scorable is true and srsc.activeflag is true
              and stsc.activeflag is true
      group by stu.statestudentidentifier,srsc.studentstestsectionsid, srsc.taskvariantexternalid;


UPDATE
    mathperfdata mdf
SET
    response = CASE WHEN ext.totalscore > 0.0 THEN
                         1 ELSE 0 END, score = ext.totalscore 
FROM questar_data ext
WHERE student_id = ext.statestudentidentifier  and item_id = ext.taskvariantexternalid;


\COPY (select * from mathperfdata order by student_id, item_number) to 'KS_Metametrics_Student_Responses_M_Perf_data.csv' DELIMITER ',' CSV HEADER ;

DROP TABLE IF EXISTS metametricsstudentsresponses;
DROP TABLE IF EXISTS mathperfdata;
DROP TABLE IF EXISTS questar_data;
