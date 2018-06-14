DO
$BODY$
	DECLARE 
        school_year integer;
	BEGIN
	        school_year:=2018;
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
        SELECT	s.id         studentid,
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
      END;
 $BODY$;
\copy (select distinct labelnumber from surveylabel order by labelnumber) to '/srv/extracts/pnpdata/tmp_labelnumber.csv' (FORMAT CSV,header true, FORCE_QUOTE *);
\copy (select * from tmp_firstcontact_sqlite) to '/srv/extracts/pnpdata/tmp_firstcontact_sqlite.csv' (FORMAT CSV,header true, FORCE_QUOTE *);
\copy (select * from tmp_fcs_ques_answ) to '/srv/extracts/pnpdata/pnp_ReadOnlyFolder/fcs_ques_answ.csv' (FORMAT CSV,header true, FORCE_QUOTE *);