begin;

select id,status from studentstests
where  id in (16240382,
16285088 ,
16315532 ,
16315358 ,
16315429 ,
16290039 ,
16315330 );

update studentstests
set status=86
where id in (16240382,
16285088 ,
16315532 ,
16315358 ,
16315429 ,
16290039 ,
16315330 );

commit ;
