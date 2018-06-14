BEGIN;


update enrollment
set   activeflag =false,
      notes='As for ticket #507787',
      modifieddate =now(),
	  modifieduser =174744
where id = 2927196;


update enrollmentsrosters 
set    activeflag =false,
      modifieddate=now(),
	  modifieduser=174744
where id in (15589842,15589841);


COMMIT;
