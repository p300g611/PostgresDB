CREATE TABLE IF NOT EXISTS masterpull as
SELECT DISTINCT
       student.id,
       studentstests.testsectionid,
       studentstests.teststatus,
       studentstests.programname,
       datetime(studentstests.createddate) as createddate,
       datetime(studentstests.startdatetime) as startdatetime,
       datetime(studentstests.enddatetime) as enddatetime,
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
       date(student.dateofbirth) as dateofbirth,
       student.gender,
       student.comprehensiverace,
       student.hispanicethnicity,
       student.primarydisabilitycode,
       student.esolparticipationcode,
       datetime(student.schoolentrydate) as schoolentrydate,
       datetime(student.districtentrydate) as districtentrydate,
       datetime(student.stateentrydate) as stateentrydate,
       student.attendanceschoolidentifier,
       student.aypschoolidentifier,
       student.state,
       student.districtcode,
       student.district,
       student.schoolcode,
       student.school,
       student.activeflag,
       student.organizationid,
       datetime(student.exitwithdrawaldate) as exitwithdrawaldate,
       student.exitwithdrawaltype,
       student.localstudentidentifier,
       educators.firstname as educatorfirstname,
       educators.lastname as educatorlastname,
       educators.username as educatorusername,
       educators.uniqueid as educatorstateid,
       educators.id as educatorkiteid,
       student.final_ela,
       student.final_math,
       student.final_sci,
       student.comm_band,
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
				   LEFT JOIN enrollmentsrosters ON (enrollmentsrosters.enrollmentid = student.enrollmentid)
				   LEFT JOIN roster ON (roster.id = enrollmentsrosters.rosterid)
				   LEFT JOIN studentstests ON (studentstests.studentid = student.id 
				               AND studentstests.rosterid = roster.id AND studentstests.enrollmentid = student.enrollmentid							   
							   AND studentstests.contentareaname NOT IN ('OTH','SS')
							   AND studentstests.programname IS NOT 'Practice'
							   AND studentstests.teststatus IN ('unused','inprogress','complete'))
				   LEFT JOIN test ON studentstests.testid = test.id
				   LEFT JOIN educators on (educators.id = roster.educatorid)
				   LEFT JOIN testsection ON (studentstests.testid = testsection.testid
				                             AND studentstests.testsectionid = testsection.id)
				   LEFT JOIN testsectionstaskvariants ON (testsectionstaskvariants.testsectionid =testsection.id)
				   LEFT JOIN testlet ON testsectionstaskvariants.testletid = testlet.id
				   LEFT JOIN taskvariant ON (taskvariant.id = testsectionstaskvariants.taskvariantid
							   	   AND taskvariant.primarycontentframeworkdetail = '1')
       WHERE student.state NOT IN ('flatland', 'DLM QC State', 'AMP QC State', 'KAP QC State', 'Playground QC State', 'Flatland',
                                    'DLM QC YE State', 'DLM QC IM State', 'DLM QC IM State ', 'DLM QC EOY State','Service Desk QC State','NY Training State','QA QC State')
							   AND student.activeflag = 1
							   AND ((student.activeenrollmentflag=1 AND enrollmentsrosters.activeflag =1 AND roster.activeflag = 1)
							          OR studentstests.teststatus ='complete'
							        )
							   AND ( (roster.id is null and studentstests.id is null) OR 
					                         (roster.statesubjectarea IN ('M','ELA','Sci')) or 
					                         (studentstests.contentareaname ='Sci' and studentstests.teststatus='complete') 
					                        )
							   AND ( (studentstests.teststatus is null) OR 
								     (studentstests.teststatus = 'unused' AND studentstests.createddate > '2017-09-20') OR
								     (studentstests.teststatus IN ('unused','inprogress','complete') 
									   AND (studentstests.startdatetime BETWEEN '2017-09-20' AND '2018-03-02 23:59:59.999' OR
						                                studentstests.startdatetime BETWEEN '2018-03-12' AND '2018-06-08 23:59:59.999'
											)
								      )
								    );
