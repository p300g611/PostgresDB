BEGIN;

update enrollment
set activeflag =false,
    modifieddate=now(),
	modifieduser=12
where id in (2788422,
			2642202,
			2642204,
			2642208,
			2642214,
			2642215,
			2642198,
			2642199,
			2642200,
			2642201,
			2642203,
			2642205,
			2642206,
			2642207,
			2642210,
			2642211,
			2642212,
			2642213,
			2642209,
			2642196,
			2642197,
			2642216,
			2642217
			);
			
			
update enrollmentsrosters 
set    activeflag =false,
       modifieddate=now(),
	   modifieduser =12
where enrollmentid in 
            (2788422,
			2642202,
			2642204,
			2642208,
			2642214,
			2642215,
			2642198,
			2642199,
			2642200,
			2642201,
			2642203,
			2642205,
			2642206,
			2642207,
			2642210,
			2642211,
			2642212,
			2642213,
			2642209,
			2642196,
			2642197,
			2642216,
			2642217
			);
			
COMMIT;
