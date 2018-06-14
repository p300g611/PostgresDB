CREATE TABLE IF NOT EXISTS masterpull_item as
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
       testsectionstaskvariants.taskvariantid,
       testsectionstaskvariants.testletid,
       taskvariant.externalid as externaltaskid,
       taskvariant.contentareaname,
       taskvariant.contentframeworkdetailcode,
       taskvariant.nodecode,
       taskvariant.essentialelementlinkage,
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
       studentsresponses.foildid,
       studentsresponses.score,
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
       taskvariantsfoils.foilsorder,
       roster.statecourses,
	   student.writing_band,
	   testcollection.name testcollectname,
	   case when testcollection.gradecourse is not null then testcollection.gradecourse 
            else testcollection.gradeband end itemgrade,
	   studentstests.windowid,
	   testcollection.pooltype,
	   studentstests.source,
       studentstests.model,
	   case when studentstests.windowid in (10235,10237,10242,10243,10244,10257) then 'ITI'
	        else 'Spring' end as window, 
	   case when studentstests.windowid in (10269,10287,10296,10271,10285,10294,10273,10275,10277,10292,10279,10283,10281,10289,10260,10263,10265,10267) then 'Fieldtest' 
	     else 'Operational' end  as pool,
	   studentsresponses.readableresponse,	 
	   studentsresponses.responsetext	 
       FROM student
				   LEFT JOIN enrollmentsrosters ON (enrollmentsrosters.enrollmentid = student.enrollmentid)
				   LEFT JOIN roster ON (roster.id = enrollmentsrosters.rosterid )
				   LEFT JOIN studentstests ON (studentstests.studentid = student.id
				           AND studentstests.rosterid = roster.id
				             AND studentstests.enrollmentid = student.enrollmentid					       
					       AND studentstests.contentareaname not in ('OTH') 
					       AND studentstests.programname IS NOT 'Practice'
					       AND studentstests.teststatus IN ('unused','inprogress','complete'))
				   LEFT JOIN test ON studentstests.testid = test.id
				   LEFT JOIN testcollection on testcollection.id=studentstests.testcollectionid
				   LEFT JOIN educators on (educators.id = roster.educatorid)
				   LEFT JOIN testsection ON (studentstests.testid = testsection.testid AND studentstests.testsectionid = testsection.id)
				   LEFT JOIN testsectionstaskvariants ON (testsectionstaskvariants.testsectionid =testsection.id)
				   LEFT JOIN testlet ON testsectionstaskvariants.testletid = testlet.id
				   LEFT JOIN taskvariant ON (taskvariant.id = testsectionstaskvariants.taskvariantid
							     AND taskvariant.primarycontentframeworkdetail = '1')
				   LEFT JOIN studentsresponses ON (studentsresponses.studentstestsectionsid = studentstests.studentstestssectionsid
							       AND studentsresponses.taskvariantid = taskvariant.id )
				   LEFT JOIN taskvariantsfoils ON taskvariantsfoils.foilid = studentsresponses.foildid
       WHERE student.state NOT IN ('flatland', 'DLM QC State', 'AMP QC State', 'KAP QC State', 'Playground QC State', 'Flatland',
                                    'DLM QC YE State', 'DLM QC IM State', 'DLM QC IM State ', 'DLM QC EOY State','Service Desk QC State','NY Training State','QA QC State')
			   AND student.activeflag = 1
			   AND ((student.activeenrollmentflag=1 AND enrollmentsrosters.activeflag = 1 AND roster.activeflag = 1)
				  OR studentstests.teststatus IN ('complete')
				)
			   AND ( (roster.id is null and studentstests.id is null)  
				  or roster.statesubjectarea IN ('M','ELA','Sci')
				  or (student.state ='Wisconsin' AND roster.statesubjectarea ='SS' AND taskvariant.externalid in (58644,58645,58095))
				  or (studentstests.teststatus='complete' and studentstests.contentareaname ='Sci')
				  or (student.state='Wisconsin' and studentstests.teststatus='complete' and studentstests.contentareaname ='SS'
					    AND taskvariant.externalid in (58644,58645,58095))
				  or (student.state in('Kansas','Oklahoma') AND roster.statesubjectarea ='SS')
				  or (student.state in('Kansas','Oklahoma') and studentstests.teststatus='complete' and studentstests.contentareaname ='SS')		
			       )			        
			   AND ( (studentstests.teststatus is null) OR
				 (studentstests.teststatus = 'unused' AND studentstests.createddate > '2017-09-20') OR
				 (studentstests.teststatus IN ('unused','inprogress','complete')
					   AND (studentstests.startdatetime BETWEEN '2017-09-20' AND '2018-03-02 23:59:59.999' OR
						studentstests.startdatetime BETWEEN '2018-03-12' AND '2018-06-08 23:59:59.999'
						)
				  )
				);