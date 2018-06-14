BEGIN;

DROP TABLE IF EXISTS temp_student;
DROP TABLE IF EXISTS temp_student_writing_survey_responses;

SELECT sur.studentid, sur.id as surveyid INTO temp_student 
 FROM student stu
 JOIN survey sur ON sur.studentid = stu.id 
 WHERE stu.stateid IN (SELECT organizationid FROM firstcontactsurveysettings WHERE schoolyear = 2018 AND activeflag IS true AND elaflag = true)
 AND sur.status = (SELECT id FROM category WHERE categorycode = 'COMPLETE'
 AND categorytypeid = (SELECT id FROM categorytype WHERE typecode = 'SURVEY_STATUS'))
 AND stu.id IN (SELECT studentid FROM enrollment WHERE currentschoolyear =2018 AND activeflag IS true)
 AND sur.activeflag IS true AND stu.writingbandid IS null;

SELECT COUNT(*) as totalstudents FROM temp_student;

SELECT sr.id AS survey_response_id,sr.responselabel AS response_label,
 sl.id AS survey_label_id,sl.labelnumber AS label_number,
 sl.globalPageNum AS global_page_num,
 ssr.surveyid AS survey_id,
 ssr.id AS student_survey_response_id,
 sl.optional AS optional,
 ssr.activeflag AS active_flag,
 ssr.responsetext AS student_survey_response_text,
 sr.responsevalue AS survey_response_value,
 tempsurvey.studentid INTO temp_student_writing_survey_responses
 FROM surveylabel sl,surveyresponse sr, studentsurveyresponse ssr, temp_student tempsurvey
 WHERE tempsurvey.surveyid = ssr.surveyid AND
 (ssr.surveyresponseid=sr.id) AND sr.labelid=sl.id AND sl.complexityband IS true AND sl.activeflag IS true
 AND sl.labelnumber ='Q500' AND ssr.activeflag IS true; 
 

UPDATE student st SET writingbandid = (SELECT complexitybandid FROM complexitybandrules WHERE rule ilike '%"label":' || tempresponse.survey_label_id
 || ',"responseid":' || tempresponse.survey_response_id || '%'), modifieddate = now(), modifieduser = (SELECT id FROM aartuser WHERE username = 'cetesysadmin')
 FROM temp_student_writing_survey_responses tempresponse
 WHERE st.id = tempresponse.studentid;

DROP TABLE IF EXISTS temp_student;
DROP TABLE IF EXISTS temp_student_writing_survey_responses;

SELECT count(*) AS studentsnotupdated FROM (SELECT sur.studentid, sur.id as surveyid
 FROM student stu 
 JOIN survey sur ON sur.studentid = stu.id 
 WHERE stu.stateid IN (SELECT organizationid FROM firstcontactsurveysettings WHERE schoolyear = 2018 AND activeflag IS true AND elaflag = true)
 AND sur.status = (SELECT id FROM category WHERE categorycode = 'COMPLETE'
 AND categorytypeid = (SELECT id FROM categorytype WHERE typecode = 'SURVEY_STATUS')) 
 AND stu.id IN (SELECT studentid FROM enrollment WHERE currentschoolyear =2018 AND activeflag IS true)
 AND sur.activeflag IS true AND stu.writingbandid IS null)remaing;
 
COMMIT;
