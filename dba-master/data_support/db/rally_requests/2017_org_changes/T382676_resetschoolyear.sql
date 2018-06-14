begin;
update organization
set modifieddate=now(),
    modifieduser=12,
    schoolenddate='2017-07-31 05:00:00+00'
where organizationname in ('KAP QC State',
                           'cPass QC State',
                           'Playground QC State',
                           'ARMM QC State');
commit;                           
-- select organization_school_year(58550);
-- select organization_school_year(58549);
-- select organization_school_year(58547);
-- select organization_school_year(58538);
