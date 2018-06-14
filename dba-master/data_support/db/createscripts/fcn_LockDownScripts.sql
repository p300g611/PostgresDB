--ddl/546.sql -- addStudentToRosterWithCourse with return messages
--upgraded version from 522 to 539 to 546 to 549
-- DLM Lockdown Service Desk Data Scripts
-- Scenario 2.1: Adding student to roster with NO course. (Not transfering any completed testsessions to new roster).

DROP FUNCTION IF EXISTS addStudentToRosterWithNOCourse(character varying, character varying, character varying, bigint, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION addStudentToRosterWithNOCourse(state_student_identifier character varying, att_sch_displayidentifier character varying, ayp_sch_displayidentifier character varying, schoolyear bigint,
      subject_abbrName character varying, teacher_uniqueCommonId character varying, roster_name character varying, stateDisplayidentifier character varying) RETURNS TEXT AS

$BODY$
   DECLARE
   state_Id BIGINT;
   att_sch_id BIGINT;
   ayp_sch_id BIGINT;
   ceteSysAdminUserId BIGINT;
   contentArea_Id BIGINT;
   subject_Id BIGINT;
   teacher_Id BIGINT;
   rosterRecord RECORD;
   enrollmentRecord RECORD;
   enrlRecords RECORD;
   enrl_Id BIGINT;
   error_msg TEXT;

 BEGIN
   error_msg :='';
   
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1 
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(state_student_identifier,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE  
   SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true); 
   SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
   SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
   SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin' and activeflag is true);
   SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true LIMIT 1);
   SELECT INTO teacher_Id (SELECT DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE uso.organizationid = att_sch_id AND au.activeflag is true AND  case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(teacher_uniqueCommonId)) LIMIT 1);
   IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE
   IF((SELECT count(*) FROM roster r WHERE   r.activeflag is true AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id
                          AND currentschoolyear = schoolyear AND teacherid = teacher_Id) ) <= 0 THEN

     RAISE NOTICE 'No rosters found with roster name: %, subject: %, attendanceschool: %, teacher: %, and school year: %  ', roster_name, subject_abbrName, att_sch_displayidentifier,
          teacher_uniqueCommonId, schoolyear;
     error_msg := '<error>'||'No rosters found for studentid:'||COALESCE(state_student_identifier,'NULL')||';with roster name:'||COALESCE(roster_name,'NULL')||';subject:'||COALESCE(subject_abbrName,'NULL')||';attendanceschool:'||COALESCE(att_sch_displayidentifier,'NULL')||';teacher:'||COALESCE(teacher_uniqueCommonId,'NULL')||';and school year:'||CAST(COALESCE(schoolyear,0) AS TEXT);
   ELSE
    IF((SELECT count(en.*) FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear AND en.attendanceschoolid = att_sch_id
           AND trim(stu.statestudentidentifier) = trim(state_student_identifier) AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true) <= 0 ) THEN

        RAISE NOTICE 'Student % is not found with attendance %  in school year %', state_student_identifier, att_sch_displayidentifier, schoolyear;
        error_msg := '<error>'||'Studentid:'||COALESCE(state_student_identifier,'NULL')||'; not found attendance:'||COALESCE(att_sch_displayidentifier,'NULL')||';in school year:'||CAST(COALESCE(schoolyear,0) AS TEXT);
    ELSE
         FOR enrollmentRecord IN(SELECT en.* FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear  AND en.attendanceschoolid = att_sch_id
           AND trim(stu.statestudentidentifier) = trim(state_student_identifier) AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true)
       LOOP
         FOR rosterRecord IN(SELECT r.* FROM roster r WHERE lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND r.attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id
                          AND currentschoolyear = schoolyear AND teacherid = teacher_Id AND r.activeflag is true)
        LOOP
           IF((SELECT count(*) FROM enrollmentsrosters WHERE enrollmentid = enrollmentRecord.id AND rosterid = rosterRecord.id) <= 0) THEN

  	INSERT INTO enrollmentsrosters(enrollmentid, rosterid, createddate, createduser, activeflag, modifieddate, modifieduser)
                         VALUES (enrollmentRecord.id, rosterRecord.id, now(), ceteSysAdminUserId, true, now(), ceteSysAdminUserId) RETURNING id INTO enrl_Id;

                INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrl_Id, ceteSysAdminUserId, now(),
		      'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || rosterRecord.id || ', "enrollmentId":' ||  enrollmentRecord.id || ',"enrollmentRosterId":' || enrl_Id || '}')::json);

		RAISE NOTICE 'Student % is added to the roster %', state_student_identifier, roster_name;
    error_msg := '<success>'||'Studentid:'||COALESCE(state_student_identifier,'NULL')||'; added to the roster:'||COALESCE(roster_name,'NULL');

		 PERFORM moveCompletedTestsAndResetSTWithNoCourse(student_id := enrollmentRecord.studentid, enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id, new_roster_id := rosterRecord.id, school_year:=schoolyear, attendance_schId := att_sch_id);
	   ELSE
	      FOR enrlRecords IN (SELECT * FROM enrollmentsrosters WHERE enrollmentid = enrollmentRecord.id AND rosterid = rosterRecord.id LIMIT 1)
	        LOOP
                  UPDATE enrollmentsrosters SET activeflag = true, modifieddate = now(), modifieduser = ceteSysAdminUserId WHERE id = enrlRecords.id;

	          INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrlRecords.id, ceteSysAdminUserId, now(),
		      'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || enrlRecords.rosterid || ', "enrollmentId":' ||  enrlRecords.enrollmentid || ',"enrollmentRosterId":' || enrlRecords.id || '}')::json);

		  RAISE NOTICE 'Student % is added to the roster %', state_student_identifier, roster_name;
      error_msg = '<success>'||'Studentid:'||COALESCE(state_student_identifier,'NULL')||';  added to the roster '||COALESCE(roster_name,'NULL');
                  PERFORM moveCompletedTestsAndResetSTWithNoCourse(student_id := enrollmentRecord.studentid, enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id, new_roster_id := enrlRecords.rosterid, school_year:=schoolyear, attendance_schId := att_sch_id);

	      END LOOP;
	 END IF;
        END LOOP;
     END LOOP;
     END IF;
   END IF; 
END IF;
END IF;
RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;

--Author : Rohit Yadav
-- DLM Lockdown Service Desk Data Scripts
-- Scenario 2.2: Adding student to roster with course. (Not transfering any completed testsessions to new roster).

DROP FUNCTION IF EXISTS addStudentToRosterWithCourse(character varying, character varying, character varying, bigint, character varying, character varying, character varying,
      character varying, character varying);

CREATE OR REPLACE FUNCTION addStudentToRosterWithCourse(state_student_identifier character varying, att_sch_displayidentifier character varying, ayp_sch_displayidentifier character varying, schoolyear bigint,
      subject_abbrName character varying, course_Abbrname character varying, teacher_uniqueCommonId character varying,
      roster_name character varying, stateDisplayidentifier character varying) RETURNS TEXT AS

$BODY$
   DECLARE
   state_Id BIGINT;
   att_sch_id BIGINT;
   ayp_sch_id BIGINT;
   ceteSysAdminUserId BIGINT;
   contentArea_Id BIGINT;
   subject_Id BIGINT;
   teacher_Id BIGINT;
   rosterRecord RECORD;
   enrollmentRecord RECORD;
   enrlRecords RECORD;
   course_Id BIGINT;
   enrl_Id BIGINT;
   error_msg TEXT;

 BEGIN
   error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(state_student_identifier,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE 
   SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);

   SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
   SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
   SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
   SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true LIMIT 1);
   SELECT INTO teacher_Id (SELECT DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid = att_sch_id AND case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(teacher_uniqueCommonId)) LIMIT 1);
   SELECT INTO course_Id (SELECT id FROM gradecourse WHERE lower(trim(abbreviatedname)) = lower(trim(course_Abbrname)) AND course is true AND activeflag is true LIMIT 1);
  error_msg ='';
        IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE
        IF(course_Id is null) THEN

         RAISE NOTICE 'course_Id % is invalid', course_Abbrname;

         error_msg := '<error>' || 'invalid value on course_abbrName:' || COALESCE(course_Abbrname,'NULL');

     ELSE 

   IF((SELECT count(*) FROM roster r WHERE lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id AND r.statecoursesid = course_Id
                          AND currentschoolyear = schoolyear AND teacherid = teacher_Id AND r.activeflag is true)) <= 0 THEN

     RAISE NOTICE 'No rosters found for student:%, with roster name: %, subject: %, course: %, attendanceschool: %, teacher: %, and school year: %  ', state_student_identifier,roster_name, subject_abbrName, course_Abbrname, att_sch_displayidentifier,
          teacher_uniqueCommonId, schoolyear;
     error_msg := '<error>'||'No rosters found for studentid:'||COALESCE(state_student_identifier,'NULL')||';with roster name:'||COALESCE(roster_name,'NULL')||';subject:'||COALESCE(subject_abbrName,'NULL')||';course:'||COALESCE(course_Abbrname,'NULL')||';attendanceschool:'||COALESCE(att_sch_displayidentifier,'NULL')||';teacher:'||COALESCE(teacher_uniqueCommonId,'NULL')||';and school year:'||CAST(COALESCE(schoolyear,0) AS TEXT);

   ELSE
    IF((SELECT count(en.*) FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear AND en.attendanceschoolid = att_sch_id
           AND trim(stu.statestudentidentifier) = trim(state_student_identifier) AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true) <= 0 ) THEN

        RAISE NOTICE 'Studentid % not found with attendance %  in school year %', state_student_identifier, att_sch_displayidentifier, schoolyear;
        error_msg := '<error>'||'Studentid:'||COALESCE(state_student_identifier,'NULL')||'; not found attendance:'||COALESCE(att_sch_displayidentifier,'NULL')||';in school year:'||CAST(COALESCE(schoolyear,0) AS TEXT);
    ELSE
         FOR enrollmentRecord IN(SELECT en.* FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear AND en.attendanceschoolid = att_sch_id
           AND trim(stu.statestudentidentifier) = trim(state_student_identifier) AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true)
       LOOP
         FOR rosterRecord IN(SELECT r.* FROM roster r WHERE  r.activeflag is true AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id AND r.statecoursesid = course_Id
                          AND currentschoolyear = schoolyear AND teacherid = teacher_Id)
        LOOP
           IF((SELECT count(*) FROM enrollmentsrosters WHERE  enrollmentid = enrollmentRecord.id AND rosterid = rosterRecord.id) <= 0) THEN

INSERT INTO enrollmentsrosters(enrollmentid, rosterid, createddate, createduser, activeflag, modifieddate, modifieduser)
                         VALUES (enrollmentRecord.id, rosterRecord.id, now(), ceteSysAdminUserId, true, now(), ceteSysAdminUserId) RETURNING id INTO enrl_Id;

                INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrl_Id, ceteSysAdminUserId, now(),
     'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || rosterRecord.id || ', "enrollmentId":' ||  enrollmentRecord.id || ',"enrollmentRosterId":' || enrl_Id || '}')::json);

RAISE NOTICE 'Studentid % added to the roster %', state_student_identifier, roster_name;
    error_msg := '<success>'||'Studentid:'||COALESCE(state_student_identifier,'NULL')||';  added to the roster:'||COALESCE(roster_name,'NULL');

                 PERFORM moveCompletedTestsAndResetSTWithCourse(student_id := enrollmentRecord.studentid,enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id,
                         course_Id := course_Id, new_roster_id := rosterRecord.id, school_year := schoolyear, attendance_schId := att_sch_id);

  ELSE
     FOR enrlRecords IN (SELECT * FROM enrollmentsrosters WHERE enrollmentid = enrollmentRecord.id AND rosterid = rosterRecord.id LIMIT 1)
       LOOP
                  UPDATE enrollmentsrosters SET activeflag = true, modifieddate = now(), modifieduser = ceteSysAdminUserId WHERE id = enrlRecords.id;

         INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrlRecords.id, ceteSysAdminUserId, now(),
     'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || enrlRecords.rosterid || ', "enrollmentId":' ||  enrlRecords.enrollmentid || ',"enrollmentRosterId":' || enrlRecords.id || '}')::json);

 RAISE NOTICE 'Studentid % added to the roster %', state_student_identifier, roster_name;
 error_msg := '<success>'||'Studentid:'||COALESCE(state_student_identifier,'NULL')||';  added to the roster:'||COALESCE(roster_name,'NULL');


 PERFORM moveCompletedTestsAndResetSTWithCourse(student_id := enrollmentRecord.studentid,enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id,
            course_Id := course_Id, new_roster_id := enrlRecords.rosterid, school_year := schoolyear, attendance_schId := att_sch_id);

     END LOOP;
  END IF;
        END LOOP;
     END LOOP;
     END IF;
   END IF;
   END IF;
   END IF;
   END IF;
RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;



-- US17061: DLM Lockdown Service Desk Data Scripts
-- Scenario 4.1: Creating new roster with only subject.

DROP FUNCTION IF EXISTS createNewRosterWithNoCourse(character varying[], character varying, character varying, bigint, character varying, character varying, character varying, character varying);


CREATE OR REPLACE FUNCTION createNewRosterWithNoCourse(state_student_identifiers character varying[], att_sch_displayidentifier character varying, ayp_sch_displayidentifier character varying, schoolyear bigint,
      subject_abbrName character varying, teacher_uniqueCommonId character varying, roster_name character varying, stateDisplayidentifier character varying) RETURNS TEXT AS

