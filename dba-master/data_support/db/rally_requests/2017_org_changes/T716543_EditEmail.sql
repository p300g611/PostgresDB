begin;

update aartuser 
set username ='shayjilek@tomah.k12.wi.us',
    email ='shayjilek@tomah.k12.wi.us',
	uniquecommonidentifier = 'shayjilek@tomah.k12.wi.us',
	modifieddate = now(),
	modifieduser =12
where id = 71361;

COMMIT;