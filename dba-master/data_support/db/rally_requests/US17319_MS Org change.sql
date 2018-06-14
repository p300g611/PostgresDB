DO
$BODY$
DECLARE
 now_date timestamp with time zone; 
 row_count integer;
BEGIN
now_date :=now();

update organization 
set activeflag=true ,
    modifieddate=now_date,
	modifieduser=12
	where displayidentifier in ( '22_4120','92_4120','18_4120','500_4120','94_4120','90_4120') and activeflag=false;     

		row_count:= (select count(*) from organization where modifieddate=now_date and 	modifieduser=12);

		RAISE NOTICE 'rows updated on organization: %' , row_count;	
				       
		   
END;
$BODY$; 



