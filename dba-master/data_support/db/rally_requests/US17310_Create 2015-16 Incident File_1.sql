SELECT DISTINCT
       tct.testid
      ,t.externalid as "cbtestid"
      ,t.testname
      ,t.accessibleform
      ,(select array_to_string(array_agg(accessibilityflagcode), ',') 
        from testaccessibilityflag taf 
        where (t.id = taf.testid)) as accessibilityflagcode
      ,t.avglinkagelevel
      ,tc.id
      ,tc.externalid as "cbtestcollectionid"
      ,tc.name as "testcollectionname"
      ,tsp.id testspecificationsid
      ,tsp.externalid as "cbtestspecid"
      ,tsp.phase as testspecphase
      ,tsp.contentpool as testspeccontentpool
      ,tsp.minimumnumberofees as testspecminimumnumberofees
      ,tc.phasetype as testcollectionphase
      ,tc.pooltype as testcollectioncontentpool
      ,gc.id AS "gradecourse.id"
      ,gc.abbreviatedname AS "gradecoursename"
      ,gb.id AS "gradeband.id"
      ,gb.abbreviatedname AS "gradebandname"
      ,ca.id AS "contentarea.id"
      ,ca.abbreviatedname AS "contentareaname"
      ,course.id AS "course.id"
      ,course.abbreviatedname AS "coursename"
      ,(SELECT array_to_string(array_agg(tscontentcode), ',') as codes
        FROM (SELECt lma.ranking || ' - ' || array_to_string(array_agg(distinct cfd.contentcode), ';') as tscontentcode 
              FROM lmassessmentmodelrule lma
              INNER JOIN contentframeworkdetail cfd on lma.contentframeworkdetailid = cfd.id
              WHERE lma.testspecificationid=t.testspecificationid
              GROUP BY lma.ranking) as a
        ) "testspeccontentcode"  
      ,(SELECT array_to_string(array_agg(distinct cfd.contentcode), ',') 
        FROM testsection ts 
        JOIN testsectionstaskvariants tstv ON (ts.id = tstv.testsectionid)
	JOIN taskvariantcontentframeworkdetail tvcfd ON (tvcfd.taskvariantid = tstv.taskvariantid)
	JOIN contentframeworkdetail cfd ON (cfd.id = tvcfd.contentframeworkdetailid)
	WHERE ts.testid=t.id) AS "testcontentcode"
FROM  operationaltestwindowstestcollections otwtc
LEFT JOIN testcollectionstests tct on otwtc.testcollectionid=tct.testcollectionid
LEFT JOIN test t on (tct.testid = t.id)
LEFT JOIN testspecification tsp on (tsp.id = t.testspecificationid)
LEFT JOIN testcollection tc on (tct.testcollectionid = tc.id)
LEFT JOIN contentarea ca on (tc.contentareaid = ca.id)
LEFT JOIN gradecourse gc on (tc.gradecourseid = gc.id)
LEFT JOIN gradeband gb on (tc.gradebandid = gb.id)
LEFT JOIN gradecourse course on (tc.courseid = course.id)
WHERE t.qccomplete is true --and status = 64 
AND operationaltestwindowid = 151;
