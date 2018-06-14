 
select * into temp tmp_dup from userorganizationsgroups  where id =263908;
\copy (select * from tmp_dup) to 'T648156_info_ug.csv' (FORMAT CSV,HEADER TRUE, FORCE_QUOTE *);
select * into temp tmp_dup from userassessmentprogram  where id =436117;
\copy (select * from tmp_dup) to 'T648156_info_ua.csv' (FORMAT CSV,HEADER TRUE, FORCE_QUOTE *);

begin;

delete from userassessmentprogram  where id =436117;
delete from userorganizationsgroups where id =263908;


commit;



