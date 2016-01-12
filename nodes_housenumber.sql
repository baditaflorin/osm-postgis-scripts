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
SELECT ROW_NUMBER() over () as id,
 user_id, tstamp, changeset_id, version, nodes.id as node_ids, 
 -- # this will make the column name be geom, that will enable Qgis DB manager to figure it out that this is the column that holds geometry data
 nodes.geom as geom,
 
users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
tags->'name' As name,
 
-- #Specific Tags 
-- #leave empty the end of the last tag, don`t end it with the semicolon 
 tags->'addr:housenumber' As addr_housenumber,
 tags->'addr:interpolation' As addr_interpolation,
 tags->'addr:housename' As addr_housename,
 tags->'addr:city' As addr_city,
 tags->'addr:postcode' As addr_postcode,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
tags->'source' As source,
tags->'attribution' As attribution,
tags->'comment' As comment,
tags->'fixme' As fixme,
tags->'created_by' As created_by
FROM nodes,users
WHERE ST_GeometryType(geom) = 'ST_Point' AND users.id=nodes.user_id AND ((tags->'addr:housenumber')) is not null
