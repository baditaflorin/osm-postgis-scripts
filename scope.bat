REM #!/bin/bash
REM # version 0.3
REM # Florin Badita baditaflorin@gmail.com
REM # Ask the user for the database name and create a db with that name
REM # Adds the hstore and postgis extentions, and populate the database with the osm schema
Echo This script assume that you already have installed Osmosis, PostgreSQL, Postgis and downloaded a osm.pbf file
Echo If this is the first time you are using the script, press CTRL+Z and do the required steps
Echo To download a osm.pbf file, go to http://download.geofabrik.de/
Echo Find the country that you want, and use the wget command to bring the file into the directory where you also have this script
Echo Example : wget http://download.geofabrik.de/europe/romania-latest.osm.pbf
Echo Welcome to SCOPE - (databaSe Creator Osmosis Postgis loadEr)
set /P user=Enter the name of the PostgreSQL user account: 
Echo The PostgreSQL user is %user%
set /P database=Please enter the database name in this format Country_Code-YYMMDD ( RO-160107 ): 
Echo the database name is %database%
createdb -O %user% %database%
psql -U %user% -d %database% -c "CREATE EXTENSION hstore;"
psql -U %user% -d %database% -c "CREATE EXTENSION postgis;"

bitsadmin.exe /transfer "Download pgsnapshot_schema_0.6.sql" https://raw.githubusercontent.com/openstreetmap/osmosis/master/package/script/pgsnapshot_schema_0.6.sql %cd%\pgsnapshot_schema_0.6.sql
bitsadmin.exe /transfer "Download pgsnapshot_schema_0.6.sql" https://raw.githubusercontent.com/openstreetmap/osmosis/master/package/script/pgsnapshot_schema_0.6_linestring.sql %cd%\pgsnapshot_schema_0.6_linestring.sql

psql -U %user% -d %database% -f pgsnapshot_schema_0.6.sql
psql -U %user% -d %database% -f pgsnapshot_schema_0.6_linestring.sql

Echo Part 2 - Ready for some osmosis fun importing the osm file ? Press CTRL+Z to cancel
Echo
set /P osmfile=Enter the name of the file, without the extension ( example : romania-latest.osm.pbf will be romania-latest )

echo The script assume that the location of the PostgreSQL host is localhost, if you disagree with this location, change the script and point it to the right location
set /P pass= Enter password for user " %user% "( better safe them sorry )

REM # echo "Setting 16 GB RAM for this task to the server"
REM # set JAVACMD_OPTIONS= -Xmx16G

osmosis -v --rbf %osmfile%.osm.pbf --wp host=localhost database=%database% user=%user% password=%pass%
echo \vThis \vscript \vis \vdone \v \vCluj \vMap Analyst Team \vTelenav

echo Find Postgis Scripts and snippents of code that you can use here https://github.com/baditaflorin/osm-postgis-scripts
echo It is a Open Source Project, so you can also contribuite with you Postgis Code to make the repository more complete
