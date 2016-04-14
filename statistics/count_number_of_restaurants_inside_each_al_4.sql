-- all the time when we run the code, we drop the old table, recreating the table. 
drop table if exists al_4;
create table al_4 as 

-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS will recognize this Column as the column that have only unique values
SELECT ROW_NUMBER() over () as id , 
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
;


------------------------------------------------------------------------
------------------------------------------------------------------------
------------------------------------------------------------------------

-- all the time when we run the code, we drop the old table, recreating the table. 
drop table if exists amenity;

create table amenity as Select ROW_NUMBER() over () as id, * from (


-- insert the filter that will leave you with only yhe nodes, ways that you want, so we can count them inside each al_4 

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
WHERE users.id=ways.user_id 
AND ((tags->'amenity')) is not null
AND tags->'amenity'='restaurant'
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
AND tags->'amenity'='restaurant'
) subquery;

-- ALTER TABLE al_4 DROP CONSTRAINT al_4_pkey;

ALTER TABLE al_4
  ADD CONSTRAINT al_4_pkey PRIMARY KEY(id);

CREATE INDEX al_4_index
  ON al_4
  USING gist
  (geom);


ALTER TABLE amenity
  ADD CONSTRAINT amenity_pkey PRIMARY KEY(id);

CREATE INDEX amenity_index
  ON amenity
  USING gist
  (geom);



-----

select al_4.boundary_name,count (*) from amenity 
inner join al_4 on st_contains(al_4.geom,amenity.geom)

group by al_4.boundary_name
