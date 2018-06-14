BEGIN;


update usersorganizations
  set organizationid = 20205,
      modifieddate = now(),
      modifieduser = 12
   where id = 187785;

update userorganizationsgroups
  set status = 2,
      modifieddate = now(),
      modifieduser = 12
   where id = 239868;
   
   
COMMIT;