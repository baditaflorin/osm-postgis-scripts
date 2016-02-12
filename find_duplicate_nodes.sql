-- #Version: 0.1
-- #Author: Florin Badita, Vasile Ceteras
-- #Date: 02.12.16
-- #Website: https://www.openstreetmap.org/user/baditaflorin
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: This is usefull when you want to search for duplicate nodes */
-- #Start Code

/* #TODO #FIXME
- This will only load the duplicate nodes that are part of a way. Will not search for single nodes.
- For now this will search for nodes that are closer then ~20-30 centimeters . You can tweak the setting by changing the x=10000*(trunc(st_x(geom)::numeric,4)) on the update menodes line
 */
/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
way_nodes = wn_
nodes = n_
*/


-- all the time when we run the code, we drop the old memodes, recreating the table. 
drop table if exists menodes;
-- like nodes means that will copy the structure of the nodes table into the newly created menodes
create table menodes (like nodes);
-- we add into menodes everything that is already existing in nodes
insert into menodes select * from nodes;
-- we add 3 more column, for the x,y and the count   
alter table menodes add column x int,add column y int,add column cnt int;
-- We create a index for faster processing
create index xy on menodes using btree(x,y);
create index dups  on menodes using btree(cnt);

-- This creates a grid INDEX, simlifing the geometryies to fit within a specific grid. 
update menodes set x=10000*(trunc(st_x(geom)::numeric,4)),y= 10000*(trunc(st_y(geom)::numeric,4));

-- for faster speed, we will work only with the table that will have at least 2 points that are closer then 0.0001
-- each time we will re-run the command, 
drop table if exists big;
create table big as select x,y,count(*) cnt from menodes group by x,y having count(*) > 1;
update menodes set cnt = big.cnt from big where menodes.x = big.x and menodes.y=big.y;


drop table if exists xnodes;
create table xnodes (like menodes);
insert into xnodes select * from menodes where cnt is not null;

--create a new table to have the results saved. 
/*create table dupnode as
select st_astext(m1.geom),st_astext(m2.geom),*
from xnodes m1
inner join xnodes m2 on m1.geom = m2.geom and m1.id < m2.id and m1.cnt is not null and m2.cnt is not null;*/

-- drop old data - a better elegant version for the final results
drop table if exists dupnode;
-- a better elegant version 
create table dupnode as
select st_astext(m.geom) points,geom as geom, count(*) cnt, array_agg(id) ids
from xnodes m
group by m.geom
having count(*) > 1;
-- cleanup

drop table if exists xnodes;
drop table if exists big;
drop table if exists menodes;
select * from dupnode;
-- Show more information about the duplicated nodes , information from the ways
-- # This is created so you don`t have problems loading the file into QGIS, and also so that QGIS to recognize this Column as the column that have only unique values
select ROW_NUMBER() over () as id,
-- This big.*, line will add everything that is in the temporly table called big.
big.*,
-- this w.tags will extract all the hstore tags of the way that the nodes are belonging to nodes.
w.tags 
from (

select cnt, points, way_id, array_agg(sequence_id order by sequence_id) seq,geom as geom
from
(
select cnt, points,unnest(ids) id ,geom 
from dupnode dn
) as duplicate 
inner join  way_nodes wn on wn.node_id = duplicate.id
-- order by duplicate.id
group by 1,3,2,5
) big 
inner join ways w on w.id = big.way_id

-- #End Code
