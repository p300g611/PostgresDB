BEGIN;

update aartuser
set   
	   uniquecommonidentifier='kdubuque@tamworth.k12.nh.us',
	   modifieddate =now(),
	   modifieduser =174744
where id =104511;

COMMIT;