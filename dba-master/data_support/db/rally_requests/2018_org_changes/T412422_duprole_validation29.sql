 
select * into temp tmp_dup from userorganizationsgroups  where id =261509;
\copy (select * from tmp_dup) to 'T412422_info_ug.csv' (FORMAT CSV,HEADER TRUE, FORCE_QUOTE *);
select * into temp tmp_dup1 from userassessmentprogram  where id =433132;
\copy (select * from tmp_dup1) to 'T412422_info_ua.csv' (FORMAT CSV,HEADER TRUE, FORCE_QUOTE *);

begin;

delete from userassessmentprogram  where id =433132;
delete from userorganizationsgroups where id =261509;

update userorganizationsgroups
set    isdefault=true
where id = 174357;

update userassessmentprogram
set    isdefault=true
where id = 471627;


commit;



