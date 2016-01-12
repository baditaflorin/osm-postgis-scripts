# osm-postgis-scripts
 Openstreetmap Postgis Script Repository For Osmosis Pgsnapshot Schema that can be loaded in QGIS

This Github Repo was made because : 

Is really hard at the moment to load a osm.pbf file into Postgis
Once you have a osm.pbf file into PostGis, it`s hard to process the data, load the data into Qgis for visual oversight,etc
If we are using the same code structure and respecting the same standards, then we can also create and share Qgis Styles that can be re-used, simplifying the process needed by experts of amateurs to load and visualize OpenStreetMap data.

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

- Step 3.A

Run Qgis . Go to Layer -> Add Vector Layer -> Add Postgis Layer ( CTRL + SHIFT + D )
Under Connections, click New
You will get a new window, add the folowing : 
Name : the name of the connection
Service - you can leave it blank

<img src="http://i.imgur.com/ZdS4Hm1.png" width="50%"></img> 

- Step 3.B - Qgis DB Manager 

Go to Database -> DB Manager -> DB Manager
In the new window, select Postgis, find the Database that you had created, click the + button, Select Public
With the public selected, go to Database -> SQL Window 
Find the script that you want to run from here https://github.com/baditaflorin/osm-postgis-scripts and paste the code into the upper window and hit Execute ( F5 )
<img src="https://cloud.githubusercontent.com/assets/2330999/12267378/7fd62b74-b950-11e5-8ad9-3c50b39a8caf.PNG" width="90%"></img> 

If you want to load it as a file, check at the bottom the "Load as new Layer" and select for Colums(s) with unique values the "id" column, and for Geometry column add the "geom" column and click Load now!

- Step 4 - Qgis Styles

Because we are using the same scripts, you can create a Qgis Style that you can share it here on this Github, so that other people can fork your work and create other things based on your work. 
