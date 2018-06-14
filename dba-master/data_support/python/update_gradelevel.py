#!/usr/bin/python
#author:Sam Hopper
import psycopg2
import psycopg2.extras
import decimal
import os
import sys
import time
import ConfigParser
from operator import itemgetter
from datetime import datetime
import glob
from optparse import OptionParser
from ConfigParser import SafeConfigParser


def update_rows(db):
    """
    Return the number of rows that will be updated.
    """

    print
    user_state_displayidentifier = raw_input("Enter the state display identifier: ")
    user_statestudentidentifier = raw_input("Enter the state student identifier: ")
    user_attendanceschool = raw_input("Enter the attendance school display identifier: ")
    user_aypschool = raw_input("Enter the ayp school display identifier: ")
    user_old_gradelevel = raw_input("Enter the current gradelevel: ")
    user_new_gradelevel = raw_input("Enter the new gradelevel: ")
    user_schoolyear = raw_input("Enter the school year: ")

    cursor1 = db.cursor()

    cursor1.execute("""/*NO LOAD BALANCE*/
              SELECT e.id AS enrollmentid
                           ,s.id AS studentid
                           ,s.legallastname
                           ,s.legalfirstname
                           ,e.attendanceschoolid
                           ,o.organizationname
                           ,e.currentschoolyear
                           ,e.currentgradelevel
                           ,(SELECT abbreviatedname
                             FROM gradecourse gc
                             WHERE contentareaid IS NULL
                             AND assessmentprogramgradesid IS NOT NULL
			     AND id = e.currentgradelevel) old_grade_id
                           ,(SELECT id
                             FROM gradecourse gc
                             WHERE contentareaid IS NULL
                             AND assessmentprogramgradesid IS NOT NULL
			     AND abbreviatedname = '%s') AS new_grade_id
              FROM student s
              JOIN enrollment e ON (e.studentid = s.id
                 AND e.attendanceschoolid = (SELECT schoolid
                                             FROM organizationtreedetail
                                             WHERE schooldisplayidentifier = '%s'
                                             AND statedisplayidentifier = '%s')
                 AND e.activeflag is TRUE
                 AND e.currentschoolyear = %s)
              LEFT JOIN organization o ON (e.attendanceschoolid = o.id)
              WHERE s.statestudentidentifier = '%s';
              """ % (user_new_gradelevel, user_attendanceschool, user_state_displayidentifier, user_schoolyear, user_statestudentidentifier))

    cursor1_rows_affected=cursor1.rowcount

    rows=cursor1.fetchall()

    if (cursor1_rows_affected > 0):

       for row in rows:

          print
          print("You are about to update enrollment: " + str(row[0]))
          print
          print("For student: " + str(row[2]) + ", " + str(row[3]))
          print
          print("Changing grade level from: " + str(row[8]) + " to: " + str(user_new_gradelevel))
          print
       print(str(cursor1_rows_affected) + " rows will be updated.")
       print

       user_continue = raw_input("Type Y to continue or Ctrl D to exit: ")
       print

       if (user_continue == 'Y'):

           cursor2 = db.cursor()

           for row in rows:

              try:
                 cursor2.execute('select * from updatestudentgrade(%s,%s,%s,%s,%s,%s,%s)' % ("'"+str(user_statestudentidentifier)+"'", "'"+str(user_state_displayidentifier)+"'", "'"+str(user_attendanceschool)+"'", "'"+str(user_aypschool)+"'", user_schoolyear, "'"+str(user_old_gradelevel)+"'", "'"+str(user_new_gradelevel)+"'"))
                 for notice in db.notices:
                    print notice
                 db.commit()
              except:
	         print("Update Function Failed.  Transaction rolled back.")
	         print cursor2.query
	         db.rollback()
	         # Raise the exception.
                 raise
       else:

          print(user_continue + " is not a valid response.")
          quit()

    else:

       print("Query returned " + str(cursor1_rows_affected) + " rows.  Student not found.")

    return

    cursor1.close()

    cursor2.close()


def main():

    global db
    global aartcursor
    
    config = SafeConfigParser()

    candidates=['helpdesk_util.ini', os.path.expanduser('~/helpdesk_util.ini'), '/etc/helpdesk/helpdesk_util.ini']
    config.read(candidates)

    epdatabase_name = config.get('EPDatabaseSection', 'epdatabase.dbname')
    epdatabase_user = config.get('EPDatabaseSection', 'epdatabase.user')
    epdatabase_password = config.get('EPDatabaseSection', 'epdatabase.password')
    epdatabase_host = config.get('EPDatabaseSection', 'epdatabase.host')

    database_string = "dbname=%s user=%s password=%s host=%s port=%s" % (epdatabase_name,epdatabase_user,epdatabase_password,epdatabase_host,5432)

    try:
       db = psycopg2.connect(database_string)
    except:
       print("Unable to connect to database")
       # Raise the exception.
       raise

    try:
       update_rows(db)
    except:
       print("Unable to perform update. Rollback.")
       db.rollback()
       # Raise the exception.
       raise

    db.close()

if __name__ == '__main__':
    main()
