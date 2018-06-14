#!/bin/bash

. /srv/aai_logs/scripts/var.sh

sh ${SCRIPTS}get_all_rds_logs.sh >|${SCRIPT_LOGS}get_all_rds_logs.log 2>&1
sh ${SCRIPTS}run_pgbadger.sh     >|${SCRIPT_LOGS}run_pgbadger.log     2>&1


