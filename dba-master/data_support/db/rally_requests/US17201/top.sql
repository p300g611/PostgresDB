   SELECT distinct on(e.studentid)
		 (select displayidentifier from organization_parent(o.id) where organizationtypeid=5 limit 1)     "District Number"
		,(select organizationname from organization_parent(o.id) where organizationtypeid=5 limit 1)      "District Name"                                   
		,o.displayidentifier																 "School Number"
		,o.organizationname																	 "School Name"
		,''																					 "Local ID"
		,''																					 "Teacher ID "
		,'spring'																			 "Term"
		,''														                             "Credit"
		,'English Language Proficiency'														 "Subject / Content Area"
		,'English Language Proficiency'														 "Class"
		,case when gc.name ='Kindergarten' then '00'
			  when gc.name ='Grade 1' then '01'
			  when gc.name ='Grade 2' then '02'
			  when gc.name ='Grade 3' then '03'
			  when gc.name ='Grade 4' then '04'
			  when gc.name ='Grade 5' then '05'
			  when gc.name ='Grade 6' then '06'
			  when gc.name ='Grade 7' then '07'
			  when gc.name ='Grade 8' then '08'
			  when gc.name ='Grade 9' then '09'
			  when gc.name ='Grade 10' then '10'
			  when gc.name ='Grade 11' then '11'
			  when gc.name ='Grade 12' then '12'
			  else '13'	end 																	"Grade"
		,s.id																					"Student ID"
		,s.legallastname																		"Student Last Name"
		,s.legalfirstname																		"Student First Name"
		,s.legalmiddlename																		"Student Middle Initial"
		,to_char(s.dateofbirth::date, 'MMDDYYYY')												"Date of Birth"
		,CASE when s.gender = 0 THEN 'F' ELSE 'M' END                                           "Gender"
		,'N'																					"Ethnicity - Hispanic"
		,'N'																					"Ethnicity - American Indian or Alaska Native"
		,'N'																					"Ethnicity - Asian"
		,'N'																					"Ethnicity - Black or African American"
		,'N'																					"Ethnicity - Native Hawaiian or Other Pacific Islander"
		,'N'																					"Ethnicity - White"
		,'N'																					"Ethnicity - Multiple"
		,'99'																					"Home Language"
		,'N'																					"Disability - Autism"
		,'N'																					"Disability - Deaf-Blindness"
		,'N'																					"Disability - Development Delay "
		,'N'																					"Disability - Emotional Disturbance"
		,'N'																					"Disability - Hearing Impairment "
		,'N'																					"Disability - Intellectual Disability"
		,'N'																					"Disability - Multiple Disabilities"
		,'N'																					"Disability - Orthopedic Impairment"
		,'N'																					"Disability - Other Health Impairment"
		,'N'																					"Disability - Specific Learning Disability"
		,'N'																					"Disability - Speech or Language Impairment"
		,'N'																					"Disability - Traumatic Brain Injury"
		,'N'																					"Disability - Visual Impairment"
		,'N'																					"IEP"
		,'N'																					"Section 504"
		,'N'																					"LEP "
		,'N'																					"Highly Mobile"
		,'N'																					"Economic Disadvantaged"
		,case when (select a.id from usersorganizations uo  
			    INNER JOIN aartuser a on a.id=uo.aartuserid
			    inner join userorganizationsgroups ug on uo.id=ug.userorganizationid
			    inner join groups g on g.id = ug.groupid and g.groupname ='Building Principal'
			    where uo.organizationid=o.id  limit 1) is null then 
                    (select a.surname from  usersorganizations uo 
			    INNER JOIN aartuser a on a.id=uo.aartuserid
			    inner join userorganizationsgroups ug on uo.id=ug.userorganizationid
			    inner join groups g on g.id = ug.groupid and g.groupname ='"District Test Coordinator"'
			    where uo.organizationid in (select id from organization_parent(o.id) where organizationtypeid=5 limit 1) 
			         limit 1 ) 
	               else (select a.surname from usersorganizations uo  
			    INNER JOIN aartuser a on a.id=uo.aartuserid
			    inner join userorganizationsgroups ug on uo.id=ug.userorganizationid
			    inner join groups g on g.id = ug.groupid and g.groupname ='Building Principal'
			    where uo.organizationid=o.id  limit 1) end   											"Teacher Last Name"
		,''																						"Teacher Middle Initial"
		,case when (select a.id from usersorganizations uo  
			    INNER JOIN aartuser a on a.id=uo.aartuserid
			    inner join userorganizationsgroups ug on uo.id=ug.userorganizationid
			    inner join groups g on g.id = ug.groupid and g.groupname ='Building Principal'
			    where uo.organizationid=o.id  limit 1) is null then 
                    (select a.firstname from  usersorganizations uo 
			    INNER JOIN aartuser a on a.id=uo.aartuserid
			    inner join userorganizationsgroups ug on uo.id=ug.userorganizationid
			    inner join groups g on g.id = ug.groupid and g.groupname ='"District Test Coordinator"'
			    where uo.organizationid in (select id from organization_parent(o.id) where organizationtypeid=5 limit 1) 
			         limit 1 ) 
	               else (select a.firstname from usersorganizations uo  
			    INNER JOIN aartuser a on a.id=uo.aartuserid
			    inner join userorganizationsgroups ug on uo.id=ug.userorganizationid
			    inner join groups g on g.id = ug.groupid and g.groupname ='Building Principal'
			    where uo.organizationid=o.id  limit 1) end  									 "Teacher First Name"
		,''																						 "Teacher Email Address"
		FROM student s
						INNER JOIN studentassessmentprogram sap ON sap.studentid = s.id
						INNER JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
						INNER JOIN enrollment e ON e.studentid = s.id and e.activeflag = true
						INNER JOIN gradecourse gc ON gc.id = e.currentgradelevel
						INNER JOIN organization o ON o.id=e.attendanceschoolid
							WHERE a.programname='ELPA21'
							AND e.currentschoolyear = 2016
							AND s.stateid=51
							and s.activeflag=true limit 1000;