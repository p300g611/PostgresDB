#!/bin/bash
sftp -o IdentityFile=~/.ssh/ku-upload.key ku-upload@ku.rms.webanywhere.co.uk <<EOF
  mget /live/outgoing/upload_ep*.csv /srv/extracts/helpdesk/moodle/upload_ep/
  mput /srv/extracts/helpdesk/moodle/upload_ep/upload_ep*.csv /live/outgoing/processed/
  rm   /live/outgoing/upload_ep*.csv
  bye
EOF

