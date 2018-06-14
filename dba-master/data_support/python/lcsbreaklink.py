#!/usr/bin/python
#Author : Rohit Yadav

import psycopg2
import glob
import os
from optparse import OptionParser
from ConfigParser import SafeConfigParser

def studentstests_info(db, studentstestsid):
    """
    Display lcsstudentstests information
    """
    cursor = db.cursor()
    cursor.execute("""SELECT studentstestsid,lcsid FROM lcsstudentstests WHERE studentstestsid ='%s'""" % (studentstestsid))
    print "%s\t\t%s" % ('studentstestsid', 'lcsid')
    active = 1
    for row in cursor.fetchall():
        active = row[0]
        print "%s\t\t\t%s" % (row[0], row[1])
    return active

def delete_studentstestsid(db, studentstestsid,update):
    """
    update lcsstudentstests for a given studentstestsid
    """

    if update == 'Yes' or update == 'yes' or update == 'y':

        cursor = db.cursor()

        cursor.execute("update lcsstudentstests set activeflag=false,modifieddate=now(),modifieduser=12 where activeflag=true and studentstestsid = {0}".format(studentstestsid))

        print ("lcsstudentstests deleted for given studentstestsid")

        db.commit()

def lcsid_info(db, lcsid):
    """
    Display lcsstudentstests information
    """

    cursor = db.cursor()

    #cursor.execute("""SELECT lcsid,studentstestsid FROM lcsstudentstests WHERE lcsid = CAST({0} AS text)
                    #""".format(lcsid))

    cursor.execute("""SELECT lcsid,studentstestsid FROM lcsstudentstests WHERE lcsid = '%s'
                    """ %(lcsid))

    print "%s\t\t%s" % ('studentstestsid', 'lcsid')

    active = 1

    for row in cursor.fetchall():
        active = row[0]
        print "%s\t\t\t%s" % (row[0], row[1])

    return active

def delete_lcsid(db, lcsid, update):
    """
    update lcsstudentstests for a given lcsid
    """

    if update == 'Yes' or update == 'yes' or update == 'y':

        cursor = db.cursor()

        cursor.execute("update lcsstudentstests set activeflag=false,modifieddate=now(),modifieduser=12 where activeflag=true and lcsid = '%s'"%(lcsid))

        print ("lcsstudentstests deleted for given lcsid")

        db.commit()

def main():
    usage = "usage: %prog [options]"
    parser = OptionParser(usage=usage)

    parser.add_option("-v", "--verbose",
                    action="store_true", dest="verbose", default=True,
                    help="make lots of noise [default]")

    (options, args) = parser.parse_args()

    config = SafeConfigParser()

    candidates=['helpdesk_util.ini', os.path.expanduser('~/helpdesk_util.ini'), '/etc/helpdesk/helpdesk_util.ini']
    config.read(candidates)

    tdedatabase_name = config.get('TDEDatabaseSection', 'tdedatabase.dbname')
    tdedatabase_user = config.get('TDEDatabaseSection', 'tdedatabase.user')
    tdedatabase_password = config.get('TDEDatabaseSection', 'tdedatabase.password')
    tdedatabase_host = config.get('TDEDatabaseSection', 'tdedatabase.host')

    try:
        db = psycopg2.connect(database =tdedatabase_name,user=tdedatabase_user,password=tdedatabase_password,host=tdedatabase_host)
    except:
        print("Unable to connect to database")
        raise

    db.autocommit = True

    inputitem = raw_input('Enter 1 if you have studentstestsid or 2 if you have lcsid :')

    if (inputitem == '1'):
        studentstestsid = raw_input('Enter studentstestsid (or exit):')
        while (studentstestsid):

            if studentstestsid == 'exit' or studentstestsid == 'Exit' or studentstestsid == '':
                exit()

            studentstestsstatus = studentstests_info(db, studentstestsid)

            if studentstestsstatus != 1:
                delete_studentstestsid_val = raw_input('Delete lcsstudentstests(Yes/No): ')
                delete_studentstestsid(db,studentstestsstatus,delete_studentstestsid_val)
                studentstestsstatus = studentstests_info(db, studentstestsid)
            else:
                print "studentstestsid not found."

            studentstestsid = raw_input('Enter studentstestsid (or exit): ')

    elif (inputitem == '2'):
        lcsid = raw_input('Enter lcsid (or exit):')
        while (lcsid):

            if lcsid == 'exit' or lcsid == 'Exit' or lcsid == '':
                exit()

            lcsidstatus = lcsid_info(db, lcsid)

            if lcsidstatus != 1:
                deletelcsid = raw_input('Delete lcsstudentstests(Yes/No): ')
                delete_lcsid(db,lcsidstatus,deletelcsid)
                lcsidstatus =lcsid_info(db, lcsid)
            else:
                print "lcsid not found."

            lcsid = raw_input('Enter lcsid (or exit):')

    else:
        print "select correct choice."

if __name__ == "__main__":
    main()
