BEGIN;

update userassessmentprogram
  set activeflag = true,
      modifieddate = now(),
	  modifieduser =12
  where id =13898 and activeflag is false;

COMMIT;
  