-- #Version: ______
-- #Author: __________________________________
-- #Date: DD.MM.YY
-- #Website: __________________________________
-- #Email: __________________________________
-- #Licence AGPLv3+ - https://github.com/baditaflorin/osm-postgis-scripts/blob/master/LICENSE
/* #Example of Use: _________________________________________________________ */
-- #Start Code

/* Abrevations list 
relation_members = rl_
relations = r_
ways = w_
nodes = n_
users = u_
*/

-- # This will count all the nodes, and then will group by each year, using the extract function
Select count(*) count, extract(year from nodes.tstamp) from nodes
group by extract(year from nodes.tstamp)
order by count desc

-- #End Code
