#!/usr/bin/python
#author:Rohit Yadav

import sqlite3
import psycopg2
import psycopg2.extras
import decimal
import os
import sys
import logging
import time
import json
import glob
import collections
from optparse import OptionParser
from operator import itemgetter
from datetime import datetime
from ConfigParser import SafeConfigParser
from underscore import _
from itertools import islice

D = decimal.Decimal


def adapt_decimal(d):
    return str(d)

def convert_decimal(s):
    return D(s)

def list_assessment_programs(options, cursor):
    """
        List all of the assessment programs.
    """

    cursor.execute('SELECT id, programname FROM assessmentprogram WHERE activeflag = true ORDER BY id'
               )

    for row in cursor.fetchall():
        print '{0:8d}: {1}'.format(row[0], row[1])

    cursor.close()

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

def pnpextract(options, db, sqliteconn):
    """
    Extract pnp setting for dlm students
    """

    #logging.debug("Inside pnpextract function")
    if options.assessment == '3':

        sqlitecur = sqliteconn.cursor()

        if not _is_table(sqliteconn, 'pnpextract'):
            sqlitecur.execute("""
                CREATE Table pnpextract(
                        State text,
                        District text,
                        School text,
                        StudentLastName text,
                        StudentFirstName text,
                        StudentMiddleInitial text,
                        GradeLevel text,
                        StudentID text,
                        StudentStateID text,
                        StudentLocalID text,
                        "Final ELA" text,
                        "Final Math" text,
                        DLMStudent text,
                        "Display - Magnification" text, "Display - Magnification Activate by Default" text, "Display - Magnification Setting" text,
                        "Display - Overlay Color" text, "Display - Overlay Color Activate by Default" text, "Display - Overlay Color Code" text,
                        "Display - Overlay Color Desc" text, "Display - Invert Color Choice" text, "Display - Invert Color Choice Activate By Default" text,
                        "Display - Masking" text, "Display - Masking Activate by Default" text, "Display - Masking Setting" text,
                        "Display - Contrast Color" text, "Display - Contrast Color Activate by Default" text, "Display - Contrast Color Background" text,
                        "Display - Contrast Color Background Desc" text, "Display - Contrast Color Foreground" text, "Display - Contrast Color Foreground Desc" text,
                        "Language - Item Translation Display" text, "Language - Item Translation Display Activate by Default" text,
                        "Language - Item Translation Display Setting" text, "Language - Signing Type" text, "Language - Signing Type Activate by Default" text,
                        "Language - Signing Type Setting" text, "Language - Braille" text, "Language - Braille Activate by Default" text, "Language - Braille Usage" text,
                        "Language - Keyword Translation Display" text, "Language - Keyword Translation Display Activate by Default" text,
                        "Language - Keyword Translation Display Setting" text, "Language - Tactile" text, "Language - Tactile Activate by Default" text,
                        "Language - Tactile Setting" text,
                        "Auditory - Auditory Background" text, "Auditory - Auditory Background Activate by Default" text, "Auditory - Auditory Background Breaks" text,
                        "Auditory - Auditory Background Additional Testing Time" text, "Auditory - Auditory Background Additional Testing Time Activate by Default" text,
                        "Auditory-Auditory Background Additional Testing Time Multiplier setting" text,
                        "Auditory - Spoken Audio" text, "Auditory - Spoken Audio Activate by Default" text, "Auditory - Spoken Audio Voice Source Setting" text,
                        "Auditory - Spoken Audio Voice Read at Start" text, "Auditory - Spoken Audio Spoken Preference Setting" text, "Auditory - Audio Directions Only" text,
                        "Auditory - Spoken Audio Subject Setting" text,
                        "Auditory - Switches" text, "Auditory - Switches Activate by Default" text,
                        "Auditory - Switches Scan Speed Seconds" text,
                        "Auditory - Switches Scan Initial Delay Setting Seconds" text, "Auditory - Switches Automatic Scan Repeat Frequency" text,
                        "Other Supports - Separate, quiet, or individual setting" text,
                        "Other Supports - Presentation Student reads assessment aloud to self" text,
                        "Other Supports - Presentation Student Used Translation dictionary" text,
                        "Other Supports - Presentation Other Accommodation Used" text,
                        "Other Supports - Response - Student dictated answers to scribe" text, "Other Supports - Response - Student used a communication device" text,
                        "Other Supports - Response - Student signed responses" text,
                        "Other Supports - Provided by Alternate Form - Visual Impairment" text, "Other Supports - Provided by Alternate Form - Large Print" text,
                        "Other Supports - Provided by Alternate Form - Paper and Pencil" text,
                        "Other Supports - Requiring Additional Tools Two Switch System" text,
                        "Other Supports - Requiring Additional Tools Administration via iPad" text,
                        "Other Supports - Requiring Additional Tools Adaptive equipment" text,
                        "Other Supports - Requiring Additional Tools Individualized manipulatives" text,
                        "Other Supports - Requiring Additional Tools Calculator" text,
                        "Other Supports - Provided outside system - Human read aloud" text, "Other Supports - Provided outside system - Sign Intrepretation" text,
                        "Other Supports - Provided outside system - Translation" text, "Other Supports - Provided outside system - Test admin enters responses for student" text,
                        "Other Supports - Provided outside system - Partner assisted scanning" text,
                        "Other Supports - Provided outside system - Student provided non-embedded accommodations as noted in IEP"
                        );
            """)

        columnHeaders = ["State", "District", "School", "Student Last Name", "Student First Name",
        "Student Middle Initial","Grade Level", "StudentID","Student State ID", "Student Local ID", "Final ELA","Final Math","DLM Student",
        "Display - Magnification", "Display - Magnification Activate by Default", "Display - Magnification Setting",
        "Display - Overlay Color", "Display - Overlay Color Activate by Default", "Display - Overlay Color Code",
        "Display - Overlay Color Desc", "Display - Invert Color Choice", "Display - Invert Color Choice Activate By Default",
        "Display - Masking", "Display - Masking Activate by Default", "Display - Masking Setting",
        "Display - Contrast Color", "Display - Contrast Color Activate by Default", "Display - Contrast Color Background",
        "Display - Contrast Color Background Desc", "Display - Contrast Color Foreground", "Display - Contrast Color Foreground Desc",
        "Language - Item Translation Display", "Language - Item Translation Display Activate by Default",
        "Language - Item Translation Display Setting", "Language - Signing Type", "Language - Signing Type Activate by Default",
        "Language - Signing Type Setting", "Language - Braille", "Language - Braille Activate by Default", "Language - Braille Usage",
        "Language - Keyword Translation Display", "Language - Keyword Translation Display Activate by Default",
        "Language - Keyword Translation Display Setting", "Language - Tactile", "Language - Tactile Activate by Default",
        "Language - Tactile Setting",
        "Auditory - Auditory Background", "Auditory - Auditory Background Activate by Default", "Auditory - Auditory Background Breaks",
        "Auditory - Auditory Background Additional Testing Time", "Auditory - Auditory Background Additional Testing Time Activate by Default",
        "Auditory-Auditory Background Additional Testing Time Multiplier setting",
        "Auditory - Spoken Audio", "Auditory - Spoken Audio Activate by Default", "Auditory - Spoken Audio Voice Source Setting",
        "Auditory - Spoken Audio Voice Read at Start", "Auditory - Spoken Audio Spoken Preference Setting", "Auditory - Audio Directions Only",
        "Auditory - Spoken Audio Subject Setting",
        "Auditory - Switches", "Auditory - Switches Activate by Default",
        "Auditory - Switches Scan Speed Seconds",
        "Auditory - Switches Scan Initial Delay Setting Seconds", "Auditory - Switches Automatic Scan Repeat Frequency",
        "Other Supports - Separate, quiet, or individual setting",
        "Other Supports - Presentation Student reads assessment aloud to self",
        "Other Supports - Presentation Student Used Translation dictionary",
        "Other Supports - Presentation Other Accommodation Used",
        "Other Supports - Response - Student dictated answers to scribe", "Other Supports - Response - Student used a communication device",
        "Other Supports - Response - Student signed responses",
        "Other Supports - Provided by Alternate Form - Visual Impairment", "Other Supports - Provided by Alternate Form - Large Print",
        "Other Supports - Provided by Alternate Form - Paper and Pencil",
        "Other Supports - Requiring Additional Tools Two Switch System",
        "Other Supports - Requiring Additional Tools Administration via iPad",
        "Other Supports - Requiring Additional Tools Adaptive equipment",
        "Other Supports - Requiring Additional Tools Individualized manipulatives",
        "Other Supports - Requiring Additional Tools Calculator",
        "Other Supports - Provided outside system - Human read aloud", "Other Supports - Provided outside system - Sign Intrepretation",
        "Other Supports - Provided outside system - Translation", "Other Supports - Provided outside system - Test admin enters responses for student",
        "Other Supports - Provided outside system - Partner assisted scanning",
        "Other Supports - Provided outside system - Student provided non-embedded accommodations as noted in IEP"
		          ]

        supported = "assignedSupport"
        activeByDefault = "activateByDefault"

        pnpColumnCodes = collections.OrderedDict()

        pnpColumnCodes['Magnification'] = map(str.lower,[supported, activeByDefault, 'magnification'])
        pnpColumnCodes["ColourOverlay"] = map(str.lower,[supported, activeByDefault, "colour"])
        pnpColumnCodes["InvertColourChoice"] = map(str.lower,[supported, activeByDefault])
        pnpColumnCodes["Masking"] = map(str.lower,[supported, activeByDefault, "MaskingType"])
        pnpColumnCodes["BackgroundColour"] = map(str.lower,[supported, activeByDefault, "colour"])
        pnpColumnCodes["ForegroundColour"] = map(str.lower,["colour"])
        pnpColumnCodes["itemTranslationDisplay"] = map(str.lower,[supported, activeByDefault, "Language"])
        pnpColumnCodes["Signing"] = map(str.lower,[supported, activeByDefault, "SigningType"])
        pnpColumnCodes["Braille"] = map(str.lower,[supported, activeByDefault, "usage"])
        pnpColumnCodes["keywordTranslationDisplay"] = map(str.lower,[supported, activeByDefault, "Language"])
        pnpColumnCodes["Tactile"] = map(str.lower,[supported, activeByDefault, "tactileFile"])
        pnpColumnCodes["AuditoryBackground"] = map(str.lower,[supported, activeByDefault])
        pnpColumnCodes["breaks"] = map(str.lower,[supported]) #still in "AuditoryBackground", in the column names
        pnpColumnCodes["AdditionalTestingTime"] = map(str.lower,[supported, activeByDefault, "TimeMultiplier"])
        pnpColumnCodes["Spoken"] = map(str.lower,[supported, activeByDefault, "SpokenSourcePreference",
                "ReadAtStartPreference","UserSpokenPreference", "directionsOnly", "preferenceSubject"])
        pnpColumnCodes["onscreenKeyboard"] = map(str.lower,[supported, activeByDefault, "scanSpeed",
                "automaticScanInitialDelay","automaticScanRepeat"])
        pnpColumnCodes["setting"] = map(str.lower,["separateQuiteSetting"])
        pnpColumnCodes["presentation"] = map(str.lower,["readsAssessmentOutLoud",
                                  "useTranslationsDictionary",
                                  "someotheraccommodation"])
        pnpColumnCodes["response"] = map(str.lower,["dictated",
                              "usedCommunicationDevice",
                              "signedResponses"])
        pnpColumnCodes["supportsProvidedByAlternateForm"] = map(str.lower,["visualImpairment",
                                            "largePrintBooklet",
                                            "paperAndPencil"])
        pnpColumnCodes["supportsRequiringAdditionalTools"] = map(str.lower,["supportsTwoSwitch",
                                              "supportsAdminIpad",
                                              "supportsAdaptiveEquip",
                                              "supportsIndividualizedManipulatives",
                                              "supportsCalculator"])
        pnpColumnCodes["supportsProvidedOutsideSystem"] = map(str.lower,["supportsHumanReadAloud",
                                            "supportsSignInterpretation",
                                            "supportsLanguageTranslation",
                                            "supportsTestAdminEnteredResponses",
                                            "supportsPartnerAssistedScanning",
                                            "supportsStudentProvidedAccommodations"])

        independentSelectionContainers = set()
        independentSelectionContainers.add("supportsProvidedByAlternateForm")
        independentSelectionContainers.add("supportsRequiringAdditionalTools")
        independentSelectionContainers.add("supportsProvidedOutsideSystem")

        requiresSpecialOutput = set()
        requiresSpecialOutput.add("presentation")
        requiresSpecialOutput.add("response")

        colors = collections.OrderedDict()
        colors["#F0F8FF"] = "AliceBlue"
        colors["#FAEBD7"] = "AntiqueWhite"
        colors["#00FFFF"] = "Aqua"
        colors["#7FFFD4"] = "Aquamarine"
        colors["#F0FFFF"] = "Azure"
        colors["#F5F5DC"] = "Beige"
        colors["#FFE4C4"] = "Bisque"
        colors["#000000"] = "Black"
        colors["#FFEBCD"] = "BlanchedAlmond"
        colors["#0000FF"] = "Blue"
        colors["#8A2BE2"] = "BlueViolet"
        colors["#A52A2A"] = "Brown"
        colors["#DEB887"] = "BurlyWood"
        colors["#5F9EA0"] = "CadetBlue"
        colors["#7FFF00"] = "Chartreuse"
        colors["#D2691E"] = "Chocolate"
        colors["#FF7F50"] = "Coral"
        colors["#6495ED"] = "CornflowerBlue"
        colors["#FFF8DC"] = "Cornsilk"
        colors["#DC143C"] = "Crimson"
        colors["#00FFFF"] = "Cyan"
        colors["#00008B"] = "DarkBlue"
        colors["#008B8B"] = "DarkCyan"
        colors["#B8860B"] = "DarkGoldenrod"
        colors["#A9A9A9"] = "DarkGray"
        colors["#006400"] = "DarkGreen"
        colors["#BDB76B"] = "DarkKhaki"
        colors["#8B008B"] = "DarkMagenta"
        colors["#556B2F"] = "DarkOliveGreen"
        colors["#FF8C00"] = "DarkOrange"
        colors["#9932CC"] = "DarkOrchid"
        colors["#8B0000"] = "DarkRed"
        colors["#E9967A"] = "DarkSalmon"
        colors["#8FBC8F"] = "DarkSeaGreen"
        colors["#483D8B"] = "DarkSlateBlue"
        colors["#2F4F4F"] = "DarkSlateGray"
        colors["#00CED1"] = "DarkTurquoise"
        colors["#9400D3"] = "DarkViolet"
        colors["#FF1493"] = "DeepPink"
        colors["#00BFFF"] = "DeepSkyBlue"
        colors["#696969"] = "DimGray"
        colors["#1E90FF"] = "DodgerBlue"
        colors["#B22222"] = "FireBrick"
        colors["#FFFAF0"] = "FloralWhite"
        colors["#228B22"] = "ForestGreen"
        colors["#FF00FF"] = "Fuchsia"
        colors["#DCDCDC"] = "Gainsboro"
        colors["#F8F8FF"] = "GhostWhite"
        colors["#FFD700"] = "Gold"
        colors["#DAA520"] = "Goldenrod"
        colors["#808080"] = "Gray"
        colors["#008000"] = "Green"
        colors["#ADFF2F"] = "GreenYellow"
        colors["#F0FFF0"] = "Honeydew"
        colors["#FF69B4"] = "HotPink"
        colors["#4B0082"] = "Indigo"
        colors["#FFFFF0"] = "Ivory"
        colors["#F0E68C"] = "Khaki"
        colors["#E6E6FA"] = "Lavender"
        colors["#FFF0F5"] = "LavenderBlush"
        colors["#7CFC00"] = "LawnGreen"
        colors["#FFFACD"] = "LemonChiffon"
        colors["#ADD8E6"] = "LightBlue"
        colors["#F08080"] = "LightCoral"
        colors["#E0FFFF"] = "LightCyan"
        colors["#FAFAD2"] = "LightGoldenrodYellow"
        colors["#D3D3D3"] = "LightGray"
        colors["#90EE90"] = "LightGreen"
        colors["#FFB6C1"] = "LightPink"
        colors["#FFA07A"] = "LightSalmon"
        colors["#20B2AA"] = "LightSeaGreen"
        colors["#87CEFA"] = "LightSkyBlue"
        colors["#778899"] = "LightSlateGray"
        colors["#B0C4DE"] = "LightSteelBlue"
        colors["#FFFFE0"] = "LightYellow"
        colors["#00FF00"] = "Lime"
        colors["#32CD32"] = "LimeGreen"
        colors["#FAF0E6"] = "Linen"
        colors["#FF00FF"] = "Magenta"
        colors["#FFEEFB"] = "Magenta"
        colors["#800000"] = "Maroon"
        colors["#66CDAA"] = "MediumAquaMarine"
        colors["#0000CD"] = "MediumBlue"
        colors["#BA55D3"] = "MediumOrchid"
        colors["#9370DB"] = "MediumPurple"
        colors["#3CB371"] = "MediumSeaGreen"
        colors["#7B68EE"] = "MediumSlateBlue"
        colors["#00FA9A"] = "MediumSpringGreen"
        colors["#48D1CC"] = "MediumTurquoise"
        colors["#C71585"] = "MediumVioletRed"
        colors["#191970"] = "MidnightBlue"
        colors["#F5FFFA"] = "MintCream"
        colors["#86FDAA"] = "MintGreen"
        colors["#FFE4E1"] = "MistyRose"
        colors["#FFE4B5"] = "Moccasin"
        colors["#000080"] = "Navy"
        colors["#FDF5E6"] = "OldLace"
        colors["#808000"] = "Olive"
        colors["#6B8E23"] = "OliveDrab"
        colors["#FFA500"] = "Orange"
        colors["#FF4500"] = "OrangeRed"
        colors["#DA70D6"] = "Orchid"
        colors["#EEE8AA"] = "PaleGoldenrod"
        colors["#98FB98"] = "PaleGreen"
        colors["#AFEEEE"] = "PaleTurquoise"
        colors["#DB7093"] = "PaleVioletRed"
        colors["#FFEFD5"] = "PapayaWhip"
        colors["#FFDAB9"] = "PeachPuff"
        colors["#CD853F"] = "Peru"
        colors["#FFC0CB"] = "Pink"
        colors["#DDA0DD"] = "Plum"
        colors["#B0E0E6"] = "PowderBlue"
        colors["#800080"] = "Purple"
        colors["#FF0000"] = "Red"
        colors["#BC8F8F"] = "RosyBrown"
        colors["#4169E1"] = "RoyalBlue"
        colors["#8B4513"] = "SputleBrown"
        colors["#FA8072"] = "Salmon"
        colors["#F4A460"] = "SandyBrown"
        colors["#2E8B57"] = "SeaGreen"
        colors["#FFF5EE"] = "SeaShell"
        colors["#A0522D"] = "Sienna"
        colors["#87CEEB"] = "SkyBlue"
        colors["#6A5ACD"] = "SlateBlue"
        colors["#708090"] = "SlateGray"
        colors["#FFFAFA"] = "Snow"
        colors["#00FF7F"] = "SpringGreen"
        colors["#4682B4"] = "SteelBlue"
        colors["#D2B48C"] = "Tan"
        colors["#008080"] = "Teal"
        colors["#D8BFD8"] = "Thistle"
        colors["#FF6347"] = "Tomato"
        colors["#40E0D0"] = "Turquoise"
        colors["#EE82EE"] = "Violet"
        colors["#F5DEB3"] = "Wheat"
        colors["#FFFFFF"] = "White"
        colors["#F5F5F5"] = "WhiteSmoke"
        colors["#FFFF00"] = "Yellow"
        colors["#9ACD32"] = "YellowGreen"
        colors["#999999"] = "DarkGray"
        colors["#fefe22"] = "LaserLemon"
        colors["#ffffff"] = "White"
        colors["#3b9e24"] = "DarkLimeGreen"
        colors["#c62424"] = "StrongRed"
        colors["#87cffd"] = "SoftBlue"
        colors["#ffffff"] = "White"
        colors["#999999"] = "DarkGray"
        colors["#83cffd"] = "SoftBlue"
        colors["#fefe22"] = "LaserLemon"
        colors["#f5f2a4"] = "VerySoftYellow"
        colors["#bef9c3"] = "VerySoftLimeGreen"
        colors["#fff"] = "White"
        colors["#f2c5c5"] = "LightGrayishRed"
        colors["#c5c5c5"] = " LightGray"
        colors["#bef9c4"] = "VerySoftLimeGreen"
        colors["#efee79"] = "SoftYellow"
        colors["#3b9e24"] = "DarkLimeGreen"
        colors["#000080"] = "DarkBlue"
        colors["#ffeefb"] = "Magenta"
        colors["#f87cffd"] = "N/A"
        colors["#F87CFFD"] = "N/A"
        #attendanceSchoolIdsToOrgInfo = dict()

        #studentsAtATime = 10000
        #offset = 0

        studentIds = []
        cursor_studentid = db.cursor('cursor_studentid', cursor_factory=psycopg2.extras.DictCursor)
        #logging.debug("Fetching distinct student ids from EP")
        cursor_studentid.execute("""
                    /*NO LOAD BALANCE*/
                    SELECT DISTINCT st.id
                    FROM organizationtreedetail orglist
                    INNER JOIN enrollment enrl ON enrl.attendanceschoolid = orglist.schoolid
                    -- AND enrl.activeflag IS TRUE
                    AND enrl.currentschoolyear = %s
                    INNER JOIN student st ON enrl.studentid = st.id
                    AND st.profilestatus = 'CUSTOM'
                    AND st.activeflag = TRUE
                    JOIN studentassessmentprogram sap ON (sap.studentid = st.id)
                    WHERE sap.assessmentprogramid = 3
                    AND orglist.statename NOT IN ('flatland', 'DLM QC State', 'AMP QC State', 'KAP QC State', 'Playground QC State', 'Flatland',
      											  'DLM QC YE State', 'DLM QC IM State', 'DLM QC IM State ', 'DLM QC EOY State','Service Desk QC State')
                    ORDER BY st.id
                    """
                     %(options.year))
        ##logging.debug("Fetching Completed")
        ##logging.debug("Before Entering for loop to add studentids in studentIds list")
        count = 0
        for row in cursor_studentid:
            count += 1
            student_index = 0
            studentid_value = row['id']
            ##logging.debug("studentid_value is %s", studentid_value)
            studentIds.insert(student_index,studentid_value)

            student_index += 1
        cursor_studentid.close()

        record = []
        attributes = []
        finalrow =[]

        student_count = 0
        student_list = 0
        for x in xrange(0,len(studentIds)):
            student_count += 1
            #logging.debug("student count is %s", student_count)
            student = studentIds[x]
            record = getstudentpnpjson(options.assessment,student)
            #logging.debug("length of record is %s", len(record))
            attributes = record

            lines = []
            enrollments = []
            cursor_enrollment = db.cursor('cursor_enrollment', cursor_factory=psycopg2.extras.DictCursor)

            #logging.debug("Iterating over everystudent in the studentIds list")
            cursor_enrollment.execute("""
                        /*NO LOAD BALANCE*/
                               SELECT enrl.id,
                               aypSchoolIdentifier,
                               residenceDistrictIdentifier,
                               st.statestudentidentifier,
                               localStudentIdentifier,
                               currentGradeLevel, currentSchoolYear,
                                attendanceSchool.schooldisplayidentifier as attendanceSchoolProgramIdentifier,
                                attendanceSchool.schoolid as attendanceSchoolId,
                               SchoolEntryDate, districtEntryDate, stateEntryDate, exitWithdrawalDate,
                               exitWithdrawalType, specialCircumstancesTransferChoice,
                               giftedStudent, specialEdProgramEndingDate,
                               qualifiedFor504, enrl.studentId, restrictionId,
                              (select abbreviatedname from gradecourse where id=currentGradeLevel) as currentGradeLevelCode,
                               (select abbreviatedname from gradecourse where id=currentGradeLevel) as currentGrade,
                               attendanceSchool.schoolname,
                               attendanceSchool.districtname,
                               attendanceSchool.statename,
                               st.legallastname,
                               st.legalfirstname,
                               st.legalmiddlename,
                               cfela.categorydescription as finalela,
                			   cfmath.categorydescription as finalmath
                             FROM enrollment enrl
                             JOIN student st ON (enrl.Studentid = st.id)
                             JOIN organizationtreedetail attendanceSchool ON (attendanceSchool.schoolid = enrl.attendanceschoolid)
                             LEFT JOIN category cfela ON st.finalelabandid = cfela.id
            				 LEFT JOIN category cfmath ON st.finalmathbandid = cfmath.id
                             WHERE st.id = %s
                             AND enrl.currentschoolyear = %s
                             AND enrl.activeFlag = TRUE;
                               """
                               %(student, options.year))
            for x in record:
                #student = studentIds[studentId]
                ##logging.debug("Student id is %s", student)
                #ap = 3
                enrollment_count = 0
                for enrollment in cursor_enrollment:
                    #logging.debug("Inside enrollment - student id is %s", student)
                    enrollment_count += 1
                    #logging.debug("Number of enrollment records =%s", enrollment_count)
                    row = [None] * len(columnHeaders)
                    #logging.debug("length of row is %s", len(row))
                    enrollments.append(enrollment)
                    #schoolId = enrollment['aypSchoolIdentifier']
                    studentidNum = enrollment['studentid']
                    stateName = enrollment['statename']
                    districtName = enrollment['districtname']
                    schoolName = enrollment['schoolname']
                    legallastname = enrollment['legallastname']
                    legalfirstname = enrollment['legalfirstname']
                    legalmiddlename = enrollment['legalmiddlename']
                    currentGrade = enrollment['currentgrade']
                    statestudentidentifier = enrollment['statestudentidentifier']
                    localStudentIdentifier = enrollment['localstudentidentifier']
                    finalELA = enrollment['finalela']
                    finalMath = enrollment['finalmath']

                    index = -1
                    increment = 1
                    row.insert(index+increment,  stateName) #0
                    index += 1
                    row.insert(index+increment, districtName)#1
                    index += 1
                    row.insert(index+increment, schoolName) #2
                    index += 1
                    row.insert(index+increment, legallastname) #3
                    index += 1
                    row.insert(index+increment, legalfirstname) #4
                    index += 1
                    row.insert(index+increment, legalmiddlename) #5
                    index += 1
                    row.insert(index+increment, currentGrade) #6
                    index += 1
                    row.insert(index+increment, studentidNum) #7
                    index += 1
                    row.insert(index+increment, statestudentidentifier) #8
                    index += 1
                    row.insert(index+increment, localStudentIdentifier) #9
                    index += 1
                    row.insert(index+increment, finalELA)
                    index += 1
                    row.insert(index+increment, finalMath)
                    index += 1

                    if(options.assessment == '3'):
                        row.insert(index+increment, "TRUE")
                    else:
                        row.insert(index+increment, "FALSE")

                    for k,v in pnpColumnCodes.items():
                        attributeContainerName = k
                        ##logging.debug("attributeContainerName is %s",attributeContainerName)
                        attributeNames = v
                        ##logging.debug("attributeNames is %s", attributeNames)
                        selected = False
                        isParent = not (attributeContainerName in independentSelectionContainers)
                        if attributeContainerName in requiresSpecialOutput:
                            ##logging.debug("Paramters passed to processSpecialOutput are : attributeContainerName = '{0}', attributeNames= '{1}'".format(attributeContainerName.lower(), attributeNames))
                            values = processSpecialOutput(attributes, attributeContainerName.lower(), attributeNames)
                            ##logging.debug("values value is %s", values)
                            for x in xrange(0, len(values)):
                                index += 1
                                row[index+increment] = values[x]
                        else:
                            attributenames_length = len(attributeNames)
                            ##logging.debug("attributenames_length is %s", attributenames_length)
                            for x in xrange(0, attributenames_length):
                                ##logging.debug("x value is %s", x)
                                ##logging.debug("Paramters passed to generatePNPColumnValue are : attributeContainerName = '{0}', attributeNames[x]= '{1}'".format(attributeContainerName.lower(), attributeNames[x].lower()))
                                value = generatePNPColumnValue(attributes, attributeContainerName.lower(), attributeNames[x].lower())
                                if (isParent):
                                    if ((x > 0) and (not selected)):
                                        value = "N/A"
                                    elif (x == 0):
                                        selected = value == "Selected"
                                index += 1
                                checkval = index+increment
                                row[index+increment] = value
                                #logging.debug("index+increment value is %s", checkval)
                                #logging.debug("row[index+increment] value is %s", row[index+increment])
                                if attributeNames[x].lower() == "colour":
                                    #logging.debug("Inside color loop")
                                    colorName = "N/A"
                                    if (value != None and value.startswith("#")):
                                        colorName = colors[value]
                                        if not colorName :
                                            colorName = "N/A"
                                    index += 1
                                    row[index+increment] = colorName
                    ##logging.debug("row value is %s", row)
                    sqlitecur.execute("""INSERT INTO pnpextract(
                        State ,
                        District ,
                        School ,
                        StudentLastName ,
                        StudentFirstName ,
                        StudentMiddleInitial ,
                        GradeLevel ,
                        StudentID,
                        StudentStateID ,
                        StudentLocalID ,
                        "Final ELA",
                        "Final Math",
                        DLMStudent ,
                        "Display - Magnification" , "Display - Magnification Activate by Default" , "Display - Magnification Setting" ,
                        "Display - Overlay Color" , "Display - Overlay Color Activate by Default" , "Display - Overlay Color Code" ,
                        "Display - Overlay Color Desc" , "Display - Invert Color Choice" , "Display - Invert Color Choice Activate By Default" ,
                        "Display - Masking" , "Display - Masking Activate by Default" , "Display - Masking Setting" ,
                        "Display - Contrast Color" , "Display - Contrast Color Activate by Default" , "Display - Contrast Color Background" ,
                        "Display - Contrast Color Background Desc" , "Display - Contrast Color Foreground" , "Display - Contrast Color Foreground Desc" ,
                        "Language - Item Translation Display" , "Language - Item Translation Display Activate by Default" ,
                        "Language - Item Translation Display Setting" , "Language - Signing Type" , "Language - Signing Type Activate by Default" ,
                        "Language - Signing Type Setting" , "Language - Braille" , "Language - Braille Activate by Default" , "Language - Braille Usage" ,
                        "Language - Keyword Translation Display" , "Language - Keyword Translation Display Activate by Default" ,
                        "Language - Keyword Translation Display Setting" , "Language - Tactile" , "Language - Tactile Activate by Default" ,
                        "Language - Tactile Setting" ,
                        "Auditory - Auditory Background" , "Auditory - Auditory Background Activate by Default" , "Auditory - Auditory Background Breaks" ,
                        "Auditory - Auditory Background Additional Testing Time" , "Auditory - Auditory Background Additional Testing Time Activate by Default" ,
                        "Auditory-Auditory Background Additional Testing Time Multiplier setting" ,
                        "Auditory - Spoken Audio" , "Auditory - Spoken Audio Activate by Default" , "Auditory - Spoken Audio Voice Source Setting" ,
                        "Auditory - Spoken Audio Voice Read at Start" , "Auditory - Spoken Audio Spoken Preference Setting" , "Auditory - Audio Directions Only" ,
                        "Auditory - Spoken Audio Subject Setting" ,
                        "Auditory - Switches" , "Auditory - Switches Activate by Default" ,
                        "Auditory - Switches Scan Speed Seconds" ,
                        "Auditory - Switches Scan Initial Delay Setting Seconds" , "Auditory - Switches Automatic Scan Repeat Frequency" ,
                        "Other Supports - Separate, quiet, or individual setting" ,
                        "Other Supports - Presentation Student reads assessment aloud to self" ,
                        "Other Supports - Presentation Student Used Translation dictionary" ,
                        "Other Supports - Presentation Other Accommodation Used" ,
                        "Other Supports - Response - Student dictated answers to scribe" , "Other Supports - Response - Student used a communication device" ,
                        "Other Supports - Response - Student signed responses" ,
                        "Other Supports - Provided by Alternate Form - Visual Impairment" , "Other Supports - Provided by Alternate Form - Large Print" ,
                        "Other Supports - Provided by Alternate Form - Paper and Pencil" ,
                        "Other Supports - Requiring Additional Tools Two Switch System" ,
                        "Other Supports - Requiring Additional Tools Administration via iPad" ,
                        "Other Supports - Requiring Additional Tools Adaptive equipment" ,
                        "Other Supports - Requiring Additional Tools Individualized manipulatives" ,
                        "Other Supports - Requiring Additional Tools Calculator" ,
                        "Other Supports - Provided outside system - Human read aloud" , "Other Supports - Provided outside system - Sign Intrepretation" ,
                        "Other Supports - Provided outside system - Translation" , "Other Supports - Provided outside system - Test admin enters responses for student" ,
                        "Other Supports - Provided outside system - Partner assisted scanning" ,
                        "Other Supports - Provided outside system - Student provided non-embedded accommodations as noted in IEP"
                                    ) values (?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,
                                              ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,
                                              ?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,?,
                                              ?,?,?,?,?,?,?,?,?,?,?,?,?)""",
                                              ( row[0],
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
                                                row[18],
                                                row[19],
                                                row[20],
                                                row[21],
                                                row[22],
                                                row[23],
                                                row[24],
                                                row[25],
                                                row[26],
                                                row[27],
                                                row[28],
                                                row[29],
                                                row[30],
                                                row[31],
                                                row[32],
                                                row[33],
                                                row[34],
                                                row[35],
                                                row[36],
                                                row[37],
                                                row[38],
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
                                                row[53],
                                                row[54],
                                                row[55],
                                                row[56],
                                                row[57],
                                                row[58],
                                                row[59],
                                                row[60],
                                                row[61],
                                                row[62],
                                                row[63],
                                                row[64],
                                                row[65],
                                                row[66],
                                                row[67],
                                                row[68],
                                                row[69],
                                                row[70],
                                                row[71],
                                                row[72],
                                                row[73],
                                                row[74],
                                                row[75],
                                                row[76],
                                                row[77],
                                                row[78],
                                                row[79],
                                                row[80],
                                                row[81],
                                                row[82],
                                                row[83],
                                                row[84]
                                                ))


                    #lines.append(row)
            #finalrow.insert(student_list,row)
            #student_list += 1
            ##logging.debug("Final row is  %s", finalrow)
            cursor_enrollment.close()
            sqliteconn.commit()
            #lines.insert(0,columnHeaders)


