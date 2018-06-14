--####Barman  recovery testing####stage
-- Create table barman for testing
drop table if exists public.barman;
create table public.barman( id bigserial,modified_date timestamp without time zone NOT NULL);

insert into public.barman (modified_date) select now();

select * from public.barman;
select * from kehs.tableau_batch_request ;

--Set up crontab to insert every minute
login to puty -- daiseyutil.klwc-prod.cete.us

crontab -l

crontab -e

* * * * * psql -h daiseydb2.fix.cete.us -c "insert into public.barman (modified_date) select now();" -U kehs kehs 

--####Barman  recovery process####
1.Taking base backup
   login to puty --daiseybarman.klwc-prod.cete.us
   sudo -u barman -i 
   barman@daiseybarman.klwc-prod ~ $ barman backup daiseyfix2
 
2. verify the new base 
 /var/lib/barman/daiseyfix2/base/
 
3.find the log files 
 /var/lib/barman/daiseyfix2/wals
 
4. partial file location

barman@daiseybarman.klwc-prod ~/daiseyfix2/streaming $ ll
total 16384
-rw------- 1 barman barman 16777216 Oct 17 11:35 000000010000000E0000001E.partial 


5. recovey type-1

p300g611@daiseybarman.klwc-prod ~ $ sudo service postgresql-9.6 stop

p300g611@daiseybarman.klwc-prod ~ $ sudo -u barman -i 
##barman recover --remote-ssh-command "ssh postgres@daiseybarman.klwc-prod.cete.us" --target-time 20171201T122421 daiseyfix2 20171201T122421 /srv/pg_data/postgres/data

barman show-backup daiseyfix2 latest
Begin time           : 2017-12-01 20:15:31+00:00

barman recover --remote-ssh-command "ssh postgres@daiseybarman.klwc-prod.cete.us" --target-time "2017-12-01 20:15:31+00:00" daiseyfix2 20171201T141530 /srv/pg_data/postgres/data
barman recover --remote-ssh-command "ssh postgres@daiseybarman.klwc-prod.cete.us" --target-time "2017-12-01 20:32:41+00:00" daiseyfix2 20171201T141530 /srv/pg_data/postgres/data

 
postgres@daiseybarman.klwc-prod ~ $ pwd
/var/lib/pgsql
postgres@daiseybarman.klwc-prod ~ $ cd 9.6/data/
postgres@daiseybarman.klwc-prod ~/9.6/data $ ll


after recovery if you found diff in both dir 

barman@daiseybarman.klwc-prod /srv/barman_data/barman/daiseyfix2/streaming $ ll
total 16384
-rw------- 1 barman barman 16777216 Oct 17 11:46 000000010000000E0000001E.partial


postgres@daiseybarman.klwc-prod ~/9.6/data/barman_xlog $ ll
total 16384
-rw------- 1 postgres postgres 16777216 Oct 17 11:18 000000010000000E0000001D

barman@daiseybarman.klwc-prod ~ $ scp /srv/barman_data/barman/daiseyfix2/streaming/000000010000000E00000022.partial   postgres@daiseybarman.klwc-prod.cete.us:/srv/pg_data/postgres/data/barman_xlog/000000010000000E00000022


scp /srv/barman_data/barman/daiseyfix2/streaming/000000010000000E00000047.partial   postgres@daiseybarman.klwc-prod.cete.us:/srv/pg_data/postgres/data/barman_xlog/000000010000000E00000047

postgres@daiseybarman.klwc-prod ~/9.6/data/barman_xlog $ ll
total 32768
-rw------- 1 postgres postgres 16777216 Oct 17 11:18 000000010000000E0000001D
-rw------- 1 postgres postgres 16777216 Oct 17 11:56 000000010000000E0000001E


6. re-start postgres 

sudo service postgresql-9.6 start


after recovery we should see done fine and revode the barmab xlog files 

https://www.digitalocean.com/community/tutorials/how-to-back-up-restore-and-migrate-postgresql-databases-with-barman-on-centos-7

-rw-rw-r-- 1 postgres postgres  126 Oct 17 11:47 recovery.done
postgres@daiseybarman.klwc-prod ~/9.6/data $


--errors
1. Unable to re-start the postgres server 
   i)  log file correpted  -- delete the log file 
   ii) journalctl -xe" for details.  -- renamed the /srv/pg_data/postgres/data/recovery.config
        (removed the one base backup which is most recent one and run the above line)
   
   https://serverfault.com/questions/867100/barman-postgresql-not-start-after-barman-retore

