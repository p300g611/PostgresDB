begin;

select count(*) from organizationtreedetail where statedisplayidentifier ='MD';

update organization
set activeflag=false
where id in (select schoolid from organizationtreedetail where statedisplayidentifier ='MD' and char_length(schooldisplayidentifier) =4 );

select refresh_organization_detail();

select count(*) from organizationtreedetail where statedisplayidentifier ='MD';

commit;

