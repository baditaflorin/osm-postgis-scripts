-- #Version: 0.1
-- #Author: Florin Badita, Alexander Palamarchuk
-- #Date: 02.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to make a grid and count the nodes inside each cell */
-- #Start Code

/* #TODO #FIXME
Qgis not loading the table now ...
 */
/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
way_nodes = wn_
nodes = n_
*/

/* This function is created by Alexander Palamarchuk https://gis.stackexchange.com/questions/16374/how-to-create-a-regular-polygon-grid-in-postgis/23541#23541 */
CREATE OR REPLACE FUNCTION public.makegrid_2d (
  bound_polygon public.geometry,
  grid_step integer,
  metric_srid integer = 3857 --metric SRID (this particular is optimal for Europe, America)
)
RETURNS public.geometry AS
$body$
DECLARE
  BoundM public.geometry; --Bound polygon transformed to the metric projection (with metric_srid SRID)
  Xmin DOUBLE PRECISION;
  Xmax DOUBLE PRECISION;
  Ymax DOUBLE PRECISION;
  X DOUBLE PRECISION;
  Y DOUBLE PRECISION;
  sectors public.geometry[];
  i INTEGER;
BEGIN
  BoundM := ST_Transform($1, $3); --From WGS84 (SRID 4326) to the metric projection, to operate with step in meters
  Xmin := ST_XMin(BoundM);
  Xmax := ST_XMax(BoundM);
  Ymax := ST_YMax(BoundM);

  Y := ST_YMin(BoundM); --current sector's corner coordinate
  i := -1;
  <<yloop>>
  LOOP
    IF (Y > Ymax) THEN  --Better if generating polygons exceeds the bound for one step. You always can crop the result. But if not you may get not quite correct data for outbound polygons (e.g. if you calculate frequency per sector)
        EXIT;
    END IF;

    X := Xmin;
    <<xloop>>
    LOOP
      IF (X > Xmax) THEN
          EXIT;
      END IF;

      i := i + 1;
      sectors[i] := ST_GeomFromText('POLYGON(('||X||' '||Y||', '||(X+$2)||' '||Y||', '||(X+$2)||' '||(Y+$2)||', '||X||' '||(Y+$2)||', '||X||' '||Y||'))', $3);

      X := X + $2;
    END LOOP xloop;
    Y := Y + $2;
  END LOOP yloop;

  RETURN ST_Transform(ST_Collect(sectors), ST_SRID($1));
END;
$body$
LANGUAGE 'plpgsql';



-- first we drop the old table
drop table if exists cell_grid;
-- We recreate each time you run the script the table. We create this table so that the data remains loaded in the table when you load the data into Qgis
create table cell_grid as
-- this is to make Qgis Database Manager load the script into QGIS
SELECT ROW_NUMBER() over () as id,  
-- we put the name as geom so that Qgis DB Manager to know that this is the geom column 
cell as geom,
count(n.id) count 
FROM ( SELECT ( ST_Dump(makegrid_2d(ST_GeomFromText(ST_asText(ST_makepolygon(ST_Boundary(ST_Extent(geom ::geometry ))))
,4326), -- WGS84 SRID
10000))).geom cell from nodes ) as grid -- 10000 is the cell step in meters
-- we join the cell grid with the nodes, via a inner join.
inner join nodes n on st_contains(cell,geom)
group by cell;

-- We display the data that is in the cell_grid table that we made 
SELECT id, geom, count from cell_grid

-- #End Code
