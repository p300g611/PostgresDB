
\f ','
\a
\pset expanded off
\o 'HGSS_Tests_Extract_03022016.csv'

SELECT student.id studentid 
      ,student.statestudentidentifier
      ,student.legallastname
      ,student.legalfirstname      
      ,testsession.name testsessionname
      ,test.testname
      ,test.externalid cbtestid
      ,studentsresponses.foilid
      ,taskvariant.externalid cbtaskvariantid
      ,'"'||replace(studentsresponses.response,'"','')||'"' responsetext
      ,studentsresponses.score
      ,taskvariantsfoils.externalfoilid cbfoilid
FROM student
JOIN studentstests ON (studentstests.studentid = student.id
 AND student.statestudentidentifier in ('77708078', '77708079' ,'77708080', '77708081'))
JOIN test ON (studentstests.testid = test.id
 AND test.externalid in (14586, 14954, 14996, 14992, 15025, 15026))
JOIN testsession ON (studentstests.testsessionid = testsession.id)          
JOIN studentsresponses ON (studentsresponses.testid = test.id
 AND studentsresponses.studentid = student.id
 AND studentsresponses.studentstestsid = studentstests.id)
LEFT JOIN taskvariant ON (taskvariant.id = studentsresponses.taskvariantid) 
LEFT JOIN taskvariantsfoils ON (taskvariant.id = taskvariantsfoils.taskvariantid
 AND taskvariantsfoils.foilid = studentsresponses.foilid
 AND taskvariantsfoils.taskvariantid = studentsresponses.taskvariantid)  
ORDER BY student.id
        ,test.externalid
        ,testsession.name
        ,taskvariant.externalid
;
				

--\q

