--select closed ways that are navigable roads and usually have roundabouts
create table closed_roads as
(select * from ways 
where ST_IsClosed(linestring)='t'
and (tags->'highway'='secondary' 
or tags->'highway'='secondary_link'
or tags->'highway'='tertiary'
or tags->'highway'='tertiary_link'
or tags->'highway'='residential'
or tags->'highway'='residential_link'
or tags->'highway'='driveway'
or tags->'highway'='unclassified'
or tags->'highway'='service'
or tags->'highway'='rest_area'
or tags->'highway'='road'
or tags->'highway'='track'
or tags->'highway'='undefined'
or tags->'highway'='unknown'
or tags->'highway'='living_street'));

--delete ways that already have the roundabout tags
delete from closed_roads where tags->'junction'='roundabout';

--delete long ways (more than 400 m)
delete from closed_roads 
where id in(
select id
from closed_roads
where ST_Length(ST_Transform(linestring,3857))>400);

--delete ways inappropriate number of nodes
delete from closed_roads 
where id in (
select way_id
from way_nodes 
group by way_id 
having count(way_id)>45 or count(way_id)<8);

--distance centroid -> nodes
create table dist_centroid as (SELECT t.id as way_id,
       ST_Centroid(t.linestring) AS center,
       avg(ST_Distance(dump.geom, ST_Centroid(t.linestring))*1000) AS distance,
       dump.path AS path
FROM closed_roads as t
JOIN ST_DumpPoints(t.linestring) dump ON true
GROUP BY 1, 2, 4
ORDER BY 1);

--standard deviation for distance centroid -> nodes
create table stddev_centroid as 
(SELECT way_id, stddev(distance) as deviation
FROM dist_centroid
GROUP BY way_id);

--delete the ways that have a high deviation for centroid -> nodes distance
delete from closed_roads 
where id in 
(select way_id
from stddev_centroid
where deviation>0.08);

--create segments from linestring
create table line_to_segment as(
WITH 
  sample AS 
     
       (select * from closed_roads
     ),
  line_counts(cts, id) AS 
        (SELECT ST_NPoints(linestring) -1 , id FROM sample),
  series (num , id) AS 
        (SELECT generate_series(1, cts), id FROM line_counts)
  SELECT ST_MakeLine(
               ST_PointN(linestring, num), 
               ST_PointN(linestring, num + 1)) as geom, 
        sample.id 
  FROM series 
  INNER JOIN sample ON series.id = sample.id
);

--calculate length of segments and add to table
ALTER TABLE line_to_segment
ADD length double precision;
UPDATE line_to_segment
SET length=ST_Length(ST_Transform(geom,3857));

--calculate standard deviation for segments length
create table stddev_nodes as (
SELECT id, stddev(length) as deviation
FROM line_to_segment
GROUP BY id);

--delete ways that have unequal distance between nodes
delete from closed_roads 
where id in
(select id from stddev_nodes 
where deviation>9);




--function to calculate angle between every 3 consecutive nodes of a way
DROP FUNCTION IF EXISTS max_degree(way geometry);
CREATE OR REPLACE FUNCTION max_degree(way geometry)
  RETURNS NUMERIC
  AS
  $$
  DECLARE
     i              NUMERIC;
     result         FLOAT;
     curAngle       FLOAT;
     angle          FLOAT;
     azimuth1       FLOAT;
     azimuth2       FLOAT;
     intNumPoints   NUMERIC;
     point1         geometry;
     point2         geometry;
     point3         geometry;  
BEGIN
 
   IF geometrytype(way) <> 'LINESTRING' THEN
     RETURN 9999;
   END IF;
 
   result := 0;
 
   intNumPoints := ST_NumPoints(way);
 
   FOR i IN 2..intNumPoints LOOP
      point1 := ST_PointN(way, i-1);
      point2 := ST_PointN(way, i);
      IF i + 1 <= intNumPoints THEN
         point3 := ST_PointN(way, i+1);
      ELSE
         point3 := ST_PointN(way, 1);
      END IF;
 
      azimuth1 := DEGREES(ST_Azimuth(point1, point2));
      azimuth2 := DEGREES(ST_Azimuth(point2, point3));
 
      angle := ABS(ROUND((azimuth1 - azimuth2)::DECIMAL, 2));
 
      IF angle < (360 - angle) THEN
         curAngle := angle;
      ELSE
         curAngle := 360 - angle;
      END IF;
 
      IF curAngle > result THEN
        result := curAngle;
      END IF;
 
   END LOOP;
 
   RETURN result;
 
END
$$ LANGUAGE 'plpgsql' IMMUTABLE;




--delete the ways with sharp angles
delete from closed_roads where id in 
(select id from closed_roads
where max_degree(linestring)>36);

--create table with the number of intersections each roundabout has
CREATE TABLE intersection_points as
SELECT
a.id,
    Count(ST_Intersection(a.linestring, b.linestring)) as intersections
FROM
   closed_roads as a,
   ways as b
WHERE
    ST_Touches(a.linestring, b.linestring)
    AND a.id != b.id
GROUP BY
a.id;

--delete the ways that have only one intersection
delete from closed_roads where id in (select id from intersection_points where intersections<2);

--delete intermediate tables
drop table dist_centroid;
drop table stddev_centroid;
drop table line_to_segment;
drop table stddev_nodes;
drop table intersection_points;

