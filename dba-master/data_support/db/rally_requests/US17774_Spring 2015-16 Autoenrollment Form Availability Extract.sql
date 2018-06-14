   drop table if exists  tmp_cbtestcollectionid ;
              Create temp table tmp_cbtestcollectionid (id integer) ;
              \COPY tmp_cbtestcollectionid FROM 'tmp_cbtestcollectionid_all.csv' DELIMITER ',' CSV HEADER ;

       SELECT DISTINCT tct.testid , 
               t.externalid AS "cbtestid" , 
               t.testname , 
               ( 
                      SELECT array_to_string(array_agg(accessibilityflagcode), ',')
                      FROM   testaccessibilityflag taf 
                      WHERE  ( 
                                    t.id = taf.testid)) AS accessibilityflagcode ,
               tc.id , 
               tc.externalid          AS "cbtestcollectionid" , 
               tc.NAME                AS "testcollectionname" , 
               gc.id                  AS "gradecourse.id" , 
               gc.abbreviatedname     AS "gradecoursename" , 
               gb.id                  AS "gradeband.id" , 
               gb.abbreviatedname     AS "gradebandname" , 
               ca.id                  AS "contentarea.id" , 
               ca.abbreviatedname     AS "contentareaname" , 
               course.id              AS "course.id" , 
               course.abbreviatedname AS "coursename" , 
               tsp.id                    testspecificationsid , 
               tc.phasetype           AS testcollectionphase , 
               tc.pooltype            AS testcollectioncontentpool , 
               tsp.phase              AS testspecphase , 
               tsp.contentpool        AS testspeccontentpool , 
               tsp.minimumnumberofees AS testspecminimumnumberofees , 
               ( 
                      SELECT array_to_string(array_agg(tscontentcode), ',') AS codes
                      FROM   ( 
                                        SELECT     lma.ranking 
                                                              || ' - ' 
                                                              || array_to_string(array_agg(DISTINCT cfd.contentcode), ';') AS tscontentcode
                                        FROM       lmassessmentmodelrule lma
                                        INNER JOIN contentframeworkdetail cfd
                                        ON         lma.contentframeworkdetailid = cfd.id
                                        WHERE      lma.testspecificationid=t.testspecificationid
                                        GROUP BY   lma.ranking) AS a ) testspeccontentcode ,
               ( 
                      SELECT array_to_string(array_agg(DISTINCT cfd.contentcode), ',')
                      FROM   testsection ts 
                      JOIN   testsectionstaskvariants tstv 
                      ON     ( 
                                    ts.id = tstv.testsectionid) 
                      JOIN   taskvariantcontentframeworkdetail tvcfd 
                      ON     tvcfd.taskvariantid = tstv.taskvariantid 
                      JOIN   contentframeworkdetail cfd 
                      ON     cfd.id = tvcfd.contentframeworkdetailid 
                      WHERE  ts.testid=t.id) AS "testcontentcode" 
                          INTO temp tmp_Spring_2015_16_Autoenrollment_Form_Availability_Extract
                FROM            operationaltestwindowstestcollections otwtc 
                LEFT JOIN       testcollectionstests tct       ON  otwtc.testcollectionid=tct.testcollectionid 
                LEFT JOIN       test t                         ON  ( tct.testid = t.id) 
                LEFT JOIN       testspecification tsp          ON  ( tsp.id = t.testspecificationid) 
                LEFT JOIN       testcollection tc              ON  ( tct.testcollectionid = tc.id) 
                LEFT JOIN       contentarea ca                 ON  ( tc.contentareaid = ca.id) 
                LEFT JOIN       gradecourse gc                 ON  ( tc.gradecourseid = gc.id) 
                LEFT JOIN       gradeband gb                   ON  ( tc.gradebandid = gb.id) 
                LEFT JOIN       gradecourse course             ON  ( tc.courseid = course.id) 
                INNER JOIN tmp_cbtestcollectionid tmp on tmp.id=tc.externalid  ; 
		
\COPY tmp_Spring_2015_16_Autoenrollment_Form_Availability_Extract TO 'Spring_2015_16_Autoenrollment_Form_Availability_Extract03092016.csv' DELIMITER '|' CSV HEADER ;


