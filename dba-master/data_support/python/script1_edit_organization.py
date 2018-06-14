#!/usr/bin/python
import psycopg2
import psycopg2.extras
import sys
import ConfigParser
from optparse import OptionParser
import glob
import os
from ConfigParser import SafeConfigParser

def org_info(db,displayidentifier,state,typecode):
    """
    Display user information
    """

    cursor = db.cursor()

    cursor.execute("""
            select     ot.typecode
                       ,o.id
                       ,o.displayidentifier
                       ,o.organizationname
        from  organization o
        inner join organizationtype ot on o.organizationtypeid=ot.id
        where displayidentifier ='%s'
              and upper((select  displayidentifier from organization_parent(o.id) where organizationtypeid=2)) ='%s'
              and ot.typecode ='%s' and ot.activeflag is true
              and o.activeflag is true;
               """ % (displayidentifier,state,typecode))

    print "%s \t|%s \t\t|%s\t|%s" % ('orgtype','orgid','displayidentifier','organizationname')
    i=0
    for row in cursor.fetchall():
        i=i+1
        print "%s \t\t|%s \t\t|%s \t\t|%s" % (row[0],row[1],row[2],row[3])

    return i
def refresh_orgtree(db,update,typecode,organizationname,displayidentifier,displayidentifier_new,state):
    """
    merge Logic
    """

    if (update == 'yes' or update == 'Yes' or update == 'y' or update == 'YES'):

        if typecode=='sch' or typecode=='SCH':
            cursor = db.cursor()

            cursor.execute("""
                    update organizationtreedetail o
                       set  schoolname= case when upper(coalesce('%s','NONE'))!='NONE' then '%s'
                                 else schoolname end
                           ,schooldisplayidentifier=case when upper(coalesce('%s','NONE'))!='NONE' then '%s'
                                 else schooldisplayidentifier end
                           ,createddate=now()
                       where schooldisplayidentifier ='%s'
                            and upper(statedisplayidentifier) ='%s';
                           """ % (organizationname,organizationname,displayidentifier_new,displayidentifier_new,displayidentifier,state))

            db.commit()
            print ("Merge Logic Completed Successfully")
        else:
            cursor = db.cursor()

            cursor.execute("""
                          update organizationtreedetail o
                       set  districtname= case when upper(coalesce('%s','NONE'))!='NONE' then '%s'
                                 else schoolname end
                           ,districtdisplayidentifier=case when upper(coalesce('%s','NONE'))!='NONE' then '%s'
                                 else schooldisplayidentifier end
                           ,createddate=now()
                       where districtdisplayidentifier ='%s'
                            and upper(statedisplayidentifier) ='%s';
                           """ % (organizationname,organizationname,displayidentifier_new,displayidentifier_new,displayidentifier,state))

            db.commit()
            print ("Merge Logic Completed Successfully")
    else:
        print "Script ignored the merge logic"

def modify_org(db,displayidentifier,state,organizationname,displayidentifier_new,update,typecode):
    """
    Update Logic
    """

    if update == 'yes' or update == 'Yes' or update == 'y' or update == 'YES':

        cursor = db.cursor()

        cursor.execute("""
                      update organization o
                       set  organizationname= case when upper(coalesce('%s','NONE'))!='NONE' then '%s'
                                 else organizationname end
                           ,displayidentifier=case when upper(coalesce('%s','NONE'))!='NONE' then '%s'
                                 else displayidentifier end
                           ,modifieddate=now()
                           ,modifieduser=12
                      from organizationtype ot
                      where o.organizationtypeid=ot.id
                      and displayidentifier ='%s'
                      and upper((select  displayidentifier from organization_parent(o.id) where organizationtypeid=2)) ='%s'
                      and ot.typecode ='%s' and ot.activeflag is true
                      and o.activeflag is true;
        """ % (organizationname,organizationname,displayidentifier_new,displayidentifier_new,displayidentifier,state,typecode))

        db.commit()
        print ("Update Completed Successfully")
        if displayidentifier_new.upper()!='NONE':
            i = org_info(db, displayidentifier_new,state,typecode)
        else:
            i = org_info(db, displayidentifier,state,typecode)

    else:
        print "Script Not Updated"
