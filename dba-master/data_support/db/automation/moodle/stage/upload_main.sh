todaydate=$(date +%Y%m%d%H%M%S)
{
 echo "=======================new process started:$todaydate===================="

 echo "file download from moodle"
 sh /srv/extracts/helpdesk/moodle/scripts/stage/upload_sftp.sh

 echo "upload to EP starting"
 sh /srv/extracts/helpdesk/moodle/scripts/stage/upload_ep.sh 

 echo "upload to moodle starting"
 #sh /srv/extracts/helpdesk/moodle/scripts/stage/upload_moodle.sh 

 echo "process done"
 echo "=======================new process ended:$todaydate======================="
}>>/srv/extracts/helpdesk/moodle/scripts/stage/upload_log.txt

##crontab
## */15 * * * * /srv/extracts/helpdesk/moodle/scripts/stage/upload_main.sh &>>/srv/extracts/helpdesk/moodle/scripts/stage/upload_log.txt

