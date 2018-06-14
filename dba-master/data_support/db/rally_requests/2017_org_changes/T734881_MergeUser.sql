
BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =56401;


update aartuser
set    username='jdillner@abileneschools.org',
       email='jdillner@abileneschools.org',
	   uniquecommonidentifier='7418979657',
	   modifieddate =now(),
	   modifieduser =12
where id =163228; 

UPDATE  userorganizationsgroups
SET    status =2,
 	   modifieddate =now(),
	   modifieduser =12
where  id =238828;  


update roster 
set teacherid = 163228,
  	   modifieddate =now(),
	   modifieduser =12
where  teacherid =56401; 

update userpdtrainingdetail
set    userid = 163228,
 	   modifieddate =now(),
	   modifieduser =12
where  id in (3908,996);


COMMIT;    