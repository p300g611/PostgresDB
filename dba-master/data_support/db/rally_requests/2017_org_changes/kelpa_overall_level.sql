select distinct overall_level  from studentreport where schoolyear =2017 and assessmentprogramid=47;

create temp table tmp_kelpa(school text, ssid text);
\COPY tmp_kelpa FROM 'kelpa.csv' DELIMITER ',' CSV HEADER ;

select count(*) from tmp_kelpa tmp ;
select count(distinct s.id) from tmp_kelpa tmp 
inner join student s on s.statestudentidentifier=tmp.ssid
where s.stateid=51;

select sr.id into temp tmp_report from studentreport sr
inner join student s on s.id=sr.studentid
inner join tmp_kelpa tmp on s.statestudentidentifier=tmp.ssid
where sr.schoolyear =2017 and sr.assessmentprogramid=47 and overall_level<>3;

\copy (select * from tmp_report) to 'tmp_report.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

begin;
update studentreport
set overall_level =3 
where id in (select id from tmp_report) and overall_level<>3 and schoolyear =2017 and assessmentprogramid=47;
commit;

--DW 

create temp table tmp_report(id bigint);
\COPY tmp_report FROM 'tmp_report.csv' DELIMITER ',' CSV HEADER ;

begin;
update studentreport
set overall_level =3 
where id in (select id from tmp_report) and overall_level<>3 and schoolyear =2017 and assessmentprogramid=47;
commit;