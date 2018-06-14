BEGIN;


update enrollmentsrosters
set    enrollmentid= 2883836,
       activeflag =true,
       modifieddate=now(),
	   modifieduser =174744
where id in (15019979,15019980) and activeflag is false;


END;