begin
update organization set displayidentifier='00000'||displayidentifier, 
modifieddate=now(), modifieduser=(select id from aartuser where username ='ats_dba_team@ku.edu'),
activeflag=false
where id in ( 65214,
66014
);
commit;

