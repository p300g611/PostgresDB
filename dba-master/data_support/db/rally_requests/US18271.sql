select  s.statestudentidentifier AS "State Student ID",
            attendanceSchool.schoolname AS "School Name",
      	attendanceSchool.districtname AS "District Name",
            otw.windowname AS "Test Window Name",
            ts.name AS "Test Session Name",
            ca.abbreviatedname AS "Subject",
            gc.name as "Grade",
            stg.id AS "Stage",
            tc.externalid AS "Test Collection ID",
            t.externalid AS "cbtestid",
            t.id AS "eptestid",
            t.testname AS "Test Name",
            c.categoryname AS "Student Test Status",
            ((st.startdatetime AT TIME ZONE 'GMT' ) AT TIME ZONE 'CDT') AS "Student Test Start Time",
            ((st.enddatetime AT TIME ZONE 'GMT' ) AT TIME ZONE 'CDT') AS "Student Test End Time"
        INTO temp table tmp_ak
        from studentstests st
      	JOIN testsession ts ON ts.id = st.testsessionid
      	JOIN student s ON (s.id = st.studentid)
      	JOIN category c ON (st.status = c.id)
      	JOIN organizationtreedetail attendanceSchool ON (attendanceSchool.schoolid = ts.attendanceschoolid)
      	JOIN testcollection tc ON tc.id = ts.testcollectionid
      	JOIN test t ON (st.testid = t.id)
      	JOIN enrollment e on e.id=st.enrollmentid
      	LEFT JOIN contentarea ca ON (tc.contentareaid = ca.id)
      	LEFT JOIN gradecourse course ON (tc.courseid = course.id)
      	LEFT JOIN gradecourse gc ON (e.currentgradelevel = gc.id)
      	LEFT JOIN stage stg ON (ts.stageid = stg.id)
      	JOIN operationaltestwindow otw ON (ts.operationaltestwindowid = otw.id)
       WHERE s.activeflag = 'true'
       AND e.currentschoolyear =2016
       AND e.activeflag = 'true'
       AND st.activeflag = 'true'
       AND ts.activeflag = 'true'
       AND ts.operationaltestwindowid in (10148,10156,10158);


\copy (SELECT * FROM tmp_ak) TO 'US18271.csv' DELIMITER ',' CSV HEADER;
