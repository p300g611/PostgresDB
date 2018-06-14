\copy (select * from studentpassword ) to 'studentpassword_before.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 


select count(distinct trim(word)) from studentpassword;
select count(*) from studentpassword;


select * into temp tmp_studentpassword_duplicate from studentpassword 
where id in (
 select id from (
	select *,row_number() over (partition by trim(word) order by id) row_num
	from studentpassword ) dups
   where  row_num>1);

\copy (select * from tmp_studentpassword_duplicate) to 'studentpassword_duplicate.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *); 


begin;
delete from studentpassword 
where id in (
 select id from (
	select *,row_number() over (partition by trim(word) order by id) row_num
	from studentpassword ) dups
   where  row_num>1);
commit;


create temp table tmp_stdpwd( col1 text);
\COPY tmp_stdpwd FROM 'studentpassword_07142017.csv' DELIMITER ',' CSV HEADER ; 

select count(distinct(trim(col1))) from tmp_stdpwd src
left outer join studentpassword tgt on trim(src.col1)=trim(tgt.word)
where tgt.id is null
order by 1;

begin;

select count(*) from tmp_stdpwd;
select count(distinct trim(col1)) from tmp_stdpwd;

insert into studentpassword(word)
select distinct (trim(col1)) from tmp_stdpwd src
left outer join studentpassword tgt on trim(src.col1)=trim(tgt.word)
where tgt.id is null
order by 1;

select count(distinct trim(word)) from studentpassword;
select count(*) from studentpassword;

commit;

\copy (select * from studentpassword ) to 'studentpassword_now.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);    


select count(*) from studentpassword
where word not ilike '%i%' and  word not ilike '%l%' and word not ilike '%o%';