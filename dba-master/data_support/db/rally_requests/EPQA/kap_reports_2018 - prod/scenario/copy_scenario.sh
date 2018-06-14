
mkdir -p /srv/extracts/helpdesk/rally_requests/EPQA/kap_reports/kap_reports_$(date +%Y%m%d)
cd       /srv/extracts/helpdesk/rally_requests/EPQA/kap_reports/kap_reports_$(date +%Y%m%d)

##Completed
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/ela_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/math_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/sci_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/ss_scenario.sql" -d aartstage

##SC codes
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/sc_code.sql" -d aartstage

##Transfer 
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/ela_transfer_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/math_transfer_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/sci_transfer_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/ss_transfer_scenario.sql" -d aartstage

##Exit 
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/ela_exit_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/math_exit_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/sci_exit_scenario.sql" -d aartstage
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/ss_exit_scenario.sql" -d aartstage

##KELPA 
psql -h aartdb-stage.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/EPQA/scenario/kelpa_scenario.sql" -d aartstage

aws s3 sync /srv/extracts/helpdesk/rally_requests/EPQA/kap_reports/  s3://kite-sqlite-extracts/csv/kap_reports/

#p300g611@daiseyutil.klwc-prod ~ $ ssh backup1.klwc-prod.cete.us
#sudo -i
#/usr/bin/aws --region "us-east-1" s3 sync "s3://kite-sqlite-extracts/csv/kap_reports/" "/srv/cifs/ATS_SFD/EPQA" 
