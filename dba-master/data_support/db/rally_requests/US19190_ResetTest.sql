BEGIN;
update studentstests
			set  status=84,
				modifieddate = now(),
				modifieduser =12
		        where id = 14447301 and status = 86;	

COMMIT;			