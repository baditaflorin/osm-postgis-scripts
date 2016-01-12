-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.08.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
/* #Example of Use: This is usefull when you want to produce statistics only about the roads, 
the most used tags that are used in the highways,etc */
-- #Start Code
-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS to recognize this Column as the column that have only unique values
SELECT ROW_NUMBER() over () as id,
 user_id, tstamp, changeset_id, version, ways.id as ways_ids, 
-- # linestring as geom changes the name of the column to be geom, 
 linestring as geom,
 users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
ways.tags->'name' As w_name,

-- #Specific Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
ways.tags->'ref' As w_ref,
ways.tags->'highway' As w_highway,
ways.tags->'oneway' As w_oneway,
ways.tags->'junction' As w_junction,
ways.tags->'bridge' As w_bridge,
ways.tags->'maxspeed' As w_maxspeed,
ways.tags->'surface' As w_surface,
ways.tags->'access' As w_access,
ways.tags->'lanes' As w_lanes,
ways.tags->'tunnel' As w_tunnel,
ways.tags->'construction' As w_construction,
-- #Other possible relevant tags for highway
ways.tags->'barrier' As w_barrier,
ways.tags->'operator' As w_operator,
ways.tags->'service' As w_service,
ways.tags->'sidewalk' As w_sidewalk,
ways.tags->'cycleway' As w_cycleway,
ways.tags->'incline' As w_incline,
ways.tags->'lit' As w_lit,
ways.tags->'mountain_pass' As w_mountain_pass,
ways.tags->'traffic_calming' As w_traffic_calming,
ways.tags->'parking' As w_parking,
ways.tags->'public_transport' As w_public_transport,
ways.tags->'motorroad' As w_motorroad,
ways.tags->'width' As w_width,
ways.tags->'crossing' As w_crossing,
ways.tags->'tracktype' As w_tracktype,
ways.tags->'bus' As w_bus,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.tags->'source' As w_source,
ways.tags->'attribution' w_As attribution,
ways.tags->'comment' As w_comment,
ways.tags->'fixme' As w_fixme,
ways.tags->'created_by' As w_created_by

FROM ways,users
WHERE ST_GeometryType(linestring) = 'ST_LineString' 
-- # Link the name of the user with the id, so we can also have the name, not just the id of the user 
AND users.id=ways.user_id 
-- # Filter and keep just the linestrings that have the key highway
AND (ways.tags -> 'highway'::text) IS NOT NULL
-- #End Code
