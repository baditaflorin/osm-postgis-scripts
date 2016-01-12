-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.08.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
/* #Example of Use: This is usefull when you want to produce statistics only about the roads, 
the most used tags that are used in the highways,etc */
-- #Start Code
SELECT
 user_id, tstamp, changeset_id, version, ways.id as ways_ids, linestring,users.id as u_ids,users.name as osm_name,
 
-- # General Relevance Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
tags->'name' As name,

-- #Specific Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
tags->'ref' As ref,
tags->'highway' As highway,
tags->'oneway' As oneway,
tags->'junction' As junction,
tags->'bridge' As bridge,
tags->'maxspeed' As maxspeed,
tags->'surface' As surface,
tags->'access' As access,
tags->'lanes' As lanes,
tags->'tunnel' As tunnel,
tags->'construction' As construction,
-- #Other possible relevant tags for highway
tags->'barrier' As barrier,
tags->'operator' As operator,
tags->'service' As service,
tags->'sidewalk' As sidewalk,
tags->'cycleway' As cycleway,
tags->'incline' As incline,
tags->'lit' As lit,
tags->'mountain_pass' As mountain_pass,
tags->'traffic_calming' As traffic_calming,
tags->'parking' As parking,
tags->'public_transport' As public_transport,
tags->'motorroad' As motorroad,
tags->'width' As width,
tags->'crossing' As crossing,
tags->'tracktype' As tracktype,
tags->'bus' As bus,

-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
tags->'source' As source,
tags->'attribution' As attribution,
tags->'comment' As comment,
tags->'fixme' As fixme,
tags->'created_by' As created_by

FROM ways,users
WHERE ST_GeometryType(linestring) = 'ST_LineString' 
-- # Link the name of the user with the id, so we can also have the name, not just the id of the user 
AND users.id=ways.user_id 
-- # Filter and keep just the linestrings that have the key highway
AND (ways.tags -> 'highway'::text) IS NOT NULL;
-- #End Code
