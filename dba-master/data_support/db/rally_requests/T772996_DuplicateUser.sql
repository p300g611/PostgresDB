BEGIN;

--ezepeda@usd263.org the students do not enroll in the prod. 

--jennhansen@usd263.org
UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =132402;


update roster 
set    teacherid = 10673,
       modifieddate= now(),
	   modifieduser =12
where id  = 900009;

--jryherd@usd263.org 
UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =19481;

--jhansen@usd263.org


--kcunningham@usd263.org


--ksimon@usd263.org


commit;




