-- select id,statestudentidentifier from student where statestudentidentifier ilike '%`%';
-- select id,statestudentidentifier from student where statestudentidentifier ilike '%�%';
-- select id,statestudentidentifier from student where statestudentidentifier  ~* '[^a-z0-9]';
-- select ascii('a')
-- SELECT regexp_replace('Well- This Did-Not work&*($%%)_', '[^a-zA-Z0-9" ""-"]+', '','g')


select id,statestudentidentifier,regexp_replace(statestudentidentifier,'[^a-z" "A-Z"-"0-9"_"/\!:''-DUPLICATE''''z_'']','','g') newssid 
from student where statestudentidentifier  ~* '[^a-z" "A-Z"-"0-9"_"/\!:''-DUPLICATE''''z_'']';

begin;

update student 
set statestudentidentifier=regexp_replace(statestudentidentifier,'[^a-z" "A-Z"-"0-9"_"/\!:''-DUPLICATE''''z_'']','','g')
,modifieddate=now()
,modifieduser=12
where statestudentidentifier  ~* '[^a-z" "A-Z"-"0-9"_"/\!:''-DUPLICATE''''z_'']';

commit;



