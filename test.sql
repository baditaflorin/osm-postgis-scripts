-- #Version: 0.1
-- #Author: Florin Badita,Vasile Ceteras
-- #Date: 30.08.16
-- #Website: http://www.openstreetmap.org/user/baditaflorin/diary
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: count the length of highways by type */
-- #Start Code

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

select subquery.name,
subquery.version,
al_2.name,
subquery.r_restriction

--to slow to calculate the percentage directly from sql
--sum(total_meters/nullif(lanes_meters,0)) percentage_of_lanes,

from 
(
select 
relations.name,
(st_length(linestring::geography)) total_meters,
relations.tags->'restriction' As r_restriction, 

-- filter just the oneway that are not empty
ceil( ( 
     case when (relations.tags->'oneway') is not null then 
	 st_length(linestring::geography) 
     else 
	 0 
end)) oneway_meters,

-- filter just the maxspeed that are not empty
ceil( ( 
     case when (ways.tags->'maxspeed') is not null then 
	 st_length(linestring::geography) 
     else 
	 0 
end)) maxspeed_meters,
ways.linestring as geom,


relations.version



from all_mar_2017_telenav_usa_relations relations,relation_members,ways
where (relations.tags->'restriction') is not null
AND (relation_members.member_id = ways.id)
AND (relation_members.relation_id = relations.id)
--limit 55
) subquery
inner join al_2 on st_contains(al_2.geom,subquery.geom)

group by al_2.name,subquery.name,subquery.version,subquery.r_restriction
order by subquery.name desc


-- #End Code
