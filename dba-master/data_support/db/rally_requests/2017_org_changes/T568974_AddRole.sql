BEGIN;

update aartuser
set   
	   activeflag =true,
	   modifieddate =now(),
	   modifieduser =174744
where id =173100;



update usersorganizations
set organizationid=84598, 
    activeflag =true,
    modifieddate= now(),
	modifieduser =174744
where id  = 202380;


COMMIT;
