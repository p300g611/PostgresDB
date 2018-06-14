create temp table tmp_table_prod (table_schema text,table_name text,row_count bigint) ;
\COPY tmp_table_prod FROM '/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_prod.csv' DELIMITER ',' CSV HEADER ;

create temp table tmp_table_stage (table_schema text,table_name text,row_count bigint) ;
\COPY tmp_table_stage FROM '/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_stage.csv' DELIMITER ',' CSV HEADER ;


select prd.table_schema,prd.table_name,prd.row_count prod_row_count,stg.row_count stage_row_count
into temp tmp_table_diff  from tmp_table_prod prd
left outer join tmp_table_stage stg on prd.table_schema=stg.table_schema and prd.table_name=stg.table_name
where coalesce(prd.row_count,0)<>coalesce(stg.row_count,0);

\copy (select *  from tmp_table_diff) to '/srv/extracts/helpdesk/rally_requests/EPQA/sanitize/tmp_table_diff.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
