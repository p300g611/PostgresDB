
 BEGIN;
 
 update aartuser
 set uniquecommonidentifier= uniquecommonidentifier||'_old',
 	modifieddate = now(),
	modifieduser = 12
  where id = 121966;
  
  
  
 update aartuser
 set uniquecommonidentifier= '7468546347',
 	modifieddate = now(),
	modifieduser = 12
  where id = 6742;
  
 COMMIT;