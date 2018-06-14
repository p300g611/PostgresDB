SELECT
      o.organizationname AS "state",
      otw.id AS "windowid",
      otw.windowname AS "windowname",
      otw.effectivedate AS "window_startdatetime",
      otw.expirydate AS "window_enddatetime",
      tc.externalid as "cbtestcollectionid",
      tc.name as "testcollectionname"
      INTO temp table spring_otw_23
      FROM operationaltestwindow otw
      JOIN operationaltestwindowstate otws ON (otw.id = otws.operationaltestwindowid)
      JOIN operationaltestwindowstestcollections otwtc ON (otw.id = otwtc.operationaltestwindowid)
      JOIN testcollection tc ON (otwtc.testcollectionid = tc.id)
      JOIN organization o ON (otws.stateid= o.id)
      WHERE otw.id= 10147;

\copy (SELECT * FROM spring_otw_23) To 'Micosukkee_DLM_ELA_Math_scienceWindow.csv' DELIMITER ',' CSV HEADER;
