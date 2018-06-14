begin;

update userassessmentprogram 
set activeflag=false,
modifieddate=now(),
modifieduser=12
where id=398336;



update userorganizationsgroups 
set activeflag=false,
modifieddate=now(),
modifieduser=12
where id=238521;



update aartuser 
set activeflag=false,
uniquecommonidentifier=uniquecommonidentifier||'_old',
modifieddate=now(),
modifieduser=12
where id=37278;



update aartuser 
set activeflag=true,
uniquecommonidentifier='1242651748',
modifieddate=now(),
modifieduser=12
where id=155758;


update usersorganizations 
set activeflag=false,
modifieddate=now(),
modifieduser=12
where id=37210;

commit;




    