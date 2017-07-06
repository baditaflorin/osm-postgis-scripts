#!/bin/bash
# Bash convert osm xml files into osm.pbf
for f in *.xml 
do 
	osmconvert $f -o=`basename $f .xml`.osm.pbf 
done
