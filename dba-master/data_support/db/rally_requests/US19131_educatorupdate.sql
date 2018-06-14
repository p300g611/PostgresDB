begin;
select username,email,uniquecommonidentifier from aartuser where id=31087;


update aartuser
set username=username||'_old',
email=email||'_old',
uniquecommonidentifier=uniquecommonidentifier||'_old',
modifieduser=12,
modifieddate=now()
where id=31087;


select username,email,uniquecommonidentifier from aartuser where id=31087;

commit;