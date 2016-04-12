-- #Version: 0.1
-- #Author: Florin Badita
-- #Date: 28.03.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to get only the admin_level = 4 provinces, as a polygon */
-- #Start Code

/* #TODO #FIXME
This will only load the ways that are a complete polygon */

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
a = the Inner Join that we have created
*/

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values


/* For every relation, create a polygon from all the linestrings that are composed from that relation */ 
select ROW_NUMBER() over () as id, 
-- useful information that we get from the relations table
r.user_id,r.changeset_id,r.tstamp r_tstamp,r.version r_version, relation_id r_id,
-- some more useful information that we get from the Hstore tags. 
r.tags->'name' boundary_name, r.tags->'admin_level' r_admin_level,
/* Here we get the geometry of the combined polygon. 
We use ST_BuildArea because the polygon is made out of multiple linestrings that are not in order, so we cannot use ST_makepolygon, we will get an error. */ 

ST_BuildArea(a.r_polygon) geom

/* -- debug purpouses only 
,ST_Boundary(a.r_polygon) geom_debug_unclosed,
ST_isclosed(a.r_polygon) ST_isclosed,ST_isvalid(a.r_polygon) ST_isvalid,ST_IsValidReason(a.r_polygon) ST_IsValidReason,
ST_isclosed(ST_Boundary(a.r_polygon)) collect_boundary
-- end of debug pourpouses only */

from relations r
inner join (

select r.id relation_id, 
ST_Collect(w.linestring) r_polygon, 
count(*)
from relations r 
inner join relation_members rm on r.id = rm.relation_id and rm.member_type='W'
left join ways w on w.id = rm.member_id
where r.tags->'boundary'='administrative'
group by r.id
) a on r.id = a.relation_id

-- Debug
-- ADD /* before the first -- caracters of this line. Comment this code to get all the 'boundary'='administrative' polygons 
-- We have used the ST_boundary to check if a polygon is closed, because the classic command ST_isclosed(a.r_polygon) seems not to work. I don`t know why, but anyhow, this works :)
where ST_isclosed(ST_Boundary(a.r_polygon))= 'f'
-- we filter so that we only get the al=4
AND r.tags->'admin_level' = '4'
-- comment this code to get all the 'boundary'='administrative' polygons */
