select 
w_version,
sum(subquery.navigable_geometry_count) signpost_lenght_meters ,
sum(subquery.navigable_geometry_lenght) navigable_geometry_lenght,
sum(subquery.name_count) name_count,
sum(subquery.name_lenght_meters) name_lenght_meters,
sum(subquery.oneway_count)oneway_count ,
sum(subquery.oneway_lenght_meters)oneway_lenght_meters ,
sum(subquery.sighpost_count)sighpost_count ,
sum(subquery.signpost_lenght_meters) signpost_lenght_meters 

from 

(
SELECT 
w.version w_version,
-- Road Geometry START
(CASE WHEN w.tags->'highway' is not null THEN 1
            ELSE 0
       END  )navigable_geometry_count -- THis will count the name occurences.
,
(CASE WHEN w.tags->'highway' is not null THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END  )navigable_geometry_lenght -- THis will count the name occurences.
,
-- Road Geometry END
-- Road Name START 
(CASE WHEN w.tags->'name' is not null THEN 1
            ELSE 0
       END  )name_count -- THis will count the name occurences.
,
(CASE WHEN w.tags->'name' is not null THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END ) name_lenght_meters -- THis will count the name lenght.
,
-- Road Name END
-- Road Oneway START 
(CASE WHEN w.tags->'oneway' = 'yes' THEN 1
            ELSE 0
       END ) oneway_count -- THis will count the oneway
,
(CASE WHEN w.tags->'oneway' = 'yes'  THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END ) oneway_lenght_meters -- This will measure the oneway lenght.
-- Road Oneway END
-- Road Signpost START 
,
(CASE WHEN w.tags->'destination' is not null THEN 1
            ELSE 0
       END ) sighpost_count -- THis will count the oneway
,
(CASE WHEN w.tags->'destination' = 'yes'  THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END ) signpost_lenght_meters -- This will measure the oneway lenght.

,
*

 from ways w

where w.tstamp > '2016-01-01'
and w.tags->'highway' is not null
--and user_id = '2959379'



--limit 5000
) subquery
group by w_version
order by w_version asc
--Separate query to extract linestring for each of the following map features : 
