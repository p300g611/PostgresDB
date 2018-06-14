BEGIN;

--SSID:  5259874587 
update enrollment
set   activeflag =false,
      notes='As for ticket #577398',
      modifieddate =now(),
	  modifieduser =174744
where id = 2914380;


update enrollmentsrosters 
set    activeflag =false,
      modifieddate=now(),
	  modifieduser=174744
where id in (15559951,15559950,15559949);


COMMIT;
