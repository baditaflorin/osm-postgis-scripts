-- #Version: 0.1
-- #Author: Florin Badita
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



select subquery.w_highway,
ceil(sum(total_meters/1000)) total_km,

ceil(sum(lanes_meters/1000)) lanes_km,
--to slow to calculate the percentage directly from sql
--sum(total_meters/nullif(lanes_meters,0)) percentage_of_lanes,

ceil(sum(maxspeed_meters/1000)) maxspeed_km,

ceil(sum(ref_meters/1000)) ref_km,

ceil(sum(surface_meters/1000)) surface_km,

ceil(sum(width_meters/1000)) width_km,

ceil(sum(sidewalk_meters/1000)) sidewalk_km


from 
(
select 
(st_length(linestring::geography)) total_meters,
ways.tags->'highway' As w_highway, 

-- filter just the lanes that are not empty
ceil( ( 
     case when (ways.tags->'lanes') is not null then 
	 st_length(linestring::geography) 
     else 
	 0 
end)) lanes_meters,

-- filter just the maxspeed that are not empty
ceil( ( 
     case when (ways.tags->'maxspeed') is not null then 
	 st_length(linestring::geography) 
     else 
	 0 
end)) maxspeed_meters,


-- filter just the highway that have a ref
ceil( ( 
     case when (ways.tags->'ref') is not null then 
	 st_length(linestring::geography) 
     else 
	 0 
end)) ref_meters,

-- filter just the highway that have a surface information
ceil( ( 
     case when (ways.tags->'surface') is not null then 
	 st_length(linestring::geography) 
     else 
	 0 
end)) surface_meters,

-- filter just the highway that have width information
ceil( ( 
     case when (ways.tags->'width') is not null then 
	 st_length(linestring::geography) 
     else 
	 0 
end)) width_meters,

-- filter just the highway that have a sidewalk information
ceil( ( 
     case when (ways.tags->'sidewalk') is not null then 
	 st_length(linestring::geography) 
     else 
	 0 
end)) sidewalk_meters



from ways
where (ways.tags->'highway') is not null
--limit 5500
) subquery
group by w_highway
order by total_km desc

-- #End Code
