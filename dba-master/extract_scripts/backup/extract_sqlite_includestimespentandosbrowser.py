#!/usr/bin/python
#author:Rohit Yadav
import sqlite3
import psycopg2
import psycopg2.extras
import decimal
import json
import os
import sys
import logging
from optparse import OptionParser
from operator import itemgetter
from datetime import datetime
D = decimal.Decimal


def adapt_decimal(d):
    return str(d)


def convert_decimal(s):
    return D(s)


def _is_table(sqliteconn, tablename):
    """
    Tests for the existance of a given table.
    """

    sqlitecur = sqliteconn.cursor()

    sqlitecur.execute('SELECT name FROM sqlite_master WHERE type=? AND name=?;'
                      , ('table', tablename))
    tables = sqlitecur.fetchone()

    if tables is None:
        return False

    return True


def list_assessment_programs(options, cursor):
    """
        List all of the assessment programs.
    """

    cursor.execute('SELECT id, programname FROM assessmentprogram WHERE activeflag = true ORDER BY id'
                   )

    for row in cursor.fetchall():
        print '{0:8d}: {1}'.format(row[0], row[1])

    cursor.close()


def extract_educators(options, db, sqliteconn):
    """
    Create the educators table
    """

    sqlitecur = sqliteconn.cursor()

    # FIX so school id and school code populate.
    if (not _is_table(sqliteconn, 'educators')):
        sqlitecur.execute("""
            CREATE Table educators (
                id int,
                uniqueid text,
                active boolean,
                username text,
                firstname text,
                lastname text,
                schoolid text,
                school_code text,
                school text,
                district text,
                area text,
                region text,
                state text,
                role text,
                schoolyear int,
                agreement text,
                agreementdate datetime,
                exipredate datetime
            );
            """);

    # FIXME: Limit this user listing to participants in program.

    cursor1 = db.cursor()
    cursor1.execute("""
	/*NO LOAD BALANCE*/
    SELECT  au.id, au.activeflag, au.uniquecommonidentifier, au.username,
            au.firstname, au.surname,
            o.organizationname, o.displayidentifier, o.id, o.organizationtypeid,
            po.organizationname, po.displayidentifier, po.id,
                po.organizationtypeid,
            gpo.organizationname, gpo.displayidentifier, gpo.id,
                gpo.organizationtypeid,
            gpo1.organizationname, gpo1.displayidentifier, gpo1.id,
                gpo1.organizationtypeid,
            gpo2.organizationname, gpo2.displayidentifier, gpo2.id,
                gpo2.organizationtypeid,
            gpo3.organizationname, gpo3.displayidentifier, gpo3.id,
                gpo3.organizationtypeid,
            gpo4.organizationname, gpo4.displayidentifier, gpo4.id,
                gpo4.organizationtypeid,
            g.groupname, o.schoolstartdate,
            usa.agreementelection, usa.agreementsigneddate,
            o.schoolenddate

    FROM aartuser au
        JOIN usersorganizations uo ON uo.aartuserid = au.id
        JOIN organization o ON uo.organizationid = o.id

        JOIN organizationrelation por ON o.id = por.organizationid
        JOIN organization po ON por.parentorganizationid = po.id

        LEFT JOIN organizationrelation gpor ON po.id = gpor.organizationid
        LEFT JOIN organization gpo ON gpor.parentorganizationid = gpo.id

        lEFT JOIN organizationrelation gpor1 ON gpo.id = gpor1.organizationid
        LEFT JOIN organization gpo1 ON gpor1.parentorganizationid = gpo1.id

        LEFT JOIN organizationrelation gpor2 ON gpo1.id = gpor2.organizationid
        LEFT JOIN organization gpo2 ON gpor2.parentorganizationid = gpo2.id

        LEFT JOIN organizationrelation gpor3 ON gpo2.id = gpor3.organizationid
        LEFT JOIN organization gpo3 ON gpor3.parentorganizationid = gpo3.id

        LEFT JOIN organizationrelation gpor4 ON gpo3.id = gpor4.organizationid
        LEFT JOIN organization gpo4 ON gpor4.parentorganizationid = gpo4.id

        LEFT JOIN usersecurityagreement usa ON au.id = usa.aartuserid

        JOIN userorganizationsgroups uog ON uo.id = uog.userorganizationid
        JOIN groups g ON uog.groupid = g.id

    WHERE au.activeflag = TRUE AND uog.isdefault = TRUE
    """)

    location_dict = {1: 5, 2: 4, 3: 3, 4: 2, 5: 1, 6: 0, 7: 0}

    for row in cursor1:
        location = [None] * 6
        locationid = [None] * 6
        locationcode = [None] * 6

        # Arrange the school location correctly
        for entry in (6, 10, 14, 18, 22):
            if row[entry + 1]:
                location[location_dict[row[entry + 3]]] = row[entry]
                locationcode[location_dict[row[entry + 3]]] = row[entry + 1]
                locationid[location_dict[row[entry + 3]]] = row[entry + 2]

        sqlitecur.execute("""
            INSERT INTO educators (id, active, uniqueid, username,
                firstname, lastname, schoolid, school_code, school,
                district, area, region, state, role, schoolyear,
                agreement, agreementdate, exipredate)
            VALUES(?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
            """,
                          [row[0], row[1], row[2], row[3], row[4], row[5],
                           locationid[0], locationcode[0], location[0],
                           location[1], location[2], location[3],
                           location[4], row[34], row[35], row[36], row[37],
                           row[38]]
                          )

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_educators on educators(id,schoolid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_educators on educators(firstname)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_educators on educators(lastname)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx4_educators on educators(username)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx5_educators on educators(uniqueid)");

    cursor1.close()
    sqliteconn.commit()


def extract_professional_development(options, db, sqliteconn):
    """
    Create the educators table
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'module'):
        sqlitecur.execute("""
            CREATE Table module (
                id int,
                name text,
                status text,
                createddate datetime,
                modifieddate datetime,
                testid int,
                passingscore int
            );
            """)

    # FIXME: Make this program generic....

    cursor1 = db.cursor()
    cursor1.execute("""
		/*NO LOAD BALANCE*/
        SELECT m.id, m.name, category.categorycode, m.createddate,
        m.modifieddate, m.testid, m.passingscore FROM module AS m,
        category where m.assessmentprogramid = %s AND m.statusid = category.id
        """
                    % options.assessment)

    for row in cursor1:
        sqlitecur.execute("""
            INSERT INTO module (id, name, status, createddate, modifieddate,testid, passingscore) VALUES ( ?, ?, ?, ?, ?, ?, ?)""",row)

    cursor1.close()
    sqliteconn.commit()

    if not _is_table(sqliteconn, 'usermodule'):
        sqlitecur.execute("""
            CREATE Table usermodule (
                id int,
                userid int,
                moduleid int,
                createddate datetime,
                modifieddate datetime,
                status text,
                testfinalscore text,
                testcompletiondate datetime,
                earnedceu int
            );
            """)

    cursor2 = db.cursor()
    cursor2.execute("""
		/*NO LOAD BALANCE*/
        SELECT
        um.id, um.userid, um.moduleid, um.createddate, um.modifieddate,c.categorycode, um.testfinalscore::text, um.testcompletiondate,um.earnedceu
        FROM module AS m, usermodule as um, category AS c
        WHERE um.moduleid = m.id AND  m.assessmentprogramid = %s AND c.id = um.enrollmentstatusid
        """ % options.assessment)

    for row in cursor2:
        sqlitecur.execute("""
            INSERT INTO usermodule (id, userid, moduleid, createddate,modifieddate, status, testfinalscore, testcompletiondate,earnedceu)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?)""",row)

    cursor2.close()
    sqliteconn.commit()

    if not _is_table(sqliteconn, 'usertest'):
        sqlitecur.execute("""
            CREATE Table usertest (
                userid int,
                usermoduleid int,
                startdatetime datetime,
                enddatetime datetime,
                activeflag boolean,
                status text,
                scores text
            );
            """)

    cursor3 = db.cursor()
    cursor3.execute("""
		/*NO LOAD BALANCE*/
        SELECT
            um.userid, um.id, ut.startdatetime, ut.enddatetime,ut.activeflag, c.categorycode, ut.scores
        FROM module AS m, usermodule as um, usertest AS ut, category AS c
        WHERE ut.usermoduleid = um.id AND um.moduleid = m.id
            AND  m.assessmentprogramid = %s AND c.id = ut.status
        """
                    % options.assessment)

    for row in cursor3:
        sqlitecur.execute("""
            INSERT INTO usertest (userid, usermoduleid, startdatetime,enddatetime, activeflag, status, scores)VALUES (?, ?, ?, ?, ?, ?,?)""",row)

    cursor3.close()
    sqliteconn.commit()


def extract_students(options, db, sqliteconn):
    """
    Extract all student demographics
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'student'):
        sqlitecur.execute("""
            CREATE Table student (
                id integer,
                activeflag boolean,
                enrollmentid integer,
                legalfirstname text,
                legalmiddlename text,
                legallastname text,
				generationcode text,
                statestudentidentifier text,
                username text,
                currentschoolyear integer,
                firstlanguage text,
                dateofbirth date,
                gender text,
                comprehensiverace text,
                hispanicethnicity text,
                primarydisabilitycode text,
                organizationid integer,
                grade text,
                state text,
                region text,
                area text,
                districtcode text,
                district text,
                schoolcode text,
                school text,
                schoolentrydate datetime,
                districtentrydate datetime,
                stateentrydate datetime,
                aypschoolidentifier text,
                attendanceschoolidentifier text,
                esolparticipationcode text,
                comm_band text,
                ela_band text,
                math_band text,
                final_ela text,
                final_math text,
                activeenrollmentflag boolean,
                exitwithdrawaldate datetime,
                exitwithdrawaltype integer
            );
            """)

    limiter = 'sap.assessmentprogramid=%s' % options.assessment

    if options.organization:
        limiter = \
            's.stateid in (select organizationid from orgassessmentprogram where assessmentprogramid=%s)' \
            % options.assessment

    # cursor1 = db.cursor()

    cursor1 = db.cursor('cursor_unique_name5', cursor_factory=psycopg2.extras.DictCursor)
    cursor1.itersize = options.itersize

    cursor1.execute("""
			/*NO LOAD BALANCE*/
            SELECT
                s.id, s.activeflag, e.id, s.legalfirstname,
                s.legalmiddlename, s.legallastname,
				s.generationcode, s.statestudentidentifier, s.username,
				e.currentschoolyear, s.firstlanguage,
                cast( case when length(cast (EXTRACT(YEAR from s.dateofbirth) as varchar(4))) < 4 then
                          case when EXTRACT(YEAR from s.dateofbirth) between 1 and 16 then s.dateofbirth+INTERVAL '2000 year'
                               when EXTRACT(YEAR from s.dateofbirth) between 90 and 99 then s.dateofbirth+INTERVAL '1900 year'
                               when EXTRACT(YEAR from s.dateofbirth) between 900 and  999 then s.dateofbirth+INTERVAL '1000 year'
                               when EXTRACT(YEAR from s.dateofbirth) between 201 and  209 then s.dateofbirth+INTERVAL '1800 year'
                               else s.dateofbirth end
                else s.dateofbirth end as date) as dateofbirth,
                case when s.gender = 1 then 'Male'
                    when s.gender = 0 then 'Female'
                else '' end,
                s.comprehensiverace, s.hispanicethnicity,
                s.primarydisabilitycode, gc.name, e.attendanceschoolid,

                o.organizationname, o.displayidentifier, o.organizationtypeid,
                po.organizationname, po.displayidentifier, po.organizationtypeid,
                gpo.organizationname, gpo.displayidentifier, gpo.organizationtypeid,
                gpo1.organizationname, gpo1.displayidentifier, gpo1.organizationtypeid,
                gpo2.organizationname, gpo2.displayidentifier, gpo2.organizationtypeid,
                gpo3.organizationname, gpo3.displayidentifier, gpo3.organizationtypeid,
                gpo4.organizationname, gpo4.displayidentifier, gpo4.organizationtypeid,

                e.schoolentrydate, e.districtentrydate,
                e.stateentrydate, aypco.displayidentifier,
                o.displayidentifier, s.esolparticipationcode,
                ccomm.categorydescription as "Comm band ",
                cela.categorydescription as "Ela band ",
                cmath.categorydescription as "Math band ",
                cfela.categorydescription as "Final ELA",
                cfmath.categorydescription as "Final math",
                e.activeflag, e.exitwithdrawaldate, e.exitwithdrawaltype

            FROM student s
            JOIN enrollment e ON (s.id = e.studentid)
            JOIN gradecourse gc ON gc.id = e.currentgradelevel

            JOIN organization aypco ON e.aypschoolid = aypco.id
            JOIN organization o ON e.attendanceschoolid = o.id

            JOIN organizationrelation por ON o.id = por.organizationid
            JOIN organization po ON por.parentorganizationid = po.id

            LEFT JOIN organizationrelation gpor ON po.id = gpor.organizationid
            LEFT JOIN organization gpo ON gpor.parentorganizationid = gpo.id

            lEFT JOIN organizationrelation gpor1 ON gpo.id = gpor1.organizationid
            LEFT JOIN organization gpo1 ON gpor1.parentorganizationid = gpo1.id

            LEFT JOIN organizationrelation gpor2 ON gpo1.id = gpor2.organizationid
            LEFT JOIN organization gpo2 ON gpor2.parentorganizationid = gpo2.id

            LEFT JOIN organizationrelation gpor3 ON gpo2.id = gpor3.organizationid
            LEFT JOIN organization gpo3 ON gpor3.parentorganizationid = gpo3.id

            LEFT JOIN organizationrelation gpor4 ON gpo3.id = gpor4.organizationid
            LEFT JOIN organization gpo4 ON gpor4.parentorganizationid = gpo4.id

            LEFT JOIN category ccomm ON s.commbandid = ccomm.id
            LEFT JOIN category cela ON s.elabandid = cela.id
            LEFT JOIN category cmath ON s.mathbandid = cmath.id
            LEFT JOIN category cfela ON s.finalelabandid = cfela.id
            LEFT JOIN category cfmath ON s.finalmathbandid = cfmath.id

			JOIN studentassessmentprogram sap ON sap.studentid = s.id
			JOIN assessmentprogram a ON a.id = sap.assessmentprogramid


        WHERE
			%s AND e.currentschoolyear=%s
        """
                    % (limiter, options.year))

    # # Wrong ^^

    location_dict = {
        1: 5,
        2: 4,
        3: 3,
        4: 2,
        5: 1,
        6: 0,
        7: 0,
    }

    for row in cursor1:

        location = [None] * 6
        locationcode = [None] * 6

        # Arrange the school location correctly

        for entry in (18, 21, 24, 27, 30):

            # print row

            if row[entry + 1]:
                location[location_dict[row[entry + 2]]] = row[entry]
                locationcode[location_dict[row[entry + 2]]] = row[entry
                                                                  + 1]

        sqlitecur.execute("""
            INSERT INTO student (id, activeflag, enrollmentid, legalfirstname,
                legalmiddlename,
                legallastname, generationcode, statestudentidentifier, username,
                currentschoolyear, firstlanguage, dateofbirth, gender,
                comprehensiverace, hispanicethnicity,
                primarydisabilitycode, grade, organizationid,
                schoolcode, school, districtcode, district, area,
                region, state, schoolentrydate, districtentrydate,
                stateentrydate, aypschoolidentifier,
                attendanceschoolidentifier, esolparticipationcode,
                comm_band, ela_band, math_band, final_ela, final_math,
                activeenrollmentflag, exitwithdrawaldate, exitwithdrawaltype
                )
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)
        """,
                          [
                              row[0],
                              row[1],
                              row[2],
                              row[3],
                              row[4],
                              row[5],
                              row[6],
                              row[7],
                              row[8],
                              row[9],
                              row[10],
                              row[11],
                              row[12],
                              row[13],
                              row[14],
                              row[15],
                              row[16],
                              row[17],
                              locationcode[0],
                              location[0],
                              locationcode[1],
                              location[1],
                              location[2],
                              location[3],
                              location[4],
                              row[39],
                              row[40],
                              row[41],
                              row[42],
                              row[43],
                              row[44],
                              row[45],
                              row[46],
                              row[47],
                              row[48],
                              row[49],
                              row[50],
                              row[51],
                              row[52],
                          ])

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_student on student(enrollmentid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_student on student(state,activeflag)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_student on student(organizationid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx4_student on student(statestudentidentifier)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx5_student on student(aypschoolidentifier)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx6_student on student(legalfirstname)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx7_student on student(legalmiddlename)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx8_student on student(legallastname)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx9_student on student(generationcode)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx10_student on student(id)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx11_student on student(firstlanguage)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx12_student on student(dateofbirth)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx13_student on student(gender)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx14_student on student(comprehensiverace)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx15_student on student(hispanicethnicity)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx16_student on student(primarydisabilitycode)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx17_student on student(esolparticipationcode)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx18_student on student(districtentrydate)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx19_student on student(schoolentrydate)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx20_student on student(attendanceschoolidentifier)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx21_student on student(activeflag)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx22_student on student(organizationid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx23_student on student(school)");

    cursor1.close()
    sqliteconn.commit()


def extract_student_rosters(options, db, sqliteconn):
    """
    Extract all student rosters and enrollments_rosters
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'enrollmentsrosters'):
        sqlitecur.execute("""
            CREATE Table enrollmentsrosters (
                enrollmentid integer,
                rosterid integer,
                createddate datetime,
                modifieddate datetime,
                activeflag boolean
            );
            """)

    if not _is_table(sqliteconn, 'roster'):
        sqlitecur.execute("""
            CREATE Table roster (
                id integer,
                createddate datetime,
                modifieddate datetime,
                activeflag boolean,
                educatorid integer,
                coursesectionname text,
                coursesectiondescription text,
                statesubjectarea text,
                statesubjectcourseidentifier text,
                localcourseid text,
                educatorschooldisplayidentifier text,
                statecourses text
            );
            """)

    limiter = 'sap.assessmentprogramid=%s' % options.assessment

    if options.organization:
        limiter = \
            's.stateid in (select organizationid from orgassessmentprogram where assessmentprogramid=%s)' \
            % options.assessment

    cursor1 = db.cursor()

    # cursor1 = db.cursor('cursor_unique_name5', cursor_factory=psycopg2.extras.DictCursor)
    # cursor1.itersize = options.itersize

    cursor1.execute("""
			/*NO LOAD BALANCE*/
            SELECT
                e.id, er.rosterid, er.createddate, er.modifieddate,
                er.activeflag
            FROM student s
            JOIN enrollment e ON (s.id = e.studentid and e.activeflag=true)
            JOIN enrollmentsrosters er ON (e.id = er.enrollmentid)
			JOIN studentassessmentprogram sap ON sap.studentid = s.id
			JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
        WHERE
			%s AND e.currentschoolyear=%s
        """
                    % (limiter, options.year))

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
            INSERT INTO enrollmentsrosters (enrollmentid, rosterid,
                createddate, modifieddate, activeflag)
            VALUES (?,?,?,?,?)
        """,
                          row)

    cursor1.close()

    cursor2 = db.cursor()

    # cursor2 = db.cursor('cursor_unique_name5', cursor_factory=psycopg2.extras.DictCursor)
    # cursor2.itersize = options.itersize

    cursor2.execute("""
			/*NO LOAD BALANCE*/
            SELECT
                r.id, r.createddate, r.modifieddate, r.activeflag,
                r.teacherid, r.coursesectionname, r.coursesectiondescription,
                ca.abbreviatedname, r.statesubjectcourseidentifier,
                r.localcourseid, r.educatorschooldisplayidentifier,
                gc.abbreviatedname
            FROM roster r
            LEFT JOIN contentarea ca ON (r.statesubjectareaid = ca.id)
            LEFT JOIN gradecourse gc ON (r.statecoursesid = gc.id)
        WHERE
            r.id in (
                SELECT er.rosterid FROM student s
                JOIN enrollment e ON (s.id = e.studentid and e.activeflag=true)
                JOIN enrollmentsrosters er ON (e.id = er.enrollmentid)
				JOIN studentassessmentprogram sap ON sap.studentid = s.id
				JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
                WHERE %s AND e.currentschoolyear=%s
            )
        """
                    % (limiter, options.year))

    # # Wrong ^^

    for row in cursor2:
        sqlitecur.execute("""
            INSERT INTO roster (id, createddate, modifieddate,
                activeflag, educatorid, coursesectionname,
                coursesectiondescription, statesubjectarea,
                statesubjectcourseidentifier, localcourseid,
                educatorschooldisplayidentifier,
                statecourses)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)
        """,
                          row)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_enrollmentsrosters on enrollmentsrosters(enrollmentid,activeflag)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_enrollmentsrosters on enrollmentsrosters(rosterid)");

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_roster on roster(id,activeflag)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_roster on roster(educatorid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_roster on roster(statecourses)");

    cursor2.close()

    sqliteconn.commit()


def extract_firstcontact(options, db, sqliteconn):
    """
    Extract all student first contact
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'firstcontact'):
        sqlitecur.execute("""
            CREATE Table firstcontact (
                studentid integer,
                createddate datetime,
                modifieddate datetime,
                surveylabelnumber text,
                surveylabel text,
                responselabel text,
                responsevalue text,
                responsetext text
            );
            """)

    # cursor1 = db.cursor('cursor_unique_name6', cursor_factory=psycopg2.extras.DictCursor)

    cursor1 = db.cursor()
    cursor1.execute("""
			/*NO LOAD BALANCE*/
            SELECT
                s.id, ssr.createddate, ssr.modifieddate,
                sl.labelnumber AS "Survey Label Number",
                sl.label AS "Survey Label",
                sr.responselabel as "Response Label",
                sr.responsevalue  AS "Survey Response",
                ssr.responsetext as "Text Response"
            FROM student s

            JOIN enrollment AS e
                ON (e.studentid = s.id and e.activeflag = true)

            JOIN survey sv ON s.id = sv.studentid
            JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid
            JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id
            JOIN surveylabel sl ON sr.labelid = sl.id
			JOIN studentassessmentprogram sap ON sap.studentid = s.id
			JOIN assessmentprogram a ON a.id = sap.assessmentprogramid

            WHERE ssr.activeflag is true AND sap.assessmentprogramid=%s
                AND e.currentschoolyear=%s
        """
                    % (options.assessment, options.year))

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
            INSERT INTO firstcontact (studentid, createddate,
                modifieddate, surveylabelnumber, surveylabel,
                responselabel, responsevalue, responsetext)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)
        """,
                          row)
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_firstcontact ON firstcontact (studentid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_firstcontact ON firstcontact (studentid ,createddate,modifieddate)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_firstcontact ON firstcontact (responselabel)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx4_firstcontact ON firstcontact (surveylabelnumber)");

    cursor1.close()
    sqliteconn.commit()


def extract_pnp(options, db, sqliteconn):
    """
    Extract all student pnp
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'pnp'):
        sqlitecur.execute("""
            CREATE Table pnp (
                studentid integer,
                valueid integer,
				attributecontainer text,
				attributename text,
				value text
            );
            """)

    limiter = 'sap.assessmentprogramid=%s' % options.assessment

    if options.organization:
        limiter = \
            's.stateid in (select organizationid from orgassessmentprogram where assessmentprogramid=%s)' \
            % options.assessment

    # cursor1 = db.cursor('cursor_unique_name7', cursor_factory=psycopg2.extras.DictCursor)

    cursor1 = db.cursor()
    cursor1.execute("""
			/*NO LOAD BALANCE*/
			SELECT
				s.id,
				spiav.id,
				piac.attributecontainer,
				pia.attributename,
				spiav.selectedvalue
			FROM student s
				JOIN enrollment e
					ON (e.studentid = s.id and e.activeflag = true)
				JOIN studentassessmentprogram sap ON sap.studentid = s.id
				JOIN assessmentprogram a ON a.id = sap.assessmentprogramid
				LEFT JOIN studentprofileitemattributevalue spiav
					ON s.id = spiav.studentid
				LEFT JOIN profileitemattributenameattributecontainer pianc
					ON spiav.profileitemattributenameattributecontainerid =
						pianc.id
				LEFT JOIN profileitemattribute pia
					ON pianc.attributenameid = pia.id
				LEFT JOIN profileitemattributecontainer piac
					ON pianc.attributecontainerid = piac.id
			WHERE %s AND e.currentschoolyear=%s ;
        """
                    % (limiter, options.year))

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
			INSERT INTO pnp (studentid, valueid, attributecontainer,
				attributename, value) VALUES (?, ?, ?, ?, ?)
        """,
                          row)

    cursor1.close()
    sqliteconn.commit()


def extract_student_tests(options, db, sqliteconn):
    """
    Extract all student tests
    """

    sqlitecur = sqliteconn.cursor()

    if options.assessment == '12' or options.assessment == '37':

        if not _is_table(sqliteconn, 'studentstests'):
            sqlitecur.execute("""
            CREATE Table studentstests (
                id integer,
                studentid integer,
                enrollmentid integer,
                testid integer,
                studentstestssectionsid integer,
                testsectionid integer,
                teststatus text,
                testsectionstatus text,
		        createddate datetime,
                startdatetime datetime,
                enddatetime datetime,
                educatorid integer,
                finalband text,
                programname text,
                paperpencil boolean,
                rosterid integer,
                contentareaname text,
                interimtheta real,
                osbrowser text,
                specialcircumstanceid integer,
                specialcircumstancetype text,
                specialcircumstancecedscode integer,
                specialcircumstanceactive boolean
            );
            """)

            limiter = ''
            if options.programname:
                limiter = "AND tp.programname = '%s'" % options.programname

    # the case statment is to isolate paper and pencil test.

        cursor1 = db.cursor('cursor_unique_name8',
                        cursor_factory=psycopg2.extras.DictCursor)
        cursor1.itersize = options.itersize

        tdedb = psycopg2.connect(options.tde_database_string)
        tdecursor = tdedb.cursor()
        tdecursor.itersize = options.itersize

        cursor1.execute("""
			/*NO LOAD BALANCE*/
            SELECT
                st.id, st.studentid, st.enrollmentid, st.testid as testid,
                sts.id as studentstestssectionsid,
                sts.testsectionid as testsectionid,
                stcat.categorycode as teststatus,
                stscat.categorycode as testsectionstatus,
		st.createddate, st.startdatetime, st.enddatetime,
		r.teacherid as educatorid, fband.categorydescription as finalband, tp.programname as programname,
                CASE
                    WHEN ts.source = 'QUESTARPROCESS' THEN true
                    WHEN ts.createduser = 105101 THEN true
                    ELSE false
                END as paperpencil,
                ts.rosterid as rosterid,ca.abbreviatedname as contentareaname,st.interimtheta as interimtheta,
                sc.id as specialcircumstanceid,
		sc.specialcircumstancetype,
		sc.cedscode as  specialcircumstancecedscode,
                sc.activeflag as specialcircumstanceactive
            FROM studentstests st
            JOIN test t ON st.testid = t.id
            JOIN studentstestsections sts ON sts.studentstestid = st.id
            JOIN testcollectionstests tct ON st.testid = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN contentarea ca ON ca.id = tc.contentareaid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
            JOIN testsession ts ON st.testsessionid = ts.id AND ts.testcollectionid = tc.id
            JOIN category stscat ON stscat.id = sts.statusid
            JOIN category stcat ON stcat.id = st.status
            LEFT JOIN category fband ON st.finalbandid = fband.id
            LEFT JOIN roster r ON ts.rosterid = r.id
            LEFT JOIN enrollment e ON st.enrollmentid = e.id
            LEFT JOIN studentspecialcircumstance stsc ON (st.id = stsc.studenttestid)
	    LEFT JOIN specialcircumstance sc ON (stsc.specialcircumstanceid = sc.id)
                AND e.currentschoolyear=%s
            WHERE ap.id=%s %s AND e.currentschoolyear=%s AND st.activeflag='t';
        """
                    % (options.year, options.assessment, limiter,
                       options.year))

        count =0;
        for row in cursor1:
            sqlitecur.execute("""
                INSERT INTO studentstests (id, studentid, enrollmentid, testid,
                studentstestssectionsid, testsectionid, teststatus,
                testsectionstatus, createddate, startdatetime, enddatetime,
                educatorid, finalband, programname, paperpencil,rosterid,contentareaname,interimtheta,osbrowser,specialcircumstanceid,
		        specialcircumstancetype,specialcircumstancecedscode,specialcircumstanceactive)
                VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                (row['id'],row['studentid'],row['enrollmentid'],row['testid'],row['studentstestssectionsid'],row['testsectionid'],
                row['teststatus'],row['testsectionstatus'],row['createddate'],row['startdatetime'],row['enddatetime'],
                row['educatorid'],row['finalband'],row['programname'],row['paperpencil'],row['rosterid'],row['contentareaname'],
                row['interimtheta'],'',row['specialcircumstanceid'],row['specialcircumstancetype'],row['specialcircumstancecedscode'],
                row['specialcircumstanceactive']))

            tdecursor.execute("SELECT ta.attrvalue as osbrowser FROM tracker_attrs ta LEFT JOIN tracker t ON ta.trackerid = t.id WHERE t.goaltype = 'Os-Browser' AND t.typecode = CAST({0} AS text) ".format(row['studentstestssectionsid']))

            for row1 in tdecursor:
                count = count+1
                logging.debug("updated %s times",count)
                logging.debug("row1[0] value is %s",row1[0])
                logging.debug("row[id] value is %s",row['id'])
                sqlitecur.execute("""UPDATE studentstests SET osbrowser = ? where id = ? """,
                                (row1[0],row['id']))

        tdecursor.close()

    else:
        if not _is_table(sqliteconn, 'studentstests'):
            sqlitecur.execute("""
                CREATE Table studentstests (
                id integer,
                studentid integer,
                enrollmentid integer,
                testid integer,
                studentstestssectionsid integer,
                testsectionid integer,
                teststatus text,
                testsectionstatus text,
		createddate datetime,
                startdatetime datetime,
                enddatetime datetime,
                educatorid integer,
                finalband text,
                programname text,
                paperpencil boolean,
                rosterid integer,
                contentareaname text,
                specialcircumstanceid integer,
                specialcircumstancetype text,
                specialcircumstancecedscode integer,
                specialcircumstanceactive boolean
            );
            """)

        limiter = ''
        if options.programname:
            limiter = "AND tp.programname = '%s'" % options.programname

            # the case statment is to isolate paper and pencil test.

        cursor1 = db.cursor('cursor_unique_name8',
                        cursor_factory=psycopg2.extras.DictCursor)
        cursor1.itersize = options.itersize

        cursor1.execute("""
			/*NO LOAD BALANCE*/
            SELECT
                st.id, st.studentid, st.enrollmentid, st.testid as testid,
                sts.id as studentstestssectionsid,
                sts.testsectionid as testsectionid,
                stcat.categorycode, stscat.categorycode,
		st.createddate, st.startdatetime, st.enddatetime,
		r.teacherid, fband.categorydescription, tp.programname,
                CASE
                    WHEN ts.source = 'QUESTARPROCESS' THEN true
                    WHEN ts.createduser = 105101 THEN true
                    ELSE false
                END,
                ts.rosterid as rosterid,ca.abbreviatedname as contentareaname,
                sc.id as specialcircumstanceid,
		sc.specialcircumstancetype,
		sc.cedscode as  specialcircumstancecedscode,
                sc.activeflag as specialcircumstanceactive
            FROM studentstests st
            JOIN test t ON st.testid = t.id
            JOIN studentstestsections sts ON sts.studentstestid = st.id
            JOIN testcollectionstests tct ON st.testid = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN contentarea ca ON ca.id = tc.contentareaid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
            JOIN testsession ts ON st.testsessionid = ts.id AND ts.testcollectionid = tc.id
            JOIN category stscat ON stscat.id = sts.statusid
            JOIN category stcat ON stcat.id = st.status
            LEFT JOIN category fband ON st.finalbandid = fband.id
            LEFT JOIN roster r ON ts.rosterid = r.id
            LEFT JOIN enrollment e ON st.enrollmentid = e.id
            LEFT JOIN studentspecialcircumstance stsc ON (st.id = stsc.studenttestid)
	    LEFT JOIN specialcircumstance sc ON (stsc.specialcircumstanceid = sc.id)
                AND e.currentschoolyear=%s
            WHERE ap.id=%s %s AND e.currentschoolyear=%s AND st.activeflag='t';
        """
                    % (options.year, options.assessment, limiter,
                       options.year))


        for row in cursor1:
            sqlitecur.execute("""
                INSERT INTO studentstests (id, studentid, enrollmentid, testid,
                studentstestssectionsid, testsectionid, teststatus,
                testsectionstatus, createddate, startdatetime, enddatetime,
                educatorid, finalband, programname, paperpencil,rosterid,contentareaname,
                specialcircumstanceid,specialcircumstancetype,specialcircumstancecedscode,specialcircumstanceactive)
                VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                          row)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_studentstests on studentstests(testsectionid,teststatus,programname,createddate,startdatetime,enddatetime)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_studentstests on studentstests(studentid,enrollmentid,programname,teststatus)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_studentstests on studentstests(testid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx4_studentstests on studentstests(studentstestssectionsid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx5_studentstests on studentstests(studentid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx6_studentstests on studentstests(rosterid)");

    cursor1.close()
    sqliteconn.commit()

def extract_student_response_unscored(options, db, sqliteconn):
    """
    Extract all student response scores from Questar
    """

    # Only do this for Alaska.

    if options.assessment != '37':
        return

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'studentresponseunscored'):
        sqlitecur.execute("""
            CREATE Table studentresponseunscored (
                statestudentid text,
                studentid integer,
                externaltestid integer,
                externaltaskvariantid integer,
                response text,
                itemnumber integer,
                itemname text,
                intensityhex text
            );
            """)

    audit_db = psycopg2.connect(options.audit_database_string)
    cursor1 = audit_db.cursor()
    cursor1.itersize = options.itersize

    # This is only avaialble for KAP currently.

    cursor1.execute("""
            SELECT
               qs.studentid, qs.studentkitenumber, qs.formnumber,
               regexp_replace(qsr.itemname, '_.*$', ''), qsr.response,
               qsr.itemnumber, qsr.itemname,
               qsr.intensityhex
            FROM questar_staging qs
            JOIN questar_staging_response qsr
                ON (qs.id = qsr.questar_staging_id)
            WHERE qsr.tasktypecode='ITP' and qs.status='COMPLETE'
        """
                    % ())

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
            INSERT INTO studentresponseunscored (
                statestudentid, studentid, externaltestid,
                externaltaskvariantid, response, itemnumber,
                itemname, intensityhex)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                          row)

    cursor1.close()
    sqliteconn.commit()
    audit_db.close()


def extract_student_response_score(options, db, sqliteconn):
    """
    Extract all student response scores from Questar
    """

    if options.assessment != '12':
        return

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'studentresponsescore'):
        sqlitecur.execute("""
            CREATE Table studentresponsescore (
                studentstestsectionsid integer,
                externaltaskvariantid integer,
                score float,
                dimension text,
                diagnosticstatement text,
                raterid inetger,
                ratername text,
                raterorder integer,
                raterexposure integer,
                createdate datetime,
                activeflag boolean
            );
            """)

    cursor1 = db.cursor()
    cursor1.itersize = options.itersize

    # This is only avaialble for KAP currently.

    cursor1.execute("""
			/*NO LOAD BALANCE*/
            SELECT
                srs.studentstestsectionsid, srs.taskvariantid, srs.score,
                srs.dimension, srs.diagnosticstatement,
                srsr.userid, ratername, srs.raterorder,
                srs.raterexposure, srs.createdate, srs.activeflag
            FROM studentresponsescore srs
            LEFT JOIN studentresponsescorerater srsr
                ON (srs.raterid = srsr.raterid)
        """
                    % ())

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
            INSERT INTO studentresponsescore (
                studentstestsectionsid, externaltaskvariantid, score,
                dimension, diagnosticstatement, raterid, ratername,
                raterorder, raterexposure, createdate, activeflag )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                          row)

    cursor1.close()
    sqliteconn.commit()


def extract_student_responses(options, db, sqliteconn):
    """
    Extract all student responses
    """

    sqlitecur = sqliteconn.cursor()

    if (not _is_table(sqliteconn, 'studentsresponses')):
        sqlitecur.execute("""
            CREATE Table studentsresponses (
                studentstestsid integer,
                studentstestsectionsid integer,
                taskvariantid integer,
                foildid integer,
                foiltext text,
                responsetext text,
                score real,
                sortorder integer,
                studentsresponsesorder integer,
                createddate datetime,
                modifieddate datetime,
                timespent text
            );
            """)

    cursor1 = db.cursor('cursor_unique_name9', cursor_factory=psycopg2.extras.DictCursor)
    cursor1.itersize = options.itersize

    tdedb = psycopg2.connect(options.tde_database_string)
    tdecursor = tdedb.cursor()
    tdecursor.itersize = options.itersize

    limiter = ""
    if options.programname:
        limiter = "AND tp.programname = '%s'" % (options.programname)

    if (options.assessment == "4"):
        # sort order from time - This only works for adaptive.
        cursor1.execute("""
			/*NO LOAD BALANCE*/
            SELECT
                st.id, sres1.studentstestsectionsid as studentstestsectionsid,
                sres1.taskvariantid, sres1.foilid,
                regexp_replace(f.foiltext, E'[\\n\\r]+', ' ', 'g' ),
                sres1.response, sres1.score,
                extract(epoch from sres1.createddate)*100000::INTEGER,tvf.responseorder as responseorder,
                sres1.createddate,sres1.modifieddate
            FROM studentstests st
            JOIN enrollment AS e ON st.enrollmentid = e.id
            JOIN testcollectionstests tct ON st.testid = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
            LEFT JOIN studentsresponses sres1 ON
                st.id = sres1.studentstestsid
            LEFT JOIN foil f ON sres1.foilid = f.id
	        LEFT JOIN taskvariantsfoils tvf ON sres1.foilid = tvf.foilid
	        LEFT JOIN taskvariant tv ON tv.id = tvf.taskvariantid
            WHERE ap.id = %s AND e.currentschoolyear=%s %s
        """ % (options.assessment, options.year, limiter))
        ## Wrong ^^
    else:
        cursor1.execute("""
			/*NO LOAD BALANCE*/
            SELECT st.id, sts.id as studentstestsectionsid, tstv.taskvariantid, sres1.foilid,
   regexp_replace(f.foiltext, E'[\\n\\r]+', ' ', 'g' ),
    sres1.response, sres1.score, stst.sortorder,tvf.responseorder as responseorder,
    sres1.createddate,sres1.modifieddate
  	FROM studentstests st
     	JOIN enrollment AS e ON st.enrollmentid = e.id
    	JOIN testcollectionstests tct ON st.testid = tct.testid
        JOIN testcollection tc ON tc.id = tct.testcollectionid
        JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
        JOIN assessment a ON atc.assessmentid = a.id
        JOIN testingprogram tp ON a.testingprogramid = tp.id
        JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
        JOIN studentstestsections sts ON sts.studentstestid = st.id
        JOIN testsection tsec ON sts.testsectionid = tsec.id
        JOIN testsectionstaskvariants tstv ON tsec.id = tstv.testsectionid
        JOIN studentsresponses sres1 ON
              st.id = sres1.studentstestsid and
              sres1.taskvariantid=tstv.taskvariantid
        LEFT JOIN studentstestsectionstasks stst ON
              stst.studentstestsectionsid=sts.id and
              stst.taskid=tstv.taskvariantid
        LEFT JOIN foil f ON sres1.foilid = f.id
        LEFT JOIN taskvariantsfoils tvf ON sres1.foilid = tvf.foilid
        LEFT JOIN taskvariant tv ON tv.id = tvf.taskvariantid
         WHERE ap.id = %s AND e.currentschoolyear=%s %s
        """ % (options.assessment, options.year, limiter))
        ## Wrong ^^

    for row in cursor1:
        if type(row["responseorder"]) is int:
            sqlitecur.execute("""
                INSERT INTO studentsresponses (
                    studentstestsid, studentstestsectionsid, taskvariantid,
                    foildid, foiltext, responsetext, score, sortorder,studentsresponsesorder,createddate,modifieddate,timespent)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, 1+?,?,?,'')""", row)

            #tdecursor.execute("""select response from studentsresponseshistory where studentstestsectionsid = ?""",(row['studentstestsectionsid']))
            tdecursor.execute("""select path from studentsresponseshistory where studentstestsectionsid = 14324402""")

            for row1 in tdecursor:
                #logging.debug("row1[0] is %s",row1[0])
                timespent_json = json.loads(row1[0])
                #logging.debug("timespent json is %s",timespent_json) # print timespent_json
                timespent_json_length = len(timespent_json) # find json array length
                logging.debug("timespent json array length is %s",timespent_json_length) # print timespent_json_length to iterate over the values
                count = 0
                for x in xrange(timespent_json_length):
                    count = count+1
                    logging.debug("timespent value being inserted is %s",timespent_json[x-1])
                    sqlitecur.execute("""UPDATE studentsresponses
                                         SET  timespent = ?
                                         WHERE studentstestsectionsid = ? AND taskvariantid = ? """,
                                         (timespent_json[x-1]["time"],row['studentstestsectionsid'],row['taskvariantid'])
                                      )
                logging.debug("studentsresponses updated %s times",count)
        else:
            sqlitecur.execute("""
                INSERT INTO studentsresponses (
                    studentstestsid, studentstestsectionsid, taskvariantid,
                    foildid, foiltext, responsetext, score, sortorder,studentsresponsesorder,createddate,modifieddate,timespent)
                    VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,'')""", row)

            tdecursor.execute("""select path from studentsresponseshistory where studentstestsectionsid = 14324402""")

            for row1 in tdecursor:
                #logging.debug("row1[0] is %s",row1[0])
                timespent_json = json.loads(row1[0])
                #logging.debug("timespent json is %s",timespent_json) # print timespent_json
                timespent_json_length = len(timespent_json) # find json array length
                logging.debug("timespent json array length is %s",timespent_json_length) # print timespent_json_length to iterate over the values
                count = 0
                for x in xrange(timespent_json_length):
                    count = count+1
                    logging.debug("timespent value being inserted is %s",timespent_json[x-1])
                    sqlitecur.execute("""UPDATE studentsresponses
                                         SET  timespent = ?
                                         WHERE studentstestsectionsid = ? AND taskvariantid = ? """,
                                         (timespent_json[x-1]["time"],row['studentstestsectionsid'],row['taskvariantid'])
                                      )
                logging.debug("studentsresponses updated %s times",count)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_studentsresponses on studentsresponses(studentstestsectionsid,taskvariantid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_studentsresponses on studentsresponses(foildid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_studentsresponses on studentsresponses(responsetext)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx4_studentsresponses on studentsresponses(createddate,modifieddate)");

    tdecursor.close()
    cursor1.close()
    sqliteconn.commit()


def extract_test(options, db, sqliteconn):
    """
    Extract all test definitions
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'test'):
        sqlitecur.execute("""
            CREATE Table test (
                id int,
                externalid int,
                testname text,
                testinternalname text,
				createdate datetime,
				status text,
				gradecourse text,
				gradeband text,
                contentareaname text,
				avglinkagelevel float,
				qccomplete boolean,
				testspecificationid integer,
				externaltestspecificationid bigint,
				specificationname text,
				phase text,
				contentpool text,
				minimumnumberofees integer,
				accessibilityflagcode text
            );
            """)

    cursor1 = db.cursor()
    cursor1.execute("""
		/*NO LOAD BALANCE*/
            SELECT
            t.id, t.externalid, t.testname, t.testinternalname,
            t.createdate, c.categoryname,
			g.name, gb.name, ca.name, t.avglinkagelevel, t.qccomplete,t.testspecificationid,ts.externalid,ts.specificationname,ts.phase,ts.contentpool,ts.minimumnumberofees,af.accessibilityflagcodes
            FROM test t
			JOIN category as c ON (t.status = c.id)
			JOIN contentarea as ca ON (t.contentareaid = ca.id)
            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
			LEFT JOIN gradecourse AS g ON (tc.gradecourseid = g.id)
			LEFT JOIN gradeband AS gb ON (tc.gradebandid = gb.id)
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            LEFT JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
            LEFT JOIN testspecification ts ON t.testspecificationid = ts.id
            LEFT JOIN (select testid,array_to_string(array_agg(accessibilityflagcode), ',') accessibilityflagcodes from testaccessibilityflag GROUP BY testid) af ON af.testid = t.id
            WHERE ap.id=%s
        """
                    % options.assessment)

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
			INSERT INTO test (id, externalid, testname, testinternalname,
                createdate, status, gradecourse, gradeband, contentareaname,
				avglinkagelevel, qccomplete,testspecificationid,externaltestspecificationid,specificationname,phase,contentpool,minimumnumberofees,accessibilityflagcode)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?,?,?,?,?,?,?,?)""",
                          row)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_test on test(id)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_test on test(testname)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_test on test(avglinkagelevel)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx4_test on test(externaltestspecificationid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx5_test on test(specificationname)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx6_test on test(accessibilityflagcode)");

    cursor1.close()
    sqliteconn.commit()


def extract_lmassessmentmodelrule(options, db, sqliteconn):
    """
    Extract lmassessmentmodelrule
    """


    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'lmassessmentmodelrule'):
        sqlitecur.execute(
        "CREATE Table lmassessmentmodelrule(testspecificationid integer,ranking integer,contentframeworkdetailid integer,operator text,contentcodecorder integer)")

    cursor1 = db.cursor()

    if options.assessment == '3':
        cursor1.execute(""" /*NO LOAD BALANCE*/
					  select testspecificationid,ranking,contentframeworkdetailid,operator,contentcodecorder from lmassessmentmodelrule""")

        for row in cursor1:
            sqlitecur.execute("""
						    INSERT INTO lmassessmentmodelrule (testspecificationid,ranking,contentframeworkdetailid,operator,contentcodecorder)
						    VALUES (?,?,?,?,?)""", row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_testsection(options, db, sqliteconn):
    """
    Extract all test definitions
    """

    sqlitecur = sqliteconn.cursor()


    if not _is_table(sqliteconn, 'testsection'):
        sqlitecur.execute("""
            CREATE Table testsection (
                id int,
                externalid int,
				testid int,
                testsectionname text,
				createdate datetime,
                numberoftestitems int,
				tips text
            );
            """)

    cursor1 = db.cursor()
    cursor1.execute("""
		/*NO LOAD BALANCE*/
		SELECT
            ts.id, ts.externalid, ts.testid, ts.testsectionname,
			ts.createdate, ts.numberoftestitems, sva.filename
        FROM test t
			JOIN testsection as ts ON (t.id = ts.testid)
            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
			LEFT JOIN testsectionresource tsr ON ts.id = tsr.testsectionid
			LEFT JOIN stimulusvariant sv ON tsr.stimulusvariantid = sv.id
			LEFT JOIN stimulusvariantattachment sva on sv.id = sva.stimulusvariantid
        WHERE ap.id=%s
        """
                % options.assessment)

# # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
            INSERT INTO testsection (id, externalid, testid, testsectionname,
				createdate, numberoftestitems, tips)
            VALUES (?,?,?,?,?,?,?)""",
                      row)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_testsection on testsection(testid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_testsection on testsection(id)");

    cursor1.close()
    sqliteconn.commit()


def extract_testsectionstaskvariants(options, db, sqliteconn):
    """
    Extract all test definitions
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'testsectionstaskvariants'):
        sqlitecur.execute("""
            CREATE Table testsectionstaskvariants (
				testsectionid int,
				taskvariantid int,
				externaltestsectionid int,
				externaltaskid int,
				taskvariantposition int,
				testletid int,
				sortorder int,
				groupnumber int
            );
            """)

    cursor1 = db.cursor()
    cursor1.execute("""
		/*NO LOAD BALANCE*/
		SELECT
			tstv.testsectionid, tstv.taskvariantid,
			tstv.externaltestsectionid, tstv.externaltaskid,
			tstv.taskvariantposition, tstv.testletid, tstv.sortorder,
			tstv.groupnumber
        FROM test t
			JOIN testsection as ts ON (t.id = ts.testid)
			JOIN testsectionstaskvariants AS tstv
				ON (ts.id = tstv.testsectionid)

            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
        WHERE ap.id=%s
        """
                    % options.assessment)

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
            INSERT INTO testsectionstaskvariants (
				testsectionid, taskvariantid, externaltestsectionid,
				externaltaskid, taskvariantposition, testletid,
				sortorder, groupnumber )
            VALUES (?, ?, ?, ?, ?, ?, ?, ?)""",
                          row)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_testsectionstaskvariants on testsectionstaskvariants(testsectionid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_testsectionstaskvariants on testsectionstaskvariants(testletid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_testsectionstaskvariants on testsectionstaskvariants(taskvariantid)");

    cursor1.close()
    sqliteconn.commit()


def extract_testlet(options, db, sqliteconn):
    """
    Extract all test definitions
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'testlet'):
        sqlitecur.execute("""
            CREATE Table testlet (
                id int,
                externalid int,
                testletname text,
				contentarea text,
				gradecourse text
            );
            """)

    cursor1 = db.cursor()
    cursor1.execute("""
		/*NO LOAD BALANCE*/
		SELECT
			distinct tl.id, tl.externalid, tl.testletname, ca.name, gc.name
        FROM test t
			JOIN testsection as ts ON (t.id = ts.testid)
			JOIN testsectionstaskvariants AS tstv
				ON (ts.id = tstv.testsectionid)
			JOIN testlet as tl ON (tstv.testletid = tl.id)

            LEFT JOIN contentarea ca ON ca.id = tl.contentareaid
            LEFT JOIN gradecourse gc ON gc.id = tl.gradecourseid

            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
        WHERE ap.id=%s
        """
                    % options.assessment)

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
			INSERT INTO testlet (id, externalid, testletname,
				contentarea, gradecourse)
            VALUES (?,?,?,?,?)""",
                          row)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_testlet on testlet(id)");

    cursor1.close()
    sqliteconn.commit()


def extract_taskvariant(options, db, sqliteconn):
    """
    Extract all test definitions
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'taskvariant'):
        sqlitecur.execute("""
            CREATE Table taskvariant (
                id int,
                externalid int,
                taskname text,
				variantname text,
				tasktypecode text,
				tasksubtypecode text,
				frameworktype text,
                contentareaname text,
                contentframeworkdetailcode text,
                primarycontentframeworkdetail boolean,
                cognitivetaxonomyname text,
                cognitivecategoryname text,
                tasklayoutformatname text,
                essentialelementlinkage text,
				nodecode text
            );
            """)

    cursor1 = db.cursor()
    cursor1.execute("""
		/*NO LOAD BALANCE*/
		SELECT
			tv.id, tv.externalid, tv.taskname, tv.variantname,
			tt.code as tasktypecode, tst.code as tasksubtypecode,
			ft.name as frameworktype, ca.abbreviatedname,
            cfd.contentcode, tvcfd.isprimary,
            ct.name, ctd.name, tlf.formatname, tvcat.categoryname, nodecode

        FROM test t
			JOIN testsection as ts ON (t.id = ts.testid)
			JOIN testsectionstaskvariants AS tstv
				ON (ts.id = tstv.testsectionid)
			JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
			LEFT JOIN taskvariantlearningmapnode AS tvlm
				ON (tv.id = tvlm.taskvariantid)

            LEFT JOIN tasktype tt ON tv.tasktypeid = tt.id
			LEFT JOIN frameworktype ft ON ft.id = tv.frameworktypeid
            LEFT JOIN contentarea ca ON ca.id = tv.contentareaid
			LEFT JOIN taskvariantcontentframeworkdetail tvcfd
				ON tv.id = tvcfd.taskvariantid
            LEFT JOIN contentframeworkdetail cfd ON
                tvcfd.contentframeworkdetailid = cfd.id
            LEFT JOIN cognitivetaxonomy ct ON tv.cognitivetaxonomyid = ct.id
			LEFT JOIN cognitivetaxonomydimension ctd on
				tv.cognitivetaxonomydimensionid = ctd.id
            LEFT JOIN tasklayoutformat tlf ON tv.tasklayoutformatid = tlf.id
			LEFT JOIN tasksubtype tst ON tv.tasksubtypeid = tst.id
            LEFT JOIN category tvcat ON tv.essentialelementlinkageid = tvcat.id

            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
        WHERE ap.id=%s
        """
                    % options.assessment)

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
			INSERT INTO taskvariant (id, externalid, taskname, variantname,
				tasktypecode, tasksubtypecode, frameworktype, contentareaname,
				contentframeworkdetailcode, primarycontentframeworkdetail,
                cognitivetaxonomyname, cognitivecategoryname,
                tasklayoutformatname, essentialelementlinkage, nodecode)
            VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)""",
                          row)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_taskvariant on taskvariant(id)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_taskvariant on taskvariant(id,contentareaname,primarycontentframeworkdetail)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx3_taskvariant on taskvariant(externalid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx4_taskvariant on taskvariant(contentareaname)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx5_taskvariant on taskvariant(contentframeworkdetailcode)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx6_taskvariant on taskvariant(nodecode)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx7_taskvariant on taskvariant(essentialelementlinkage)");

    cursor1.close()
    sqliteconn.commit()


def extract_taskvariantsfoils(options, db, sqliteconn):
    """
    Extract all test definitions
    """

    sqlitecur = sqliteconn.cursor()

    if not _is_table(sqliteconn, 'taskvariantsfoils'):
        sqlitecur.execute("""
            CREATE Table taskvariantsfoils (
				taskvariantid int,
				foilid int,
				foilsorder integer,
				correctresponse boolean,
				responsescore int,
				responsename text,
				foiltext text
            );
            """)

    cursor1 = db.cursor()
    cursor1.execute("""
		/*NO LOAD BALANCE*/
		SELECT
			tvf.taskvariantid, tvf.foilid, tvf.responseorder,
			tvf.correctresponse, tvf.responsescore, tvf.responsename,
			 f.foiltext

        FROM test t
			JOIN testsection as ts ON (t.id = ts.testid)
			JOIN testsectionstaskvariants AS tstv
				ON (ts.id = tstv.testsectionid)
			JOIN taskvariant AS tv ON (tstv.taskvariantid = tv.id)
			JOIN taskvariantsfoils AS tvf ON (tv.id = tvf.taskvariantid)
			JOIN foil as f on (tvf.foilid = f.id)

            JOIN testcollectionstests tct ON t.id = tct.testid
            JOIN testcollection tc ON tc.id = tct.testcollectionid
            JOIN assessmentstestcollections atc ON tc.id = atc.testcollectionid
            JOIN assessment a ON atc.assessmentid = a.id
            JOIN testingprogram tp ON a.testingprogramid = tp.id
            JOIN assessmentprogram ap ON tp.assessmentprogramid = ap.id
        WHERE ap.id=%s
        """
                    % options.assessment)

    # # Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
			INSERT INTO taskvariantsfoils (taskvariantid, foilid,
				foilsorder, correctresponse, responsescore,
				responsename, foiltext)
            VALUES (?,?, 1+?,?, ?,?, ?)""",
                          row)

    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx1_taskvariantsfoils on taskvariantsfoils(foilid)");
    sqlitecur.execute("CREATE INDEX IF NOT EXISTS idx2_taskvariantsfoils on taskvariantsfoils(foilsorder)");

    cursor1.close()
    sqliteconn.commit()


