select table_schema, 
       table_name, 
       (xpath('/row/cnt/text()', xml_count))[1]::text::int as row_count
into temp tmp_table       
from (
  select table_name, table_schema, 
         query_to_xml(format('select count(*) as cnt from %I.%I', table_schema, table_name), false, true, '') as xml_count
  from information_schema.tables
  where table_schema not in ('information_schema','pg_catalog')--= 'public' --<< change here for the schema you want
) t
order by table_name;

\copy (select *  from tmp_table) to '/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);