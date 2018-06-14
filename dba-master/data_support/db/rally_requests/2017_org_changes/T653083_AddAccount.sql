begin;

update userorganizationsgroups
 set  status =2,
      modifieddate =now(),
	  modifieduser =12
where id = 241657;

COMMIT;