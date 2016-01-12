-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 01.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
/* #Example of Use: This is usefull when you want to produce statistics about the routes, 
the most used tags that are used in the routes, network, etc */
-- #Start Code

/* #TODO #FIXME
This will only load the ways, but usualy route relations are made out of ways and nodes.
In this form, this script will only load the ways, not the nodes */
/* Abrevations list 

relation_members = rl_
relations = r_
ways = w_
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS to recognize this Column as the column that have only unique values
SELECT ROW_NUMBER() over (order by ways.id) as id,

-- #relations_members

relation_members.relation_id rl_id,
relation_members.member_id as rl_member_id,
relation_members.member_role as rl_member_role,
relation_members.sequence_id as rl_sequence,

-- #relations 

relations.id as r_id,
relations.version as r_version,
relations.tstamp as r_tstamp,
relations.user_id as r_user_id,
date_trunc('day',relations.tstamp) as r_day,
date_trunc('month',relations.tstamp) as r_month,
date_part('year', relations.tstamp) as r_year,

relations.changeset_id as  r_changeset_id,
relations.tags as r_tags,

-- tags from relations
-- #relations tags split
relations.tags->'name' As r_name,
relations.tags->'ref' As r_ref,
relations.tags->'type' As r_type,
relations.tags->'route' As r_route,
relations.tags->'source' As r_source,
relations.tags->'network' As r_network,
-- Create a column that will count the number of keys in each row.
array_length(avals(relations.tags), 1) AS r_count_keys,

-- relation tstamp minus ways tstamp
age (relations.tstamp,ways.tstamp) as diff_rel_ways,
--  The day of the week as Sunday (0) to Saturday (6)
extract(dow from relations.tstamp) as r_day_of_the_week,

-- Create a column for ways that will count the number of keys in each row.
array_length(avals(ways.tags), 1) AS w_count_keys,
-- done -- Max nodes per way segment
ST_NPoints(ways.linestring) AS w_points_per_way,

-- ways --
-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.version as w_version,
ways.changeset_id as w_changeset_id,
ways.user_id as w_user_id,
ways.tstamp as w_tstamp,
date_trunc('day',ways.tstamp) as w_day,
date_trunc('month',ways.tstamp) as w_month,
date_part('year', ways.tstamp) as w_year,

-- # ways - General Relevance Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
ways.id as w_id,
ways.tags->'name' As w_name,

-- #Specific Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
ways.tags as w_tags,
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

ways.tags->'source' As w_source,
ways.tags->'attribution' As w_attribution,
ways.tags->'comment' As w_comment,
ways.tags->'fixme' As w_fixme,
ways.tags->'created_by' As w_created_by,

-- geom from ways --

-- we add the name geom to ways.linestring so that Qgis will know automaticly that this is the column that holds geometry data
ways.linestring as geom

from relation_members,ways,relations
where (relation_members.member_id = ways.id)
AND (relation_members.relation_id = relations.id)
-- Other type of relations will not be loaded with this script. this will filter and load only the tags that have set as type=route 
AND (relations.tags ->'type'in ('route'))
--limit 1000
-- #End Code