$BODY$
   DECLARE
   state_Id BIGINT;
   att_sch_id BIGINT;
   ayp_sch_id BIGINT;
   ceteSysAdminUserId BIGINT;
   contentArea_Id BIGINT;
   subject_Id BIGINT;
   teacher_Id BIGINT;
   rosterRecord RECORD;
   enrollmentRecord RECORD;
   enrlRecords RECORD;
   enrl_Id BIGINT;
   roster_Id BIGINT;
   error_msg TEXT;
   student_identify TEXT;

 BEGIN
   student_identify:=  state_student_identifiers::TEXT;
   error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(state_student_identifiers,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE 
   SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
   SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
   SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
   SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin' AND activeflag is true);
   SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true LIMIT 1);
   SELECT INTO teacher_Id (SELECT DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id AND case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(teacher_uniqueCommonId)) LIMIT 1);
   error_msg := '';
   IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE
  IF((SELECT count(en.*) FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear  AND en.attendanceschoolid = att_sch_id
           AND trim(stu.statestudentidentifier) = ANY(state_student_identifiers)AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true) <= 0) THEN

        RAISE NOTICE 'Student % is not found with  attendance %  in school year %', student_identify, att_sch_displayidentifier, schoolyear;
        error_msg := '<error>'||'Studentid:'||COALESCE(student_identify,'NULL')||'; not found attendance:'||COALESCE(att_sch_displayidentifier,'NULL')||';in school year:'||CAST(COALESCE(schoolyear,0) AS TEXT);
    ELSE
   IF((SELECT count(*) FROM roster r WHERE  r.activeflag is true AND  lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id
                          AND currentschoolyear = schoolyear AND teacherid = teacher_Id)) <= 0 THEN

     RAISE NOTICE 'No rosters found with roster name: %, subject: %, attendanceschool: %, teacher: %, and school year: %, So creating new roster.  ',
                  roster_name, subject_abbrName, att_sch_displayidentifier, teacher_uniqueCommonId, schoolyear;
    error_msg := '<validation>' || 'No rosters found with roster name:'|| COALESCE(roster_name,'NULL')||';subject:'||COALESCE(subject_abbrName,'NULL')||';attendanceschool:'
                  ||COALESCE(att_sch_displayidentifier,'NULL')||';teacher:'||COALESCE(teacher_uniqueCommonId,'NULL')||';and school year:'||CAST(COALESCE(schoolyear,0) AS TEXT)||
                  ' So creating new roster.';
     IF(teacher_Id is null) THEN

         RAISE NOTICE 'Teacher % is not found in the organization %', teacher_uniqueCommonId, att_sch_displayidentifier;

         error_msg := '<error>' || 'Teacher:' || COALESCE(teacher_uniqueCommonId,'NULL')|| ';  not found in school:' || COALESCE(att_sch_displayidentifier,'NULL');

     ELSE
          INSERT INTO roster(coursesectionname, teacherid, attendanceSchoolId, statesubjectareaid, restrictionid, createddate, createduser, activeflag, modifieddate, modifieduser,
		educatorschooldisplayidentifier, sourcetype, currentSchoolYear, aypSchoolId)
		VALUES(roster_name, teacher_Id, att_sch_id, subject_Id, 1, now(), ceteSysAdminUserId, true, now(), ceteSysAdminUserId,att_sch_displayidentifier,
                'LOCK_DOWN_SCRIPT', schoolyear, ayp_sch_id) RETURNING id INTO roster_Id;

	FOR enrollmentRecord IN(SELECT stu.statestudentidentifier,en.* FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear AND en.attendanceschoolid = att_sch_id
          AND stu.statestudentidentifier = ANY(state_student_identifiers)AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true)
        LOOP

          INSERT INTO enrollmentsrosters(enrollmentid, rosterid, createddate, createduser, activeflag, modifieddate, modifieduser)
                      VALUES (enrollmentRecord.id, roster_Id, now(), ceteSysAdminUserId, true, now(), ceteSysAdminUserId) RETURNING id INTO enrl_Id;

          INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrl_Id, ceteSysAdminUserId, now(),
		      'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || roster_Id || ', "enrollmentId":' ||  enrollmentRecord.id || ',"enrollmentRosterId":' || enrl_Id || '}')::json);

           RAISE NOTICE 'Student % is added to the roster %', enrollmentRecord.statestudentidentifier, roster_name;

            error_msg :=  '<success>' || 'Student:' || COALESCE(enrollmentRecord.statestudentidentifier,'NULL') || ';  added to the roster:' || COALESCE(roster_name,'NULL');

           PERFORM moveCompletedTestsAndResetSTWithNoCourse(student_id := enrollmentRecord.studentid,enrollment_id := enrollmentRecord.id,
                 subjectArea_id := subject_Id, new_roster_id := roster_Id, school_year := schoolyear, attendance_schId := att_sch_id);

        END LOOP;
     END IF;
   ELSE
    FOR enrollmentRecord IN(SELECT stu.statestudentidentifier, en.* FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear AND en.attendanceschoolid = att_sch_id
         AND trim(stu.statestudentidentifier) = ANY(state_student_identifiers)AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true)
     LOOP
        FOR rosterRecord IN(SELECT r.* FROM roster r WHERE r.activeflag is true AND  lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id
                        AND currentschoolyear = schoolyear AND teacherid = teacher_Id)
	 LOOP
           IF((SELECT count(*) FROM enrollmentsrosters WHERE enrollmentid = enrollmentRecord.id AND rosterid = rosterRecord.id) <= 0) THEN

	       INSERT INTO enrollmentsrosters(enrollmentid, rosterid, createddate, createduser, activeflag, modifieddate, modifieduser)
                      VALUES (enrollmentRecord.id, rosterRecord.id, now(), ceteSysAdminUserId, true, now(), ceteSysAdminUserId) RETURNING id INTO enrl_Id;

               INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrl_Id, ceteSysAdminUserId, now(),
		      'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || rosterRecord.id || ', "enrollmentId":' ||  enrollmentRecord.id || ',"enrollmentRosterId":' || enrl_Id || '}')::json);

	      RAISE NOTICE 'Student % is added to the roster %', enrollmentRecord.statestudentidentifier, roster_name;

	      error_msg :=  '<success>' || 'Student:' || COALESCE(enrollmentRecord.statestudentidentifier,'NULL') || ';  added to the roster:' || COALESCE(roster_name,'NULL');

	      PERFORM moveCompletedTestsAndResetSTWithNoCourse(student_id := enrollmentRecord.studentid,enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id,
	                 new_roster_id := rosterRecord.id, school_year := schoolyear, attendance_schId := att_sch_id);

	   ELSE
	      FOR enrlRecords IN (SELECT * FROM enrollmentsrosters WHERE enrollmentid = enrollmentRecord.id AND rosterid = rosterRecord.id LIMIT 1)
	        LOOP
                  UPDATE enrollmentsrosters SET activeflag = true, modifieddate = now(), modifieduser = ceteSysAdminUserId WHERE id = enrlRecords.id;

	          INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrlRecords.id, ceteSysAdminUserId, now(),
		      'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || enrlRecords.rosterid || ', "enrollmentId":' ||  enrlRecords.enrollmentid || ',"enrollmentRosterId":' || enrlRecords.id || '}')::json);

                 error_msg :=  '<success>' || 'enrollmentid:' || CAST(COALESCE(enrlRecords.enrollmentid,0) AS TEXT)  || ';  added to the roster:' || COALESCE(roster_name,'NULL');

		 PERFORM moveCompletedTestsAndResetSTWithNoCourse(student_id := enrollmentRecord.studentid,enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id,
		             new_roster_id := rosterRecord.id, school_year := schoolyear, attendance_schId := att_sch_id);

	      END LOOP;
	   END IF;
        END LOOP;
     END LOOP;
   END IF;
   END IF;
   END IF;
   END IF;
RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;



-- US17061: DLM Lockdown Service Desk Data Scripts
-- Scenario 4.2: Creating new roster with subject and course combination.

DROP FUNCTION IF EXISTS createNewRosterWithSubAndCourse(character varying[], character varying, character varying, bigint, character varying, character varying, character varying, character varying, character varying);


CREATE OR REPLACE FUNCTION createNewRosterWithSubAndCourse(state_student_identifiers character varying[], att_sch_displayidentifier character varying, ayp_sch_displayidentifier character varying, schoolyear bigint,
      subject_abbrName character varying, course_abbrName character varying, teacher_uniqueCommonId character varying, roster_name character varying, stateDisplayidentifier character varying) RETURNS TEXT AS

$BODY$
   DECLARE
   state_Id BIGINT;
   att_sch_id BIGINT;
   ayp_sch_id BIGINT;
   ceteSysAdminUserId BIGINT;
   contentArea_Id BIGINT;
   subject_Id BIGINT;
   teacher_Id BIGINT;
   rosterRecord RECORD;
   enrollmentRecord RECORD;
   enrlRecords RECORD;
   enrl_Id BIGINT;
   roster_Id BIGINT;
   course_Id BIGINT;
   error_msg TEXT;
   student_identify TEXT;

 BEGIN
   student_identify:=  state_student_identifiers::TEXT;
    error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(state_student_identifiers,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
   SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
   SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
   SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
   SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin' AND activeflag is true );
   SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true LIMIT 1);
   SELECT INTO teacher_Id (SELECT DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id AND case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(teacher_uniqueCommonId)) LIMIT 1);
   SELECT INTO course_Id (SELECT id FROM gradecourse WHERE lower(trim(abbreviatedname)) = lower(trim(course_abbrName)) and activeflag is true LIMIT 1);
   error_msg := '';
      IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE
        IF(course_Id is null) THEN

         RAISE NOTICE 'course_Id % is invalid', course_abbrName;

         error_msg := '<error>' || 'invalid value on course_abbrName:' || COALESCE(course_abbrName,'NULL');

     ELSE   
  IF((SELECT count(en.*) FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear  AND en.attendanceschoolid = att_sch_id
           AND stu.statestudentidentifier = ANY(state_student_identifiers)AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true) <= 0) THEN

        RAISE NOTICE 'Student % is not found with attendance %  in school year %', student_identify, att_sch_displayidentifier, schoolyear;
        error_msg := '<error>'||'Studentid:'||COALESCE(student_identify,'NULL')||'; not found attendance:'||COALESCE(att_sch_displayidentifier,'NULL')||';in school year:'||CAST(COALESCE(schoolyear,0) AS TEXT);
    ELSE
   IF((SELECT count(*) FROM roster r WHERE r.activeflag is true AND  lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id
                       AND r.statecoursesid = course_Id AND currentschoolyear = schoolyear AND teacherid = teacher_Id)) <= 0 THEN

     RAISE NOTICE 'No rosters found with roster name: %, subject: %, course: %, attendanceschool: %, teacher: %, and school year: %, So creating new roster.  ',
                  roster_name, subject_abbrName, course_abbrName, att_sch_displayidentifier, teacher_uniqueCommonId, schoolyear;
     error_msg := '<validation>' || 'No rosters found with roster name:'|| COALESCE(roster_name,'NULL')||';subject:' ||COALESCE(subject_abbrName,'NULL')||';course:'||COALESCE(course_abbrName,'NULL')||';attendanceschool:'
                                ||COALESCE(att_sch_displayidentifier,'NULL')||';teacher:'||COALESCE(teacher_uniqueCommonId,'NULL')||';and school year:'||CAST(COALESCE(schoolyear,0) AS TEXT)||
                                ' So creating new roster.';

     IF(teacher_Id is null) THEN

         RAISE NOTICE 'Teacher % is not found in the organization %', teacher_uniqueCommonId, att_sch_displayidentifier;

         error_msg := '<error>' || 'Teacher:' || COALESCE(teacher_uniqueCommonId,'NULL')|| ';  not found in the organization:' || COALESCE(att_sch_displayidentifier,'NULL');

     ELSE
       INSERT INTO roster(coursesectionname, teacherid, attendanceSchoolId, statesubjectareaid, restrictionid, createddate, createduser, activeflag, modifieddate, modifieduser,
		educatorschooldisplayidentifier, sourcetype, currentSchoolYear, aypSchoolId, statecoursecode, statecoursesid)
	  VALUES(roster_name, teacher_Id, att_sch_id, subject_Id, 1, now(), ceteSysAdminUserId, true, now(), ceteSysAdminUserId,att_sch_displayidentifier,
                'LOCK_DOWN_SCRIPT', schoolyear, ayp_sch_id, course_abbrName, course_Id) RETURNING id INTO roster_Id;

       FOR enrollmentRecord IN(SELECT stu.statestudentidentifier,en.* FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear AND en.attendanceschoolid = att_sch_id
          AND trim(stu.statestudentidentifier) = ANY(state_student_identifiers)AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true)
       LOOP

          INSERT INTO enrollmentsrosters(enrollmentid, rosterid, createddate, createduser, activeflag, modifieddate, modifieduser)
                      VALUES (enrollmentRecord.id, roster_Id, now(), ceteSysAdminUserId, true, now(), ceteSysAdminUserId) RETURNING id INTO enrl_Id;

          INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrl_Id, ceteSysAdminUserId, now(),
		      'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || roster_Id || ', "enrollmentId":' ||  enrollmentRecord.id || ',"enrollmentRosterId":' || enrl_Id || '}')::json);

          RAISE NOTICE 'Student % is added to the roster %', enrollmentRecord.statestudentidentifier, roster_name;

          error_msg :=  '<success>' || 'Student:' || COALESCE(enrollmentRecord.statestudentidentifier,'NULL') || ';  added to the roster:' || COALESCE(roster_name,'NULL');

          PERFORM moveCompletedTestsAndResetSTWithCourse(student_id := enrollmentRecord.studentid,enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id,
                 course_Id := course_Id, new_roster_id := roster_Id, school_year := schoolyear, attendance_schId := att_sch_id);

       END LOOP;
    END IF;

   ELSE
    FOR enrollmentRecord IN(SELECT stu.statestudentidentifier, en.* FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear  AND en.attendanceschoolid = att_sch_id
         AND trim(stu.statestudentidentifier) = ANY(state_student_identifiers)AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true)
     LOOP
        FOR rosterRecord IN(SELECT r.* FROM roster r WHERE r.activeflag is true AND  lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id
                   AND r.statecoursesid = course_Id AND currentschoolyear = schoolyear AND teacherid = teacher_Id)
	 LOOP
           IF((SELECT count(*) FROM enrollmentsrosters WHERE enrollmentid = enrollmentRecord.id AND rosterid = rosterRecord.id) <= 0) THEN

	       INSERT INTO enrollmentsrosters(enrollmentid, rosterid, createddate, createduser, activeflag, modifieddate, modifieduser)
                      VALUES (enrollmentRecord.id, rosterRecord.id, now(), ceteSysAdminUserId, true, now(), ceteSysAdminUserId) RETURNING id INTO enrl_Id;

               INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrl_Id, ceteSysAdminUserId, now(),
		      'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || rosterRecord.id || ', "enrollmentId":' ||  enrollmentRecord.id || ',"enrollmentRosterId":' || enrl_Id || '}')::json);

	      RAISE NOTICE 'Student % is added to the roster %', enrollmentRecord.statestudentidentifier, roster_name;

        error_msg :=  '<success>' || 'Student:' || COALESCE(enrollmentRecord.statestudentidentifier,'NULL') || ';  added to the roster:' || COALESCE(roster_name,'NULL');


	      PERFORM moveCompletedTestsAndResetSTWithCourse(student_id := enrollmentRecord.studentid,enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id,
	               course_Id := course_Id, new_roster_id := roster_Id, school_year := schoolyear, attendance_schId := att_sch_id);


	   ELSE
	      FOR enrlRecords IN (SELECT * FROM enrollmentsrosters WHERE enrollmentid = enrollmentRecord.id AND rosterid = rosterRecord.id LIMIT 1)
	        LOOP
                  UPDATE enrollmentsrosters SET activeflag = true, modifieddate = now(), modifieduser = ceteSysAdminUserId WHERE id = enrlRecords.id;

	          INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', enrlRecords.id, ceteSysAdminUserId, now(),
		      'ADD_STUDNET_TO_ROSTER', ('{"rosterId":' || enrlRecords.rosterid || ', "enrollmentId":' ||  enrlRecords.enrollmentid || ',"enrollmentRosterId":' || enrlRecords.id || '}')::json);

      error_msg :=  '<success>' || 'enrollmentid:' || CAST(COALESCE(enrlRecords.enrollmentid,0) AS TEXT)  || ';  added to the roster:' || COALESCE(roster_name,'NULL');

		 PERFORM moveCompletedTestsAndResetSTWithCourse(student_id := enrollmentRecord.studentid,enrollment_id := enrollmentRecord.id, subjectArea_id := subject_Id,
	               course_Id := course_Id, new_roster_id := roster_Id, school_year := schoolyear, attendance_schId := att_sch_id);

	      END LOOP;
	   END IF;
        END LOOP;
     END LOOP;
   END IF;
   END IF;
   END IF;
   END IF;
   END IF;
RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;



-- US17061: DLM Lockdown Service Desk Data Scripts
-- Scenario: 1.2 Removing all students from roster. With course code.
DROP FUNCTION IF EXISTS removeAllStudentsFromRosterWithCourse(character varying, character varying, character varying, bigint, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION removeAllStudentsFromRosterWithCourse(ayp_sch_displayidentifier character varying, att_sch_displayidentifier character varying, stateDisplayidentifier character varying,
              schoolyear bigint, subject_abbrName character varying, course_Abbrname character varying, teacher_uniqueCommonId character varying, roster_name character varying) RETURNS TEXT AS

$BODY$
 DECLARE
   state_Id BIGINT;
   ayp_sch_id BIGINT;
   att_sch_id BIGINT;
   ceteSysAdminUserId BIGINT;
   contentArea_Id BIGINT;
   rosterUnEnrolledStuTestSecsStatus BIGINT;
   rosterUnEnrolledStuTestsStatus BIGINT;
   inProgressStuTestsStatus BIGINT;
   pendingStuTestsStatus BIGINT;
   unusedStuTestsStatus BIGINT;
   course_Id BIGINT;
   subject_Id BIGINT;
   teacher_Id BIGINT;
   studentsEnrollemntsRostersRecord RECORD;
   stuTestsRecordsInprgsPenUnusedStatus RECORD;
   error_msg TEXT;

 BEGIN
    error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)) or lower(trim(org.tree_schooldisplayidentifier))=lower(trim(ayp_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||' State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL')||';OR AYP School:'||COALESCE(ayp_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
   SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
   SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
   SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
   SELECT INTO rosterUnEnrolledStuTestSecsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TESTSECTION_STATUS' AND categorycode = 'rosterunenrolled');
   SELECT INTO rosterUnEnrolledStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'rosterunenrolled');
   SELECT INTO inProgressStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'inprogress');
   SELECT INTO pendingStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'pending');
   SELECT INTO unusedStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'unused');
   SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
   SELECT INTO course_Id (SELECT id FROM gradecourse WHERE lower(trim(abbreviatedname)) = lower(trim(course_Abbrname)) and activeflag is true and course is true LIMIT 1);
   SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) and activeflag is true LIMIT 1);
   SELECT INTO teacher_Id (select DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id and case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(teacher_uniqueCommonId)) LIMIT 1);
   error_msg := '';
         IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE
        IF(course_Id is null) THEN

         RAISE NOTICE 'course_Id % is invalid', course_Abbrname;

         error_msg := '<error>' || 'invalid value on course_abbrName:' || COALESCE(course_Abbrname,'NULL');

     ELSE 

   IF((SELECT count(*) FROM roster WHERE r.activeflag is true AND teacherid = teacher_Id AND statecoursesid = course_Id AND statesubjectareaid = subject_Id AND attendanceschoolid = att_sch_id
          AND currentschoolyear = schoolyear AND lower(trim(coursesectionname)) = lower(trim(roster_name))) = 0) THEN

        RAISE NOTICE 'Roster % not found with subject % , course %, teacher %, attendance school % in school year %', roster_name, subject_abbrName, course_Abbrname, teacher_uniqueCommonId,
                      att_sch_displayidentifier, schoolyear;

        error_msg := '<error>' || 'No rosters found with name:' || COALESCE(roster_name,'NULL') || ';subject:' || COALESCE(subject_abbrName,'NULL') || ';course:' || COALESCE(course_Abbrname,'NULL') || ';teacher:' || COALESCE(teacher_uniqueCommonId,'NULL')
                     ||';attendance school:' || COALESCE(att_sch_displayidentifier,'NULL') || ';and school year:' || CAST(COALESCE(schoolyear,0) AS TEXT);

   ELSE
    FOR studentsEnrollemntsRostersRecord IN (SELECT stu.statestudentidentifier, stu.id as studentId, en.id as enrollmentid, enrl.id as enrlRosterId, enrl.rosterId as rosterId
           FROM student stu JOIN enrollment en on stu.id = en.studentid JOIN enrollmentsrosters enrl on enrl.enrollmentid = en.id and enrl.activeflag is true and stu.activeflag is true and en.activeflag is true
           WHERE enrl.rosterid IN (SELECT r.id FROM roster r
               WHERE r.activeflag is true AND r.statecoursesid = course_Id  and r.activeflag is true and r.teacherid = teacher_id AND r.statesubjectareaid = subject_Id AND r.attendanceschoolid = att_sch_id AND currentschoolyear = schoolyear AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)))
               AND en.attendanceschoolid = att_sch_id AND en.aypschoolid = ayp_sch_id AND en.currentschoolyear = schoolyear AND stu.stateid = state_Id AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true)
        LOOP
          UPDATE enrollmentsrosters SET activeflag = false,modifieddate=CURRENT_TIMESTAMP, modifieduser = ceteSysAdminUserId
                  WHERE enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid AND rosterid = studentsEnrollemntsRostersRecord.rosterId
                      AND id = studentsEnrollemntsRostersRecord.enrlRosterId;

           RAISE NOTICE 'Student(%) with Id : % is removed from the rosterId: %  enrollmentrosterId: % ', studentsEnrollemntsRostersRecord.statestudentidentifier, studentsEnrollemntsRostersRecord.studentId,
                       studentsEnrollemntsRostersRecord.rosterId, studentsEnrollemntsRostersRecord.enrlRosterId;

           error_msg := '<success> Student:'|| COALESCE(studentsEnrollemntsRostersRecord.statestudentidentifier,'NULL') || ';  removed from roster:' || COALESCE(roster_name,'NULL');

           INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', studentsEnrollemntsRostersRecord.enrlRosterId, ceteSysAdminUserId, now(),
		'RM_STUDENT_FROM_ROSTER', ('{"rosterId":' || studentsEnrollemntsRostersRecord.rosterId  || ',"enrollmentId":'
				|| studentsEnrollemntsRostersRecord.enrollmentid || ',"enrollmentRosterId":' || studentsEnrollemntsRostersRecord.enrlRosterId || '}')::json);

           FOR stuTestsRecordsInprgsPenUnusedStatus IN (SELECT st.id, st.studentid, st.testid, st.testcollectionid, st.testsessionid, st.status,st.enrollmentid
                FROM studentstests st JOIN testsession ts ON st.testsessionid = ts.id JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
		 WHERE st.activeflag=true  and ts.activeflag=true AND ts.rosterid = studentsEnrollemntsRostersRecord.rosterId 
                AND st.enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid AND (otw.effectivedate <= now() AND now() <= otw.expirydate)
                AND st.status in (inProgressStuTestsStatus, pendingStuTestsStatus, unusedStuTestsStatus))
	    LOOP
	        PERFORM inActivateStuTestsTrackerITITestsessions(studentTestsId := stuTestsRecordsInprgsPenUnusedStatus.id, inActiveStuTestSecStatusId := rosterUnEnrolledStuTestSecsStatus,
	            inActiveStuTestStatusId := rosterUnEnrolledStuTestsStatus, testsession_Id := stuTestsRecordsInprgsPenUnusedStatus.testsessionid, student_Id :=stuTestsRecordsInprgsPenUnusedStatus.studentid);
            END LOOP;
      UPDATE ititestsessionhistory SET activeflag = false, modifieddate = now(), modifieduser = ceteSysAdminUserId, status = rosterUnEnrolledStuTestsStatus
	     WHERE studentenrlrosterid IN (SELECT id FROM enrollmentsrosters WHERE enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid  and rosterid = studentsEnrollemntsRostersRecord.rosterId)
             AND status = pendingStuTestsStatus AND activeflag IS true;
   END LOOP;
END IF;
END IF;
END IF;
END IF;
RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;




-- US17061: DLM Lockdown Service Desk Data Scripts
-- Scenario: 1.4 Removing all students from roster. No course code.
DROP FUNCTION IF EXISTS removeAllStudentsFromRosterWithNoCourse(character varying, character varying, character varying, bigint, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION removeAllStudentsFromRosterWithNoCourse(ayp_sch_displayidentifier character varying, att_sch_displayidentifier character varying, stateDisplayidentifier character varying,
              schoolyear bigint, subject_abbrName character varying, teacher_uniqueCommonId character varying, roster_name character varying) RETURNS TEXT AS

$BODY$
 DECLARE
   state_Id BIGINT;
   ayp_sch_id BIGINT;
   att_sch_id BIGINT;
   ceteSysAdminUserId BIGINT;
   contentArea_Id BIGINT;
   rosterUnEnrolledStuTestSecsStatus BIGINT;
   rosterUnEnrolledStuTestsStatus BIGINT;
   inProgressStuTestsStatus BIGINT;
   pendingStuTestsStatus BIGINT;
   unusedStuTestsStatus BIGINT;
   course_Id BIGINT;
   subject_Id BIGINT;
   teacher_Id BIGINT;
   studentsEnrollemntsRostersRecord RECORD;
   stuTestsRecordsInprgsPenUnusedStatus RECORD;
   error_msg TEXT;

 BEGIN
    error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)) or lower(trim(org.tree_schooldisplayidentifier))=lower(trim(ayp_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||' State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL')||';OR AYP School:'||COALESCE(ayp_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
   SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
   SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
   SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
   SELECT INTO rosterUnEnrolledStuTestSecsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TESTSECTION_STATUS' AND categorycode = 'rosterunenrolled');
   SELECT INTO rosterUnEnrolledStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'rosterunenrolled');
   SELECT INTO inProgressStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'inprogress');
   SELECT INTO pendingStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'pending');
   SELECT INTO unusedStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'unused');
   SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
   SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true LIMIT 1);
   SELECT INTO teacher_Id (select DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id and case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(teacher_uniqueCommonId)) LIMIT 1);
   error_msg := '';
      IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE

   IF((SELECT count(r.*) FROM roster r WHERE r.activeflag is true AND  r.teacherid = teacher_id AND r.statesubjectareaid = subject_Id and r.activeflag is true
         AND r.attendanceschoolid = att_sch_id AND currentschoolyear = schoolyear AND lower(trim(r.coursesectionname)) = lower(trim(roster_name))) = 0) THEN

          RAISE NOTICE 'Roster % not found with subject % , teacher %, attendance school % in school year %', roster_name, subject_abbrName, teacher_uniqueCommonId,
                      att_sch_displayidentifier, schoolyear;

         error_msg := '<error>' || 'No rosters found with name:' || COALESCE(roster_name,'NULL') || ';subject:' || COALESCE(subject_abbrName,'NULL') || ';teacher:' ||
                      COALESCE(teacher_uniqueCommonId,'NULL') || ';attendance school:' || COALESCE(att_sch_displayidentifier,'NULL') || ';and school year:' || CAST(COALESCE(schoolyear,0) AS TEXT);

   ELSE
     FOR studentsEnrollemntsRostersRecord IN (SELECT stu.statestudentidentifier, stu.id as studentId, en.id as enrollmentid, enrl.id as enrlRosterId, enrl.rosterId as rosterId
           FROM student stu JOIN enrollment en on stu.id = en.studentid JOIN enrollmentsrosters enrl on enrl.enrollmentid = en.id and enrl.activeflag is true and stu.activeflag is true and  en.activeflag is true
           WHERE enrl.rosterid IN (SELECT r.id FROM roster r 
               WHERE r.activeflag is true AND  r.teacherid = teacher_id AND   r.activeflag is true and r.statesubjectareaid = subject_Id AND r.attendanceschoolid = att_sch_id AND currentschoolyear = schoolyear AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)))
               AND en.attendanceschoolid = att_sch_id AND en.aypschoolid = ayp_sch_id AND en.currentschoolyear = schoolyear AND stu.stateid = state_Id)
        LOOP
          UPDATE enrollmentsrosters SET activeflag = false,modifieddate=CURRENT_TIMESTAMP, modifieduser = ceteSysAdminUserId
                  WHERE enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid AND rosterid = studentsEnrollemntsRostersRecord.rosterId
                      AND id = studentsEnrollemntsRostersRecord.enrlRosterId;

           RAISE NOTICE 'Student(%) with Id : % is removed from the rosterId: %  enrollmentrosterId: % ', studentsEnrollemntsRostersRecord.statestudentidentifier, studentsEnrollemntsRostersRecord.studentId,
                       studentsEnrollemntsRostersRecord.rosterId, studentsEnrollemntsRostersRecord.enrlRosterId;

           error_msg := '<success> Student with id :'|| COALESCE(studentsEnrollemntsRostersRecord.statestudentidentifier,'NULL') || ';  removed from roster ' || COALESCE(roster_name,'NULL');

           INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', studentsEnrollemntsRostersRecord.enrlRosterId, ceteSysAdminUserId, now(),
		'RM_STUDENT_FROM_ROSTER', ('{"rosterId":' || studentsEnrollemntsRostersRecord.rosterId  || ',"enrollmentId":'
				|| studentsEnrollemntsRostersRecord.enrollmentid || ',"enrollmentRosterId":' || studentsEnrollemntsRostersRecord.enrlRosterId || '}')::json);

           FOR stuTestsRecordsInprgsPenUnusedStatus IN (SELECT st.id, st.studentid, st.testid, st.testcollectionid, st.testsessionid, st.status,st.enrollmentid
                FROM studentstests st JOIN testsession ts ON st.testsessionid = ts.id and  st.activeflag=true  and ts.activeflag=true JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
		 WHERE st.activeflag=true AND ts.rosterid = studentsEnrollemntsRostersRecord.rosterId
                AND st.enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid AND (otw.effectivedate <= now() AND now() <= otw.expirydate)
                AND st.status in (inProgressStuTestsStatus, pendingStuTestsStatus, unusedStuTestsStatus))
	    LOOP
	        PERFORM inActivateStuTestsTrackerITITestsessions(studentTestsId := stuTestsRecordsInprgsPenUnusedStatus.id, inActiveStuTestSecStatusId := rosterUnEnrolledStuTestSecsStatus,
	            inActiveStuTestStatusId := rosterUnEnrolledStuTestsStatus, testsession_Id := stuTestsRecordsInprgsPenUnusedStatus.testsessionid, student_Id :=stuTestsRecordsInprgsPenUnusedStatus.studentid);
            END LOOP;
      UPDATE ititestsessionhistory SET activeflag = false, modifieddate = now(), modifieduser = ceteSysAdminUserId, status = rosterUnEnrolledStuTestsStatus
	     WHERE studentenrlrosterid IN (SELECT id FROM enrollmentsrosters WHERE enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid  and rosterid = studentsEnrollemntsRostersRecord.rosterId)
             AND status = pendingStuTestsStatus AND activeflag IS true;
    END LOOP;
  END IF;
  END IF;
  END IF;
RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;

  -- US17061: DLM Lockdown Service Desk Data Scripts
  -- Scenario: 7: Exit Student
  DROP FUNCTION IF EXISTS exitStudent(character varying, character varying, character varying, numeric, date, bigint, character varying);

  CREATE OR REPLACE FUNCTION exitStudent(statestudent_identifier character varying, ayp_sch_displayidentifier character varying, att_sch_displayidentifier character varying, exitReason numeric, exitDate date, schoolyear bigint, stateDisplayidentifier character varying)
       RETURNS TEXT AS
  $BODY$
   DECLARE
     studentEnrollemntRecord RECORD;
     stuTestsRecordsInprgsPenUnusedStatus RECORD;
     state_Id BIGINT;
     ayp_sch_id BIGINT;
     att_sch_id BIGINT;
     exitStuTestSecsStatus BIGINT;
     exitStuTestsStatus BIGINT;
     inProgressStuTestsStatus BIGINT;
     pendingStuTestsStatus BIGINT;
     unusedStuTestsStatus BIGINT;
     ceteSysAdminUserId BIGINT;
     error_msg TEXT;
     exitDate_cdt timestamp with time zone;
   BEGIN
   error_msg :='';
   exitDate_cdt:=((exitDate::timestamp) AT TIME ZONE 'CDT');
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)) or lower(trim(org.tree_schooldisplayidentifier))=lower(trim(ayp_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(statestudent_identifier,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL')||';OR AYP School:'||COALESCE(ayp_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE   
  	SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
  	SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
  	SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
  	SELECT INTO exitStuTestSecsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TESTSECTION_STATUS' AND categorycode = 'exitclearunenrolled');
  	SELECT INTO exitStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'exitclearunenrolled');
  	SELECT INTO inProgressStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'inprogress');
  	SELECT INTO pendingStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'pending');
  	SELECT INTO unusedStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'unused');
  	SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
  	error_msg := '';
   IF((SELECT count(en.*) FROM enrollment en JOIN student stu ON stu.id = en.studentid AND en.currentschoolyear = schoolyear AND en.aypschoolid = ayp_sch_id AND en.attendanceschoolid = att_sch_id
           AND trim(stu.statestudentidentifier) = trim(statestudent_identifier) AND stu.stateid = state_Id) <= 0) THEN

        RAISE NOTICE 'Student % is not found with ayp %, attendance %  in school year %', statestudent_identifier, ayp_sch_displayidentifier, att_sch_displayidentifier, schoolyear;
        error_msg := '<error>'||'Studentid:'||COALESCE(statestudent_identifier,'NULL')||';  not found with ayp:'||COALESCE(ayp_sch_displayidentifier,'NULL')||';attendance:'||COALESCE(att_sch_displayidentifier,'NULL')||';in school year:'||CAST(COALESCE(schoolyear,0) AS TEXT);
    ELSE 	   
      FOR studentEnrollemntRecord IN (SELECT stu.statestudentidentifier,stu.stateid, en.* FROM student stu JOIN enrollment en ON en.studentid = stu.id
  					WHERE lower(trim(stu.statestudentidentifier)) = lower(trim(statestudent_identifier))
  					AND stu.stateid = state_Id and en.currentschoolyear = schoolyear
  					AND en.aypschoolid = ayp_sch_id and en.attendanceschoolid = att_sch_id)
       LOOP
           IF (studentEnrollemntRecord.schoolentrydate <= exitDate_cdt) THEN
             UPDATE enrollment SET exitwithdrawaldate = exitDate_cdt, activeflag = false, exitwithdrawaltype = exitReason, modifieddate = now(), modifieduser = ceteSysAdminUserId WHERE id = studentEnrollemntRecord.id;

             RAISE NOTICE 'Updated the enrollment record with id: %', studentEnrollemntRecord.id;
             error_msg := '<success> Updated the enrollment record with id:'|| studentEnrollemntRecord.id;

            INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT', studentEnrollemntRecord.id, ceteSysAdminUserId, now(),
  		'EXIT_STUDENT', ('{"studentId":'|| studentEnrollemntRecord.studentid || ',"stateId":' ||  studentEnrollemntRecord.stateid
  				|| ',"stateStudentIdentifier":"' || studentEnrollemntRecord.statestudentidentifier
  				|| '","aypSchool":' || studentEnrollemntRecord.aypschoolid || ',"attendanceSchoolId":'|| studentEnrollemntRecord.attendanceschoolid
  				|| ',"exitWithdrawalDate":"' || exitDate || '","exitReason":"' || exitReason ||  '"}')::json);



            FOR stuTestsRecordsInprgsPenUnusedStatus IN (SELECT  st.id, st.studentid, st.testid, st.testcollectionid, st.testsessionid, st.status,st.enrollmentid
                  FROM studentstests st JOIN testsession ts on st.testsessionid = ts.id  and st.activeflag=true  and ts.activeflag=true JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
                   WHERE st.activeflag=true AND st.enrollmentid = studentEnrollemntRecord.id AND (otw.effectivedate <= now() AND now() <= otw.expirydate)
                   AND st.status in (inProgressStuTestsStatus, pendingStuTestsStatus,unusedStuTestsStatus)) LOOP

  		PERFORM inActivateStuTestsTrackerITITestsessions(studentTestsId := stuTestsRecordsInprgsPenUnusedStatus.id , inActiveStuTestSecStatusId := exitStuTestSecsStatus,
  		      inActiveStuTestStatusId := exitStuTestsStatus, testsession_Id := stuTestsRecordsInprgsPenUnusedStatus.testsessionid, student_Id := stuTestsRecordsInprgsPenUnusedStatus.studentid);


            END LOOP;
            UPDATE ititestsessionhistory SET activeflag=false,modifieddate=now(),modifieduser=ceteSysAdminUserId,status=exitStuTestsStatus
  		       WHERE studentenrlrosterid IN (SELECT id FROM enrollmentsrosters WHERE enrollmentid = studentEnrollemntRecord.id)
                         AND status = (SELECT cat.id FROM category cat, categorytype ct WHERE ct.id = cat.categorytypeid AND cat.categorycode='pending' AND ct.typecode = 'STUDENT_TEST_STATUS')
                         AND activeflag IS true;
           ELSE
             RAISE NOTICE 'Exit withdrawal date(%) is less than the school entry date(%)', exitDate, studentEnrollemntRecord.schoolentrydate;
             error_msg := '<error>' || 'Exit withdrawal date:' ||  cast(coalesce(exitDate,'01/01/1900') as text) ||';  less than the school entry date:' || cast(coalesce(studentEnrollemntRecord.schoolentrydate,'01/01/1900') as text) ;
         END IF;
     END LOOP;
     END IF;
     END IF;
     RETURN error_msg;
     END;
  $BODY$
  LANGUAGE plpgsql VOLATILE
    COST 100;

  --  SELECT exitStudent(statestudent_identifier := '1234567814', ayp_sch_displayidentifier :='1090024020', att_sch_displayidentifier := '1090024020', exitReason := 7, exitDate := '2016-03-07', schoolyear := 2016, stateDisplayidentifier := 'MO');

-- Scenario 9 - addNewEnrollment

DROP FUNCTION IF EXISTS addNewEnrollment(character varying, character varying, character varying, character varying, character varying, bigint,
         date, date, date, character varying, character varying);

CREATE OR REPLACE FUNCTION addNewEnrollment(statestudent_identifier character varying, localState_StuId character varying, aypSch character varying, attSch character varying, district character varying, schoolyear bigint,
         schEntryDate date, distEntryDate date, state_EntryDate date, grade character varying, stateDisplayidentifier character varying)
        RETURNS TEXT AS
$BODY$
 DECLARE
   state_Id BIGINT;
   ayp_sch_id BIGINT;
   att_sch_id BIGINT;
   dist_id BIGINT;
   ceteSysAdminUserId BIGINT;
   new_EnrlId BIGINT;
   newSchEnrlRecord RECORD;
   grade_id BIGINT;
   student_id BIGINT;
   sch_entry_date timestamp with time zone;
   district_entry_date timestamp with time zone;
   state_entry_date timestamp with time zone;
   error_msg TEXT;

 BEGIN
   error_msg :='';
   sch_entry_date:=((schEntryDate::timestamp) AT TIME ZONE 'CDT');
   district_entry_date:=((distEntryDate::timestamp) AT TIME ZONE 'CDT');
   state_entry_date:=((state_EntryDate::timestamp) AT TIME ZONE 'CDT');
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(org.tree_schooldisplayidentifier)=lower(attSch) or lower(org.tree_schooldisplayidentifier)=lower(aypSch))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(statestudent_identifier,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(attSch,'NULL')||';OR AYP School:'||COALESCE(aypSch,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
	SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
	SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(aypSch)));
	SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(attSch)));
	SELECT INTO dist_id (SELECT districtid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(district)));
	SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
        SELECT INTO grade_id (SELECT id FROM gradecourse gc WHERE contentareaid IS NULL AND assessmentprogramgradesid IS NOT NULL
					AND abbreviatedname = grade AND activeflag is true);
        SELECT INTO student_id (SELECT id FROM student WHERE lower(trim(statestudentidentifier)) = lower(trim(statestudent_identifier)) AND stateid = state_Id AND activeflag is true LIMIT 1);

    IF (student_id IS NULL)

     THEN
	RAISE NOTICE 'Student % is not present in state %', statestudent_identifier, stateDisplayidentifier;
	error_msg = '<error>'||'Student :'|| COALESCE(statestudent_identifier,'NULL') || ';  not present in state:' || COALESCE(stateDisplayidentifier,'NULL');

    ELSE
    IF (grade_id IS NULL)

     THEN
	RAISE NOTICE 'Invalid grade  %', grade;
	error_msg = '<error>'||'Student :'|| COALESCE(statestudent_identifier,'NULL') || '; grade Invalid:' || COALESCE(grade,'NULL');

    ELSE    
      IF((SELECT  count(*) FROM enrollment WHERE studentid = student_id AND currentschoolyear = schoolyear 
		AND aypschoolid = ayp_sch_id and attendanceschoolid = att_sch_id) <= 0)
        THEN
          INSERT INTO enrollment(aypschoolidentifier, residencedistrictidentifier, localstudentidentifier,
		currentgradelevel, currentschoolyear, attendanceschoolid,
		schoolentrydate, districtentrydate, stateentrydate, exitwithdrawaldate,
		exitwithdrawaltype, studentid, restrictionid, createddate, createduser,
		activeflag, modifieddate, modifieduser, aypSchoolId, sourcetype)
	     VALUES (aypSch, district, localState_StuId,
		     grade_id, schoolyear, att_sch_id,
		     sch_entry_date, district_entry_date, state_entry_date, null,
		     0, student_id, 2, now(), ceteSysAdminUserId,
		     true, now(), ceteSysAdminUserId, ayp_sch_id, 'LOCK_DOWN_SCRIPT') RETURNING id INTO new_EnrlId;

	    INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT', new_EnrlId, ceteSysAdminUserId, now(),
		'NEW_ENROLLMENT', ('{"studentId":'|| student_id || ',"stateId":' ||  state_Id
				|| ',"stateStudentIdentifier":"' ||  statestudent_identifier
				|| '","aypSchool":' || ayp_sch_id || ',"attendanceSchoolId":'|| att_sch_id
				|| ',"grade":' || grade_id || ',"schoolEntryDate":"' || schEntryDate ||  '"}')::json);

	RAISE NOTICE 'Student % is enrolled into School % for school year % and grade level %', statestudent_identifier, attSch, schoolyear, grade;
	error_msg = '<success>'||'Student:' || COALESCE(statestudent_identifier,'NULL') || ';  enrolled into School:' || COALESCE(attSch,'NULL') || ';for school year:' || CAST(COALESCE(schoolyear,0) AS TEXT)  || ';and grade level:' || COALESCE(grade,'NULL');

        ELSE
	      FOR newSchEnrlRecord IN (SELECT stu.statestudentidentifier, en.* FROM enrollment en JOIN student stu ON stu.id = en.studentid
	                WHERE stu.id = student_id AND aypschoolid = ayp_sch_id AND attendanceschoolid = att_sch_id
                         AND currentschoolyear = schoolyear LIMIT 1)
             LOOP
		IF(schEntryDate is null) THEN
		     sch_entry_date := newSchEnrlRecord.schoolentrydate;
		ELSE
		     sch_entry_date := sch_entry_date;
		END IF;

                IF(distEntryDate is null) THEN
                    district_entry_date := newSchEnrlRecord.districtentrydate;
                ELSE
                   district_entry_date := district_entry_date;
                END IF;

                IF(state_EntryDate is null) THEN
                   state_entry_date := newSchEnrlRecord.stateentrydate;
                ELSE
                   state_entry_date := state_entry_date;
                END IF;

		UPDATE enrollment SET currentgradelevel= grade_id,activeflag = true, schoolentrydate = sch_entry_date, districtentrydate = district_entry_date, stateentrydate = state_entry_date,exitwithdrawaldate = null,
		          exitwithdrawaltype = 0, modifieduser = ceteSysAdminUserId, modifieddate = now() WHERE id = newSchEnrlRecord.id;

		RAISE NOTICE 'Enrollment % is updated, student % in school year %', newSchEnrlRecord.id, newSchEnrlRecord.statestudentidentifier, schoolyear;

		error_msg = '<success>'|| 'Enrollment:' || CAST(COALESCE(newSchEnrlRecord.id,0) AS TEXT)  || ';  updated for student:' || COALESCE(newSchEnrlRecord.statestudentidentifier,'NULL') || ';in school year:' || CAST(COALESCE(schoolyear,0) AS TEXT) ;

             END LOOP;
        END IF;
        END IF;
      END IF;
      END IF;
RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
COST 100;


-- US17061: DLM Lockdown Service Desk Data Scripts
-- Scenario: 1.1 Removing student from roster with Course.
DROP FUNCTION IF EXISTS removeStudentFromRosterWithCourse(character varying, character varying, character varying, character varying, bigint, character varying, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION removeStudentFromRosterWithCourse(statestudent_identifier character varying, ayp_sch_displayidentifier character varying, att_sch_displayidentifier character varying, stateDisplayidentifier character varying,
              schoolyear bigint, subject_abbrName character varying, course_Abbrname character varying, teacher_uniqueCommonId character varying, roster_name character varying) RETURNS TEXT AS

$BODY$
 DECLARE
   state_Id BIGINT;
   ayp_sch_id BIGINT;
   att_sch_id BIGINT;
   ceteSysAdminUserId BIGINT;
   contentArea_Id BIGINT;
   rosterUnEnrolledStuTestSecsStatus BIGINT;
   rosterUnEnrolledStuTestsStatus BIGINT;
   inProgressStuTestsStatus BIGINT;
   pendingStuTestsStatus BIGINT;
   unusedStuTestsStatus BIGINT;
   course_Id BIGINT;
   subject_Id BIGINT;
   teacher_Id BIGINT;
   studentsEnrollemntsRostersRecord RECORD;
   stuTestsRecordsInprgsPenUnusedStatus RECORD;
   error_msg TEXT;
 BEGIN
    error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)) or lower(trim(org.tree_schooldisplayidentifier))=lower(trim(ayp_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(statestudent_identifier,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL')||';OR AYP School:'||COALESCE(ayp_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
   SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
   SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
   SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
   SELECT INTO rosterUnEnrolledStuTestSecsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TESTSECTION_STATUS' AND categorycode = 'rosterunenrolled');
   SELECT INTO rosterUnEnrolledStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'rosterunenrolled');
   SELECT INTO inProgressStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'inprogress');
   SELECT INTO pendingStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'pending');
   SELECT INTO unusedStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'unused');
   SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
   SELECT INTO course_Id (SELECT id FROM gradecourse WHERE lower(trim(abbreviatedname)) = lower(trim(course_Abbrname)) and course is true AND activeflag is true  LIMIT 1);
   SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true  LIMIT 1);
   SELECT INTO teacher_Id (select DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id and case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(teacher_uniqueCommonId)) LIMIT 1);
   error_msg :='';
         IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE
        IF(course_Id is null) THEN

         RAISE NOTICE 'course_Id % is invalid', course_Abbrname;

         error_msg := '<error>' || 'invalid value on course_abbrName:' || COALESCE(course_Abbrname,'NULL');

     ELSE 
  RAISE NOTICE 'Beginning remove student from roster with course';
   IF((SELECT count(stu.*)
           FROM student stu JOIN enrollment en on stu.id = en.studentid JOIN enrollmentsrosters enrl on enrl.enrollmentid = en.id and enrl.activeflag is true and stu.activeflag is true and en.activeflag is true
           WHERE lower(trim(stu.statestudentidentifier)) = lower(trim(statestudent_identifier)) AND
           enrl.rosterid IN (SELECT r.id FROM roster r
               WHERE r.activeflag is true AND  r.statecoursesid = course_Id AND r.teacherid = teacher_id AND r.statesubjectareaid = subject_Id AND r.attendanceschoolid = att_sch_id AND currentschoolyear = schoolyear AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)))
               AND en.attendanceschoolid = att_sch_id AND en.aypschoolid = ayp_sch_id AND en.currentschoolyear = schoolyear AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true )<= 0)THEN
          RAISE NOTICE 'Student % not found in state %, attendace school %', statestudent_identifier,stateDisplayidentifier, att_sch_id;
          error_msg := '<error>' || 'Student not found in roster. Student  :'||coalesce(statestudent_identifier,'NULL')|| ';state:' ||coalesce(stateDisplayidentifier,'NULL')||';attendace school:'||coalesce(att_sch_displayidentifier,'NULL')||';ayp school:'||coalesce(ayp_sch_displayidentifier,'NULL');
          error_msg := error_msg ||';associated with teacher:'||coalesce(teacher_uniqueCommonId,'NULL')|| ';roster name:'||coalesce(roster_name,'NULL')|| ';statesubjectarea:'||coalesce(subject_abbrName,'NULL')||';course_Abbrname:'||coalesce(course_Abbrname,'NULL')||';and roster attendanceschoolid:' ||coalesce(att_sch_displayidentifier,'NULL')||';for current currentschoolyear:'||cast(coalesce(schoolyear,0)as text);
         RAISE NOTICE '%',error_msg;
   ELSE
   FOR studentsEnrollemntsRostersRecord IN (SELECT stu.statestudentidentifier, stu.id as studentId, en.id as enrollmentid, enrl.id as enrlRosterId, enrl.rosterId as rosterId
           FROM student stu JOIN enrollment en on stu.id = en.studentid JOIN enrollmentsrosters enrl on enrl.enrollmentid = en.id and stu.activeflag is true and en.activeflag is true
           WHERE lower(trim(stu.statestudentidentifier)) = lower(trim(statestudent_identifier)) AND
           enrl.rosterid IN (SELECT r.id FROM roster r
               WHERE r.activeflag is true AND  r.statecoursesid = course_Id AND r.teacherid = teacher_id AND r.statesubjectareaid = subject_Id AND r.attendanceschoolid = att_sch_id AND currentschoolyear = schoolyear AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)))
               AND en.attendanceschoolid = att_sch_id AND en.aypschoolid = ayp_sch_id AND en.currentschoolyear = schoolyear AND stu.stateid = state_Id)
        LOOP
          UPDATE enrollmentsrosters SET activeflag = false,modifieddate=CURRENT_TIMESTAMP, modifieduser = ceteSysAdminUserId
                  WHERE enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid AND rosterid = studentsEnrollemntsRostersRecord.rosterId
                      AND id = studentsEnrollemntsRostersRecord.enrlRosterId;

           RAISE NOTICE 'Student(%) with Id : % is removed from the rosterId: %  enrollmentrosterId: % ', studentsEnrollemntsRostersRecord.statestudentidentifier, studentsEnrollemntsRostersRecord.studentId,
                       studentsEnrollemntsRostersRecord.rosterId, studentsEnrollemntsRostersRecord.enrlRosterId;
           error_msg = '<success>'||'Student:'||COALESCE(studentsEnrollemntsRostersRecord.statestudentidentifier,'NULL')||';  removed from the rosterId:'||CAST(COALESCE(studentsEnrollemntsRostersRecord.rosterId,0)AS TEXT);

           INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', studentsEnrollemntsRostersRecord.enrlRosterId, ceteSysAdminUserId, now(),
    'RM_STUDENT_FROM_ROSTER', ('{"rosterId":' || studentsEnrollemntsRostersRecord.rosterId  || ',"enrollmentId":'
        || studentsEnrollemntsRostersRecord.enrollmentid || ',"enrollmentRosterId":' || studentsEnrollemntsRostersRecord.enrlRosterId || '}')::json);

           FOR stuTestsRecordsInprgsPenUnusedStatus IN (SELECT st.id, st.studentid, st.testid, st.testcollectionid, st.testsessionid, st.status,st.enrollmentid
                FROM studentstests st JOIN testsession ts ON st.testsessionid = ts.id and st.activeflag=true  and ts.activeflag=true JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
     WHERE st.activeflag=true AND ts.rosterid = studentsEnrollemntsRostersRecord.rosterId
                AND st.enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid AND (otw.effectivedate <= now() AND now() <= otw.expirydate)
                AND st.status in (inProgressStuTestsStatus, pendingStuTestsStatus, unusedStuTestsStatus))
      LOOP
          PERFORM inActivateStuTestsTrackerITITestsessions(studentTestsId := stuTestsRecordsInprgsPenUnusedStatus.id, inActiveStuTestSecStatusId := rosterUnEnrolledStuTestSecsStatus,
              inActiveStuTestStatusId := rosterUnEnrolledStuTestsStatus, testsession_Id := stuTestsRecordsInprgsPenUnusedStatus.testsessionid, student_Id :=stuTestsRecordsInprgsPenUnusedStatus.studentid);
            END LOOP;
      UPDATE ititestsessionhistory SET activeflag = false, modifieddate = now(), modifieduser = ceteSysAdminUserId, status = rosterUnEnrolledStuTestsStatus
       WHERE studentenrlrosterid IN (SELECT id FROM enrollmentsrosters WHERE enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid  and rosterid = studentsEnrollemntsRostersRecord.rosterId)
             AND status = pendingStuTestsStatus AND activeflag IS true;
  END LOOP;
  END IF;
  END IF;
  END IF;
  END IF;
  RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;


-- Sample function calling
-- SELECT removeStudentFromRosterWithCourse(statestudent_identifier := '5478565' , ayp_sch_displayidentifier := 'abaes' , att_sch_displayidentifier := 'abaes' , stateDisplayidentifier := 'mo' , schoolyear := 2016 ,
        -- subject_abbrName := 'ELA' , course_Abbrname := 'ENG11' , teacher_uniqueCommonId :='89234' , roster_name:='ELA 11 LockDown');


-- US17061: DLM Lockdown Service Desk Data Scripts
-- Scenario: 1.3 Removing student from roster with NO Course.
DROP FUNCTION IF EXISTS removeStudentFromRosterWithNoCourse(character varying, character varying, character varying, character varying, bigint, character varying, character varying, character varying);

CREATE OR REPLACE FUNCTION removeStudentFromRosterWithNoCourse(statestudent_identifier character varying, ayp_sch_displayidentifier character varying, att_sch_displayidentifier character varying, stateDisplayidentifier character varying,
              schoolyear bigint, subject_abbrName character varying, teacher_uniqueCommonId character varying, roster_name character varying) RETURNS TEXT AS

