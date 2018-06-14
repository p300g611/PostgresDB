create temp table tmp_firstcontact_sqlite(studentid bigint,
							  createddate date,
							  modifieddate date,
							  surveylabelnumber character varying(100),
							  surveylabel character varying(2000),
							  responselabel character varying(10),
							  responsevalue character varying(2000),
							  responsetext text
							  );							  
\COPY tmp_firstcontact_sqlite FROM '/srv/extracts/pnpdata/tmp_firstcontact_sqlite.csv' DELIMITER ',' CSV HEADER ; 							  
CREATE INDEX  idx1_tmp_firstcontact_sqlite ON tmp_firstcontact_sqlite (studentid);                          
CREATE INDEX  idx2_tmp_firstcontact_sqlite ON tmp_firstcontact_sqlite (surveylabelnumber);	
create temp table tmp_labelnumber(labelnumber character varying(100));
\COPY tmp_labelnumber FROM '/srv/extracts/pnpdata/tmp_labelnumber.csv' DELIMITER ',' CSV HEADER ;
DO
$BODY$
	DECLARE 
		tmp_table record;
		sqlcreate text;
		sqlselect text;
		sqlfcs text;
		row_num integer;
		tmp_total integer;
		start_date timestamp with time zone;
        end_date timestamp with time zone;
        run_time interval;
        school_year integer;
	BEGIN
            sqlcreate:='';
	        sqlselect:='';
	        sqlfcs:='';
	        row_num:=0;
	        tmp_total:=0;
	        school_year:=2018;
	        start_date:=clock_timestamp();
	        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_fcs_report' and table_type='LOCAL TEMPORARY')
                 THEN DROP TABLE IF EXISTS tmp_fcs_report; END IF;
            IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_firstcontact_std' and table_type='LOCAL TEMPORARY')                 THEN DROP TABLE IF EXISTS tmp_firstcontact_std; END IF;
         create temp table tmp_firstcontact_std (studentid bigint,createddate date,modifieddate date);
		 insert into tmp_firstcontact_std
		 select studentid,min(createddate) createddate,max(modifieddate) modifieddate 
		 from tmp_firstcontact_sqlite group by studentid; 
		 CREATE INDEX  idx1_tmp_firstcontact_std ON tmp_firstcontact_std (studentid);		 
		 select string_agg(',"'||labelnumber||'" character varying(10)', ' '),
		        string_agg(',(select responselabel from firstcontact_res '||labelnumber||' where '||labelnumber||'.surveylabelnumber='||''''||
					     labelnumber||''''||' and fc.studentid='||labelnumber||'.studentid limit 1 )'||' "'||labelnumber||'"', ' ') 
					       into sqlcreate,sqlselect
					      from tmp_labelnumber ord;                
		sqlcreate:='create temp table tmp_fcs_report(studentid bigint,createddate date,modifieddate date'||sqlcreate||');';
		sqlselect:='insert into tmp_fcs_report 
		            with firstcontact_res as 
                                (select fc.studentid,fc.responselabel,fc.surveylabelnumber
                            from tmp_firstcontact_sqlite fc where fc.studentid=##$tmp_studentid$##) 
		            SELECT fc.studentid,fc.createddate,fc.modifieddate'||sqlselect||' from tmp_firstcontact_std fc 
		            where fc.studentid=##$tmp_studentid$##;';
		--RAISE NOTICE '%', sqlcreate;
                --RAISE NOTICE '%', sqlselect; 
                --RAISE NOTICE '%', school_year; 
		EXECUTE sqlcreate; 
		select count(1) from tmp_firstcontact_std into tmp_total;
      FOR tmp_table IN (select studentid from tmp_firstcontact_std order by studentid)
      LOOP 
      row_num=row_num+1;       
      --Raise info 'studentid:% current row:% of total count:% ',tmp_table.studentid,row_num,tmp_total;
      select replace(sqlselect,'##$tmp_studentid$##',tmp_table.studentid::text) into sqlfcs;
--       RAISE NOTICE '%', sqlselect;
      EXECUTE sqlfcs;                    		        
      end loop;	
      end_date:=clock_timestamp();    
      run_time := (extract(epoch from end_date) - extract(epoch from start_date));
      --RAISE NOTICE 'script run time=%', run_time;	                                    
      END;
 $BODY$;
\copy (select * from tmp_fcs_report) to '/srv/extracts/pnpdata/pnp_ReadOnlyFolder/fcs_tiny_data.csv' (FORMAT CSV,header true, FORCE_QUOTE *);