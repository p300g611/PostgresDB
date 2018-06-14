BEGIN;
update aartuser
 set username = username||'_old',
     email = email||'_old',
  uniquecommonidentifier=uniquecommonidentifier||'_old',
  activeflag = false,
  modifieddate = now(),
  modifieduser =12
  where id = 125135; 

update aartuser
 set 
  uniquecommonidentifier='6817652391',
  modifieddate = now(),
  modifieduser =12
  where id = 162727;
  
  
COMMIT;