$BODY$
 DECLARE
   state_Id BIGINT;
   ayp_sch_id BIGINT;
   att_sch_id BIGINT;
   ceteSysAdminUserId BIGINT;
   contentArea_Id BIGINT;
   rosterUnEnrolledStuTestSecsStatus BIGINT;
   rosterUnEnrolledStuTestsStatus BIGINT;
   inProgressStuTestsStatus BIGINT;
   pendingStuTestsStatus BIGINT;
   unusedStuTestsStatus BIGINT;
   subject_Id BIGINT;
   teacher_Id BIGINT;
   studentsEnrollemntsRostersRecord RECORD;
   stuTestsRecordsInprgsPenUnusedStatus RECORD;
   error_msg TEXT;
 BEGIN
    error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)) or lower(trim(org.tree_schooldisplayidentifier))=lower(trim(ayp_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(statestudent_identifier,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL')||';OR AYP School:'||COALESCE(ayp_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
   SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
   SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
   SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
   SELECT INTO rosterUnEnrolledStuTestSecsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TESTSECTION_STATUS' AND categorycode = 'rosterunenrolled');
   SELECT INTO rosterUnEnrolledStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'rosterunenrolled');
   SELECT INTO inProgressStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'inprogress');
   SELECT INTO pendingStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'pending');
   SELECT INTO unusedStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'unused');
   SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
   SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true  LIMIT 1);
   SELECT INTO teacher_Id (select DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id and case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(teacher_uniqueCommonId)) LIMIT 1);
   error_msg:='';
         IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE

   IF((SELECT count(1)
		   FROM student stu JOIN enrollment en on stu.id = en.studentid JOIN enrollmentsrosters enrl on enrl.enrollmentid = en.id and stu.activeflag is true and en.activeflag is true
		   WHERE lower(trim(stu.statestudentidentifier)) = lower(trim(statestudent_identifier)) AND
		   enrl.rosterid IN (SELECT r.id FROM roster r
		       WHERE r.activeflag is true AND  r.teacherid = teacher_id AND r.statesubjectareaid = subject_Id AND r.attendanceschoolid = att_sch_id AND currentschoolyear = schoolyear AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)))
		       AND en.attendanceschoolid = att_sch_id AND en.aypschoolid = ayp_sch_id AND en.currentschoolyear = schoolyear AND stu.stateid = state_Id)<=0)THEN
		  RAISE NOTICE 'Student % not found in state %, attendace school %', statestudent_identifier,stateDisplayidentifier, att_sch_id;
		  error_msg := '<error>' || ' Student not found in roster. Student:'||coalesce(statestudent_identifier,'NULL')|| ';state:' ||coalesce(stateDisplayidentifier,'NULL')||';attendace school:'||coalesce(att_sch_displayidentifier,'NULL')||';ayp school:'||coalesce(ayp_sch_displayidentifier,'NULL');
		  error_msg := error_msg ||';associated with teacher:'||coalesce(teacher_uniqueCommonId,'NULL')|| ';roster name:'||coalesce(roster_name,'NULL')|| ';statesubjectarea:'||coalesce(subject_abbrName,'NULL')||';and roster attendanceschoolid:' ||coalesce(att_sch_displayidentifier,'NULL')||';for current currentschoolyear:'||cast(coalesce(schoolyear,0)as text);
		  RAISE NOTICE '%',error_msg;          
   ELSE
    FOR studentsEnrollemntsRostersRecord IN (SELECT stu.statestudentidentifier, stu.id as studentId, en.id as enrollmentid, enrl.id as enrlRosterId, enrl.rosterId as rosterId
           FROM student stu JOIN enrollment en on stu.id = en.studentid JOIN enrollmentsrosters enrl on enrl.enrollmentid = en.id and enrl.activeflag is true and stu.activeflag is true and en.activeflag is true
           WHERE lower(trim(stu.statestudentidentifier)) = lower(trim(statestudent_identifier)) AND
           enrl.rosterid IN (SELECT r.id FROM roster r
               WHERE r.activeflag is true AND  r.teacherid = teacher_id AND r.statesubjectareaid = subject_Id AND r.attendanceschoolid = att_sch_id AND currentschoolyear = schoolyear AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)))
               AND en.attendanceschoolid = att_sch_id AND en.aypschoolid = ayp_sch_id AND en.currentschoolyear = schoolyear AND stu.stateid = state_Id)
        LOOP
          UPDATE enrollmentsrosters SET activeflag = false,modifieddate=CURRENT_TIMESTAMP, modifieduser = ceteSysAdminUserId
                  WHERE enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid AND rosterid = studentsEnrollemntsRostersRecord.rosterId
                      AND id = studentsEnrollemntsRostersRecord.enrlRosterId;

           RAISE NOTICE 'Student(%) with Id : % is removed from the rosterId: %  enrollmentrosterId: % ', studentsEnrollemntsRostersRecord.statestudentidentifier, studentsEnrollemntsRostersRecord.studentId,
                       studentsEnrollemntsRostersRecord.rosterId, studentsEnrollemntsRostersRecord.enrlRosterId;
           error_msg = '<success>'||'Student:'||COALESCE(studentsEnrollemntsRostersRecord.statestudentidentifier,'NULL')||';  removed from the rosterId:'||CAST(COALESCE(studentsEnrollemntsRostersRecord.rosterId,0) AS TEXT)||';enrollmentrosterId:'||CAST(COALESCE(studentsEnrollemntsRostersRecord.enrlRosterId,0) AS TEXT);

           INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT_ROSTER', studentsEnrollemntsRostersRecord.enrlRosterId, ceteSysAdminUserId, now(),
    'RM_STUDENT_FROM_ROSTER', ('{"rosterId":' || studentsEnrollemntsRostersRecord.rosterId  || ',"enrollmentId":'
        || studentsEnrollemntsRostersRecord.enrollmentid || ',"enrollmentRosterId":' || studentsEnrollemntsRostersRecord.enrlRosterId || '}')::json);

           FOR stuTestsRecordsInprgsPenUnusedStatus IN (SELECT st.id, st.studentid, st.testid, st.testcollectionid, st.testsessionid, st.status,st.enrollmentid
                FROM studentstests st JOIN testsession ts ON st.testsessionid = ts.id  and st.activeflag is true and ts.activeflag is true  --JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
     WHERE st.activeflag=true AND ts.rosterid = studentsEnrollemntsRostersRecord.rosterId
                AND st.enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid --AND (otw.effectivedate <= now() AND now() <= otw.expirydate)
                AND st.status in (inProgressStuTestsStatus, pendingStuTestsStatus, unusedStuTestsStatus))
      LOOP
          PERFORM inActivateStuTestsTrackerITITestsessions(studentTestsId := stuTestsRecordsInprgsPenUnusedStatus.id, inActiveStuTestSecStatusId := rosterUnEnrolledStuTestSecsStatus,
              inActiveStuTestStatusId := rosterUnEnrolledStuTestsStatus, testsession_Id := stuTestsRecordsInprgsPenUnusedStatus.testsessionid, student_Id :=stuTestsRecordsInprgsPenUnusedStatus.studentid);
            END LOOP;
      UPDATE ititestsessionhistory SET activeflag = false, modifieddate = now(), modifieduser = ceteSysAdminUserId, status = rosterUnEnrolledStuTestsStatus
       WHERE studentenrlrosterid IN (SELECT id FROM enrollmentsrosters WHERE enrollmentid = studentsEnrollemntsRostersRecord.enrollmentid  and rosterid = studentsEnrollemntsRostersRecord.rosterId)
             AND status = pendingStuTestsStatus AND activeflag IS true;
  END LOOP;
  END IF;
  END IF;
  END IF;
  RETURN error_msg;
END;
$BODY$
LANGUAGE plpgsql VOLATILE
  COST 100;          
  

-- Sample function calling
-- SELECT removeStudentFromRosterWithNoCourse(statestudent_identifier := '5478565' , ayp_sch_displayidentifier := 'abaes' , att_sch_displayidentifier := 'abaes' , stateDisplayidentifier := 'mo' , schoolyear := 2016 ,
        -- subject_abbrName := 'ELA' , teacher_uniqueCommonId :='89234' , roster_name:='ELA 11 LockDown');

        -- Scenario 3.2.1: Change educator with no course.

DROP FUNCTION IF EXISTS changeEductorOnRosterWithNoCourse(character varying, bigint, character varying, character varying, character varying, character varying, character varying);


CREATE OR REPLACE FUNCTION changeEductorOnRosterWithNoCourse(att_sch_displayidentifier character varying, schoolyear bigint,
              subject_abbrName character varying, old_teacher_uniqueCommonId character varying, new_teacher_uniqueCommonId character varying, roster_name character varying, stateDisplayidentifier character varying) RETURNS TEXT AS

        $BODY$
           DECLARE
           state_Id BIGINT;
           att_sch_id BIGINT;
           ceteSysAdminUserId BIGINT;
           contentArea_Id BIGINT;
           subject_Id BIGINT;
           old_teacherId BIGINT;
           new_teacherId BIGINT;
           rosterRecord RECORD;
           error_msg TEXT;

         BEGIN
   error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||' State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE         
           SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
           SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
           SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
           SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true  LIMIT 1);
           SELECT INTO old_teacherId (SELECT DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id AND case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(old_teacher_uniqueCommonId)) LIMIT 1);
           SELECT INTO new_teacherId (SELECT DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id AND case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(new_teacher_uniqueCommonId)) LIMIT 1);
             IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE
     IF(new_teacherId is null) THEN

         RAISE NOTICE 'NEW Teacher % is not found in the organization %', new_teacher_uniqueCommonId, att_sch_displayidentifier;

         error_msg := '<error>' || 'NEW Teacher:' || COALESCE(new_teacher_uniqueCommonId,'NULL')|| ';  not found in the organization:' || COALESCE(att_sch_displayidentifier,'NULL');

     ELSE
           IF((SELECT count(*) FROM roster r WHERE r.activeflag is true AND  lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id
                                  AND currentschoolyear = schoolyear AND teacherid = old_teacherId)) <= 0 THEN

             RAISE NOTICE 'No rosters found with roster name: %, subject: %, attendanceschool: %, teacher: %, and school year: %  ', roster_name, subject_abbrName, att_sch_displayidentifier,
                   old_teacher_uniqueCommonId, schoolyear;

             error_msg := '<error>' || 'No rosters found with roster name:' || COALESCE(roster_name,'NULL') || ';subject:' || COALESCE(subject_abbrName,'NULL') || ';attendanceschool:' || COALESCE(att_sch_displayidentifier,'NULL')||';teacher:' || COALESCE(old_teacher_uniqueCommonId,'NULL') || ';and school year:' || CAST(COALESCE(schoolyear,0) AS TEXT);

           ELSE
           FOR rosterRecord IN (SELECT r.* FROM roster r WHERE r.activeflag is true AND lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id
                                  AND currentschoolyear = schoolyear AND teacherid = old_teacherId)
             LOOP

          UPDATE roster set teacherid = new_teacherId, modifieddate=CURRENT_TIMESTAMP, modifieduser = ceteSysAdminUserId
                      WHERE id = rosterRecord.id;

                INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ROSTER', rosterRecord.id, ceteSysAdminUserId, now(),
            'TEACHER_CHANGE', ('{"rosterId":' ||  rosterRecord.id || ',"oldEducatorId":' ||  old_teacherId || ',"newEducatorId":'  || new_teacherId || '}')::json);

          RAISE NOTICE 'Roster with id %, changed the educator from  % to new educator %', rosterRecord.id, old_teacher_uniqueCommonId, new_teacher_uniqueCommonId;
          error_msg = '<success>'||'Roster with id:' || CAST(COALESCE(rosterRecord.id,0) AS TEXT) || ';changed the educator from:'||COALESCE(old_teacher_uniqueCommonId,'NULL')||';to new educator:'||COALESCE(new_teacher_uniqueCommonId,'NULL');
             END LOOP;
           END IF;
           END IF;
           END IF;
           END IF;
        RETURN error_msg;
        END;
        $BODY$
        LANGUAGE plpgsql VOLATILE
          COST 100;



        -- Calling the function
        --SELECT changeEductorOnRosterWithNoCourse(att_sch_displayidentifier := 'ABAES', schoolyear := 2016, subject_abbrName :='ELA' , old_teacher_uniqueCommonId := 'PriyaRao',
        -- new_teacher_uniqueCommonId:='Priya_DLMTest' ,  roster_name:='Priya_DLM_ELA_Test',stateDisplayidentifier := 'MO');

        -- Scenario 3.2.2: Change educator with course.

DROP FUNCTION IF EXISTS changeEductorOnRosterWithCourse(character varying, bigint, character varying, character varying, character varying, character varying, character varying, character varying);


