--step1: roles setup login setup on prod transaction
CREATE ROLE barman LOGIN SUPERUSER INHERIT NOCREATEDB NOCREATEROLE NOREPLICATION;
alter user barman with password '#######';

CREATE ROLE streaming_barman LOGIN SUPERUSER INHERIT CREATEDB CREATEROLE REPLICATION;
alter user streaming_barman with password '#####';

--Set up .pgpass on barman server under barman user 
--chmod 600 .pgpss

--step2:server configuration
/srv/pg_data/postgres/data  -- in source server

# 1. barman streaming replication on pg_hba
host    replication     streaming_barman 10.101.35.154/32        md5
{
          "comment": "barman streaming replication",
          "type": "host",
          "db": "replication",
          "user": "streaming_barman",
          "addr": "129.237.37.80/32",
          "method": "md5"
        },

# 2. wal replica set They are included in a chef role called "barman_client" (required postgres restart)
wal_level = 'replica'
 "wal_level": "replica",
        "max_wal_senders": 2,
        "max_replication_slots": 2,
        "archive_mode": "off"

--step3 test process

ssh -A aaiprddaisbarman.cc.ku.edu  ##Login from putty daiseyutil.klwc-prod.cete.us

scp /home/p300g611/daiseydb2-prod.conf  p300g611@aaiprddaisbarman.cc.ku.edu:/home/p300g611/
sudo -i
 cp /home/p300g611/daiseydb2-prod.conf /etc/barman.d/
 
 chown barman:barman /etc/barman.d/daiseydb2-prod.conf
 
 barman diagnose
 barman check daiseyprod2
 barman status daiseyprod2
 barman backup daiseyprod2


barman backup daiseyprod2

final setting 
which pg_receivexlog

vi .bash_profile 
export PATH=/usr/pgsql-9.6/bin:$PATH

.ssh key need to set up (should not ask password for  barman@aaiprddaisbarman.cc.ku.edu ~/.ssh $ ssh postgres@aaiprddaisbarman.cc.ku.edu)


##Reference 
http://docs.pgbarman.org/release/2.3/


error 
1) ArchiverFailure:pg_receivexlog not present in $PATH
 
resolve 
barman receive-wal --create-slot daiseyprod2
barman receive-wal daiseyprod2
2) WAL archive: FAILED (please make sure WAL shipping is setup

resolve
    barman cron 
    barman switch-xlog --force --archive daiseyprod2
3) barman.server ERROR: Check 'pg_receivexlog' failed for server 'daiseyprod2'
   barman.server ERROR: Check 'pg_receivexlog compatible' failed for server 'daiseyprod2'
   barman.server ERROR: Impossible to start the backup. Check the log for more details, or run 'barman check daiseyprod2'  
   resolve 
   PATH missing for pg_receivexlog
   
   path_prefix = "/usr/pgsql-9.6/bin"  -- uncomment the line in config table.
   



