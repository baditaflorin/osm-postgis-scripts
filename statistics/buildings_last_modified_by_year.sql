-- #Version: ______
-- #Author: Florin Badita
-- #Date: DD.MM.YY
-- #Website: __________________________________
-- #Email: baditaflorin@gmail.com
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: count the number of buildings, separated by years */
-- #Start Code

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This will count all the buildings, and then will group by each year, using the extract function
Select count(*) count, extract(year from ways.tstamp) from ways
where (ways.tags -> 'building'::text) IS NOT NULL
group by extract(year from ways.tstamp)
order by date_part desc;

-- #End Code
