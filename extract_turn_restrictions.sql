-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 12.07.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to extract all the turn restrictions */
-- #Start Code

/* #TODO #FIXME
None yet  */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
way_nodes = wn_
nodes = n_
ways_or_nodes = w_or_n_
*/

select rl_id,ST_Collect(geom),count(*) from (

select 
--relation_id,count(*) 
--*,
-- #relations_members

relation_members.relation_id rl_id,
relation_members.member_id as rl_member_id,
relation_members.member_role as rl_member_role,
relation_members.sequence_id as rl_sequence,
relation_members.member_type as rl_momber_type,

-- #relations 

relations.id as r_id,
relations.version as r_version,
relations.tstamp as r_tstamp,
relations.user_id as r_user_id,

-- relation tstamp minus ways tstamp
age (relations.tstamp,ways.tstamp) as diff_rel_ways_or_nodes,
--  The day of the week as Sunday (0) to Saturday (6)
extract(dow from relations.tstamp) as r_day_of_the_week,

-- Create a column for ways that will count the number of keys in each row.
array_length(avals(ways.tags), 1) AS w_or_n_count_keys,
-- done -- Max nodes per way segment
ST_NPoints(ways.linestring) AS w_or_n_points_per_way,

-- ways --
-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
ways.version as w_or_n_version,
ways.changeset_id as w_or_n_changeset_id,
ways.user_id as w_or_n_user_id,
ways.tstamp as w_or_n_tstamp,
date_trunc('day',ways.tstamp) as w_or_n_day,
date_trunc('month',ways.tstamp) as w_or_n_month,
date_part('year', ways.tstamp) as w_or_n_year,

-- # ways - General Relevance Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
ways.id as w_or_n_id,
ways.tags->'name' As w_or_n_name,

-- #Specific Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
ways.tags as w_or_n_tags,
ways.tags->'ref' As w_or_n_ref,
ways.tags->'highway' As w_or_n_highway,

-- we add the name geom to ways.linestring so that Qgis will know automaticly that this is the column that holds geometry data
ways.linestring as geom

from relation_members,ways,relations--,nodes
where (relation_members.member_id = ways.id)
--OR (relation_members.member_id = nodes.id)
AND (relation_members.relation_id = relations.id)
AND (relations.tags ->'type'in ('restriction'))

--limit 5
--group by relation_id

UNION ALL


select 
--relation_id,count(*) 

-- #relations_members

relation_members.relation_id rl_id,
relation_members.member_id as rl_member_id,
relation_members.member_role as rl_member_role,
relation_members.sequence_id as rl_sequence,
relation_members.member_type as rl_momber_type,
-- #relations 

relations.id as r_id,
relations.version as r_version,
relations.tstamp as r_tstamp,
relations.user_id as r_user_id,

-- relation tstamp minus ways tstamp
age (relations.tstamp,nodes.tstamp) as diff_rel_ways_or_nodes,
--  The day of the week as Sunday (0) to Saturday (6)
extract(dow from relations.tstamp) as r_day_of_the_week,

-- Create a column for ways that will count the number of keys in each row.
array_length(avals(nodes.tags), 1) AS w_or_n_count_keys,
-- done -- Max nodes per way segment
ST_NPoints(nodes.geom) AS w_or_n_points_per_way,

-- ways --
-- #Internal mappers tags
-- #leave empty the end of the last tag, don`t end it with the semicolon 
nodes.version as w_or_n_version,
nodes.changeset_id as w_or_n_changeset_id,
nodes.user_id as w_or_n_user_id,
nodes.tstamp as w_or_n_tstamp,
date_trunc('day',nodes.tstamp) as w_or_n_day,
date_trunc('month',nodes.tstamp) as w_or_n_month,
date_part('year', nodes.tstamp) as w_or_n_year,

-- # ways - General Relevance Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
nodes.id as w_or_n_id,
nodes.tags->'name' As w_or_n_name,

-- #Specific Tags 
-- #Keep the semicolon at the end, we will leave empty at the last section, internal mappers tags  
nodes.tags as w_or_n_tags,
nodes.tags->'ref' As w_or_n_ref,
nodes.tags->'highway' As w_or_n_highway,

-- we add the name geom to nodes.geom so that Qgis will know automaticly that this is the column that holds geometry data
nodes.geom as geom


from relation_members,relations,nodes
where --(relation_members.member_id = ways.id)
(relation_members.member_id = nodes.id)
AND (relation_members.relation_id = relations.id)
AND (relations.tags ->'type'in ('restriction'))

) subquery

group by subquery.rl_id
order by count desc

-- #End Code
