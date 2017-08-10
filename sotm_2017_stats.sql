select 
--w_version,
sum(subquery.navigable_geometry_count) navigable_geometry_count ,
sum(subquery.navigable_geometry_lenght) navigable_geometry_lenght,
sum(subquery.tn_user_count) tn_user_count ,
sum(subquery.tn_user_length) tn_user_length ,

sum(subquery.name_count) name_count,
sum(subquery.tn_name_count) tn_name_count,
sum(subquery.name_lenght_meters) name_lenght_meters,
sum(subquery.tn_name_lenght_km) tn_name_lenght_km,

sum(subquery.oneway_count)oneway_count ,
sum(subquery.tn_oneway_count)tn_oneway_count ,
sum(subquery.oneway_lenght_meters)oneway_lenght_meters ,
sum(subquery.tn_oneway_lenght_km)tn_oneway_lenght_km ,

sum(subquery.sighpost_count)sighpost_count ,
sum(subquery.tn_sighpost_count)tn_sighpost_count 


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

(CASE WHEN  w.tags->'name' is not null and 
(user_id = '2855302'  or user_id = '2944689' or user_id = '2929338' or user_id = '2959379' or user_id = '3277198' or user_id = '4355402' or user_id = '4433679' or user_id = '4437318' or user_id = '4930407' or user_id = '4973384' or user_id = '4667454' or user_id = '4827180' or user_id = '4667606' or user_id = '4827272' or user_id = '4870032' or user_id = '4827171' or user_id = '4940486' or user_id = '5188736' or user_id = '5270261' or user_id = '5351387' or user_id = '5245700' or user_id = '5074211' or user_id = '4832980' or user_id = '4972028' or user_id = '5607966' or user_id = '5663000' or user_id = '5478253' )
THEN 1
            ELSE 0
       END  ) tn_name_count
,

(CASE WHEN w.tags->'name' is not null THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END ) name_lenght_meters -- THis will count the name lenght.
,

(CASE WHEN  w.tags->'name' is not null and 
(user_id = '2855302'  or user_id = '2944689' or user_id = '2929338' or user_id = '2959379' or user_id = '3277198' or user_id = '4355402' or user_id = '4433679' or user_id = '4437318' or user_id = '4930407' or user_id = '4973384' or user_id = '4667454' or user_id = '4827180' or user_id = '4667606' or user_id = '4827272' or user_id = '4870032' or user_id = '4827171' or user_id = '4940486' or user_id = '5188736' or user_id = '5270261' or user_id = '5351387' or user_id = '5245700' or user_id = '5074211' or user_id = '4832980' or user_id = '4972028' or user_id = '5607966' or user_id = '5663000' or user_id = '5478253' )
THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END  ) tn_name_lenght_km

,
-- Road Name END
-- Road Oneway START 
(CASE WHEN w.tags->'oneway' = 'yes' THEN 1
            ELSE 0
       END ) oneway_count -- THis will count the oneway
,
(CASE WHEN  w.tags->'oneway' = 'yes' and 
(user_id = '2855302'  or user_id = '2944689' or user_id = '2929338' or user_id = '2959379' or user_id = '3277198' or user_id = '4355402' or user_id = '4433679' or user_id = '4437318' or user_id = '4930407' or user_id = '4973384' or user_id = '4667454' or user_id = '4827180' or user_id = '4667606' or user_id = '4827272' or user_id = '4870032' or user_id = '4827171' or user_id = '4940486' or user_id = '5188736' or user_id = '5270261' or user_id = '5351387' or user_id = '5245700' or user_id = '5074211' or user_id = '4832980' or user_id = '4972028' or user_id = '5607966' or user_id = '5663000' or user_id = '5478253' )
THEN 1
            ELSE 0
       END  ) tn_oneway_count

,
(CASE WHEN  w.tags->'oneway' = 'yes' and 
(user_id = '2855302'  or user_id = '2944689' or user_id = '2929338' or user_id = '2959379' or user_id = '3277198' or user_id = '4355402' or user_id = '4433679' or user_id = '4437318' or user_id = '4930407' or user_id = '4973384' or user_id = '4667454' or user_id = '4827180' or user_id = '4667606' or user_id = '4827272' or user_id = '4870032' or user_id = '4827171' or user_id = '4940486' or user_id = '5188736' or user_id = '5270261' or user_id = '5351387' or user_id = '5245700' or user_id = '5074211' or user_id = '4832980' or user_id = '4972028' or user_id = '5607966' or user_id = '5663000' or user_id = '5478253' )
THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END  ) tn_oneway_lenght_km
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
(CASE WHEN  w.tags->'destination' is not null and 
(user_id = '2855302'  or user_id = '2944689' or user_id = '2929338' or user_id = '2959379' or user_id = '3277198' or user_id = '4355402' or user_id = '4433679' or user_id = '4437318' or user_id = '4930407' or user_id = '4973384' or user_id = '4667454' or user_id = '4827180' or user_id = '4667606' or user_id = '4827272' or user_id = '4870032' or user_id = '4827171' or user_id = '4940486' or user_id = '5188736' or user_id = '5270261' or user_id = '5351387' or user_id = '5245700' or user_id = '5074211' or user_id = '4832980' or user_id = '4972028' or user_id = '5607966' or user_id = '5663000' or user_id = '5478253' )
THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END  ) tn_sighpost_count
,
(CASE WHEN w.tags->'destination' = 'yes'  THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END ) signpost_lenght_meters -- This will measure the oneway lenght.

,
(CASE WHEN 
user_id = '2855302'  or user_id = '2944689' or user_id = '2929338' or user_id = '2959379' or user_id = '3277198' or user_id = '4355402' or user_id = '4433679' or user_id = '4437318' or user_id = '4930407' or user_id = '4973384' or user_id = '4667454' or user_id = '4827180' or user_id = '4667606' or user_id = '4827272' or user_id = '4870032' or user_id = '4827171' or user_id = '4940486' or user_id = '5188736' or user_id = '5270261' or user_id = '5351387' or user_id = '5245700' or user_id = '5074211' or user_id = '4832980' or user_id = '4972028' or user_id = '5607966' or user_id = '5663000' or user_id = '5478253' 
THEN (st_length(linestring::geography)/1000)
            ELSE 0
       END  ) tn_user_length
,
(CASE WHEN 
user_id = '2855302'  
or user_id = '2944689' 
or user_id = '2929338' 
or user_id = '2959379' 
or user_id = '3277198' 
or user_id = '4355402' 
or user_id = '4433679' 
or user_id = '4437318' 
or user_id = '4930407' 
or user_id = '4973384' 
or user_id = '4667454' 
or user_id = '4827180' 
or user_id = '4667606' 
or user_id = '4827272' 
or user_id = '4870032' 
or user_id = '4827171' 
or user_id = '4940486' 
or user_id = '5188736' 
or user_id = '5270261' 
or user_id = '5351387' 
or user_id = '5245700' 
or user_id = '5074211' 
or user_id = '4832980' 
or user_id = '4972028' 
or user_id = '5607966' 
or user_id = '5663000' 
or user_id = '5478253' 

THEN 1
            ELSE 0
       END  ) tn_user_count
,


*

 from ways w

where w.tstamp > '2016-01-01'
and w.tags->'highway' is not null
--and user_id = '2959379'



--limit 5000
) subquery
--group by w_version
--order by w_version asc
--Separate query to extract linestring for each of the following map features : 
