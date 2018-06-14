BEGIN;

UPDATE userorganizationsgroups
SET isdefault = false,
    activeflag = false,
	status =1,
	modifieddate = now(),
	modifieduser=12
where id in(35234,35233,35231,13083,35230);

UPDATE userorganizationsgroups
SET isdefault = true,
	modifieddate = now(),
	modifieduser=12
where id= 35232;



UPDATE userassessmentprogram
SET isdefault = false,
    activeflag = false,
	modifieddate = now(),
	modifieduser=12
where id in(218759,218757,218756,198002,218760);



UPDATE userassessmentprogram
SET isdefault = true,
	modifieddate = now(),
	modifieduser=12
where id =218758;

COMMIT;
