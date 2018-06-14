BEGIN;

update student
set primarydisabilitycode = 'ID',
    modifieddate =  now(),
	modifieduser =12,
	mathbandid =229,
	finalmathbandid =229,
	scibandid = 229
where id = 797651;


update student 
set legalfirstname = 'AJA''',
    legalmiddlename ='G',
    legallastname= 'JACKSON',
	dateofbirth ='2001-12-07',
	createddate ='2014-10-09 03:34:44.974+00',
	gender =0,
	primarydisabilitycode ='NULL',
	modifieddate = now(),
	modifieduser =12,
	scibandid= NULL
where id = 725407;


update enrollment 
set    studentid = 797651,
       modifieddate = now(),
       modifieduser =12
where id = 2421613;

COMMIT;