SELECT count(*)
FROM student s
JOIN studentstests st ON (s.id = st.studentid)
JOIN test t ON (st.testid = t.id)
JOIN testsession ts ON (t.id = ts.testid)
JOIN stage stg ON (ts.stageid = stg.id)
JOIN operationaltestwindow otw ON (ts.operationaltestwindowid = otw.id)
JOIN studentassessmentprogram sap ON sap.studentid = s.id
JOIN assessmentprogram a ON sap.assessmentprogramid = a.id
WHERE stg.id = 1 and sap.assessmentprogramid=12;
