#!/bin/sh -e

## Set the language to English because I haven't read German since highschool

export LANG="en_US.UTF-8"
export LC_MESSAGES="en_US.UTF-8"
export SYSFONT="latarcyrheb-sun16"

## set english as the default server language

if sudo sed -i 's/LANG="de_DE.UTF-8"/LANG="en_US.UTF-8"/g' /etc/sysconfig/i18n ; then
    echo "server language set to English"
    sudo cat /etc/sysconfig/i18n
else
    echo "Nope, still German"
fi

## update the system applications

sudo yum -y update

## install development tools
 
sudo yum groupinstall -y 'development tools'

## install additional needed packages

sudo yum install -y zlib-dev openssl-devel sqlite-devel bzip2-devel

## install stack

curl -sSL https://s3.amazonaws.com/download.fpcomplete.com/centos/6/fpco.repo | sudo tee /etc/yum.repos.d/fpco.repo

sudo yum -y install stack

stack upgrade

## Edit the following to change the name of the database user that will be created:p

export APP_DB_USER=aart
export APP_DB_PASS=aart

export AUDIT_DB_USER=aart
export AUDIT_DB_PASS=aart

## Edit the following to change the name of the database that is created

export APP_DB_NAME=aartlocal
export AUDIT_DB_NAME=aartaudit

## Edit the following to change the version of PostgreSQL that is installed
export PG_VERSION=9.2

###########################################################
# Changes below this line are probably not necessary
###########################################################
print_db_usage () {
  echo "Your PostgreSQL database has been setup and can be accessed on your local machine on the forwarded port (default: 15432)"
  echo "  Host: localhost"
  echo "  Port: 15432"
  echo "  Database: $APP_DB_NAME"
  echo "  Username: $APP_DB_USER"
  echo "  Password: $APP_DB_PASS"
  echo ""
  echo "Admin access to postgres user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo ""
  echo "psql access to app database user via VM:"
  echo "  vagrant ssh"
  echo "  sudo su - postgres"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost $APP_DB_NAME"
  echo ""
  echo "Env variable for application development:"
  echo "  DATABASE_URL=postgresql://$APP_DB_USER:$APP_DB_PASS@localhost:15432/$APP_DB_NAME"
  echo ""
  echo "Local command to access the database via psql:"
  echo "  PGUSER=$APP_DB_USER PGPASSWORD=$APP_DB_PASS psql -h localhost -p 15432 $APP_DB_NAME"
}

## Log provisionsing

export PROVISIONED_ON=/etc/vm_provision_on_timestamp
if [ -f "$PROVISIONED_ON" ]
then
  echo "VM was already provisioned at: $(cat $PROVISIONED_ON)"
  echo "To run system updates manually login via 'vagrant ssh' and run 'apt-get update && apt-get upgrade'"
  echo ""
  print_db_usage
  exit
fi

## Install the postgresql yum repository

sudo yum -y install http://yum.postgresql.org/9.2/redhat/rhel-6-x86_64/pgdg-centos92-9.2-7.noarch.rpm

## Install and update packages.

sudo yum -y install postgresql92-server postgresql92-contrib

## start the service

service postgresql-9.2 initdb --locale=en_US
chkconfig postgresql-9.2 on 

echo ## set variables for config files

export PG_DIR="/var/lib/pgsql/$PG_VERSION/main"
export PG_CONF="/var/lib/pgsql/$PG_VERSION/data/postgresql.conf"
export PG_HBA="/var/lib/pgsql/$PG_VERSION/data/pg_hba.conf"
export PG_IDENT="/var/lib/pgsql/$PG_VERSION/data/pg_ident.conf"

## Edit postgresql.conf to change listen address to '*':

sed -i "s/#listen_addresses = 'localhost'/listen_addresses = '*'/" "$PG_CONF"
sed -i "s/ident/trust/" "$PG_HBA"
sed -i "s/md5/trust/" "$PG_HBA"

## Append to pg_hba.conf to allow access to the databases:

sed -i "s/peer/trust/" "$PG_HBA"

## Append to pg_ident to allow vagrant to login as aart

sudo echo " localdev       vagrant            aart" >> "$PG_IDENT"

## Explicitly set default client_encoding

echo "client_encoding = utf8" >> "$PG_CONF"

## Restart the service so that all the new config is loaded:

service postgresql-9.2 restart

cat << EOF | su - postgres -c psql

SET lc_messages TO 'en_US.UTF-8';

--Create the database user:
CREATE USER $APP_DB_USER WITH PASSWORD '$APP_DB_PASS';
CREATE USER $AUDIT_DB_USER WITH PASSWORD '$AUDIT_DB_PASS';
ALTER USER $APP_DB_USER WITH SUPERUSER;

CREATE USER vagrant WITH PASSWORD 'vagrant';
ALTER USER postgres WITH password 'postgres';
ALTER USER vagrant WITH SUPERUSER;

CREATE USER root WITH PASSWORD 'root';
ALTER USER root WITH SUPERUSER;

--Create the database:
CREATE DATABASE $APP_DB_NAME WITH OWNER=$APP_DB_USER
                                  LC_COLLATE='en_US.UTF8'
                                  LC_CTYPE='en_US.UTF8'
                                  ENCODING='UTF8'
                                  TEMPLATE=template0;
                                  
CREATE DATABASE $AUDIT_DB_NAME WITH OWNER=$AUDIT_DB_USER
                                    LC_COLLATE='en_US.UTF8'
                                    LC_CTYPE='en_US.UTF8'
                                    ENCODING='UTF8'
                                    TEMPLATE=template0;                                  
                                  
GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME TO vagrant;
GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME TO aart;
GRANT ALL PRIVILEGES ON DATABASE $APP_DB_NAME TO root;

GRANT ALL PRIVILEGES ON DATABASE $AUDIT_DB_NAME TO vagrant;
GRANT ALL PRIVILEGES ON DATABASE $AUDIT_DB_NAME TO aart;
GRANT ALL PRIVILEGES ON DATABASE $AUDIT_DB_NAME TO root;

\i /schema/roles.sql

EOF
cat << EOF | psql -daartlocal

\i /schema/aartstage_schema.sql

EOF
cat << EOF | psql -daartaudit

\i /schema/aartaudit_schema.sql

EOF

##Install Python utilities

sudo python /pgdump/get-pip.py

sudo pip install openpyxl

sudo pip install sh

sudo pip install virtualenv

sudo yum -y install git

sudo yum -y install httpd

sudo yum install -y postgresql-libs

yum install -y python-psycopg2

##Install screen

yum install -y screen

##Install Liquibase

##cd /

##mkdir liquibase

##cd /liquibase

##wget https://github.com/liquibase/liquibase/releases/download/liquibase-parent-3.4.1/liquibase-3.4.1-bin.tar.gz

##tar xvf liquibase-3.4.1-bin.tar.gz -C /liquibase

##Start PostGREST Server

######commented out as PostGrest requires Centos7 to run.
######nohup /schema/postgrest postgres://postgres:@localhost:5432/aartlocal -a postgres  --schema public &

## Tag the provision time:

date > "$PROVISIONED_ON"

echo "Successfully created PostgreSQL dev virtual machine."
echo ""
print_db_usage
