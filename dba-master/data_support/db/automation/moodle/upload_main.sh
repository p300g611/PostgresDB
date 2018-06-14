todaydate=$(date +%Y%m%d%H%M%S)
{
 echo "=======================new process started:$todaydate===================="

 echo "file download from moodle"
 sh /srv/extracts/helpdesk/moodle/scripts/upload_sftp.sh

 echo "upload to EP starting"
 sh /srv/extracts/helpdesk/moodle/scripts/upload_ep.sh 

 echo "upload to moodle starting"
 sh /srv/extracts/helpdesk/moodle/scripts/upload_moodle.sh 

 echo "process done"
 todaydate=$(date +%Y%m%d%H%M%S)
 echo "=======================new process ended:$todaydate======================="
}>>/srv/extracts/helpdesk/moodle/scripts/upload_log.txt

##crontab
##24 6-12/2,18-23/2 * * * /srv/extracts/helpdesk/moodle/scripts/upload_main.sh &>>/srv/extracts/helpdesk/moodle/scripts/upload_log.txt


