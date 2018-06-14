begin;
update aartuser 
set uniquecommonidentifier='',
    modifieduser=12,
    modifieddate=now()
where activeflag is false;
commit;
