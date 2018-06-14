BEGIN;

update organization
set    displayidentifier='531020690610000',
       modifieddate =now(),
	   modifieduser=12
where id =56041;

COMMIT;
