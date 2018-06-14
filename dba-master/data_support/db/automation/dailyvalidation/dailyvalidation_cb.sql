\set VERBOSITY terse
DO
$BODY$
DECLARE
       row_count integer;
       tmp_count record;
       start_date timestamp with time zone;
       end_date timestamp with time zone;
       run_time interval;
BEGIN
     row_count:=0;
     start_date:=clock_timestamp();     
     RAISE NOTICE 'CB Validation process started:%',start_date;
--Validation(1)
     select count(distinct contenttypeid) into row_count from cb.contentdeployment where statuscode='IN_PROGRESS' and modifieddate<=current_timestamp-interval '10 minute';
     RAISE NOTICE 'Validation(1) IN_PROGRESS Publishing Test count:%',row_count;						   
     FOR tmp_count IN (select contenttypeid,modifieddate,statuscode from cb.contentdeployment where statuscode='IN_PROGRESS' and modifieddate<=current_timestamp-interval '10 minute' limit 100)
      		LOOP
			RAISE NOTICE 'Validation(1) IN_PROGRESS Publishing Test count sample data out of % (issue contenttypeid:%,modifieddate:%,statuscode:%)',row_count,tmp_count.contenttypeid,tmp_count.modifieddate,tmp_count.statuscode;
		END LOOP;   
     end_date:=clock_timestamp();    
     RAISE NOTICE 'CB Validation process ended:%',end_date;
     run_time := (extract(epoch from end_date) - extract(epoch from start_date));
     RAISE NOTICE 'script run time=%', run_time; 
END;
$BODY$;	