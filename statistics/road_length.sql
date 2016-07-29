select sum(st_length(linestring::geography)/1000) km,ways.tags->'highway' As w_highway from ways
group by w_highway
order by km desc
