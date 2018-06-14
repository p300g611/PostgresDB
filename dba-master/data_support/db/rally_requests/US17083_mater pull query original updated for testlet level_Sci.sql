SELECT DISTINCT
       student.id,
       studentstests.testsectionid,
       studentstests.teststatus,
       studentstests.programname,
       datetime(studentstests.createddate) createddate,
       datetime(studentstests.startdatetime) startdatetime,
       datetime(studentstests.enddatetime) enddatetime,
       studentstests.specialcircumstancetype,
       studentstests.specialcircumstancecedscode,
       testsectionstaskvariants.testletid,
       student.statestudentidentifier,
       student.grade,
       student.legalfirstname,
       student.legalmiddlename,
       student.legallastname,
       student.generationcode,
       student.username,
       student.firstlanguage,
       date(student.dateofbirth) dateofbirth,
       student.gender,
       student.comprehensiverace,
       student.hispanicethnicity,
       student.primarydisabilitycode,
       student.esolparticipationcode,
       datetime(student.schoolentrydate) schoolentrydate,
       datetime(student.districtentrydate) districtentrydate,
       datetime(student.stateentrydate) stateentrydate,
       student.attendanceschoolidentifier,
       student.aypschoolidentifier as fundingschool,
       student.state,
       student.districtcode,
       student.district,
       student.schoolcode,
       student.school,
       student.activeflag,
       student.organizationid,
       datetime(student.exitwithdrawaldate) exitwithdrawaldate,
       student.exitwithdrawaltype,
       educators.firstname,
       educators.lastname,
       educators.username,
       educators.uniqueid,
       student.final_ela,
       student.final_math,
       student.localstudentidentifier,
       test.testname,
       test.avglinkagelevel,
       test.externaltestspecificationid,
       test.specificationname,
       test.accessibilityflagcode,
       testlet.gradecourse,
       testlet.externalid as testletexternalid,
       testlet.testletname,
       roster.statecourses
       FROM student
				   LEFT JOIN enrollmentsrosters ON (enrollmentsrosters.enrollmentid = student.enrollmentid )
				   LEFT JOIN roster ON (roster.id = enrollmentsrosters.rosterid )
				   LEFT JOIN studentstests ON (studentstests.studentid = student.id 
				               AND studentstests.rosterid = roster.id
							   AND studentstests.enrollmentid = student.enrollmentid
							   AND studentstests.contentareaname IN ('Sci')
							   AND studentstests.programname IS NOT 'Practice'
							   AND studentstests.teststatus IN ('unused','inprogress','complete'))
				   LEFT JOIN test ON studentstests.testid = test.id
				   LEFT JOIN educators on (educators.id = roster.educatorid AND educators.schoolid = student.organizationid)
				   LEFT JOIN testsection ON (studentstests.testid = testsection.testid
				                             AND studentstests.testsectionid = testsection.id)
				   LEFT JOIN testsectionstaskvariants ON (testsectionstaskvariants.testsectionid =testsection.id)
				   LEFT JOIN testlet ON testsectionstaskvariants.testletid = testlet.id
				   LEFT JOIN taskvariant ON (taskvariant.id = testsectionstaskvariants.taskvariantid
							   	   AND taskvariant.primarycontentframeworkdetail = '1')
       WHERE student.state NOT IN ('flatland', 'DLM QC State', 'AMP QC State', 'KAP QC State', 'Playground QC State', 'Flatland',
                                    'DLM QC YE State', 'DLM QC IM State', 'DLM QC IM State ', 'DLM QC EOY State')
							   AND student.activeflag = 1
							   AND ((student.activeenrollmentflag=1 AND enrollmentsrosters.activeflag =1 AND roster.activeflag =1)
							          OR studentstests.teststatus IN ('complete')
							        )
							   AND ( (studentstests.contentareaname IN ('Sci') and studentstests.teststatus IN ('complete')) OR 
					                         (roster.statesubjectarea IN ('Sci'))
					                        )
							   AND ( (studentstests.teststatus is null) OR 
								     (studentstests.teststatus = 'unused' AND studentstests.createddate > '2015-11-07') OR
								     (studentstests.teststatus = 'unused' AND studentstests.createddate > '2016-03-13') OR
								     (studentstests.teststatus IN ('unused','inprogress','complete') 
									   AND (studentstests.startdatetime BETWEEN '2015-11-09' AND '2016-03-14 23:59:59.999' OR
											studentstests.startdatetime BETWEEN '2016-03-16' AND '2016-06-10 23:59:59.999' 
											)
								      )
								    );