def getstudentpnpjson(assessmentprogramid,studentid):
    attributes_pnpjson =[]
    cursor_pnpjson= db.cursor()
    #logging.debug("Fetching studentpnpjson for student : %s", studentid)
    cursor_pnpjson.execute("""
                          /*NO LOAD BALANCE*/
                      SELECT
                         spj.jsontext
                      FROM studentpnpjson spj
                      JOIN studentassessmentprogram sap ON (spj.studentid = sap.studentid)
                      WHERE sap.assessmentprogramid = %s AND spj.studentid = %s
                      """
                      %(assessmentprogramid,studentid))
    #logging.debug("Fetching studentpnpjson completed for student %s", studentid)
    #logging.debug("Before Entering for loop to add studentpnpjson to records and attributes lists")
    for row1 in cursor_pnpjson:
        #logging.debug("Before appending studentpnpjson to records list")
        #records.append(row1)
        #logging.debug("After appending studentpnpjson to records list")
                ##logging.debug("records list is %s",records)
        student_pnp_json = json.loads(row1[0])
        student_pnp_json_length = len(student_pnp_json)
        for x in xrange(0, student_pnp_json_length):
                    #attributes.insert(x-1,student_pnp_json[x-1]["attrName"])
            #records.insert(x,student_pnp_json[x])
            attributes_pnpjson.insert(x,student_pnp_json[x])
            ##logging.debug("Attributes list is %s", attributes_pnpjson[x])
    cursor_pnpjson.close()
    return attributes_pnpjson

