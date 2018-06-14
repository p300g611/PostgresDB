#!/bin/bash
psql -h aartdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aart_reader -f "/srv/extracts/helpdesk/rally_requests/DLM_SQLITE/fcs_tiny_data_aart.sql" -d aartprod
cp /srv/extracts/pnpdata/pnp_ReadOnlyFolder/fcs_tiny_data.csv /srv/extracts/pnpdata/pnp_ReadOnlyFolder/fcs_tiny_data_old.csv
psql -h aartdwdb-prod.c4d5gwuuaeq5.us-east-1.rds.amazonaws.com -U aartdw_reader -f "/srv/extracts/helpdesk/rally_requests/DLM_SQLITE/fcs_tiny_data_aartdw.sql" -d aartdw

aws s3 sync /srv/extracts/pnpdata/pnp_ReadOnlyFolder s3://kite-sqlite-extracts/csv/pnp_ReadOnlyFolder >/dev/null