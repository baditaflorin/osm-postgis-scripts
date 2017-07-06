select ROW_NUMBER() over () as unique_id,
tags->'osm_user' As osm_user,
(tags->'osm_timestamp')::timestamp with time zone As osm_timestamp,

(tags->'osm_timestamp')::timestamp with time zone - interval '1 month' offset_one_month_tstamp,
(tags->'osm_timestamp')::timestamp with time zone - interval '7 days' offset_one_week_tstamp,
(tags->'osm_timestamp')::timestamp with time zone - interval '1 days' offset_one_day_tstamp,

(tags->'osm_timestamp')::timestamp with time zone + interval '1 month' offset_plus_one_month_tstamp,
(tags->'osm_timestamp')::timestamp with time zone + interval '7 days' offset_plus_one_week_tstamp,
(tags->'osm_timestamp')::timestamp with time zone + interval '1 days' offset_plus_one_day_tstamp,

way geom

from planet_osm_line
--limit 5
