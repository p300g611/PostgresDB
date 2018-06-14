SELECT DISTINCT
      student.id,
      studentstests.testsectionid,
      studentstests.teststatus,
      studentstests.programname,
      studentstests.createddate,
      studentstests.startdatetime,
      studentstests.enddatetime,
      testsectionstaskvariants.taskvariantid,
      testsectionstaskvariants.testletid,
      taskvariant.externalid,
      taskvariant.contentareaname,
      taskvariant.contentframeworkdetailcode,
      taskvariant.nodecode,
      taskvariant.essentialelementlinkage,
      student.statestudentidentifier,
      student.aypschoolidentifier,
      student.grade,
      student.legalfirstname,
      student.legalmiddlename,
      student.legallastname,
      student.generationcode,
      student.username,
      student.firstlanguage,
      student.dateofbirth,
      student.gender,
      student.comprehensiverace,
      student.hispanicethnicity,
      student.primarydisabilitycode,
      student.esolparticipationcode,
      student.schoolentrydate,
      student.districtentrydate,
      student.stateentrydate,
      student.attendanceschoolidentifier,
      student.[state],
      student.districtcode,
      student.district,
      student.schoolcode,
      student.school,
      student.activeflag,
      student.organizationid,
      student.exitwithdrawaldate,
      student.exitwithdrawaltype,
      studentsresponses.foildid,
      studentsresponses.score,
      educators.firstname,
      educators.lastname,
      educators.username,
      educators.uniqueid,
      student.final_ela,
      student.final_math,
      studentsresponses.responsetext,
      test.testname,
      test.avglinkagelevel,
      testlet.gradecourse,
      testlet.externalid as testletexternalid,
      testlet.testletname
  FROM student
  LEFT JOIN enrollmentsrosters ON (enrollmentsrosters.enrollmentid = student.enrollmentid AND enrollmentsrosters.activeflag = '1')
  LEFT JOIN roster ON (roster.id = enrollmentsrosters.rosterid and roster.activeflag = '1')
  LEFT JOIN studentstests ON (studentstests.studentid = student.id
							  AND studentstests.enrollmentid = student.enrollmentid
							  AND studentstests.programname IS NOT 'Practice'
							  AND studentstests.teststatus IN ('unused','inprogress', 'complete'))
  LEFT JOIN test ON studentstests.testid = test.id
  LEFT JOIN educators on (educators.id = roster.educatorid AND educators.schoolid = student.organizationid)
  JOIN testsection ON (studentstests.testid = testsection.testid)
  JOIN testsectionstaskvariants ON (testsectionstaskvariants.testsectionid =testsection.id)
  LEFT JOIN testlet ON testsectionstaskvariants.testletid = testlet.id
  JOIN taskvariant ON (taskvariant.id = testsectionstaskvariants.taskvariantid
							  AND taskvariant.contentareaname NOT IN ('Sci','OTH')
							  AND taskvariant.primarycontentframeworkdetail = '1')
  LEFT JOIN studentsresponses ON (studentsresponses.studentstestsectionsid = studentstests.studentstestssectionsid
                              AND studentsresponses.taskvariantid = taskvariant.id )
  LEFT JOIN taskvariantsfoils ON taskvariantsfoils.foilid = studentsresponses.foildid
    WHERE   student.state NOT IN ('flatland','DLM QC State','AMP QC State','KAP QC State',
	                              'Playground QC State','Flatland','DLM QC YE State',
								  'DLM QC IM State','DLM QC IM State ','DLM QC EOY State')
          AND student.activeflag = 1
          AND(    
		             (studentstests.teststatus = 'unused' AND studentstests.createddate > '2014-11-01')  OR
                     (studentstests.teststatus IN ('unused','inprogress','complete')
	          AND 
			         (studentstests.startdatetime BETWEEN '2015-03-12' AND '2015-06-15 23:59:59.999' OR
				      studentstests.startdatetime BETWEEN '2015-01-05' AND '2015-03-06 23:59:59.999' OR
				      studentstests.startdatetime BETWEEN '2014-11-10' AND '2014-12-19 23:59:59.999'))
             );

--Compare previous query results to updated query results to verify no student records are now removed due to this addition
--Due Date: December 14, 2015

