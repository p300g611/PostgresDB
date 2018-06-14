BEGIN;
update aartuser 
  set username=username||'_old',
      uniquecommonidentifier=uniquecommonidentifier||'_old',
	  email =email||'_old',
	  activeflag =false,
	  modifieddate =now(),
	  modifieduser=12
  where id = 77082;
  
  
update aartuser 
  set username= 'andrea.colicchio@chester-nj.org',
       email='andrea.colicchio@chester-nj.org',
	   uniquecommonidentifier ='andrea.colicchio@chester-nj.org',
	   modifieddate =now(),
	   modifieduser=12
  where id = 162982;
  
  
COMMIT;

