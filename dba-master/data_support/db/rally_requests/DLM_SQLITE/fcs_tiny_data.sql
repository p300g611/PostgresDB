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
	        school_year:=2017;
	        start_date:=clock_timestamp();
	        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_fcs_report' and table_type='LOCAL TEMPORARY')
                 THEN DROP TABLE IF EXISTS tmp_fcs_report; END IF;
                IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_firstcontact_std' and table_type='LOCAL TEMPORARY')
                 THEN DROP TABLE IF EXISTS tmp_firstcontact_std; END IF;
	        IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_firstcontact_sqlite' and table_type='LOCAL TEMPORARY')
                 THEN DROP TABLE IF EXISTS tmp_firstcontact_sqlite; END IF;
                IF EXISTS (SELECT 1 FROM information_schema.tables WHERE table_name='tmp_fcs_ques_answ' and table_type='LOCAL TEMPORARY')
                 THEN DROP TABLE IF EXISTS tmp_fcs_ques_answ; END IF;
                create temp table tmp_fcs_ques_answ(s_no integer,
							  labeldbid integer,
							  labelnumber character varying(100),
							  label character varying(2000),
							  labelactive boolean,
							  responselabel character varying(10),
							  responsevalue character varying(2000),
							  responseorder integer,
							  responsactive boolean
							  ); 
		insert into tmp_fcs_ques_answ					  
		select row_number() over(order by labelnumber,responseorder,responselabel) s_no,sl.id labeldbid,labelnumber,label,sl.activeflag labelactive,
		       sr.responselabel,responsevalue,responseorder,sr.activeflag responsactive
			from surveylabel sl
			inner JOIN surveyresponse sr ON sr.labelid = sl.id
			order by labelnumber,responseorder,responselabel;
		create temp table tmp_firstcontact_sqlite(studentid bigint,
							  createddate date,
							  modifieddate date,
							  surveylabelnumber character varying(100),
							  surveylabel character varying(2000),
							  responselabel character varying(10),
							  responsevalue character varying(2000),
							  responsetext text
							  );
		insert into tmp_firstcontact_sqlite					  
                SELECT	s.id             studentid,
			ssr.createddate  createddate,
			ssr.modifieddate modifieddate,
			sl.labelnumber   surveylabelnumber,
			sl.label         surveylabel,
			sr.responselabel responselabel,
			sr.responsevalue responsevalue,
			ssr.responsetext responsetext
		 FROM student s
			INNER JOIN enrollment AS e on e.studentid = s.id
			INNER JOIN survey sv ON s.id = sv.studentid
			INNER JOIN studentsurveyresponse ssr ON sv.id = ssr.surveyid
			INNER JOIN surveyresponse sr ON ssr.surveyresponseid = sr.id
			INNER JOIN surveylabel sl ON sr.labelid = sl.id
			INNER JOIN studentassessmentprogram sap ON sap.studentid = s.id
			INNER JOIN assessmentprogram a ON a.id = sap.assessmentprogramid 
		 WHERE ssr.activeflag is true AND a.abbreviatedname='DLM'
		       AND e.currentschoolyear=school_year;
		 CREATE INDEX  idx1_tmp_firstcontact_sqlite ON tmp_firstcontact_sqlite (studentid);                          
		 CREATE INDEX  idx2_tmp_firstcontact_sqlite ON tmp_firstcontact_sqlite (surveylabelnumber);		 
                 create temp table tmp_firstcontact_std (studentid bigint,createddate date,modifieddate date);
		 insert into tmp_firstcontact_std
		 select studentid,min(createddate) createddate,max(modifieddate) modifieddate 
		 from tmp_firstcontact_sqlite group by studentid; 
		 CREATE INDEX  idx1_tmp_firstcontact_std ON tmp_firstcontact_std (studentid);		 
		 select string_agg(',"'||labelnumber||'" character varying(10)', ' '),
		        string_agg(',(select responselabel from firstcontact_res '||labelnumber||' where '||labelnumber||'.surveylabelnumber='||''''||
					     labelnumber||''''||' and fc.studentid='||labelnumber||'.studentid limit 1 )'||' "'||labelnumber||'"', ' ') 
					       into sqlcreate,sqlselect
					      from (select distinct labelnumber from surveylabel order by labelnumber) ord;                
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
\copy (select * from tmp_fcs_report) to '/srv/extracts/pnpdata/pnp_ReadOnlyFolder/fcs_tiny_data_2017.csv' (FORMAT CSV,header true, FORCE_QUOTE *);
\copy (select * from tmp_fcs_ques_answ) to '/srv/extracts/pnpdata/pnp_ReadOnlyFolder/fcs_ques_answ_2017.csv' (FORMAT CSV,header true, FORCE_QUOTE *);