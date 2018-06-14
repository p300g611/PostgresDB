begin;
-- select  refresh_organization_detail() --only on fix we need to run off time on prod
-- update organizationtreedetail
-- set districtdisplayidentifier='D0361'
-- where districtid=348;

update organization
set activeflag ='false'
where activeflag='true' and id in (60025,60027,60031,60030,60028,60023,60026,60029,60024) and organizationtypeid=3

commit;



