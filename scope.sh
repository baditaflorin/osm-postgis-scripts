#!/bin/bash
# version 0.3
# Florin Badita baditaflorin@gmail.com
# Ask the user for the database name and create a db with that name
# Adds the hstore and postgis extentions, and populate the database with the osm schema
for i in {4..101} {21..111} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo "This script assume that you already have installed Osmosis, PostgreSQL, Postgis and downloaded a osm.pbf file"
echo "If this is the first time you are using the script, press CTRL+Z and do the required steps"
echo "To download a osm.pbf file, go to http://download.geofabrik.de/"
echo "Find the country that you want, and use the wget command to bring the file into the directory where you also have this script"
echo "Example : wget http://download.geofabrik.de/europe/romania-latest.osm.pbf"
for i in {4..101} {21..111} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo "Welcome to SCOPE - (databaSe Creator Osmosis Postgis loadEr)"
echo "Enter the name of the PostgreSQL user account"
read user
echo "$(tput setaf 3) The PostgreSQL user is " $user $(tput sgr 0)
echo "Please enter the database name in this format Country_Code-YYMMDD ( RO-160107 )"
read database
echo "$(tput setaf 3)"the database name is $database $(tput sgr 0)
createdb -O $user $database
psql -U $user -d $database -c 'CREATE EXTENSION hstore;'
psql -U $user -d $database -c 'CREATE EXTENSION postgis;'
psql -U $user -d $database -f /usr/share/doc/osmosis/examples/pgsnapshot_schema_0.6.sql
psql -U $user -d $database -f /usr/share/doc/osmosis/examples/pgsnapshot_schema_0.6_linestring.sql
echo -e "\vFirst \vpart \vis \vdone \v \vCluj \vMap Analyst Team \vTelenav" 
echo "Part 2 - Ready for some osmosis fun importing the osm file ? Press CTRL+Z to cancel"
echo "Enter the name of the file, without the extension ( example : romania-latest.osm.pbf will be romania-latest  )"
read osmfile
echo "The script assume that the location of the PostgreSQL host is localhost, if you disagree with this location, change the script and point it to the right location"
echo "$(tput setaf 3) Enter password for user " $user "( better safe them sorry )" $(tput sgr 0)
read -s pass
#echo "Setting 16 GB RAM for this task to the server"
#set JAVACMD_OPTIONS= -Xmx16G
sudo osmosis -v --rbf $osmfile.osm.pbf --wp host=localhost database=$database user=$user password=$pass
echo -e "\vThis \vscript \vis \vdone \v \vCluj \vMap Analyst Team \vTelenav" 
for i in {4..101} {21..111} ; do echo -en "\e[38;5;${i}m#\e[0m" ; done ; echo
echo "Find Postgis Scripts and snippents of code that you can use here https://github.com/baditaflorin/osm-postgis-scripts"
echo "It is a Open Source Project, so you can also contribuite with you Postgis Code to make the repository more complete"
