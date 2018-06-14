#!/usr/bin/python

import psycopg2
import glob
import os
from optparse import OptionParser
from ConfigParser import SafeConfigParser

def user_info(db, email):
    """
    Display user information
    """

    cursor = db.cursor()

    cursor.execute("""
        SELECT a.id, a.activeflag, a.firstname, a.surname,
        o.organizationname
        FROM aartuser a, usersorganizations uo, organization o
        WHERE a.email = '%s'AND uo.aartuserid = a.id AND o.id =
        uo.organizationid

    """ % (email))

    print "%s\t%s\t\t%s" % ('Active', 'Name', 'Organization')

    active = 'bob'

    for row in cursor.fetchall():
        active = row[1]
        print "%s\t%s %s\t\t%s" % (row[1], row[2], row[3], row[4])

    return active

def modify_user(db, email, action, update):
    """

    """

    if update == 'Yes' or update == 'yes' or update == 'y':

        cursor = db.cursor()

        cursor.execute("""
            update aartuser set activeflag = %s where email = %s
        """, (action, email))

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

    epdatabase_name = config.get('EPDatabaseSection', 'epdatabase.dbname')
    epdatabase_user = config.get('EPDatabaseSection', 'epdatabase.user')
    epdatabase_password = config.get('EPDatabaseSection', 'epdatabase.password')
    epdatabase_host = config.get('EPDatabaseSection', 'epdatabase.host')

    db = psycopg2.connect(database = epdatabase_name,user=epdatabase_user,password=epdatabase_password, host=epdatabase_host)

    db.autocommit = True

    email = raw_input('Enter email address (or exit): ')

    while (email):

        if email == 'exit' or email == 'Exit' or email == '':
            exit()

        status = user_info(db, email)

        if status != 'bob':
            if (status):
                update = raw_input('Deactivate User (Yes/No): ')
                modify_user(db, email, 'false', update)
                status = user_info(db, email)
            else:
                update = raw_input('Activate User (Yes/No): ')
                modify_user(db, email, 'true', update)
                status = user_info(db, email)
        else:
            print "Email not found."

        email = raw_input('Enter email address (or exit): ')


if __name__ == "__main__":
    main()
