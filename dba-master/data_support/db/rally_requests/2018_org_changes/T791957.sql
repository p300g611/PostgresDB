create temp table tmp_tab(id bigint,  old  character varying(100),  new  character varying(100));
\COPY tmp_tab FROM 'de.csv' DELIMITER ',' CSV HEADER ;

select count(*) from tmp_tab;

begin;

select count(*) from organizationtreedetail ot 
inner join organization o on o.id=ot.schoolid
inner join tmp_tab tmp on tmp.id=o.id 
where o.displayidentifier=tmp.old and  statename='Delaware';

update organization o
set displayidentifier=tmp.new
,modifieddate=now()
,modifieduser =( select id from aartuser where email ='ats_dba_team@ku.edu')
from tmp_tab tmp where tmp.id=o.id;


select count(*) from organizationtreedetail ot 
inner join organization o on o.id=ot.schoolid
inner join tmp_tab tmp on tmp.id=o.id 
where o.displayidentifier=tmp.new and  statename='Delaware';

commit;