def extract_testcollections(options, db, sqliteconn):
    """
    Extract all test collections definitions
    """

    sqlitecur = sqliteconn.cursor()

    if (not _is_table(sqliteconn, 'testcollection')):
        sqlitecur.execute("""
            CREATE Table testcollection (
                id integer,
                name text,
                randomizationtype text,
                createdate datetime,
                effectivedate datetime,
                expirydate datetime,
				gradecourse text,
				gradeband text
            );
            """)

    if (not _is_table(sqliteconn, 'testcollectionstests')):
        sqlitecur.execute("""
            CREATE Table testcollectionstests (
               testcollectionid integer,
               testid integer
            );
            """)

    cursor1 = db.cursor()
    cursor1.execute("""
        /*NO LOAD BALANCE*/
        SELECT tc.id, tc.name, tc.randomizationtype, tc.createdate,
            otc.effectivedate, otc.expirydate, g.name, gb.name
        FROM testcollection tc
        LEFT JOIN operationaltestwindowstestcollections otwtc
            ON (tc.id = otwtc.testcollectionid)
        LEFT JOIN operationaltestwindow otc
            ON (otwtc.operationaltestwindowid = otc.id)
        LEFT JOIN gradecourse AS g ON (tc.gradecourseid = g.id)
        LEFT JOIN gradeband AS gb ON (tc.gradebandid = gb.id)
        """)
    ## Wrong ^^

    for row in cursor1:
        sqlitecur.execute("""
            INSERT INTO testcollection (id, name, randomizationtype,
                createdate, effectivedate, expirydate, gradecourse, gradeband)
            VALUES (?,?,?,?,?,?,?,?)""", row)

    cursor1.close()

    cursor2 = db.cursor()
    cursor2.execute("""
        /*NO LOAD BALANCE*/
        SELECT testcollectionid, testid FROM testcollectionstests
        """)
    ## Wrong ^^

    for row in cursor2:
        sqlitecur.execute("""
            INSERT INTO testcollectionstests (testcollectionid, testid)
            VALUES (?,?)""", row)

    cursor2.close()
    sqliteconn.commit()


