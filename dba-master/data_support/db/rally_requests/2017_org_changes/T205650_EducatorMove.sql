BEGIN;

update usersorganizations
 set   organizationid= 5860,
       modifieddate = now(),
	   modifieduser =12
where id  in (175257,175121);


COMMIT;