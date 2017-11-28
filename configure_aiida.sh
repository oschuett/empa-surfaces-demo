#!/bin/bash -e

set -x

#update reentry cache
sudo reentry scan

# configure postgreSQL
sudo service postgresql start
sudo -u postgres psql -d template1 -c "CREATE USER aiida WITH PASSWORD 'aiida_db_passwd';"
sudo -u postgres psql -d template1 -c "CREATE DATABASE aiidadb OWNER aiida;"
sudo -u postgres psql -d template1 -c "GRANT ALL PRIVILEGES ON DATABASE aiidadb to aiida;"

# download and import aiida db dump
wget https://storage.googleapis.com/oles_stuff/aiidadb.sql.gz
gunzip aiidadb.sql.gz
sudo -u postgres psql -d aiidadb -f aiidadb.sql
rm aiidadb.sql

# download and import aiida repository
wget https://storage.googleapis.com/oles_stuff/aiida_repository.tgz
tar -xzf aiida_repository.tgz
rm aiida_repository.tgz

# create aiida profile
verdi setup                                 \
      --non-interactive                     \
      --email aiida@localhost               \
      --first-name Some                     \
      --last-name Body                      \
      --institution XYZ                     \
      --backend django                      \
      --db_user aiida                       \
      --db_pass aiida_db_passwd             \
      --db_name aiidadb                     \
      --db_host localhost                   \
      --db_port 5432                        \
      --repo /home/ubuntu/aiida_repository  \
      default

# enable aiida profile
verdi profile setdefault verdi default

# add verdi tag-completion
echo 'eval "$(verdi completioncommand)"' >> ~/.bashrc

# install aiida magic
if [ ! -e ~/.ipython/profile_default/ipython_config.py ]; then
   mkdir -p ~/.ipython/profile_default/
   echo "c = get_config()"                         > ~/.ipython/profile_default/ipython_config.py
   echo "c.InteractiveShellApp.extensions = ["    >> ~/.ipython/profile_default/ipython_config.py
   echo "  'aiida.common.ipython.ipython_magics'" >> ~/.ipython/profile_default/ipython_config.py
   echo "]"                                       >> ~/.ipython/profile_default/ipython_config.py
fi

# TODO reenable once aiida import/export works
# download and import aiida demo database
#wget https://storage.googleapis.com/oles_stuff/empa_surfaces_demo_db.aiida
#verdi import empa_surfaces_demo_db.aiida
#rm empa_surfaces_demo_db.aiida

# stop postgreSQL properly
sudo service postgresql stop

#EOF