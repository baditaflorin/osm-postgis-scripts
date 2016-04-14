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
drop table if exists comparation;

create table comparation as Select ROW_NUMBER() over () as primary_id, * from (

select 
-- Just a ugly fix to be simple when i copy and paste from here so that everytime the comparation.geom geometry will exist 
linestring geom

,* from ways where (ways.tags -> 'highway'::text) IS NOT NULL
) subquery;

-- ALTER TABLE al_4 DROP CONSTRAINT al_4_pkey;

ALTER TABLE al_4
  ADD CONSTRAINT al_4_pkey PRIMARY KEY(id);

CREATE INDEX al_4_index
  ON al_4
  USING gist
  (geom);


ALTER TABLE comparation
  ADD CONSTRAINT comparation_pkey PRIMARY KEY(primary_id);

CREATE INDEX comparation_index
  ON comparation
  USING gist
  (geom);



-----

select al_4.boundary_name,sum(ST_length(linestring,false)),count(*) from comparation 
inner join al_4 on st_contains(al_4.geom,comparation.geom)

group by al_4.boundary_name
order by al_4.boundary_name