def processSpecialOutput(attributes,attributeContainerName, attributeNames):
    #logging.debug("Inside processSpecialOutput function")
    ret = [None]*len(attributeNames)
    #logging.debug("ret value from processSpecialOutput is %s", ret)
    ##logging.debug("attributes value from processSpecialOutput is %s", attributes)
    #logging.debug("attributeContainerName value from processSpecialOutput is %s", attributeContainerName)
    #logging.debug("attributeNames value from processSpecialOutput is %s", attributeNames)
    #dto = getPNPContainerValue(dtos,attributeContainerName)
    dto = getPNPContainerValue(attributes,attributeContainerName)
    #logging.debug("dto value inside processSpecialOutput is %s", dto)
    if dto == None:
        for x in xrange(0, len(ret)):
            ret.insert(x,"N/A")
        return ret

    index  = -1
    increment = 1
    if attributeContainerName == "presentation":
        for x in xrange(0, len(attributeNames)):
            viewOption = None
            selectedValue = None
            filteredcontainers = _.where(attributes,{"attrContainer":attributeContainerName,"attrName":attributeNames[x]})
            #logging.debug("filteredcontainers value is %s", filteredcontainers)
            if len(filteredcontainers) == 0:
                ret[index+increment] = "N/A"
            else:
                viewOption = getviewoption(attributeContainerName, attributeNames[x])
                selectedValue = filteredcontainers[0]['attrValue']
                #logging.debug("viewoption inside elseif block of processSpecialOutput function is %s", viewOption)
                #logging.debug("selectedvalue inside elseif block of processSpecialOutput function is %s", selectedValue)
                value = None
                accommodationName = None
                if attributeNames[x] == "readsassessmentoutloud":
                    accommodationName = "assessment"
                elif attributeNames[x] == "usetranslationsdictionary":
                    accommodationName = "translations"
                elif attributeNames[x] == "someotheraccommodation":
                    accommodationName = "accommodation"
                #value = "Selected" if selectedValue == accommodationName else "Not Selected"

                if selectedValue == accommodationName:
                    value = "Selected"
                else:
                    value = "Not Selected"

                if (value == "Not Selected" or value == ""):
                    if ((viewOption != None ) and ( "hide_"+accommodationName in viewOption)):
                        #logging.debug("inside 1")
                        value = "N/A"
                ret[index+increment] = value
            index += 1
    elif attributeContainerName == "response":
        for x in xrange(0, len(attributeNames)):
            viewOption = None
            selectedValue = None
            filteredcontainers = _.where(attributes,{"attrContainer":attributeContainerName,"attrName":attributeNames[x]})
            #logging.debug("filteredcontainers value is %s", filteredcontainers)
            if len(filteredcontainers) == 0:
                 ret[index+increment] = "N/A"
            else:
                viewOption = getviewoption(attributeContainerName, attributeNames[x])
                selectedValue = filteredcontainers[0]['attrValue']
                #logging.debug("viewoption inside elseif block of processSpecialOutput function is %s", viewOption)
                #logging.debug("selectedvalue inside elseif block of processSpecialOutput function is %s", selectedValue)
                value = None
                accommodationName = None

                if attributeNames[x] == "dictated":
                    accommodationName = "dictated"
                elif attributeNames[x] == "usedcommunicationdevice":
                    accommodationName = "communication"
                elif attributeNames[x] == "signedresponses":
                    accommodationName = "responses"

                if selectedValue == accommodationName:
                    value = "Selected"
                else:
                    value = "Not Selected"
                #value = "Selected" if selectedValue == accommodationName else "Not Selected"
                #logging.debug("value inside elseif block of processSpecialOutput function is %s", value)
                if (value == "Not Selected" or value == ""):
                    if ((viewOption != None )and ("hide_"+accommodationName in viewOption)):
                        value = "N/A"
                        #logging.debug("inside 2")
                ret[index+increment] = value
            index += 1
    #logging.debug("Return value from processSpecialOutput is %s", ret)
    return ret