def main():
    try :

        usage = "usage: %prog [options]"
        parser = OptionParser(usage=usage)

        parser.add_option("-v", "--verbose",
                        action="store_true", dest="verbose", default=True,
                        help="make lots of noise [default]")

        config = SafeConfigParser()

        candidates=['helpdesk_util.ini', os.path.expanduser('~/helpdesk_util.ini'), '/etc/helpdesk/helpdesk_util.ini']
        config.read(candidates)

        epdatabase_name = config.get('EPDatabaseSection', 'epdatabase.dbname')
        epdatabase_user = config.get('EPDatabaseSection', 'epdatabase.user')
        epdatabase_password = config.get('EPDatabaseSection', 'epdatabase.password')
        epdatabase_host = config.get('EPDatabaseSection', 'epdatabase.host')
        #parser.add_option("-n", "--database_string",help="Required:host='local' dbname='test' user='postgres' password='secret'")
        #parser.add_option('-s','--state',help='KS')
        #parser.add_option('-d','--displayidentifier',help='1234')
        #parser.add_option('-o','--organizationname',help='schoolname')
        #parser.add_option('-a','--activeflag',help='false/true')
        #parser.add_option('-f','--displayidentifier_new',help='ks_1234')

        (options, args) = parser.parse_args()
        #db = psycopg2.connect(options.database_string)
        db = psycopg2.connect(database = epdatabase_name,user=epdatabase_user,password=epdatabase_password, host=epdatabase_host)
        db.autocommit = True



        #displayidentifier='%s'%(options.displayidentifier)
        #displayidentifier=str(displayidentifier)
        #print ("displayidentifier entered ="),displayidentifier
        #organizationname= '%s'%(options.organizationname)
        #print ("organizationname entered="),organizationname
        #organizationname=organizationname.replace("'", "''")
        #state= '%s'%(options.state)
        #state=state.upper()
        #print ("state entered ="),state
        #activeflag='%s'%(options.activeflag)
        #activeflag=activeflag.lower()
        #print ("activeflag entered ="),activeflag
        #displayidentifier_new='%s'%(options.displayidentifier_new)
        #print ("displayidentifier_new entered ="),displayidentifier_new
        state = raw_input('PLEASE ENTER state (like "KS"): ')
        state=state.upper()
        displayidentifier = raw_input('PLEASE ENTER displayidentifier(like "KS_01234"): ')
        displayidentifier=str(displayidentifier)
        organizationname = raw_input('PLEASE ENTER new organization name (like "new name" to change or "NONE" to dontchange name): ')
        organizationname=organizationname.replace("'", "''")
        displayidentifier_new = raw_input('PLEASE ENTER new displayidentifier name (like "KS_5678" to change or "NONE" to dontchange name): ')
        displayidentifier=str(displayidentifier)
        typecode = raw_input('PLEASE ENTER sch TO SCHOOL (OR dt TO DISTRICT): ')
        typecode=typecode.upper()

        i = org_info(db, displayidentifier,state,typecode)
        i=str(i)

        print ("Number of Row will update = "),i



        update = raw_input('PLEASE ENTER yes TO UPDATE (OR no TO EXIT): ')



        modify_org(db,displayidentifier,state,organizationname,displayidentifier_new,update,typecode)
        refresh_orgtree(db,update,typecode,organizationname,displayidentifier,displayidentifier_new,state)



    except Exception, e:
        print repr(e)
        print ("***ERROR***:Please contact Datasupport Team with error message") , sys.exc_info()[0]

if __name__ == "__main__":
    main()
