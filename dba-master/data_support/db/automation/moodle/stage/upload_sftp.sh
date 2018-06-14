#!/bin/bash
sftp -o IdentityFile=~/.ssh/ku-upload.key ku-upload@ku.rms.webanywhere.co.uk <<EOF
  mget /staging/outgoing/upload_ep*.csv /srv/extracts/helpdesk/moodle/upload_ep/
  mput /srv/extracts/helpdesk/moodle/upload_ep/upload_ep*.csv /staging/outgoing/processed/
  rm   /staging/outgoing/upload_ep*.csv
  bye
EOF

