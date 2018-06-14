#!/bin/bash
DEST="/srv/cifs/ATS_SFD/SQLite_Weekly_Archives"
FILES=( "kap" "cpass" "kelpa" "dlm.pm")
SERVER="jumper1.prodku.cete.us"
REMOTE_DEST_PATH="/srv/extracts/data"
SSHKEY='/srv/extracts/aai_backup_sa.private'
USER='aai_backup_sa'
SSHOPTS='-o LogLevel=Error'
VAR_DATE=$(date +%Y%m%d)
ARCHIVE="/srv/extracts/data/archive/weekly"

for i in "${FILES[@]}"
do
        :
        PROGRAM=$(echo "$i" | tr '[:lower:]' '[:upper:]')
		tar -czvf "${ARCHIVE}"/"${i}"_"${VAR_DATE}".sqlite.tar.gz -P "${REMOTE_DEST_PATH}"/"${i}".sqlite
		#tar -xzvf  ~/extract_stage/data_stage/temp/src/mss_old.sqlite.tar.gz
        #rsync --remove-source-files -az -b --suffix "-old" -e "/usr/bin/ssh -i $SSHKEY $SSHOPTS"  "${USER}@${SERVER}:${ARCHIVE}/${i}_${VAR_DATE}.sqlite.tar.gz" "$DEST/"
        aws s3 cp "${ARCHIVE}"/"${i}"_"${VAR_DATE}".sqlite.tar.gz s3://kite-sqlite-extracts/data_archive/ >/dev/null
done
