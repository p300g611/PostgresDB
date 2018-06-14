begin;

update organization
set schoolenddate='2017-07-31 05:00:00+00',
    schoolstartdate='2016-08-04 05:00:00+00',
    modifieddate=now(),
    modifieduser=12
where id=64402;

commit;
select  organization_school_year(o.id),organizationname from organization o where id =64402;
select  distinct organization_school_year(schoolid) from organizationtreedetail  o where stateid =64402;