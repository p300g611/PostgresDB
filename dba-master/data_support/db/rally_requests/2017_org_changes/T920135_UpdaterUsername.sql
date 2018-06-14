BEGIN;

update student 
set  username = 'int.demo.k',
     modifieddate=now(),
	 modifieduser=12
where id = 1349026;


update student 
set  username = 'int.demo.1',
     modifieddate=now(),
	 modifieduser=12
where id = 1349027;

update student 
set  username = 'int.demo.2-3',
     modifieddate=now(),
	 modifieduser=12
where id = 1349028;

update student 
set  username = 'int.demo.4-5',
     modifieddate=now(),
	 modifieduser=12
where id = 1349029;

update student 
set  username = 'int.demo.6-12',
     modifieddate=now(),
	 modifieduser=12
where id = 1349030;


COMMIT;