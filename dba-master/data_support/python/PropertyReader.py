#!/usr/bin/python
# Author : Rohit Yadav

from ConfigParser import SafeConfigParser
import glob
config = SafeConfigParser()

candidates=['helpdesk_util.ini', os.path.expanduser('~/helpdesk_util.ini'), '/etc/helpdesk/helpdesk_util.ini']
config.read(candidates)

epdatabase_name = config.get('EPDatabaseSection', 'epdatabase.dbname')
epdatabase_user = config.get('EPDatabaseSection', 'epdatabase.user')
epdatabase_password = config.get('EPDatabaseSection', 'epdatabase.password')
epdatabase_host = config.get('EPDatabaseSection', 'epdatabase.host')

tdedatabase_name = config.get('TDEDatabaseSection', 'tdedatabase.dbname')
tdedatabase_user = config.get('TDEDatabaseSection', 'tdedatabase.user')
tdedatabase_password = config.get('TDEDatabaseSection', 'tdedatabase.password')
tdedatabase_host = config.get('TDEDatabaseSection', 'tdedatabase.host')
