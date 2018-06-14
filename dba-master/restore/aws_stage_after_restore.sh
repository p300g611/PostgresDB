#!/bin/bash

#Please make sure .pgpass updated below list or provide PGPASSWORD=########
#Turn off stage DW sync before restore ##https://source.cete.us/operations/dba/blob/master/restore/aartdw_turn_off_and_on.txt

#9.6.6 

aws rds modify-db-instance --region us-east-1 --db-instance-identifier cbdb-stage --engine-version 9.6.6 --apply-immediately
aws rds modify-db-instance --region us-east-1 --db-instance-identifier aartdwdb-stage --engine-version 9.6.6 --apply-immediately
aws rds modify-db-instance --region us-east-1 --db-instance-identifier aartauditdb --engine-version 9.6.6 --apply-immediately
aws rds modify-db-instance --region us-east-1 --db-instance-identifier aartdb-stage --engine-version 9.6.6 --apply-immediately


#Globals PGPASSWORD=prodPW
PGPASSWORD=######## psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/ep_global_stage.sql"
PGPASSWORD=######## psql -h aartauditdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/ep_global_stage.sql"
PGPASSWORD=######## psql -h aartdwdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/dw_global_stage.sql"
PGPASSWORD=######## psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/lportal_global_stage.sql"

#Email scrub scripts on aart before rename 
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart -d aartprod -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/sanitize_stageaws.sql"
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart -d aartprod -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/global_admin.sql"

#Turn of pending jobs on audit before rename 
psql -h aartauditdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart -d aartauditprod -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/sanitize_auditaws.sql"

#AARTDW aws_foreign_server_configure.sql
psql -h aartdwdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aartdw -d aartdw -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/foreign_server_aart.sql"


#Rename databases PGPASSWORD=satgePW
#alter database  aartauditprod owner to agilets;
#ALTER DATABASE aartauditprod RENAME TO aartauditstage;
PGPASSWORD=######## psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "ALTER DATABASE aartprod OWNER TO agilets;"
PGPASSWORD=######## psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "ALTER DATABASE aartprod RENAME TO aartstage;"
PGPASSWORD=######## psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "ALTER DATABASE aartstage OWNER TO aart;"

PGPASSWORD=######## psql -h aartauditdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "ALTER DATABASE aartauditprod OWNER TO agilets;"
PGPASSWORD=######## psql -h aartauditdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "ALTER DATABASE aartauditprod RENAME TO aartauditstage;"
PGPASSWORD=######## psql -h aartauditdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U agilets -d postgres -c "ALTER DATABASE aartauditstage OWNER TO aart;"

#Altitude release on EP and CP
#grf script from 130 dml aartdw
#psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart -d aartstage -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/EP/Altitude/update_F680_DEMO.sql"

PGPASSWORD=##########  psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/11-TestDevelopmentProgramFields.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/12-TestletProgramFields.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/13-F695MetadataCPASS.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/14-F695MetadataDLM.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/15-F695MetadataKAP.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/16-F695MetadataKELPA2.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/17-AlterPrecision.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/18-DE17052.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/31-TesdevelopmentFeedbackRulesFN-Create.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/32-MigrationTesdevelopmentFeedbackRulesDML.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/33-TesdevelopmentFeedbackRulesFN-Drop.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/34.sql"
PGPASSWORD=########## psql -h psql -h cbdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U lportal -d lportal -f "/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/Altitude/CB/Altitude/stage_aws/35.sql"

#AARTDW Altitude branch need to deployed and 130.sql run manually and EP GRF scripts need to run if altitude deployed.
#Turn ON stage DW sync after restore ##https://source.cete.us/operations/dba/blob/master/restore/aartdw_turn_off_and_on.txt
#Agilets passwords 
#9.6.5 to 9.6.6

#on DW after cals
update aartdwfulltable set sync_aartdwfulltable  =true where sync_table='studentreport';
update aartdwfulltable set sync_aartdwfulltable  =true where sync_table='reportsubscores';
update aartdwfulltable set sync_aartdwfulltable  =true where sync_table='reporttestlevelsubscores';
update aartdwfulltable set sync_aartdwfulltable  =true where sync_table='rawtoscalescores';
update aartdwfulltable set sync_aartdwfulltable  =true where sync_table='reportspercentbylevel';
update aartdwfulltable set sync_aartdwfulltable  =true where sync_table='organizationreportdetails';