CREATE OR REPLACE FUNCTION changeEductorOnRosterWithCourse(att_sch_displayidentifier character varying, schoolyear bigint,
              subject_abbrName character varying, course_Abbrname character varying, old_teacher_uniqueCommonId character varying, new_teacher_uniqueCommonId character varying, roster_name character varying, stateDisplayidentifier character varying) RETURNS TEXT AS

        $BODY$
           DECLARE
           state_Id BIGINT;
           att_sch_id BIGINT;
           ceteSysAdminUserId BIGINT;
           contentArea_Id BIGINT;
           subject_Id BIGINT;
           old_teacherId BIGINT;
           new_teacherId BIGINT;
           rosterRecord RECORD;
           course_Id BIGINT;
           error_msg TEXT;

         BEGIN
            error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||' State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
           SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
           SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
           SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
           SELECT INTO subject_Id (SELECT id FROM contentarea WHERE lower(trim(abbreviatedname))  = lower(trim(subject_abbrName)) AND activeflag is true  LIMIT 1);
           SELECT INTO old_teacherId (SELECT DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id AND case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(old_teacher_uniqueCommonId)) LIMIT 1);
           SELECT INTO new_teacherId (SELECT DISTINCT au.id FROM aartuser au JOIN usersorganizations uso ON uso.aartuserid = au.id WHERE au.activeflag is true AND  uso.organizationid  = att_sch_id AND case when lower(coalesce(uniquecommonidentifier,''))='' then lower(trim(email)) else  lower(trim(uniquecommonidentifier)) end = lower(trim(new_teacher_uniqueCommonId)) LIMIT 1);
           SELECT INTO course_Id (SELECT id FROM gradecourse WHERE lower(trim(abbreviatedname)) = lower(trim(course_Abbrname)) AND activeflag is true  and course is true LIMIT 1);
         IF(subject_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', subject_abbrName;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(subject_abbrName,'NULL');

     ELSE
              IF(course_Id is null) THEN

         RAISE NOTICE 'subject_Id % is invalid', course_Abbrname;

         error_msg := '<error>' || 'invalid value on subject_abbrName:' || COALESCE(course_Abbrname,'NULL');

     ELSE
     IF(new_teacherId is null) THEN

         RAISE NOTICE 'NEW Teacher % is not found in the organization %', new_teacher_uniqueCommonId, att_sch_displayidentifier;

         error_msg := '<error>' || 'NEW Teacher:' || COALESCE(new_teacher_uniqueCommonId,'NULL')|| ';  not found in the organization:' || COALESCE(att_sch_displayidentifier,'NULL');

     ELSE
           IF((SELECT count(*) FROM roster r WHERE r.activeflag is true AND  lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id AND r.statecoursesid = course_Id
                                  AND currentschoolyear = schoolyear AND teacherid = old_teacherId)) <= 0 THEN

             RAISE NOTICE 'No rosters found with roster name: %, subject: %, course: %, attendanceschool: %, teacher: %, and school year: %  ', roster_name, subject_abbrName, course_Abbrname, att_sch_displayidentifier,
                   old_teacher_uniqueCommonId, schoolyear;

             error_msg := '<error>' || 'No rosters found with roster name:' || COALESCE(roster_name,'NULL') || ';subject:' || COALESCE(subject_abbrName,'NULL') || ';course:' || COALESCE(course_Abbrname,'NULL') || ';attendanceschool:' || COALESCE(att_sch_displayidentifier,'NULL')  ||';teacher:' || COALESCE(old_teacher_uniqueCommonId,'NULL')  ||';and school year:' || CAST(COALESCE(schoolyear,0) AS TEXT);

           ELSE
           FOR rosterRecord IN (SELECT r.* FROM roster r WHERE r.activeflag is true AND  lower(trim(r.coursesectionname)) = lower(trim(roster_name)) AND attendanceschoolid = att_sch_id AND r.statesubjectareaid = subject_Id AND r.statecoursesid = course_Id
                                  AND currentschoolyear = schoolyear AND teacherid = old_teacherId)
             LOOP

          UPDATE roster set teacherid = new_teacherId, modifieddate=CURRENT_TIMESTAMP, modifieduser = ceteSysAdminUserId
                      WHERE id = rosterRecord.id;

          INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ROSTER', rosterRecord.id, ceteSysAdminUserId, now(),
            'TEACHER_CHANGE', ('{"rosterId":' ||  rosterRecord.id || ',"oldEducatorId":' ||  old_teacherId || ',"newEducatorId":'  || new_teacherId || '}')::json);

          RAISE NOTICE 'Roster with id %, changed the educator % from to new educator %', rosterRecord.id, old_teacher_uniqueCommonId, new_teacher_uniqueCommonId;

          error_msg := '<success>' || 'Roster with id :'|| CAST(COALESCE(rosterRecord.id,0) AS TEXT)  || ';changed the educator from:' || COALESCE(old_teacher_uniqueCommonId,'NULL') || ';to new educator :' || COALESCE(new_teacher_uniqueCommonId,'NULL');

             END LOOP;
           END IF;
           END IF;
           END IF;
           END IF;
           END IF;
        RETURN error_msg;
        END;
        $BODY$
        LANGUAGE plpgsql VOLATILE
        COST 100;



        DROP FUNCTION IF EXISTS updateStudentDemoGraphics(character varying, character varying, boolean, character varying, character varying, character varying, character varying, bigint, character varying);

        -- US17061: DLM Lockdown Service Desk Data Scripts
        -- Scenario 5: Update student demographic data. Also changes the date of birth, firstname, last name and also updates the username of the student.

        DROP FUNCTION IF EXISTS updateStudentDemoGraphics(character varying, character varying, character varying, character varying, boolean, character varying, character varying, character varying, character varying, bigint, character varying, date);

        DROP FUNCTION IF EXISTS updateStudentDemoGraphics(character varying, character varying, character varying, character varying, boolean, character varying, character varying, character varying, character varying, bigint, character varying, date,integer);
        
        CREATE OR REPLACE FUNCTION updateStudentDemoGraphics(student_firstName character varying, student_LastName character varying, state_student_identifier character varying, state_displayidentifier character varying, hispanic_Ethnicity boolean, race character varying, esolCode character varying,
           att_sch_displayidentifier character varying, ayp_sch_displayidentifier character varying, schoolyear bigint, grade_abbrName character varying, birthDate date,student_gender integer) RETURNS text AS

        $BODY$
           DECLARE
           state_Id BIGINT;
           ceteSysAdminUserId BIGINT;
           att_sch_id BIGINT;
           ayp_sch_id BIGINT;
           grade_Id BIGINT;
           student_userName CHARACTER VARYING;
           updated_userName CHARACTER VARYING;
           studentRecord RECORD;
           dob date;
           error_msg TEXT;

         BEGIN
              error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(state_displayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)) or lower(trim(org.tree_schooldisplayidentifier))=lower(trim(ayp_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(state_student_identifier,'NULL')||';State:'||COALESCE(state_displayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL')||';OR AYP School:'||COALESCE(ayp_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
           SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(state_displayidentifier)) AND activeflag is true );
           SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
           SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
           SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
           SELECT INTO grade_Id (SELECT id FROM gradecourse gc WHERE contentareaid IS NULL AND assessmentprogramgradesid IS NOT NULL
        					AND lower(trim(abbreviatedname)) = lower(trim(grade_abbrName)) AND activeflag is true );

           IF((SELECT count(stu.*) FROM student stu JOIN enrollment en ON en.studentid = stu.id
                      WHERE trim(stu.statestudentidentifier) = trim(state_student_identifier) AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true AND en.attendanceschoolid = att_sch_id
                        AND en.aypschoolid = ayp_sch_id AND en.currentschoolyear = schoolyear AND en.currentgradelevel = grade_Id) <= 0) THEN
        	RAISE NOTICE 'Student % not found in state %, attendace school %, ayp school %, grade %, and current school %', state_student_identifier,
        	                  state_student_identifier, att_sch_displayidentifier, ayp_sch_displayidentifier, grade_abbrName, schoolyear;
               error_msg := '<error>' || 'Student:'|| coalesce(state_student_identifier,'NULL')||';not found in state :'||coalesce(state_displayidentifier,'NULL')|| ';att_sch_displayidentifier:'||coalesce(att_sch_displayidentifier,'NULL')||';ayp school:'||coalesce(ayp_sch_displayidentifier,'NULL')|| ';grade:'||coalesce(grade_abbrName,'NULL')|| ';and current school:'||cast(coalesce(schoolyear,0) as text);


           ELSE

              FOR studentRecord IN (SELECT stu.* FROM student stu JOIN enrollment en ON en.studentid = stu.id
                      WHERE trim(stu.statestudentidentifier) = trim(state_student_identifier) AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true AND en.attendanceschoolid = att_sch_id
                        AND en.aypschoolid = ayp_sch_id AND en.currentschoolyear = schoolyear AND en.currentgradelevel = grade_Id LIMIT 1) LOOP

                IF(lower(studentRecord.legalfirstname) != lower(student_firstName)  OR lower(studentRecord.legallastname) != lower(student_LastName)) THEN
                    SELECT substring(student_firstName, 1, LEAST(length(student_firstName), 4)) || '.' || substring(student_LastName, 1, LEAST(length(student_LastName), 4)) INTO student_userName;

                    select (case when ucount is null
                         then student_userName
        		 else student_userName || '.' || (ucount+1)
        		 end) as modifiedUsername from (select (select 0 as ucount from student where username = student_userName
        					union select CAST(split_part(username, '.', 3) as int) as ucount from student
        					where username like  student_userName || '.%' order by ucount desc limit 1) )a INTO updated_userName;

                  update student set legalfirstname = student_firstName, legallastname = student_LastName, username = updated_userName,modifieddate = now(),
        	         modifieduser = ceteSysAdminUserId WHERE id = studentRecord.id;
        	  error_msg := '<success>' 	;

                END IF;
        	IF (birthDate IS null)
        	  THEN
        	     dob = studentRecord.dateofbirth;
        	   ELSE
        	    dob = birthDate;
        	 END IF;

        	UPDATE student SET esolparticipationcode = esolCode, hispanicethnicity = hispanic_Ethnicity, comprehensiverace = race, modifieddate = now(), dateofbirth = dob,
        	         modifieduser = ceteSysAdminUserId,gender=student_gender
        	          WHERE id = studentRecord.id;

               RAISE NOTICE 'Student %  demographic info got changed', state_student_identifier;
               error_msg := '<success>' || 'demographic info got changed Student:'|| state_student_identifier ||';in state :'||state_displayidentifier||';att_sch_displayidentifier:'||att_sch_displayidentifier||';ayp school:'||ayp_sch_displayidentifier||';grade:'||grade_abbrName||';and current school:'|| cast(coalesce(schoolyear,0) as text)||';and gender:'|| cast(coalesce(student_gender,0) as text);

              END LOOP;

           END IF;
           END IF;
           RETURN error_msg;
        END;
        $BODY$
        LANGUAGE plpgsql VOLATILE
          COST 100;

        -- US17061: DLM Lockdown Service Desk Data Scripts
        -- Scenario: 8: TransferStudent
        DROP FUNCTION IF EXISTS transferStudent(character varying, character varying, character varying, numeric, date, bigint,
              character varying, character varying, character varying, date, date, character varying);

        CREATE OR REPLACE FUNCTION transferStudent(statestudent_identifier character varying, old_aypSch character varying, old_attSch character varying, exitReason numeric, exitDate date, schoolyear bigint,
              new_AypSch character varying, new_attSch character varying, new_Dist character varying, new_schEntryDate date, new_DistEntryDate date, stateDisplayidentifier character varying)
                RETURNS text AS
        $BODY$
         DECLARE
           old_studentEnrollemntRecord RECORD;
           old_stuTestsRecordsInprgsPenUnusedStatus RECORD;
           state_Id BIGINT;
           old_ayp_sch_id BIGINT;
           old_att_sch_id BIGINT;
           new_aypSch_id BIGINT;
           new_attSch_id BIGINT;
           new_dist_id BIGINT;
           exitStuTestSecsStatus BIGINT;
           exitStuTestsStatus BIGINT;
           inProgressStuTestsStatus BIGINT;
           pendingStuTestsStatus BIGINT;
           unusedStuTestsStatus BIGINT;
           ceteSysAdminUserId BIGINT;
           new_EnrlId BIGINT;
           newSchEnrlRecord RECORD;
           enrlTestTypeSubjectAreaRecord RECORD;
           error_msg text;
           new_schEntryDate_cdt timestamp with time zone;
           new_DistEntryDate_cdt timestamp with time zone; 
           exitDate_cdt timestamp with time zone;

         BEGIN
            error_msg :='';
            new_schEntryDate_cdt:=((new_schEntryDate::timestamp) AT TIME ZONE 'CDT');
            new_DistEntryDate_cdt:=((new_DistEntryDate::timestamp) AT TIME ZONE 'CDT');
            exitDate_cdt:=((exitDate::timestamp) AT TIME ZONE 'CDT');
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(old_attSch)) or lower(trim(org.tree_schooldisplayidentifier))=lower(trim(old_aypSch)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(statestudent_identifier,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND old Attendance school:'||COALESCE(old_attSch,'NULL')||';OR old AYP School:'||COALESCE(old_attSch,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(stateDisplayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(new_attSch)) or lower(trim(org.tree_schooldisplayidentifier))=lower(trim(new_AypSch)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(statestudent_identifier,'NULL')||';State:'||COALESCE(stateDisplayidentifier,'NULL')||';AND new Attendance school:'||COALESCE(new_attSch,'NULL')||';OR new AYP School:'||COALESCE(new_AypSch,'NULL');
       RAISE NOTICE '%',error_msg;
       ELSE
        	SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(stateDisplayidentifier)) AND activeflag is true);
        	SELECT INTO old_ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(old_aypSch)));
        	SELECT INTO old_att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(old_attSch)));
        	SELECT INTO new_aypSch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(new_AypSch)));
        	SELECT INTO new_attSch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(new_attSch)));
        	SELECT INTO new_dist_id (SELECT districtid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(new_attSch)));
        	SELECT INTO exitStuTestSecsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TESTSECTION_STATUS' AND categorycode = 'exitclearunenrolled');
        	SELECT INTO exitStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'exitclearunenrolled');
        	SELECT INTO inProgressStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'inprogress');
        	SELECT INTO pendingStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'pending');
        	SELECT INTO unusedStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'unused');
        	SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
        	error_msg := '';

           IF((SELECT count(stu.*) FROM student stu JOIN enrollment en ON en.studentid = stu.id
        					WHERE lower(trim(stu.statestudentidentifier)) = lower(trim(statestudent_identifier))
        					AND stu.stateid = state_Id and en.currentschoolyear = schoolyear
        					AND en.aypschoolid = old_ayp_sch_id and en.attendanceschoolid = old_att_sch_id) <= 0) THEN
        	RAISE NOTICE 'Student % not found in state %, attendace school %', statestudent_identifier,stateDisplayidentifier, old_attSch;
        	error_msg := '<error>' || 'Student:'||coalesce(statestudent_identifier,'NULL')|| ';not found in state:' ||coalesce(stateDisplayidentifier,'NULL')||';attendace school:'||coalesce(old_attSch,'NULL')||';ayp school:'||coalesce(old_aypSch,'NULL');
                RAISE NOTICE '%',error_msg;
           ELSE
            FOR old_studentEnrollemntRecord IN (SELECT stu.statestudentidentifier,stu.stateid, en.* FROM student stu JOIN enrollment en ON en.studentid = stu.id
        					WHERE lower(trim(stu.statestudentidentifier)) = lower(trim(statestudent_identifier))
        					AND stu.stateid = state_Id and en.currentschoolyear = schoolyear
        					AND en.aypschoolid = old_ayp_sch_id and en.attendanceschoolid = old_att_sch_id)
             LOOP
                 IF (old_studentEnrollemntRecord.schoolentrydate <= exitDate_cdt) THEN
                   UPDATE enrollment SET exitwithdrawaldate = exitDate_cdt, activeflag = false, exitwithdrawaltype = exitReason, modifieddate = now(), modifieduser = ceteSysAdminUserId WHERE id = old_studentEnrollemntRecord.id;

                   RAISE NOTICE 'Updated the enrollment record with id: %', old_studentEnrollemntRecord.id;

                  INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT', old_studentEnrollemntRecord.id, ceteSysAdminUserId, now(),
        		'EXIT_STUDENT', ('{"studentId":'|| old_studentEnrollemntRecord.studentid || ',"stateId":' ||  old_studentEnrollemntRecord.stateid
        				|| ',"stateStudentIdentifier":"' || old_studentEnrollemntRecord.statestudentidentifier
        				|| '","aypSchool":' || old_studentEnrollemntRecord.aypschoolid || ',"attendanceSchoolId":'|| old_studentEnrollemntRecord.attendanceschoolid
        				|| ',"exitWithdrawalDate":"' || exitDate || '","exitReason":"' || exitReason ||  '"}')::json);

                  IF ((SELECT count(en.*) FROM enrollment en WHERE studentid = old_studentEnrollemntRecord.studentid AND aypschoolid = new_aypSch_id AND attendanceschoolid = new_attSch_id
                              AND currentschoolyear = schoolyear) <= 0)
                    THEN
        		INSERT INTO enrollment(aypschoolidentifier, residencedistrictidentifier, localstudentidentifier,
        			currentgradelevel, currentschoolyear, attendanceschoolid,
        			schoolentrydate, districtentrydate, stateentrydate, exitwithdrawaldate,
        			exitwithdrawaltype, specialcircumstancestransferchoice,
        			giftedstudent, specialedprogramendingdate,
        			qualifiedfor504, studentid, restrictionid, createddate, createduser,
        			activeflag, modifieddate, modifieduser, aypSchoolId, sourcetype)
        		 VALUES (new_AypSch, new_Dist, old_studentEnrollemntRecord.localstudentidentifier,
        		          old_studentEnrollemntRecord.currentgradelevel, schoolyear, new_attSch_id,
        		          new_schEntryDate_cdt, new_DistEntryDate_cdt, old_studentEnrollemntRecord.stateentrydate, null,
        		          0, old_studentEnrollemntRecord.specialcircumstancestransferchoice,
        		          old_studentEnrollemntRecord.giftedstudent, old_studentEnrollemntRecord.specialedprogramendingdate,
        		          old_studentEnrollemntRecord.qualifiedfor504, old_studentEnrollemntRecord.studentid, old_studentEnrollemntRecord.restrictionid, now(), ceteSysAdminUserId,
        		          true, now(), ceteSysAdminUserId, new_aypSch_id, 'STUDENT_TRANSFER_T') RETURNING id INTO new_EnrlId;

        	    INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT', new_EnrlId, ceteSysAdminUserId, now(),
        		'NEW_ENROLLMENT', ('{"studentId":'|| old_studentEnrollemntRecord.studentid || ',"stateId":' ||  old_studentEnrollemntRecord.stateid
        				|| ',"stateStudentIdentifier":"' || old_studentEnrollemntRecord.statestudentidentifier
        				|| '","aypSchool":' || new_aypSch_id || ',"attendanceSchoolId":'|| new_attSch_id
        				|| ',"grade":' || old_studentEnrollemntRecord.currentgradelevel || ',"schoolEntryDate":"' || new_schEntryDate ||  '"}')::json);

                     FOR enrlTestTypeSubjectAreaRecord IN (SELECT * FROM enrollmenttesttypesubjectarea WHERE enrollmentid = old_studentEnrollemntRecord.id AND activeflag = true)
                     LOOP

                         INSERT INTO enrollmenttesttypesubjectarea(activeflag, enrollmentid, testtypeid, subjectareaid, groupingindicator1, groupingindicator2, createddate, createduser, modifieddate, modifieduser)
                               VALUES(true, new_EnrlId, enrlTestTypeSubjectAreaRecord.testtypeid, enrlTestTypeSubjectAreaRecord.subjectareaid, enrlTestTypeSubjectAreaRecord.groupingindicator1, enrlTestTypeSubjectAreaRecord.groupingindicator2,
                                        now(), ceteSysAdminUserId, now(), ceteSysAdminUserId);

                     END LOOP;

        	  ELSE

        	    FOR newSchEnrlRecord IN (SELECT en.* FROM enrollment en WHERE studentid = old_studentEnrollemntRecord.studentid AND aypschoolid = new_aypSch_id AND attendanceschoolid = new_attSch_id
                              AND currentschoolyear = schoolyear LIMIT 1)
                     LOOP

        		UPDATE enrollment SET activeflag = true, schoolentrydate = new_schEntryDate_cdt, districtentrydate = new_DistEntryDate_cdt, exitwithdrawaldate = null,
        		          exitwithdrawaltype = 0, currentgradelevel = old_studentEnrollemntRecord.currentgradelevel, modifieduser = ceteSysAdminUserId,
        		          modifieddate = now() WHERE id = newSchEnrlRecord.id;

        		RAISE NOTICE 'Enrollment % is updated, already transfered school has enrollment for student % in school year %', newSchEnrlRecord.id, old_studentEnrollemntRecord.statestudentidentifier, schoolyear;
                        error_msg := '<success>';
                     FOR enrlTestTypeSubjectAreaRecord IN (SELECT * FROM enrollmenttesttypesubjectarea WHERE enrollmentid = old_studentEnrollemntRecord.id AND activeflag = true)
                     LOOP

                         INSERT INTO enrollmenttesttypesubjectarea(activeflag, enrollmentid, testtypeid, subjectareaid, groupingindicator1, groupingindicator2, createddate, createduser, modifieddate, modifieduser)
                               VALUES(true, newSchEnrlRecord.id, enrlTestTypeSubjectAreaRecord.testtypeid, enrlTestTypeSubjectAreaRecord.subjectareaid, enrlTestTypeSubjectAreaRecord.groupingindicator1, enrlTestTypeSubjectAreaRecord.groupingindicator2,
                                        now(), ceteSysAdminUserId, now(), ceteSysAdminUserId);

                     END LOOP;

                     END LOOP;

                  END IF;

                  FOR old_stuTestsRecordsInprgsPenUnusedStatus IN (SELECT  st.id, st.studentid, st.testid, st.testcollectionid, st.testsessionid, st.status,st.enrollmentid
                        FROM studentstests st JOIN testsession ts on st.testsessionid = ts.id and st.activeflag=true  and ts.activeflag=true JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
                         WHERE st.activeflag=true AND st.enrollmentid = old_studentEnrollemntRecord.id AND (otw.effectivedate <= now() AND now() <= otw.expirydate)
                         AND st.status in (inProgressStuTestsStatus, pendingStuTestsStatus,unusedStuTestsStatus)) LOOP

        		PERFORM inActivateStuTestsTrackerITITestsessions(studentTestsId := old_stuTestsRecordsInprgsPenUnusedStatus.id , inActiveStuTestSecStatusId := exitStuTestSecsStatus,
        		      inActiveStuTestStatusId := exitStuTestsStatus, testsession_Id := old_stuTestsRecordsInprgsPenUnusedStatus.testsessionid, student_Id := old_stuTestsRecordsInprgsPenUnusedStatus.studentid);


                  END LOOP;
                  UPDATE ititestsessionhistory SET activeflag=false,modifieddate=now(),modifieduser=ceteSysAdminUserId,status=exitStuTestsStatus
        		       WHERE studentenrlrosterid IN (SELECT id FROM enrollmentsrosters WHERE enrollmentid = old_studentEnrollemntRecord.id)
                               AND status = (SELECT cat.id FROM category cat, categorytype ct WHERE ct.id = cat.categorytypeid AND cat.categorycode='pending' AND ct.typecode = 'STUDENT_TEST_STATUS')
                               AND activeflag IS true;
                 ELSE
                   RAISE NOTICE 'Exit withdrawal date(%) is less than the school entry date(%)', exitDate, old_studentEnrollemntRecord.schoolentrydate;
                   error_msg := '<error>' || 'Exit withdrawal date:'||  cast(coalesce(exitDate,'01/01/1900') as text) ||';  less than the school entry date:'  ||  cast(coalesce(old_studentEnrollemntRecord.schoolentrydate,'01/01/1900') as text) ;
               END IF;
           END LOOP;
             END IF;
             END IF;
             END IF;
           RETURN error_msg;
           END;
        $BODY$
        LANGUAGE plpgsql VOLATILE
          COST 100;
                  -- US17061: DLM Lockdown Service Desk Data Scripts
          -- Scenario 6: Update student grade.

          DROP FUNCTION IF EXISTS updateStudentGrade(character varying, character varying, character varying, character varying, bigint, character varying, character varying);


          CREATE OR REPLACE FUNCTION updateStudentGrade(state_student_identifier character varying, state_displayidentifier character varying, att_sch_displayidentifier character varying, ayp_sch_displayidentifier character varying,
          	schoolyear bigint, old_grade character varying, new_grade character varying) RETURNS text AS

          $BODY$
             DECLARE
             state_Id BIGINT;
             ceteSysAdminUserId BIGINT;
             att_sch_id BIGINT;
             ayp_sch_id BIGINT;
             old_grade_Id BIGINT;
             new_grade_Id BIGINT;
             enrollmentRecord RECORD;
             studentTestsRecords RECORD;
             exitStuTestSecsStatus BIGINT;
             exitStuTestsStatus BIGINT;
             error_msg text ;

           BEGIN
                error_msg :='';
   IF (select count(*) from (select o.schooldisplayidentifier tree_schooldisplayidentifier,o.stateDisplayidentifier tree_stateDisplayidentifier from organizationtreedetail o) org 
            where lower(trim(org.tree_stateDisplayidentifier))=lower(trim(state_displayidentifier))
            and (lower(trim(org.tree_schooldisplayidentifier))=lower(trim(att_sch_displayidentifier)))  
       group by org.tree_schooldisplayidentifier,org.tree_stateDisplayidentifier order by 1 desc limit 1 ) >1
   THEN 
       error_msg := '<error> Duplicate display Identifier on school more info>> '||'Student:'||COALESCE(state_student_identifier,'NULL')||';State:'||COALESCE(state_displayidentifier,'NULL')||';AND Attendance school:'||COALESCE(att_sch_displayidentifier,'NULL');
       RAISE NOTICE '%',error_msg;
   ELSE
             SELECT INTO state_Id (SELECT id FROM organization WHERE lower(trim(displayidentifier)) = lower(trim(state_displayidentifier)) AND activeflag is true );
             SELECT INTO att_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(att_sch_displayidentifier)));
             SELECT INTO ayp_sch_id (SELECT schoolid FROM organizationtreedetail WHERE stateid = state_Id AND lower(trim(schooldisplayidentifier)) = lower(trim(ayp_sch_displayidentifier)));
             SELECT INTO ceteSysAdminUserId (SELECT id FROM aartuser WHERE username='cetesysadmin');
             SELECT INTO old_grade_Id (SELECT id FROM gradecourse gc WHERE contentareaid IS NULL AND assessmentprogramgradesid IS NOT NULL
          					AND trim(abbreviatedname) = trim(old_grade) AND activeflag is true );
             SELECT INTO new_grade_Id (SELECT id FROM gradecourse gc WHERE contentareaid IS NULL AND assessmentprogramgradesid IS NOT NULL
          					AND trim(abbreviatedname) = trim(new_grade) AND activeflag is true );
             SELECT INTO exitStuTestSecsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TESTSECTION_STATUS' AND categorycode = 'exitclearunenrolled');
             SELECT INTO exitStuTestsStatus (SELECT c.id FROM category c INNER JOIN categorytype ct ON c.categorytypeid=ct.id WHERE ct.typecode='STUDENT_TEST_STATUS' AND categorycode = 'exitclearunenrolled');

             IF((SELECT count(stu.*) FROM student stu JOIN enrollment en ON en.studentid = stu.id
                        WHERE trim(stu.statestudentidentifier) = trim(state_student_identifier) AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true AND en.attendanceschoolid = att_sch_id
                           AND en.currentschoolyear = schoolyear AND en.currentgradelevel = old_grade_Id) <= 0) THEN
          	RAISE NOTICE 'Student % not found in state %, attendace school %, grade %, and current school %', state_student_identifier,state_displayidentifier, att_sch_displayidentifier,  old_grade, schoolyear;
          	error_msg := '<error>' || 'Student:'||coalesce(state_student_identifier,'NULL')|| ';not found in state:' ||coalesce(state_displayidentifier,'NULL')||';attendace school:'||coalesce(att_sch_displayidentifier,'NULL')||';grade:'||coalesce(old_grade,'NULL')||';and current school:'|| cast(coalesce(schoolyear,0)as text);
                  RAISE NOTICE '%',error_msg;
             ELSE

                FOR enrollmentRecord IN (SELECT stu.id as studentid, stu.stateid, en.* FROM student stu JOIN enrollment en ON en.studentid = stu.id
                        WHERE trim(stu.statestudentidentifier) = trim(state_student_identifier) AND stu.stateid = state_Id  and en.activeflag is true and stu.activeflag is true AND en.attendanceschoolid = att_sch_id 
                           AND en.currentschoolyear = schoolyear AND en.currentgradelevel = old_grade_Id) LOOP

          	UPDATE enrollment SET currentgradelevel = new_grade_Id, modifieddate = now(), modifieduser = ceteSysAdminUserId WHERE id = enRollmentRecord.id;

          	INSERT INTO domainaudithistory (source,objecttype,objectid, createduserid, createddate, action, objectaftervalues) VALUES ('LOCK_DOWN_SCRIPT', 'ENROLLMENT', enrollmentRecord.id, ceteSysAdminUserId, now(),
          		'GRADE_CHANGE', ('{"studentId":' || enrollmentRecord.studentid || ',"stateId":' || state_Id
          				|| ',"stateStudentIdentifier":"' || state_student_identifier || '","aypSchool":' || enrollmentRecord.aypschoolid
          				|| ',"attendanceSchoolId":' || enrollmentRecord.attendanceschoolid
          				|| ',"newGrade":' || new_grade_Id || ',"oldGrade":' || old_grade_Id || '}')::json);

          	RAISE NOTICE 'Student %  grade is changed to %', state_student_identifier, new_grade;
          	error_msg := '<success>' || coalesce(state_student_identifier,'NULL') || ':Student grade is changed' ;

          	FOR studentTestsRecords IN (SELECT  st.id, st.studentid, st.testid, st.testcollectionid, st.testsessionid, st.status,st.enrollmentid
                          FROM studentstests st JOIN testsession ts on st.testsessionid = ts.id and st.activeflag=true  and ts.activeflag=true JOIN operationaltestwindow otw on otw.id = ts.operationaltestwindowid
                           WHERE st.activeflag=true AND st.enrollmentid = enrollmentRecord.id AND (otw.effectivedate <= now() AND now() <= otw.expirydate))
          	LOOP

          	    PERFORM inActivateStuTestsTrackerITITestsessions(studentTestsId := studentTestsRecords.id , inActiveStuTestSecStatusId := exitStuTestSecsStatus,
          		      inActiveStuTestStatusId := exitStuTestsStatus, testsession_Id := studentTestsRecords.testsessionid, student_Id := studentTestsRecords.studentid);

                  END LOOP;
          	    UPDATE ititestsessionhistory SET activeflag=false,modifieddate=now(),modifieduser=ceteSysAdminUserId,status=exitStuTestsStatus
          		       WHERE studentenrlrosterid IN (SELECT id FROM enrollmentsrosters WHERE enrollmentid = enrollmentRecord.id)
                                 AND status = (SELECT cat.id FROM category cat, categorytype ct WHERE ct.id = cat.categorytypeid AND cat.categorycode='pending' AND ct.typecode = 'STUDENT_TEST_STATUS')
                                 AND activeflag IS true;
               END LOOP;
             END IF;
             END IF;
              RETURN error_msg;
          END;
          $BODY$
          LANGUAGE plpgsql VOLATILE
            COST 100;


          -- Calling the function
          --SELECT updateStudentGrade(state_student_identifier := , state_displayidentifier := , att_sch_displayidentifier := , ayp_sch_displayidentifier := ,
          --	schoolyear := , old_grade := , new_grade := );


          -- Calling the function
          --SELECT updateStudentGrade(state_student_identifier := , state_displayidentifier := , att_sch_displayidentifier := , ayp_sch_displayidentifier := ,
          --	schoolyear := , old_grade := , new_grade := );