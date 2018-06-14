BEGIN;

UPDATE userorganizationsgroups
set   status =2,
      modifieddate = now(),
	  modifieduser =12
where id  = 242401;


COMMIT;