select ROW_NUMBER() over () as unique_id,
tags->'highway' highway,
tstamp - interval '1 month' offset_one_month_tstamp,
tstamp - interval '7 days' offset_one_week_tstamp,
tstamp - interval '1 days' offset_one_day_tstamp,
* from ways