def getPNPContainerValue(attributes, attributeContainerName):
    for x in xrange(0, len(attributes)):
        attrcontainer = attributes[x]['attrContainer']
        if attrcontainer == attributeContainerName:
            return attributes[x]
            #logging.debug("attributes[x] value from getPNPContainerValue is %s", attributes[x])
    #logging.debug("Could not find attribute container %s",attributeContainerName)
    return None

def generatePNPColumnValue(attributes, attributeContainerName, attributeName):
    attr_length = len(attributes)
    #logging.debug("attr_length is %s ", attr_length)
    for x in xrange(0, attr_length):
        attrcontainer = attributes[x]['attrContainer']
        #logging.debug("attrcontainer value is %s", attrcontainer)
        attrName = attributes[x]['attrName']
        #logging.debug("attrName value is %s", attrName)
        if ((attrcontainer == attributeContainerName) and (attrName == attributeName)):
            selectedValue = attributes[x]['attrValue']
            #logging.debug("selectedvalue is %s", selectedValue)
            viewOption = getviewoption(attributeContainerName, attributeName)
            #logging.debug("viewoption is %s", viewOption)
            value = selectedValue
            if selectedValue == "true":
                value = "Selected"
            elif ((selectedValue == '') or (selectedValue == "false") or (len(selectedValue) == 0)):
                value = "Not Selected"

            if ((viewOption != None) and (value == "Not Selected")):
                if viewOption == "disable_":
                    pass
                elif (viewOption == "disable") or  (viewOption == "hide"):
                    value = "N/A"

            #logging.debug("Return value from generatePNPColumnValue is %s", value)
            return value
            break
    return "N/A"
    ##logging.debug("Could not find attribute {} in attribute container {} -- returning N/A",(attributeName,attributeContainerName))


