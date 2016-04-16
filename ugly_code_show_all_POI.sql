Create table all_poi as-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to produce statistics about the housenumbers, to see in a visual way in Qgis who added housenumbers in a city, etc */
-- #Start Code

/* #TODO #FIXME
This will load the nodes and ways, and will convert the ways using ST_centroid to get a node for each way. This script will not tell you if the original was a way or a node */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
-- # We create the ROW_NUMBER() here, because if not it will generate 2 starting sequences, one for the nodes and one for the ways, and then QGIS will not allow us to load the data, because we don`t have a unique ID. SOURCE http://stackoverflow.com/questions/5190240/row-number-with-union-query

SELECT ROW_NUMBER() over () as id,* from 
( SELECT user_id, tstamp, changeset_id, version, ways.id as ways_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 ST_centroid(ways.linestring) as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 ways.tags->'addr:housenumber' As n_addr_housenumber,
 ways.tags->'addr:interpolation' As n_addr_interpolation,
 ways.tags->'addr:housename' As n_addr_housename,
 ways.tags->'addr:city' As n_addr_city,
 ways.tags->'addr:postcode' As n_addr_postcode,

ways.tags->'amenity' As amenity,
ways.tags->'shop' As shop,
ways.tags->'tourism' As tourism,
ways.tags->'man_made' As man_made,
ways.tags->'leisure' As leisure,
ways.tags->'sport' As sport,


-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'source' As n_source,
ways.tags->'attribution' As n_attribution,
ways.tags->'comment' As n_comment,
ways.tags->'fixme' As n_fixme,
ways.tags->'created_by' As n_created_by
FROM ways,users
WHERE users.id=ways.user_id AND ((tags->'amenity')) is not null


UNION ALL 

-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to produce statistics about the housenumbers, to see in a visual way in Qgis who added housenumbers in a city, etc */
-- #Start Code

/* #TODO #FIXME
This will only load the nodes, but housenumbers are made out of ways and nodes.
In this form, this script will only load the nodes, not the ways */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
SELECT user_id, tstamp, changeset_id, version, nodes.id as node_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 nodes.geom as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 nodes.tags->'addr:housenumber' As n_addr_housenumber,
 nodes.tags->'addr:interpolation' As n_addr_interpolation,
 nodes.tags->'addr:housename' As n_addr_housename,
 nodes.tags->'addr:city' As n_addr_city,
 nodes.tags->'addr:postcode' As n_addr_postcode,

nodes.tags->'amenity' As amenity,
nodes.tags->'shop' As shop,
nodes.tags->'tourism' As tourism,
nodes.tags->'man_made' As man_made,
nodes.tags->'leisure' As leisure,
nodes.tags->'sport' As sport,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'source' As n_source,
nodes.tags->'attribution' As n_attribution,
nodes.tags->'comment' As n_comment,
nodes.tags->'fixme' As n_fixme,
nodes.tags->'created_by' As n_created_by
FROM nodes,users
WHERE ST_GeometryType(geom) = 'ST_Point' AND users.id=nodes.user_id AND ((tags->'amenity')) is not null 

-- # Amenity
UNION ALL 

SELECT user_id, tstamp, changeset_id, version, ways.id as ways_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 ST_centroid(ways.linestring) as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 ways.tags->'addr:housenumber' As n_addr_housenumber,
 ways.tags->'addr:interpolation' As n_addr_interpolation,
 ways.tags->'addr:housename' As n_addr_housename,
 ways.tags->'addr:city' As n_addr_city,
 ways.tags->'addr:postcode' As n_addr_postcode,

ways.tags->'amenity' As amenity,
ways.tags->'shop' As shop,
ways.tags->'tourism' As tourism,
ways.tags->'man_made' As man_made,
ways.tags->'leisure' As leisure,
ways.tags->'sport' As sport,


-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'source' As n_source,
ways.tags->'attribution' As n_attribution,
ways.tags->'comment' As n_comment,
ways.tags->'fixme' As n_fixme,
ways.tags->'created_by' As n_created_by
FROM ways,users
WHERE users.id=ways.user_id AND ((tags->'shop')) is not null


UNION ALL 

-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to produce statistics about the housenumbers, to see in a visual way in Qgis who added housenumbers in a city, etc */
-- #Start Code

/* #TODO #FIXME
This will only load the nodes, but housenumbers are made out of ways and nodes.
In this form, this script will only load the nodes, not the ways */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
SELECT user_id, tstamp, changeset_id, version, nodes.id as node_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 nodes.geom as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 nodes.tags->'addr:housenumber' As n_addr_housenumber,
 nodes.tags->'addr:interpolation' As n_addr_interpolation,
 nodes.tags->'addr:housename' As n_addr_housename,
 nodes.tags->'addr:city' As n_addr_city,
 nodes.tags->'addr:postcode' As n_addr_postcode,

nodes.tags->'amenity' As amenity,
nodes.tags->'shop' As shop,
nodes.tags->'tourism' As tourism,
nodes.tags->'man_made' As man_made,
nodes.tags->'leisure' As leisure,
nodes.tags->'sport' As sport,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'source' As n_source,
nodes.tags->'attribution' As n_attribution,
nodes.tags->'comment' As n_comment,
nodes.tags->'fixme' As n_fixme,
nodes.tags->'created_by' As n_created_by
FROM nodes,users
WHERE ST_GeometryType(geom) = 'ST_Point' AND users.id=nodes.user_id AND ((tags->'shop')) is not null 

-- # SHOP 
UNION ALL 

SELECT user_id, tstamp, changeset_id, version, ways.id as ways_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 ST_centroid(ways.linestring) as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 ways.tags->'addr:housenumber' As n_addr_housenumber,
 ways.tags->'addr:interpolation' As n_addr_interpolation,
 ways.tags->'addr:housename' As n_addr_housename,
 ways.tags->'addr:city' As n_addr_city,
 ways.tags->'addr:postcode' As n_addr_postcode,

ways.tags->'amenity' As amenity,
ways.tags->'shop' As shop,
ways.tags->'tourism' As tourism,
ways.tags->'man_made' As man_made,
ways.tags->'leisure' As leisure,
ways.tags->'sport' As sport,


-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'source' As n_source,
ways.tags->'attribution' As n_attribution,
ways.tags->'comment' As n_comment,
ways.tags->'fixme' As n_fixme,
ways.tags->'created_by' As n_created_by
FROM ways,users
WHERE users.id=ways.user_id AND ((tags->'tourism')) is not null


UNION ALL 

-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to produce statistics about the housenumbers, to see in a visual way in Qgis who added housenumbers in a city, etc */
-- #Start Code

/* #TODO #FIXME
This will only load the nodes, but housenumbers are made out of ways and nodes.
In this form, this script will only load the nodes, not the ways */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
SELECT user_id, tstamp, changeset_id, version, nodes.id as node_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 nodes.geom as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 nodes.tags->'addr:housenumber' As n_addr_housenumber,
 nodes.tags->'addr:interpolation' As n_addr_interpolation,
 nodes.tags->'addr:housename' As n_addr_housename,
 nodes.tags->'addr:city' As n_addr_city,
 nodes.tags->'addr:postcode' As n_addr_postcode,

nodes.tags->'amenity' As amenity,
nodes.tags->'shop' As shop,
nodes.tags->'tourism' As tourism,
nodes.tags->'man_made' As man_made,
nodes.tags->'leisure' As leisure,
nodes.tags->'sport' As sport,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'source' As n_source,
nodes.tags->'attribution' As n_attribution,
nodes.tags->'comment' As n_comment,
nodes.tags->'fixme' As n_fixme,
nodes.tags->'created_by' As n_created_by
FROM nodes,users
WHERE ST_GeometryType(geom) = 'ST_Point' AND users.id=nodes.user_id AND ((tags->'tourism')) is not null 


-- TOURISM
UNION ALL 



SELECT user_id, tstamp, changeset_id, version, ways.id as ways_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 ST_centroid(ways.linestring) as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 ways.tags->'addr:housenumber' As n_addr_housenumber,
 ways.tags->'addr:interpolation' As n_addr_interpolation,
 ways.tags->'addr:housename' As n_addr_housename,
 ways.tags->'addr:city' As n_addr_city,
 ways.tags->'addr:postcode' As n_addr_postcode,

ways.tags->'amenity' As amenity,
ways.tags->'shop' As shop,
ways.tags->'tourism' As tourism,
ways.tags->'man_made' As man_made,
ways.tags->'leisure' As leisure,
ways.tags->'sport' As sport,


-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'source' As n_source,
ways.tags->'attribution' As n_attribution,
ways.tags->'comment' As n_comment,
ways.tags->'fixme' As n_fixme,
ways.tags->'created_by' As n_created_by
FROM ways,users
WHERE users.id=ways.user_id AND ((tags->'man_made')) is not null


UNION ALL 

-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to produce statistics about the housenumbers, to see in a visual way in Qgis who added housenumbers in a city, etc */
-- #Start Code

/* #TODO #FIXME
This will only load the nodes, but housenumbers are made out of ways and nodes.
In this form, this script will only load the nodes, not the ways */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
SELECT user_id, tstamp, changeset_id, version, nodes.id as node_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 nodes.geom as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 nodes.tags->'addr:housenumber' As n_addr_housenumber,
 nodes.tags->'addr:interpolation' As n_addr_interpolation,
 nodes.tags->'addr:housename' As n_addr_housename,
 nodes.tags->'addr:city' As n_addr_city,
 nodes.tags->'addr:postcode' As n_addr_postcode,

nodes.tags->'amenity' As amenity,
nodes.tags->'shop' As shop,
nodes.tags->'tourism' As tourism,
nodes.tags->'man_made' As man_made,
nodes.tags->'leisure' As leisure,
nodes.tags->'sport' As sport,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'source' As n_source,
nodes.tags->'attribution' As n_attribution,
nodes.tags->'comment' As n_comment,
nodes.tags->'fixme' As n_fixme,
nodes.tags->'created_by' As n_created_by
FROM nodes,users
WHERE ST_GeometryType(geom) = 'ST_Point' AND users.id=nodes.user_id AND ((tags->'man_made')) is not null 

UNION ALL 
-- MAN MADE


SELECT user_id, tstamp, changeset_id, version, ways.id as ways_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 ST_centroid(ways.linestring) as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 ways.tags->'addr:housenumber' As n_addr_housenumber,
 ways.tags->'addr:interpolation' As n_addr_interpolation,
 ways.tags->'addr:housename' As n_addr_housename,
 ways.tags->'addr:city' As n_addr_city,
 ways.tags->'addr:postcode' As n_addr_postcode,

ways.tags->'amenity' As amenity,
ways.tags->'shop' As shop,
ways.tags->'tourism' As tourism,
ways.tags->'man_made' As man_made,
ways.tags->'leisure' As leisure,
ways.tags->'sport' As sport,


-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'source' As n_source,
ways.tags->'attribution' As n_attribution,
ways.tags->'comment' As n_comment,
ways.tags->'fixme' As n_fixme,
ways.tags->'created_by' As n_created_by
FROM ways,users
WHERE users.id=ways.user_id AND ((tags->'leisure')) is not null


UNION ALL 

-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to produce statistics about the housenumbers, to see in a visual way in Qgis who added housenumbers in a city, etc */
-- #Start Code

/* #TODO #FIXME
This will only load the nodes, but housenumbers are made out of ways and nodes.
In this form, this script will only load the nodes, not the ways */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
SELECT user_id, tstamp, changeset_id, version, nodes.id as node_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 nodes.geom as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 nodes.tags->'addr:housenumber' As n_addr_housenumber,
 nodes.tags->'addr:interpolation' As n_addr_interpolation,
 nodes.tags->'addr:housename' As n_addr_housename,
 nodes.tags->'addr:city' As n_addr_city,
 nodes.tags->'addr:postcode' As n_addr_postcode,

nodes.tags->'amenity' As amenity,
nodes.tags->'shop' As shop,
nodes.tags->'tourism' As tourism,
nodes.tags->'man_made' As man_made,
nodes.tags->'leisure' As leisure,
nodes.tags->'sport' As sport,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'source' As n_source,
nodes.tags->'attribution' As n_attribution,
nodes.tags->'comment' As n_comment,
nodes.tags->'fixme' As n_fixme,
nodes.tags->'created_by' As n_created_by
FROM nodes,users
WHERE ST_GeometryType(geom) = 'ST_Point' AND users.id=nodes.user_id AND ((tags->'leisure')) is not null 


-- LEISURE
UNION ALL 


SELECT user_id, tstamp, changeset_id, version, ways.id as ways_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 ST_centroid(ways.linestring) as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 ways.tags->'addr:housenumber' As n_addr_housenumber,
 ways.tags->'addr:interpolation' As n_addr_interpolation,
 ways.tags->'addr:housename' As n_addr_housename,
 ways.tags->'addr:city' As n_addr_city,
 ways.tags->'addr:postcode' As n_addr_postcode,

ways.tags->'amenity' As amenity,
ways.tags->'shop' As shop,
ways.tags->'tourism' As tourism,
ways.tags->'man_made' As man_made,
ways.tags->'leisure' As leisure,
ways.tags->'sport' As sport,


-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'source' As n_source,
ways.tags->'attribution' As n_attribution,
ways.tags->'comment' As n_comment,
ways.tags->'fixme' As n_fixme,
ways.tags->'created_by' As n_created_by
FROM ways,users
WHERE users.id=ways.user_id AND ((tags->'sport')) is not null


UNION ALL 

-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to produce statistics about the housenumbers, to see in a visual way in Qgis who added housenumbers in a city, etc */
-- #Start Code

/* #TODO #FIXME
This will only load the nodes, but housenumbers are made out of ways and nodes.
In this form, this script will only load the nodes, not the ways */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
SELECT user_id, tstamp, changeset_id, version, nodes.id as node_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 nodes.geom as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'name' As n_name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 nodes.tags->'addr:housenumber' As n_addr_housenumber,
 nodes.tags->'addr:interpolation' As n_addr_interpolation,
 nodes.tags->'addr:housename' As n_addr_housename,
 nodes.tags->'addr:city' As n_addr_city,
 nodes.tags->'addr:postcode' As n_addr_postcode,

nodes.tags->'amenity' As amenity,
nodes.tags->'shop' As shop,
nodes.tags->'tourism' As tourism,
nodes.tags->'man_made' As man_made,
nodes.tags->'leisure' As leisure,
nodes.tags->'sport' As sport,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.tags->'source' As n_source,
nodes.tags->'attribution' As n_attribution,
nodes.tags->'comment' As n_comment,
nodes.tags->'fixme' As n_fixme,
nodes.tags->'created_by' As n_created_by
FROM nodes,users
WHERE ST_GeometryType(geom) = 'ST_Point' AND users.id=nodes.user_id AND ((tags->'sport')) is not null 


) nodes_and_ways;

select * from all_poi
