# Author: Rohit Yadav
# Date : 04/29/2016


# To calculate Average & Maximum amount of timetaken to complete KAP Adaptive tests
SELECT
       stg.id AS "Stage",
       gc.name AS "Grade",
       ca.abbreviatedname AS "Subject",
       round(avg(EXTRACT(EPOCH FROM (enddatetime - startdatetime))/60)) AS "Average Timetaken",
       max(round(EXTRACT(EPOCH FROM (st.enddatetime - st.startdatetime))/60)) AS "Maximum Timetaken"
       INTO temp table tmp_avg
       FROM studentstests st
       JOIN testsession ts ON (st.testsessionid = ts.id)
       JOIN testcollection tc ON (ts.testcollectionid = tc.id)
       JOIN contentarea ca ON (tc.contentareaid = ca.id)
       JOIN gradecourse gc ON gc.id=ts.gradecourseid
       JOIN stage stg ON (ts.stageid = stg.id)
       WHERE st.startdatetime is not null
       AND st.enddatetime is not null
       AND st.activeflag is true
       AND st.status = 86
       AND ts.activeflag is true
       AND st.enddatetime > st.startdatetime
       AND ts.operationaltestwindowid in (10131,10132,10133)
       AND round(EXTRACT(EPOCH FROM (st.enddatetime - st.startdatetime))/60) <= 90
       GROUP BY stg.id,gc.name,ca.abbreviatedname
       ORDER BY CAST(substring(gc.name from 7 for 2) AS INTEGER),"Stage","Subject";

# To generate csv file for Average amount of time to complete KAP Adaptive tests
\copy (SELECT * FROM tmp_avg ) TO 'KAP_Adapative_average_max.csv' DELIMITER ',' CSV HEADER;


# To calculate 95th percentile Average amount of time to complete KAP Adaptive tests
WITH stcount AS (
       SELECT
              stg.id AS stageid,
              gc.id AS gradecourseid,
              gc.name AS grade,
              ca.id AS contentareaid,
              ca.abbreviatedname AS subject,
              round(EXTRACT(EPOCH FROM (enddatetime - startdatetime))/60) AS timetaken,
              ROW_NUMBER() over (PARTITION BY stg.id,gc.id,ca.id ORDER BY (round(EXTRACT(EPOCH FROM (st.enddatetime - st.startdatetime))/60))) as row_num
              FROM studentstests st
              JOIN testsession ts ON (st.testsessionid = ts.id)
              JOIN testcollection tc ON (ts.testcollectionid = tc.id) AND st.testcollectionid=tc.id
              JOIN contentarea ca ON (tc.contentareaid = ca.id)
              JOIN gradecourse gc ON (gc.id=ts.gradecourseid)
              JOIN stage stg ON (ts.stageid = stg.id)
              WHERE st.startdatetime is not null
              AND st.enddatetime is not null
              AND st.activeflag is true
              AND st.status = 86
              AND ts.activeflag is true
              AND st.enddatetime > st.startdatetime
              AND round(EXTRACT(EPOCH FROM (st.enddatetime - st.startdatetime))/60) <= 90
              AND ts.operationaltestwindowid in (10131,10132,10133)),
              stmax AS (
                  SELECT
                       stg.id AS stageid,
                       gc.id AS gradecourseid,
                       ca.id AS contentareaid,
                       count(st.id) AS st_tot
                       FROM studentstests st
                       JOIN testsession ts ON (st.testsessionid = ts.id)
                       JOIN testcollection tc ON (ts.testcollectionid = tc.id) AND st.testcollectionid=tc.id
                       JOIN contentarea ca ON (tc.contentareaid = ca.id)
                       JOIN gradecourse gc ON (gc.id=ts.gradecourseid)
                       JOIN stage stg ON (ts.stageid = stg.id)
                       WHERE st.activeflag is true
                       AND st.startdatetime is not null
                       AND st.enddatetime is not null
                       AND st.status = 86
                       AND st.enddatetime > st.startdatetime
                       AND round(EXTRACT(EPOCH FROM (st.enddatetime - st.startdatetime))/60) <= 90
                       AND ts.activeflag is true
                       AND ts.operationaltestwindowid in (10131,10132,10133)
                       GROUP BY stg.id,gc.id,ca.id)
       SELECT
          stc.stageid AS "Stage",
          stc.grade AS "Grade",
          stc.subject AS "Subject",
          stc.timetaken as “Percentile"
          INTO temp table tmp_percentile_avg
          FROM stcount stc
          INNER JOIN stmax stm ON stc.stageid = stm.stageid AND stc.gradecourseid = stm.gradecourseid AND stc.contentareaid=stm.contentareaid
          WHERE stc.row_num = round((CAST(st_tot AS NUMERIC)*95)/100)
          ORDER BY CAST(substring(stc.grade from 7 for 2) AS INTEGER),"Stage","Subject";

# To generate csv file for 95th Percentile Average amount of time to complete KAP Adaptive tests
\copy (SELECT * FROM tmp_percentile_avg ) TO 'KAP_Adapative_percentile_averagetime.csv' DELIMITER ',' CSV HEADER;