def getviewoption(attributeContainerName, attributeName):
    cursor_viewoption2 = db.cursor()
    ##logging.debug("Get Viewoption for given student")
    cursor_viewoption2.execute("""
                  /*NO LOAD BALANCE*/
                  SELECT pianacvo.viewoption as "viewOption"
                  FROM profileitemattribute pia
                  JOIN profileItemAttributenameAttributeContainer pianc ON pia.id = pianc.attributenameid
                  JOIN profileitemattributecontainer piac ON pianc.attributecontainerid = piac.id
                  LEFT OUTER JOIN profileitemattrnameattrcontainerviewoptions pianacvo ON pianacvo.pianacid = pianc.id
                  AND pianacvo.assessmentprogramid = 3
                  WHERE lower(piac.attributecontainer) = '%s'
                  AND lower(pia.attributename) = '%s'
                  """
                  %(attributeContainerName, attributeName))
    ##logging.debug("viewoption value fetch completed")
    rowcount = cursor_viewoption2.rowcount;
    if rowcount == 0:
        return None
    else:
        for row in cursor_viewoption2:
            viewoption = row[0]
            return viewoption
    cursor_viewoption2.close()

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
                  default='2018')
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

    global db
    global adb
    global tdedb
    #global tdecursor
    global aartcursor
    global LOG_FILENAME

    LOG_FILENAME = 'extract_sqlite.log'
    logging.basicConfig(filename=LOG_FILENAME, level=logging.DEBUG)

    (options, args) = parser.parse_args()

    #config = SafeConfigParser()

    #candidates=['extract_sqlite.ini', os.path.expanduser('~/extract_sqlite.ini')]
    #config.read(candidates)

    #epdatabase_name = config.get('EPDatabaseSection', 'epdatabase.dbname')
    #epdatabase_user = config.get('EPDatabaseSection', 'epdatabase.user')
    #epdatabase_password = config.get('EPDatabaseSection', 'epdatabase.password')
    #epdatabase_host = config.get('EPDatabaseSection', 'epdatabase.host')

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

    if "pnpextract" in options.tables or "all" in options.tables:
        pnpextract(options,db,sqliteconn)

    #analyze_db(sqliteconn)

    sqliteconn.close()
    db.close()


if __name__ == '__main__':
    main()

#to generate csv file from sqlite database use this command -- sqlite3 -header -csv pnp.sqlite "select * from pnpextract;" > pnp_extract_stage.csv
