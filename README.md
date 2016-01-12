# osm-postgis-scripts
 Openstreetmap Postgis Script Repository For Osmosis Pgsnapshot Schema that can be loaded in QGIS

- Requirements : 

Linux, Postgresql 9.x, Postgis 2.x, Osmosis 0.43+ , Qgis 2.12.2+

Installation : 

- Step 1.A

Using a terminal, download into a folder the scope.sh file
After you download, set the file to be executable by using 
chmod +x scope.sh

- Step 1.B

Go to http://download.geofabrik.de/ or another website and download in the same folder where the scope.sh file is, the osm.pbf file that you are interested. 
For example, from the terminal, i can do :
wget http://download.geofabrik.de/europe/malta-latest.osm.pbf

- Step 2

Run the scope.sh file from the terminal and follow the instructions. 

- Step 3 

Run Qgis . Go to Layer -> Add Vector Layer -> Add Postgis Layer ( CTRL + SHIFT + D )
Under Connections, click New
You will get a new window, add the folowing : 
Name : the name of the connection
Service - you can leave it blank