def extract_excludeditems(options, db, sqliteconn):
    """
    Extract all excluded items
    """
    sqlitecur = sqliteconn.cursor()


    if options.assessment == "12" or options.assessment == "37":

        if (not _is_table(sqliteconn, 'excludeditems')):
            sqlitecur.execute(
            "CREATE Table excludeditems (id bigint,schoolyear bigint,assessmentprogramid bigint,subjectid bigint,gradeid bigint,taskvariantid bigint,batchuploadid bigint,createddate timestamp,createduser bigint)")

        cursor1 = db.cursor()

        cursor1.execute("""
            /*NO LOAD BALANCE*/
            select id,schoolyear,assessmentprogramid,subjectid,gradeid,taskvariantid,batchuploadid,createddate,createduser
             from excludeditems
             where assessmentprogramid = %s and schoolyear = %s
            """ % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute("""
            INSERT INTO excludeditems (id,schoolyear,assessmentprogramid,subjectid,gradeid,taskvariantid,batchuploadid,createddate,createduser)
            VALUES (?,?,?,?,?,?,?,?,?)""",
                              row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_reportsmedianscore(options, db, sqliteconn):
    """
    Extract all medianscore
    """
    sqlitecur = sqliteconn.cursor()

    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'reportsmedianscore')):
            sqlitecur.execute(
            "CREATE Table reportsmedianscore (id integer,assessmentprogramid bigint ,contentareaid bigint ,gradeid bigint ,organizationid bigint,organizationtypeid bigint,score bigint,standarddeviation numeric(10,6),standarderror numeric(10,6),schoolyear bigint,studentcount integer,createddate timestamp,subscoredefinitionname text,batchreportprocessid bigint)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
            select id,assessmentprogramid,contentareaid,gradeid,organizationid,organizationtypeid ,
                score ,standarddeviation ,standarderror ,schoolyear , studentcount ,createddate ,subscoredefinitionname ,batchreportprocessid
                 from reportsmedianscore where assessmentprogramid = %s and schoolyear = %s
            """ % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute("""
                INSERT INTO reportsmedianscore (id,assessmentprogramid,contentareaid,gradeid,organizationid,organizationtypeid ,
                score ,standarddeviation ,standarderror ,schoolyear , studentcount ,createddate ,subscoredefinitionname ,batchreportprocessid)
                VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                              row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_reportspercentbylevel(options, db, sqliteconn):
    """
    Extract all reportspercent bylevel
    """

    sqlitecur = sqliteconn.cursor()

    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'reportspercentbylevel')):
            sqlitecur.execute(
            "CREATE Table reportspercentbylevel (id integer,organizationid bigint,organizationtypeid bigint,assessmentprogramid bigint,gradeid bigint,contentareaid bigint,studenttest1id bigint,studenttest2id bigint,externaltest1id bigint,externaltest2id bigint,level bigint,percent integer,studentcount integer,batchreportprocessid bigint,schoolyear bigint,createddate timestamp)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
        select id,organizationid,organizationtypeid,assessmentprogramid,gradeid,contentareaid,studenttest1id,studenttest2id,
        externaltest1id,externaltest2id,level,percent,studentcount,batchreportprocessid,schoolyear,createddate
        from reportspercentbylevel where assessmentprogramid = %s and schoolyear = %s
        """
                        % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute("""
            INSERT INTO reportspercentbylevel (id,organizationid,organizationtypeid,assessmentprogramid,gradeid,contentareaid,studenttest1id,studenttest2id,
            externaltest1id,externaltest2id,level,percent,studentcount,batchreportprocessid,schoolyear,createddate)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                              row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_reportsubscores(options, db, sqliteconn):
    """
    Extract all reportsubscores
    """
    sqlitecur = sqliteconn.cursor()


    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'reportsubscores')):
            sqlitecur.execute(
            "CREATE Table reportsubscores (id bigint,studentid bigint,subscoredefinitionname text,subscorerawscore numeric(6,3),subscorescalescore bigint,subscorestandarderror numeric,studentreportid bigint ,createddate timestamp)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
        select id,studentid,subscoredefinitionname,subscorerawscore,subscorescalescore,
        subscorestandarderror,studentreportid,createddate
        from reportsubscores
        """)

        for row in cursor1:
            sqlitecur.execute(""" INSERT INTO reportsubscores (id,studentid,subscoredefinitionname,subscorerawscore,subscorescalescore,
        subscorestandarderror,studentreportid,createddate) VALUES (?,?,?,?,?,?,?,?)
        """, row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_studentreport(options, db, sqliteconn):
    """
    Extract all studentreports
    """
    sqlitecur = sqliteconn.cursor()


    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'studentreport')):
            sqlitecur.execute(
            "CREATE Table studentreport (id integer,studentid bigint,enrollmentid bigint,gradeid bigint,contentareaid bigint,attendanceschoolid bigint,districtid bigint,stateid bigint,studenttest1id bigint,studenttest2id bigint,externaltest1id bigint,externaltest2id bigint,levelid bigint,rawscore numeric(6,3),subscore numeric(6,3),batchreportprocessid bigint,scalescore bigint,standarderror numeric(6,3),assessmentprogramid bigint,schoolyear bigint,filepath text,aggregates boolean,incompletestatus boolean,exitstatus boolean,status boolean)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
        select id,studentid,enrollmentid,gradeid,contentareaid,
        attendanceschoolid,districtid,stateid,studenttest1id,studenttest2id,externaltest1id,externaltest2id,
        levelid,rawscore,subscore,batchreportprocessid,scalescore,standarderror,assessmentprogramid,schoolyear,
        filepath,aggregates,incompletestatus,exitstatus,status
        from studentreport
        where schoolyear = %s
            """ % options.year)

        for row in cursor1:
            sqlitecur.execute(""" INSERT INTO studentreport (id,studentid,enrollmentid,gradeid,contentareaid,
                    attendanceschoolid,districtid,stateid,studenttest1id,studenttest2id,externaltest1id,externaltest2id,
                    levelid,rawscore,subscore,batchreportprocessid,scalescore,standarderror,assessmentprogramid,schoolyear,
                    filepath,aggregates,incompletestatus,exitstatus,status) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                              row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_organizationreportdetails(options, db, sqliteconn):
    """
    Extract all organizationreportdetails
    """
    sqlitecur = sqliteconn.cursor()


    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'organizationreportdetails')):
            sqlitecur.execute(
            "CREATE Table organizationreportdetails(id integer,assessmentprogramid bigint,contentareaid bigint,gradeid bigint,organizationid bigint,schoolyear bigint,createddate timestamp,detailedreportpath text,schoolreportpdfpath text,schoolreportpdfsize bigint,schoolreportzipsize bigint,batchreportprocessid bigint,gradecourseabbrname text,summaryreportpath text)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
        select id,assessmentprogramid,contentareaid,gradeid,organizationid,schoolyear,
        createddate,detailedreportpath,schoolreportpdfpath,schoolreportpdfsize,schoolreportzipsize,batchreportprocessid,gradecourseabbrname,
        summaryreportpath
        from organizationreportdetails
        where assessmentprogramid = %s and schoolyear = %s
            """ % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute(""" INSERT INTO organizationreportdetails (id,assessmentprogramid,contentareaid,gradeid,organizationid,schoolyear,
        createddate,detailedreportpath,schoolreportpdfpath,schoolreportpdfsize,schoolreportzipsize,batchreportprocessid,gradecourseabbrname,
        summaryreportpath) VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                              row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_rawtoscalescores(options, db, sqliteconn):
    """
    Extract rawtoscalescores
    """
    sqlitecur = sqliteconn.cursor()

    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'rawtoscalescores')):
            sqlitecur.execute(
            "CREATE Table rawtoscalescores(id integer,schoolyear bigint,assessmentprogramid bigint,subjectid bigint,gradeid bigint,testid1 bigint,testid2 bigint,rawscore numeric,scalescore bigint,standarderror numeric,batchuploadid bigint,createddate timestamp)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
        select id,schoolyear,assessmentprogramid,subjectid,gradeid,testid1,testid2,
        rawscore,scalescore,standarderror,batchuploadid,createddate
        from rawtoscalescores where assessmentprogramid = %s and schoolyear = %s
        """ % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute("""
        INSERT INTO rawtoscalescores (id,schoolyear,assessmentprogramid,subjectid,gradeid,testid1,testid2,
        rawscore,scalescore,standarderror,batchuploadid,createddate) VALUES (?,?,?,?,?,?,?,?,?,?,?,?)""",
                              row)

    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_subscoreframework(options, db, sqliteconn):
    """
    Extract subscoreframework
    """
    sqlitecur = sqliteconn.cursor()

    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'subscoreframework')):
            sqlitecur.execute(
            "CREATE Table subscoreframework(id integer,schoolyear bigint,assessmentprogramid bigint,subjectid bigint,gradeid bigint,subscoredefinitionname text,framework text,frameworklevel1 text,frameworklevel2 text,frameworklevel3 text,batchuploadid bigint,createddate timestamp)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
            select id,schoolyear,assessmentprogramid,subjectid,gradeid,subscoredefinitionname,
            framework,frameworklevel1,frameworklevel2,frameworklevel3,batchuploadid,createddate
            from subscoreframework where assessmentprogramid = %s and schoolyear = %s
            """ % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute("""
            INSERT INTO subscoreframework (id,schoolyear,assessmentprogramid,subjectid,gradeid,subscoredefinitionname,
            framework,frameworklevel1,frameworklevel2,frameworklevel3,batchuploadid,createddate)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?)""", row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_subscoresdescription(options, db, sqliteconn):
    """
    Extract subscoresdescription
    """
    sqlitecur = sqliteconn.cursor()

    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'subscoresdescription')):
            sqlitecur.execute(
            "CREATE Table subscoresdescription(id integer,schoolyear bigint,assessmentprogramid bigint,subjectid bigint,report text,subscoredefinitionname text,subscorereportdisplayname text, subscorereportdescription text, subscoredisplaysequence integer,batchuploadid bigint,createddate timestamp)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
            select id,schoolyear,assessmentprogramid,subjectid,report,subscoredefinitionname,
            subscorereportdisplayname,subscorereportdescription,subscoredisplaysequence,batchuploadid,createddate
            from subscoresdescription where assessmentprogramid = %s and schoolyear = %s
            """ % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute("""
            INSERT INTO subscoresdescription (id,schoolyear,assessmentprogramid,subjectid,report,subscoredefinitionname,
            subscorereportdisplayname,subscorereportdescription,subscoredisplaysequence,batchuploadid,createddate)
            VALUES (?,?,?,?,?,?,?,?,?,?,?)""",
                              row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_subscoresrawtoscale(options, db, sqliteconn):
    """
    Extract subscoresrawtoscale
    """
    sqlitecur = sqliteconn.cursor()


    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'subscoresrawtoscale')):
            sqlitecur.execute(
            "CREATE Table subscoresrawtoscale(id integer,schoolyear bigint,assessmentprogramid bigint,subjectid bigint,gradeid bigint,testid1 bigint,testid2 bigint,subscoredefinitionname text,rawscore numeric,scalescore bigint,standarderror numeric,batchuploadid bigint,createddate timestamp)")

        cursor1 = db.cursor()

        cursor1.execute(""" /*NO LOAD BALANCE*/
            select id,schoolyear,assessmentprogramid,subjectid,gradeid,testid1,testid2,
            subscoredefinitionname,rawscore,scalescore,standarderror,batchuploadid,createddate
            from subscoresrawtoscale where assessmentprogramid = %s and schoolyear = %s
            """ % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute("""
            INSERT INTO subscoresrawtoscale (id,schoolyear,assessmentprogramid,subjectid,gradeid,testid1,testid2,
            subscoredefinitionname,rawscore,scalescore,standarderror,batchuploadid,createddate)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)""", row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()


def extract_leveldescription(options, db, sqliteconn):
    """
    Extract leveldescription
    """
    sqlitecur = sqliteconn.cursor()

    if options.assessment == '12' or options.assessment == '37':

        if (not _is_table(sqliteconn, 'leveldescription')):
            sqlitecur.execute(
                "CREATE Table leveldescription(id integer,schoolyear bigint,assessmentprogramid bigint,subjectid bigint,gradeid bigint,testid1 bigint, testid2 bigint,level bigint,levelname text,batchuploadid bigint,createddate timestamp,createduser bigint,activeflag boolean,leveldescription text)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
            select id,schoolyear,assessmentprogramid,subjectid,gradeid,testid1,testid2,
            level,levelname,batchuploadid,createddate,createduser,activeflag,leveldescription
            from leveldescription where assessmentprogramid = %s and schoolyear = %s
            """ % (options.assessment, options.year))

        for row in cursor1:
            sqlitecur.execute("""
            INSERT INTO leveldescription (id,schoolyear,assessmentprogramid,subjectid,gradeid,testid1,testid2,
            level,levelname,batchuploadid,createddate,createduser,activeflag,leveldescription)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?,?)""", row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()

def extract_operationaltestwindowstudent(options, db, sqliteconn):
    """
    Extract operationaltestwindowstudent information
    """
    sqlitecur = sqliteconn.cursor()

    if options.assessment == '3':

        if (not _is_table(sqliteconn, 'operationaltestwindowstudent')):
            sqlitecur.execute(
                "CREATE Table operationaltestwindowstudent(studentid integer,stateid integer,contentareaid integer,contentareaname text,courseid integer,coursename text,operationaltestwindowid integer,operationaltestwindowname text,createddate text,effectiveddate text,expirydate text,exclude boolean,include boolean)")

        cursor1 = db.cursor()

        cursor1.execute("""/*NO LOAD BALANCE*/
            SELECT
              otws.studentid AS "studentid",
              s.stateid AS "stateid",
              otws.contentareaid AS "contentareaid",
              ca.abbreviatedname AS "contentareaname",
              otws.courseid AS "courseid",
              gc.abbreviatedname AS "coursename",
              otws.operationaltestwindowid AS "operationaltestwindowid",
              otw.windowname AS "operationaltestwindowname",
              otws.createddate AS "createddate",
              otw.effectivedate AS "effectivedate",
              otw.expirydate AS "expirydate",
              otws.exclude AS "exclude",
              otws.activeflag AS "include"
            FROM operationaltestwindowstudent otws
            JOIN operationaltestwindow otw ON otws.operationaltestwindowid = otw.id
            JOIN student s ON otws.studentid = s.id
            JOIN contentarea ca ON otws.contentareaid = ca.id
            LEFT JOIN gradecourse gc on otws.courseid = gc.id
            """)

        for row in cursor1:
            sqlitecur.execute("""
            INSERT INTO operationaltestwindowstudent (studentid,stateid,contentareaid,contentareaname,courseid,coursename,operationaltestwindowid,operationaltestwindowname,createddate,effectivedate,expirydate,exclude,include)
            VALUES (?,?,?,?,?,?,?,?,?,?,?,?,?)""", row)
    else:
        return

    cursor1.close()
    sqliteconn.commit()

def analyze_db(sqliteconn):

    sqlitecur = sqliteconn.cursor()

    sqlitecur.execute("ANALYZE");

def main():
    # Register the adapter
    sqlite3.register_adapter(D, adapt_decimal)

    # Register the converter
    sqlite3.register_converter("decimal", convert_decimal)

    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)

    parser.add_option("-v", "--verbose",
                      action="store_true", dest="verbose", default=True,
                      help="make lots of noise [default]")
    parser.add_option("-l", "--list", action="store_true",
                      help="List assessment programs")
    parser.add_option("-a", "--assessment", help="Assessment Program ID")
    parser.add_option("-p", "--programname", help="Testing Progam Name")
    parser.add_option("-o", "--organization", help="Students by organization",
                      default=False, action="store_true")
    parser.add_option("-y", "--year", help="Assessment Year",
                      default='2016')
    parser.add_option("-t", "--tables", action="append", type="string",
                      help="all, educators, pd, test,exclude,reports,score,level")
    parser.add_option("-d", "--database", action="store",
                      help="SQLite database file name.")
    parser.add_option("-n", "--database_string",
                      help="Required:host='local' dbname='test' user='postgres' password='secret'")
    parser.add_option("-m", "--audit_database_string",
                      help="Required:host='local' dbname='test' user='postgres' password='secret'")
    parser.add_option("-s", "--tde_database_string",
                      help="Required:host='local' dbname='test' user='postgres' password='secret'")
    parser.add_option("-i", "--itersize", help="Cursor IterSize",
                  default=1000000)

    (options, args) = parser.parse_args()

    global db
    global adb
    global tdedb
    global tdecursor
    global aartcursor
    global LOG_FILENAME

    LOG_FILENAME = 'extract_sqlite.log'
    logging.basicConfig(filename=LOG_FILENAME,level=logging.DEBUG)

    (options, args) = parser.parse_args()

    db = psycopg2.connect(options.database_string)


    if options.list:
        list_assessment_programs(options, db.cursor())
        return

    if not options.tables:
        parser.print_help()
        return

    if os.path.isfile(options.database):
        os.remove(options.database)

    sqliteconn = sqlite3.connect(options.database)
    sqliteconn.text_factory = str

    # Populate educators
    if "educators" in options.tables or "all" in options.tables:
        extract_educators(options, db, sqliteconn)

    # popluate professional development
    if "pd" in options.tables or "all" in options.tables:
        extract_professional_development(options, db, sqliteconn)

    # Populate test information (Includes questions)
    if "test" in options.tables or "all" in options.tables:
        extract_test(options, db, sqliteconn)
        extract_lmassessmentmodelrule(options, db, sqliteconn)
        extract_testsection(options, db, sqliteconn)
        extract_testlet(options, db, sqliteconn)
        extract_taskvariant(options, db, sqliteconn)
        extract_taskvariantsfoils(options, db, sqliteconn)
        extract_testsectionstaskvariants(options, db, sqliteconn)
        extract_testcollections(options, db, sqliteconn)

    # Populate Student demographics
    if "student" in options.tables or "all" in options.tables:
        #extract_students(options, db, sqliteconn)
        #extract_student_rosters(options, db, sqliteconn)
        #extract_firstcontact(options, db, sqliteconn)
        #extract_pnp(options, db, sqliteconn)
        #extract_student_tests(options, db, sqliteconn)
        extract_student_responses(options, db, sqliteconn)
        #extract_student_response_score(options, db, sqliteconn)
        #extract_student_response_unscored(options, db, sqliteconn)

    # Populate excluded items

    if "exclude" in options.tables or "all" in options.tables:
        extract_excludeditems(options, db, sqliteconn)

    # Populate reports information

    if "reports" in options.tables or "all" in options.tables:
        extract_studentreport(options, db, sqliteconn)
        extract_reportsmedianscore(options, db, sqliteconn)
        extract_reportspercentbylevel(options, db, sqliteconn)
        extract_reportsubscores(options, db, sqliteconn)
        extract_organizationreportdetails(options, db, sqliteconn)

    # Populate score information

    if "score" in options.tables or "all" in options.tables:
        extract_rawtoscalescores(options, db, sqliteconn)
        extract_subscoreframework(options, db, sqliteconn)
        extract_subscoresdescription(options, db, sqliteconn)
        extract_subscoresrawtoscale(options, db, sqliteconn)

    # Populate level information

    if "level" in options.tables or "all" in options.tables:
        extract_leveldescription(options, db, sqliteconn)

    # operationaltestwindowstudent information
    if "operationaltestwindowstudent" in options.tables or "all" in options.tables:
        extract_operationaltestwindowstudent(options, db, sqliteconn)

    # Analyze the database

    analyze_db(sqliteconn)

    sqliteconn.close()
    db.close()


if __name__ == '__main__':
    main()
