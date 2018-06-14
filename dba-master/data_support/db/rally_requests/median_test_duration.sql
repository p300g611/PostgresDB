--KAP only operational test windows
--excludes tests where end date is greater than start date
--limited to Buhler, El Dorado and Derby school districts.

\f ','
\a
\pset expanded off

\o 'dist_median_duration.csv'

WITH stcount AS (
       SELECT otd.districtname AS District,
              stg.id AS stageid,
              gc.id AS gradecourseid,
              ca.id AS contentareaid,
              stg.name AS Stagename,
              gc.name AS Grade,
              ca.abbreviatedname AS Subject,
              round(EXTRACT(EPOCH FROM (enddatetime - startdatetime))/60) AS timetaken,
              ROW_NUMBER() over (PARTITION BY otd.districtname,stg.id,gc.id,ca.id ORDER BY (round(EXTRACT(EPOCH FROM (st.enddatetime - st.startdatetime))/60))) as row_num
              FROM studentstests st
              JOIN testsession ts ON (st.testsessionid = ts.id)
              JOIN testcollection tc ON (ts.testcollectionid = tc.id) AND st.testcollectionid=tc.id
              JOIN contentarea ca ON (tc.contentareaid = ca.id)
              JOIN gradecourse gc ON (gc.id=ts.gradecourseid)
              JOIN stage stg ON (ts.stageid = stg.id)
              JOIN student s ON (s.id = st.studentid)
              JOIN enrollment en ON (en.studentid = s.id)
              JOIN organizationtreedetail otd ON (otd.schoolid = en.attendanceschoolid)              
              WHERE st.startdatetime is not null
              AND otd.districtdisplayidentifier IN ('D0313','D0260','D0490')
              AND st.startdatetime is not null
              AND st.enddatetime is not null
              AND st.activeflag is true
              AND st.status = 86
              AND ts.activeflag is true
              AND st.enddatetime > st.startdatetime
              AND ts.operationaltestwindowid in (10124,10131,10132,10133)),
              stmax AS (
                  SELECT
                       otd.districtname,
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
                       JOIN student s ON (s.id = st.studentid)
		       JOIN enrollment en ON (en.studentid = s.id)
                       JOIN organizationtreedetail otd ON (otd.schoolid = en.attendanceschoolid)
                       WHERE st.activeflag is true
                       AND otd.districtdisplayidentifier IN ('D0313','D0260','D0490')
                       AND st.startdatetime is not null
                       AND st.enddatetime is not null
                       AND st.status = 86
                       AND st.enddatetime > st.startdatetime
                       AND ts.activeflag is true
                       AND ts.operationaltestwindowid in (10124,10131,10132,10133)
                       GROUP BY otd.districtname,stg.id,gc.id,ca.id)
       SELECT
          stc.district,
          stc.Stagename AS "Stage",
          stc.grade AS "Grade",
          stc.subject AS "Subject",
          stc.timetaken as "Median"
          FROM stcount stc
          INNER JOIN stmax stm ON stc.stageid = stm.stageid AND stc.gradecourseid = stm.gradecourseid AND stc.contentareaid=stm.contentareaid
                     AND stc.district = stm.districtname
          WHERE stc.row_num = round((CAST(st_tot AS NUMERIC)*50)/100)
          ORDER BY stc.district, stc.Stagename, stc.grade, stc.Subject;
          
                   
          
\o 'st_median_duration.csv'

WITH stcount AS (
       SELECT stg.id AS stageid,
              gc.id AS gradecourseid,
              ca.id AS contentareaid,
              stg.name AS Stagename,
              gc.name AS Grade,
              ca.abbreviatedname AS Subject,
              round(EXTRACT(EPOCH FROM (enddatetime - startdatetime))/60) AS timetaken,
              ROW_NUMBER() over (PARTITION BY stg.id,gc.id,ca.id ORDER BY (round(EXTRACT(EPOCH FROM (st.enddatetime - st.startdatetime))/60))) as row_num
              FROM studentstests st
              JOIN testsession ts ON (st.testsessionid = ts.id)
              JOIN testcollection tc ON (ts.testcollectionid = tc.id) AND st.testcollectionid=tc.id
              JOIN contentarea ca ON (tc.contentareaid = ca.id)
              JOIN gradecourse gc ON (gc.id=ts.gradecourseid)
              JOIN stage stg ON (ts.stageid = stg.id)
              JOIN student s ON (s.id = st.studentid)
              JOIN enrollment en ON (en.studentid = s.id)           
              WHERE st.startdatetime is not null
              AND st.startdatetime is not null
              AND st.enddatetime is not null
              AND st.activeflag is true
              AND st.status = 86
              AND ts.activeflag is true
              AND st.enddatetime > st.startdatetime
              AND ts.operationaltestwindowid in (10124,10131,10132,10133)),
              stmax AS (
                  SELECT stg.id AS stageid,
                         gc.id AS gradecourseid,
                         ca.id AS contentareaid,
                         count(st.id) AS st_tot
                         FROM studentstests st
                         JOIN testsession ts ON (st.testsessionid = ts.id)
                         JOIN testcollection tc ON (ts.testcollectionid = tc.id) AND st.testcollectionid=tc.id
                         JOIN contentarea ca ON (tc.contentareaid = ca.id)
                         JOIN gradecourse gc ON (gc.id=ts.gradecourseid)
                         JOIN stage stg ON (ts.stageid = stg.id)
                         JOIN student s ON (s.id = st.studentid)
		         JOIN enrollment en ON (en.studentid = s.id)
                         WHERE st.activeflag is true
                         AND st.startdatetime is not null
                         AND st.enddatetime is not null
                         AND st.status = 86
                         AND st.enddatetime > st.startdatetime
                         AND ts.activeflag is true
                         AND ts.operationaltestwindowid in (10124,10131,10132,10133)
                         GROUP BY stg.id,gc.id,ca.id)
       SELECT
          stc.Stagename AS "Stage",
          stc.grade AS "Grade",
          stc.subject AS "Subject",
          stc.timetaken as "Median"
          FROM stcount stc
          INNER JOIN stmax stm ON stc.stageid = stm.stageid AND stc.gradecourseid = stm.gradecourseid AND stc.contentareaid=stm.contentareaid
          WHERE stc.row_num = round((CAST(st_tot AS NUMERIC)*50)/100)
          ORDER BY stc.Stagename, stc.grade, stc.Subject;         
          
          