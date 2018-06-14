--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = on;
SET check_function_bodies = false;
SET client_min_messages = warning;

--
-- Name: plpgsql; Type: EXTENSION; Schema: -; Owner: 
--

CREATE EXTENSION IF NOT EXISTS plpgsql WITH SCHEMA pg_catalog;


--
-- Name: EXTENSION plpgsql; Type: COMMENT; Schema: -; Owner: 
--

COMMENT ON EXTENSION plpgsql IS 'PL/pgSQL procedural language';


SET search_path = public, pg_catalog;

--
-- Name: tasc_xml_creation(integer, character varying); Type: FUNCTION; Schema: public; Owner: aart
--

CREATE FUNCTION tasc_xml_creation(ksdexmlauditid integer, subjectarea character varying) RETURNS xml
    LANGUAGE plpgsql
    AS $$
      BEGIN
      RETURN   
      (

select xmlelement( name "TASC_Data", 
(
select xmlagg(TASCSTAGINGROW.tascXML) from 
(SELECT 
         xmlelement(name "TASC_Record",
         xmlconcat(
         xmlelement( name "Create_Date", create_date),
         xmlelement( name "Record_Common_ID", record_common_id),
         xmlelement( name "Record_Type", record_type),
         xmlelement( name "State_Student_Identifier", state_student_identifier),
         xmlelement( name "AYP_QPA_Bldg_No", ayp_qpa_bldg_no),
         xmlelement( name "Student_Legal_Last_Name", student_legal_last_name),
         xmlelement( name "Student_Legal_First_Name", student_legal_first_name),
         xmlelement( name "Student_Legal_Middle_Name", student_legal_middle_name),
         xmlelement( name "Student_Generation_Code", student_generation_code),
         xmlelement( name "Student_Gender", student_gender),
         xmlelement( name "Current_Grade_Level", current_grade_level),
         xmlelement( name "Current_School_Year", current_school_year),
         xmlelement( name "Attendance_Bldg_No", attendance_bldg_no),
         xmlelement( name "Educator_Bldg_No", educator_bldg_no),
         xmlelement( name "State_Subj_Area_Code", state_subj_area_code),
         xmlelement( name "Local_Course_ID", local_course_id),
         xmlelement( name "Course_Status", course_status),
         xmlelement( name "Teacher_Identifier", teacher_identifier),
         xmlelement( name "Teacher_Last_Name", teacher_last_name),
         xmlelement( name "Teacher_First_Name", teacher_first_name),
         xmlelement( name "Teacher_Middle_Name", teacher_middle_name),
         xmlelement( name "Teacher_District_Email", teacher_district_email)
         )::xml
       ) as tascXML FROM tasc_record_staging where ksdexmlaudit_id = ksdexmlauditId
	and state_subj_area_code = subjectArea order by id)  TASCSTAGINGROW
       ))
      );             
      END;
       $$;


ALTER FUNCTION public.tasc_xml_creation(ksdexmlauditid integer, subjectarea character varying) OWNER TO aart;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: batchregisteredtestsessions; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE batchregisteredtestsessions (
    batchregistrationid bigint NOT NULL,
    testsessionid bigint
);


ALTER TABLE public.batchregisteredtestsessions OWNER TO aart;

--
-- Name: batchregistration; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE batchregistration (
    id bigint NOT NULL,
    submissiondate timestamp with time zone DEFAULT now() NOT NULL,
    status character varying(200),
    assessmentprogram bigint,
    testingprogram bigint,
    assessment bigint,
    testtype bigint,
    subject bigint,
    grade bigint,
    successcount integer,
    failedcount integer,
    createddate timestamp with time zone DEFAULT now() NOT NULL,
    modifieddate timestamp with time zone DEFAULT now() NOT NULL,
    createduser bigint,
    contentareaid bigint,
    batchtypecode character varying(20) DEFAULT 'BATCHAUTO'::character varying NOT NULL,
    operationaltestwindowid bigint,
    autoenrollmentmethodid bigint
);


ALTER TABLE public.batchregistration OWNER TO aart;

--
-- Name: batchregistration_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE batchregistration_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.batchregistration_id_seq OWNER TO aart;

--
-- Name: batchregistration_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aart
--

ALTER SEQUENCE batchregistration_id_seq OWNED BY batchregistration.id;


--
-- Name: batchregistrationreason; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE batchregistrationreason (
    batchregistrationid bigint NOT NULL,
    studentid bigint,
    reason text,
    testsessionid bigint
);


ALTER TABLE public.batchregistrationreason OWNER TO aart;

--
-- Name: ddl_version; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE ddl_version (
    version integer NOT NULL,
    project character varying,
    updated timestamp with time zone DEFAULT now()
);


ALTER TABLE public.ddl_version OWNER TO aart;

--
-- Name: domainaudithistory; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE domainaudithistory (
    id bigint NOT NULL,
    source character varying(25) NOT NULL,
    objecttype character varying(50) NOT NULL,
    objectid bigint NOT NULL,
    createduserid integer NOT NULL,
    createddate timestamp with time zone DEFAULT ('now'::text)::timestamp without time zone,
    action character varying(25) NOT NULL,
    objectbeforevalues json,
    objectaftervalues json
);


ALTER TABLE public.domainaudithistory OWNER TO aart;

--
-- Name: domainaudithistory_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE domainaudithistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.domainaudithistory_id_seq OWNER TO aart;

--
-- Name: domainaudithistory_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aart
--

ALTER SEQUENCE domainaudithistory_id_seq OWNED BY domainaudithistory.id;


--
-- Name: kids_record_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE kids_record_staging_id_seq
    START WITH 2000
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kids_record_staging_id_seq OWNER TO aart;

--
-- Name: kids_record_staging; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE kids_record_staging (
    id bigint DEFAULT nextval('kids_record_staging_id_seq'::regclass) NOT NULL,
    ksdexmlaudit_id bigint NOT NULL,
    create_date character varying(30),
    record_common_id character varying(30),
    record_type character varying(30),
    state_student_identifier character varying(30),
    ayp_qpa_bldg_no character varying(30),
    legal_last_name character varying(70),
    legal_first_name character varying(70),
    legal_middle_name character varying(70),
    generation_code character varying(70),
    gender character varying(10),
    current_grade_level character varying(10),
    hispanic_ethnicity character varying(10),
    current_school_year character varying(10),
    attendance_bldg_no character varying(30),
    school_entry_date character varying(30),
    district_entry_date character varying(30),
    state_entry_date character varying(30),
    comprehensive_race character varying(30),
    primary_exceptionality_code character varying(30),
    secondary_exceptionality_code character varying(30),
    grouping_math_1 character varying(50),
    grouping_math_2 character varying(50),
    grouping_reading_1 character varying(50),
    grouping_reading_2 character varying(50),
    grouping_science_1 character varying(50),
    grouping_science_2 character varying(50),
    grouping_history_1 character varying(50),
    grouping_history_2 character varying(50),
    state_math_assess character varying(10),
    state_science_assess character varying(10),
    animal_systems_assess character varying(10),
    comprehensive_ag_assess character varying(10),
    comprehensive_business_assess character varying(10),
    design_preconstruction_assess character varying(10),
    ela_proctor_id character varying(20),
    ela_proctor_name character varying(120),
    elpa21_assess character varying(10),
    esol_participation_code character varying(10),
    finance_assess character varying(10),
    general_cte_assess character varying(10),
    grouping_animal_systems character varying(50),
    grouping_comprehensive_ag character varying(50),
    grouping_comprehensive_business character varying(50),
    grouping_cte_1 character varying(50),
    grouping_cte_2 character varying(50),
    grouping_design_preconstruction character varying(50),
    grouping_elpa21_1 character varying(50),
    grouping_elpa21_2 character varying(50),
    grouping_finance character varying(50),
    grouping_manufacturing_prod character varying(50),
    grouping_plant_systems character varying(50),
    manufacturing_prod_assess character varying(10),
    math_dlm_proctor_id character varying(20),
    math_dlm_proctor_name character varying(120),
    plant_systems_assess character varying(10),
    science_dlm_proctor_id character varying(20),
    science_dlm_proctor_name character varying(120),
    state_ela_assess character varying(10),
    state_hist_gov_assess character varying(10)
);


ALTER TABLE public.kids_record_staging OWNER TO aart;

--
-- Name: kids_record_staging_2015; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE kids_record_staging_2015 (
    id bigint NOT NULL,
    ksdexmlaudit_id bigint NOT NULL,
    create_date character varying(30),
    record_common_id character varying(30),
    record_type character varying(30),
    state_student_identifier character varying(30),
    ayp_qpa_bldg_no character varying(30),
    residence_org_no character varying(30),
    legal_last_name character varying(70),
    legal_first_name character varying(70),
    legal_middle_name character varying(70),
    generation_code character varying(70),
    gender character varying(10),
    birth_date character varying(30),
    current_grade_level character varying(10),
    local_student_identifier character varying(30),
    hispanic_ethnicity character varying(10),
    current_school_year character varying(10),
    funding_bldg_no character varying(30),
    attendance_bldg_no character varying(30),
    school_entry_date character varying(30),
    district_entry_date character varying(30),
    state_entry_date character varying(30),
    user_field_1 character varying(500),
    user_field_2 character varying(500),
    user_field_3 character varying(500),
    exit_withdrawal_date character varying(30),
    exit_withdrawal_type character varying(30),
    special_circumstances_transfer character varying(30),
    post_graduation_plans character varying(30),
    sid_supplied_by_user character varying(10),
    comprehensive_race character varying(30),
    primary_exceptionality_code character varying(30),
    secondary_exceptionality_code character varying(30),
    migratory_status character varying(30),
    usa_entry_date character varying(30),
    first_language character varying(30),
    esol_participation_code character varying(30),
    esol_program_ending_date character varying(30),
    sped_program_end_date character varying(30),
    esol_program_entry_date character varying(30),
    grouping_math_1 character varying(50),
    grouping_math_2 character varying(50),
    grouping_reading_1 character varying(50),
    grouping_reading_2 character varying(50),
    grouping_science_1 character varying(50),
    grouping_science_2 character varying(50),
    grouping_history_1 character varying(50),
    grouping_history_2 character varying(50),
    grouping_writing_1 character varying(50),
    grouping_writing_2 character varying(50),
    state_math_assess character varying(10),
    state_reading_assess character varying(10),
    k8_state_sci_assess character varying(10),
    hs_state_life_sci_assess character varying(10),
    hs_state_phys_sci_assess character varying(10),
    k8_state_hist_gov_assess character varying(10),
    hs_state_hist_gov_world character varying(10),
    hs_state_hist_gov_state character varying(10),
    state_writing_assess character varying(10),
    kelpa character varying(30),
    grouping_kelpa_1 character varying(50),
    grouping_kelpa_2 character varying(50),
    state_science_assess character varying(10),
    state_history_assess character varying(10),
    cte_assess character varying(10),
    pathways_assess character varying(10),
    math_proctor_id character varying(30),
    math_proctor_name character varying(100),
    reading_proctor_id character varying(30),
    reading_proctor_name character varying(100),
    science_proctor_id character varying(30),
    science_proctor_name character varying(100),
    cte_proctor_id character varying(30),
    cte_proctor_name character varying(100)
);


ALTER TABLE public.kids_record_staging_2015 OWNER TO aart;

--
-- Name: kids_record_staging_2015_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE kids_record_staging_2015_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.kids_record_staging_2015_id_seq OWNER TO aart;

--
-- Name: kids_record_staging_2015_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aart
--

ALTER SEQUENCE kids_record_staging_2015_id_seq OWNED BY kids_record_staging_2015.id;


--
-- Name: ksdexmlaudit_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE ksdexmlaudit_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.ksdexmlaudit_id_seq OWNER TO aart;

--
-- Name: ksdexmlaudit; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE ksdexmlaudit (
    id bigint DEFAULT nextval('ksdexmlaudit_id_seq'::regclass) NOT NULL,
    type character varying(10) NOT NULL,
    xml text NOT NULL,
    createdate timestamp with time zone DEFAULT ('now'::text)::timestamp with time zone,
    processeddate timestamp with time zone,
    processedcode character varying(30),
    fromdate timestamp with time zone,
    todate timestamp with time zone,
    errors text,
    successcount integer,
    failedcount integer
);


ALTER TABLE public.ksdexmlaudit OWNER TO aart;

--
-- Name: questar_staging; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE questar_staging (
    id bigint NOT NULL,
    questar_staging_file_id bigint NOT NULL,
    createdate timestamp with time zone,
    refid text,
    assessmentadministrationrefid text,
    studentpersonalrefid text,
    walkin boolean,
    formnumber bigint,
    districtcode text,
    schoolcode text,
    subject text,
    studentfirstname text,
    studentlastname text,
    studentmiddlename text,
    grade text,
    studentkitenumber bigint,
    studentid text,
    studentdateofbirth date,
    status character varying(20),
    modifieddate timestamp with time zone,
    batchstatus character varying(20),
    sccode character varying(10),
    accommodation character varying(10)
);


ALTER TABLE public.questar_staging OWNER TO aart;

--
-- Name: questar_staging_file; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE questar_staging_file (
    id bigint NOT NULL,
    processeddate timestamp with time zone,
    filename text,
    assessmentrefid text,
    assessmentname text,
    result character varying(10),
    successcount integer,
    skipcount integer
);


ALTER TABLE public.questar_staging_file OWNER TO aart;

--
-- Name: questar_staging_file_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE questar_staging_file_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questar_staging_file_id_seq OWNER TO aart;

--
-- Name: questar_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE questar_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questar_staging_id_seq OWNER TO aart;

--
-- Name: questar_staging_response; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE questar_staging_response (
    id bigint NOT NULL,
    questar_staging_id bigint NOT NULL,
    response text,
    itemnumber bigint,
    itemname text,
    diagnosticstatement text,
    numberofattempts integer,
    intensityhex "char",
    tasktypecode character varying(75)
);


ALTER TABLE public.questar_staging_response OWNER TO aart;

--
-- Name: questar_staging_response_info_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE questar_staging_response_info_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.questar_staging_response_info_id_seq OWNER TO aart;

--
-- Name: questarregistrationreason; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE questarregistrationreason (
    batchregistrationid bigint NOT NULL,
    studentid bigint,
    reason text,
    testsessionid bigint,
    questar_staging_id bigint,
    questar_staging_file_id bigint
);


ALTER TABLE public.questarregistrationreason OWNER TO aart;

--
-- Name: stco_record_staging; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE stco_record_staging (
    id bigint NOT NULL,
    ksdexmlaudit_id bigint NOT NULL,
    create_date character varying(30),
    record_common_id character varying(30),
    record_type character varying(30),
    state_student_identifier character varying(30),
    ayp_qpa_bldg_no character varying(30),
    student_legal_last_name character varying(70),
    student_legal_first_name character varying(70),
    student_legal_middle_name character varying(70),
    student_generation_code character varying(70),
    student_gender character varying(10),
    student_birth_date character varying(30),
    current_grade_level character varying(10),
    local_student_identifier character varying(30),
    hispanic_ethnicity character varying(10),
    current_school_year character varying(10),
    attendance_bldg_no character varying(30),
    comprehensive_race character varying(30),
    educator_bldg_no character varying(30),
    kcc_id character varying(70),
    section character varying(30),
    local_course_id character varying(70),
    course_status character varying(10),
    teacher_identifier character varying(30),
    teacher_last_name character varying(70),
    teacher_first_name character varying(70),
    teacher_middle_name character varying(70)
);


ALTER TABLE public.stco_record_staging OWNER TO aart;

--
-- Name: stco_record_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE stco_record_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.stco_record_staging_id_seq OWNER TO aart;

--
-- Name: stco_record_staging_id_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: aart
--

ALTER SEQUENCE stco_record_staging_id_seq OWNED BY stco_record_staging.id;


--
-- Name: tasc_record_staging_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE tasc_record_staging_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.tasc_record_staging_id_seq OWNER TO aart;

--
-- Name: tasc_record_staging; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE tasc_record_staging (
    id bigint DEFAULT nextval('tasc_record_staging_id_seq'::regclass) NOT NULL,
    ksdexmlaudit_id bigint,
    create_date character varying(30),
    record_common_id character varying(30),
    record_type character varying(30),
    state_student_identifier character varying(30),
    ayp_qpa_bldg_no character varying(30),
    student_legal_last_name character varying(70),
    student_legal_first_name character varying(70),
    student_legal_middle_name character varying(70),
    student_generation_code character varying(70),
    student_gender character varying(10),
    current_grade_level character varying(10),
    current_school_year character varying(10),
    attendance_bldg_no character varying(30),
    educator_bldg_no character varying(30),
    state_subj_area_code character varying(30),
    local_course_id character varying(70),
    course_status character varying(10),
    teacher_identifier character varying(30),
    teacher_last_name character varying(70),
    teacher_first_name character varying(70),
    teacher_middle_name character varying(70),
    teacher_district_email character varying(70)
);


ALTER TABLE public.tasc_record_staging OWNER TO aart;

--
-- Name: useraudittrailhistory; Type: TABLE; Schema: public; Owner: aart; Tablespace: 
--

CREATE TABLE useraudittrailhistory (
    id bigint NOT NULL,
    source character varying(10),
    eventtype character varying(20),
    eventname text,
    loggedinuser bigint,
    affecteduser bigint,
    historicalvalue text,
    currentvalue text,
    lastbatchexecutiontime timestamp with time zone,
    createddate timestamp with time zone DEFAULT ('now'::text)::timestamp without time zone
);


ALTER TABLE public.useraudittrailhistory OWNER TO aart;

--
-- Name: useraudittrailhistory_id_seq; Type: SEQUENCE; Schema: public; Owner: aart
--

CREATE SEQUENCE useraudittrailhistory_id_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.useraudittrailhistory_id_seq OWNER TO aart;

--
-- Name: id; Type: DEFAULT; Schema: public; Owner: aart
--

ALTER TABLE ONLY batchregistration ALTER COLUMN id SET DEFAULT nextval('batchregistration_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: aart
--

ALTER TABLE ONLY domainaudithistory ALTER COLUMN id SET DEFAULT nextval('domainaudithistory_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: aart
--

ALTER TABLE ONLY kids_record_staging_2015 ALTER COLUMN id SET DEFAULT nextval('kids_record_staging_2015_id_seq'::regclass);


--
-- Name: id; Type: DEFAULT; Schema: public; Owner: aart
--

ALTER TABLE ONLY stco_record_staging ALTER COLUMN id SET DEFAULT nextval('stco_record_staging_id_seq'::regclass);


--
-- Name: batchregistration_pk; Type: CONSTRAINT; Schema: public; Owner: aart; Tablespace: 
--

ALTER TABLE ONLY batchregistration
    ADD CONSTRAINT batchregistration_pk PRIMARY KEY (id);


--
-- Name: ksdexmlaudit_pkey; Type: CONSTRAINT; Schema: public; Owner: aart; Tablespace: 
--

ALTER TABLE ONLY ksdexmlaudit
    ADD CONSTRAINT ksdexmlaudit_pkey PRIMARY KEY (id);


--
-- Name: pk_ddl_version; Type: CONSTRAINT; Schema: public; Owner: aart; Tablespace: 
--

ALTER TABLE ONLY ddl_version
    ADD CONSTRAINT pk_ddl_version PRIMARY KEY (version);


--
-- Name: questar_staging_file_pkey; Type: CONSTRAINT; Schema: public; Owner: aart; Tablespace: 
--

ALTER TABLE ONLY questar_staging_file
    ADD CONSTRAINT questar_staging_file_pkey PRIMARY KEY (id);


--
-- Name: questar_staging_pkey; Type: CONSTRAINT; Schema: public; Owner: aart; Tablespace: 
--

ALTER TABLE ONLY questar_staging
    ADD CONSTRAINT questar_staging_pkey PRIMARY KEY (id);


--
-- Name: questar_staging_response_info_pkey; Type: CONSTRAINT; Schema: public; Owner: aart; Tablespace: 
--

ALTER TABLE ONLY questar_staging_response
    ADD CONSTRAINT questar_staging_response_info_pkey PRIMARY KEY (id);


--
-- Name: tasc_record_staging_pkey; Type: CONSTRAINT; Schema: public; Owner: aart; Tablespace: 
--

ALTER TABLE ONLY tasc_record_staging
    ADD CONSTRAINT tasc_record_staging_pkey PRIMARY KEY (id);


--
-- Name: idx_batchregisteredtestsessions_batchregistrationid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregisteredtestsessions_batchregistrationid ON batchregisteredtestsessions USING btree (batchregistrationid);


--
-- Name: idx_batchregistration_assessment; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistration_assessment ON batchregistration USING btree (assessment);


--
-- Name: idx_batchregistration_assessmentprogram; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistration_assessmentprogram ON batchregistration USING btree (assessmentprogram);


--
-- Name: idx_batchregistration_contentareaid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistration_contentareaid ON batchregistration USING btree (contentareaid);


--
-- Name: idx_batchregistration_grade; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistration_grade ON batchregistration USING btree (grade);


--
-- Name: idx_batchregistration_subject; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistration_subject ON batchregistration USING btree (subject);


--
-- Name: idx_batchregistration_submissiondate; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistration_submissiondate ON batchregistration USING btree (submissiondate);


--
-- Name: idx_batchregistration_testingprogram; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistration_testingprogram ON batchregistration USING btree (testingprogram);


--
-- Name: idx_batchregistration_testtype; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistration_testtype ON batchregistration USING btree (testtype);


--
-- Name: idx_batchregistrationreason_batchregistrationid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistrationreason_batchregistrationid ON batchregistrationreason USING btree (batchregistrationid);


--
-- Name: idx_batchregistrationreason_studentid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_batchregistrationreason_studentid ON batchregistrationreason USING btree (studentid);


--
-- Name: idx_domainaudithistory_createduserid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_domainaudithistory_createduserid ON domainaudithistory USING btree (createduserid);


--
-- Name: idx_domainaudithistory_objectid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_domainaudithistory_objectid ON domainaudithistory USING btree (objectid);


--
-- Name: idx_domainaudithistory_objecttype; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_domainaudithistory_objecttype ON domainaudithistory USING btree (objecttype);


--
-- Name: idx_domainaudithistory_source; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_domainaudithistory_source ON domainaudithistory USING btree (source);


--
-- Name: idx_kids_record_staging_2015_currschyr; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_kids_record_staging_2015_currschyr ON kids_record_staging_2015 USING btree (current_school_year);


--
-- Name: idx_kids_record_staging_2015_ststudentid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_kids_record_staging_2015_ststudentid ON kids_record_staging_2015 USING btree (state_student_identifier);


--
-- Name: idx_kids_record_staging_currschyr; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_kids_record_staging_currschyr ON kids_record_staging USING btree (current_school_year);


--
-- Name: idx_kids_record_staging_ststudentid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_kids_record_staging_ststudentid ON kids_record_staging USING btree (state_student_identifier);


--
-- Name: idx_ksdexmlaudit_type; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_ksdexmlaudit_type ON ksdexmlaudit USING btree (type);


--
-- Name: idx_stco_record_staging_currschyr; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_stco_record_staging_currschyr ON stco_record_staging USING btree (current_school_year);


--
-- Name: idx_stco_record_staging_ststudentid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_stco_record_staging_ststudentid ON stco_record_staging USING btree (state_student_identifier);


--
-- Name: idx_tasc_record_staging_currschyear; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_tasc_record_staging_currschyear ON tasc_record_staging USING btree (current_school_year);


--
-- Name: idx_tasc_record_staging_statestudentid; Type: INDEX; Schema: public; Owner: aart; Tablespace: 
--

CREATE INDEX idx_tasc_record_staging_statestudentid ON tasc_record_staging USING btree (state_student_identifier);


--
-- Name: batchregisteredtestsessions_batchregistrationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aart
--

ALTER TABLE ONLY batchregisteredtestsessions
    ADD CONSTRAINT batchregisteredtestsessions_batchregistrationid_fkey FOREIGN KEY (batchregistrationid) REFERENCES batchregistration(id);


--
-- Name: batchregistrationreason_batchregistrationid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aart
--

ALTER TABLE ONLY batchregistrationreason
    ADD CONSTRAINT batchregistrationreason_batchregistrationid_fkey FOREIGN KEY (batchregistrationid) REFERENCES batchregistration(id);


--
-- Name: questar_staging_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: aart
--

ALTER TABLE ONLY questar_staging
    ADD CONSTRAINT questar_staging_fkey1 FOREIGN KEY (questar_staging_file_id) REFERENCES questar_staging_file(id);


--
-- Name: questar_staging_response_fkey1; Type: FK CONSTRAINT; Schema: public; Owner: aart
--

ALTER TABLE ONLY questar_staging_response
    ADD CONSTRAINT questar_staging_response_fkey1 FOREIGN KEY (questar_staging_id) REFERENCES questar_staging(id);


--
-- Name: questarregistrationreason_fileid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aart
--

ALTER TABLE ONLY questarregistrationreason
    ADD CONSTRAINT questarregistrationreason_fileid_fkey FOREIGN KEY (questar_staging_file_id) REFERENCES questar_staging_file(id) MATCH FULL;


--
-- Name: questarregistrationreason_stageid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: aart
--

ALTER TABLE ONLY questarregistrationreason
    ADD CONSTRAINT questarregistrationreason_stageid_fkey FOREIGN KEY (questar_staging_id) REFERENCES questar_staging(id) MATCH FULL;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: tasc_xml_creation(integer, character varying); Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON FUNCTION tasc_xml_creation(ksdexmlauditid integer, subjectarea character varying) FROM PUBLIC;
REVOKE ALL ON FUNCTION tasc_xml_creation(ksdexmlauditid integer, subjectarea character varying) FROM aart;
GRANT ALL ON FUNCTION tasc_xml_creation(ksdexmlauditid integer, subjectarea character varying) TO aart;
GRANT ALL ON FUNCTION tasc_xml_creation(ksdexmlauditid integer, subjectarea character varying) TO PUBLIC;


--
-- Name: batchregisteredtestsessions; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE batchregisteredtestsessions FROM PUBLIC;
REVOKE ALL ON TABLE batchregisteredtestsessions FROM aart;
GRANT ALL ON TABLE batchregisteredtestsessions TO aart;
GRANT SELECT ON TABLE batchregisteredtestsessions TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE batchregisteredtestsessions TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE batchregisteredtestsessions TO etl_user;


--
-- Name: batchregistration; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE batchregistration FROM PUBLIC;
REVOKE ALL ON TABLE batchregistration FROM aart;
GRANT ALL ON TABLE batchregistration TO aart;
GRANT SELECT ON TABLE batchregistration TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE batchregistration TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE batchregistration TO etl_user;


--
-- Name: batchregistration_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE batchregistration_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE batchregistration_id_seq FROM aart;
GRANT ALL ON SEQUENCE batchregistration_id_seq TO aart;
GRANT SELECT ON SEQUENCE batchregistration_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE batchregistration_id_seq TO aart_user;
GRANT ALL ON SEQUENCE batchregistration_id_seq TO etl_user;


--
-- Name: batchregistrationreason; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE batchregistrationreason FROM PUBLIC;
REVOKE ALL ON TABLE batchregistrationreason FROM aart;
GRANT ALL ON TABLE batchregistrationreason TO aart;
GRANT SELECT ON TABLE batchregistrationreason TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE batchregistrationreason TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE batchregistrationreason TO etl_user;


--
-- Name: ddl_version; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE ddl_version FROM PUBLIC;
REVOKE ALL ON TABLE ddl_version FROM aart;
GRANT ALL ON TABLE ddl_version TO aart;
GRANT SELECT ON TABLE ddl_version TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE ddl_version TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE ddl_version TO etl_user;


--
-- Name: domainaudithistory; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE domainaudithistory FROM PUBLIC;
REVOKE ALL ON TABLE domainaudithistory FROM aart;
GRANT ALL ON TABLE domainaudithistory TO aart;
GRANT SELECT ON TABLE domainaudithistory TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE domainaudithistory TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE domainaudithistory TO etl_user;


--
-- Name: domainaudithistory_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE domainaudithistory_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE domainaudithistory_id_seq FROM aart;
GRANT ALL ON SEQUENCE domainaudithistory_id_seq TO aart;
GRANT SELECT ON SEQUENCE domainaudithistory_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE domainaudithistory_id_seq TO aart_user;
GRANT ALL ON SEQUENCE domainaudithistory_id_seq TO etl_user;


--
-- Name: kids_record_staging_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE kids_record_staging_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE kids_record_staging_id_seq FROM aart;
GRANT ALL ON SEQUENCE kids_record_staging_id_seq TO aart;
GRANT SELECT ON SEQUENCE kids_record_staging_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE kids_record_staging_id_seq TO aart_user;
GRANT ALL ON SEQUENCE kids_record_staging_id_seq TO etl_user;


--
-- Name: kids_record_staging; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE kids_record_staging FROM PUBLIC;
REVOKE ALL ON TABLE kids_record_staging FROM aart;
GRANT ALL ON TABLE kids_record_staging TO aart;
GRANT SELECT ON TABLE kids_record_staging TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE kids_record_staging TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE kids_record_staging TO etl_user;


--
-- Name: kids_record_staging_2015; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE kids_record_staging_2015 FROM PUBLIC;
REVOKE ALL ON TABLE kids_record_staging_2015 FROM aart;
GRANT ALL ON TABLE kids_record_staging_2015 TO aart;
GRANT SELECT ON TABLE kids_record_staging_2015 TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE kids_record_staging_2015 TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE kids_record_staging_2015 TO etl_user;


--
-- Name: kids_record_staging_2015_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE kids_record_staging_2015_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE kids_record_staging_2015_id_seq FROM aart;
GRANT ALL ON SEQUENCE kids_record_staging_2015_id_seq TO aart;
GRANT SELECT ON SEQUENCE kids_record_staging_2015_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE kids_record_staging_2015_id_seq TO aart_user;
GRANT ALL ON SEQUENCE kids_record_staging_2015_id_seq TO etl_user;


--
-- Name: ksdexmlaudit_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE ksdexmlaudit_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE ksdexmlaudit_id_seq FROM aart;
GRANT ALL ON SEQUENCE ksdexmlaudit_id_seq TO aart;
GRANT SELECT ON SEQUENCE ksdexmlaudit_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE ksdexmlaudit_id_seq TO aart_user;
GRANT ALL ON SEQUENCE ksdexmlaudit_id_seq TO etl_user;


--
-- Name: ksdexmlaudit; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE ksdexmlaudit FROM PUBLIC;
REVOKE ALL ON TABLE ksdexmlaudit FROM aart;
GRANT ALL ON TABLE ksdexmlaudit TO aart;
GRANT SELECT ON TABLE ksdexmlaudit TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE ksdexmlaudit TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE ksdexmlaudit TO etl_user;


--
-- Name: questar_staging; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE questar_staging FROM PUBLIC;
REVOKE ALL ON TABLE questar_staging FROM aart;
GRANT ALL ON TABLE questar_staging TO aart;
GRANT SELECT ON TABLE questar_staging TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE questar_staging TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE questar_staging TO etl_user;


--
-- Name: questar_staging_file; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE questar_staging_file FROM PUBLIC;
REVOKE ALL ON TABLE questar_staging_file FROM aart;
GRANT ALL ON TABLE questar_staging_file TO aart;
GRANT SELECT ON TABLE questar_staging_file TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE questar_staging_file TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE questar_staging_file TO etl_user;


--
-- Name: questar_staging_file_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE questar_staging_file_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE questar_staging_file_id_seq FROM aart;
GRANT ALL ON SEQUENCE questar_staging_file_id_seq TO aart;
GRANT SELECT ON SEQUENCE questar_staging_file_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE questar_staging_file_id_seq TO aart_user;
GRANT ALL ON SEQUENCE questar_staging_file_id_seq TO etl_user;


--
-- Name: questar_staging_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE questar_staging_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE questar_staging_id_seq FROM aart;
GRANT ALL ON SEQUENCE questar_staging_id_seq TO aart;
GRANT SELECT ON SEQUENCE questar_staging_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE questar_staging_id_seq TO aart_user;
GRANT ALL ON SEQUENCE questar_staging_id_seq TO etl_user;


--
-- Name: questar_staging_response; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE questar_staging_response FROM PUBLIC;
REVOKE ALL ON TABLE questar_staging_response FROM aart;
GRANT ALL ON TABLE questar_staging_response TO aart;
GRANT SELECT ON TABLE questar_staging_response TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE questar_staging_response TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE questar_staging_response TO etl_user;


--
-- Name: questar_staging_response_info_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE questar_staging_response_info_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE questar_staging_response_info_id_seq FROM aart;
GRANT ALL ON SEQUENCE questar_staging_response_info_id_seq TO aart;
GRANT SELECT ON SEQUENCE questar_staging_response_info_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE questar_staging_response_info_id_seq TO aart_user;
GRANT ALL ON SEQUENCE questar_staging_response_info_id_seq TO etl_user;


--
-- Name: questarregistrationreason; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE questarregistrationreason FROM PUBLIC;
REVOKE ALL ON TABLE questarregistrationreason FROM aart;
GRANT ALL ON TABLE questarregistrationreason TO aart;
GRANT SELECT ON TABLE questarregistrationreason TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE questarregistrationreason TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE questarregistrationreason TO etl_user;


--
-- Name: stco_record_staging; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE stco_record_staging FROM PUBLIC;
REVOKE ALL ON TABLE stco_record_staging FROM aart;
GRANT ALL ON TABLE stco_record_staging TO aart;
GRANT SELECT ON TABLE stco_record_staging TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stco_record_staging TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stco_record_staging TO etl_user;


--
-- Name: stco_record_staging_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE stco_record_staging_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE stco_record_staging_id_seq FROM aart;
GRANT ALL ON SEQUENCE stco_record_staging_id_seq TO aart;
GRANT SELECT ON SEQUENCE stco_record_staging_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE stco_record_staging_id_seq TO aart_user;
GRANT ALL ON SEQUENCE stco_record_staging_id_seq TO etl_user;


--
-- Name: tasc_record_staging_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE tasc_record_staging_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE tasc_record_staging_id_seq FROM aart;
GRANT ALL ON SEQUENCE tasc_record_staging_id_seq TO aart;
GRANT SELECT ON SEQUENCE tasc_record_staging_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE tasc_record_staging_id_seq TO aart_user;
GRANT ALL ON SEQUENCE tasc_record_staging_id_seq TO etl_user;


--
-- Name: tasc_record_staging; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE tasc_record_staging FROM PUBLIC;
REVOKE ALL ON TABLE tasc_record_staging FROM aart;
GRANT ALL ON TABLE tasc_record_staging TO aart;
GRANT SELECT ON TABLE tasc_record_staging TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tasc_record_staging TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE tasc_record_staging TO etl_user;


--
-- Name: useraudittrailhistory; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON TABLE useraudittrailhistory FROM PUBLIC;
REVOKE ALL ON TABLE useraudittrailhistory FROM aart;
GRANT ALL ON TABLE useraudittrailhistory TO aart;
GRANT SELECT ON TABLE useraudittrailhistory TO aart_reader;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE useraudittrailhistory TO aart_user;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE useraudittrailhistory TO etl_user;


--
-- Name: useraudittrailhistory_id_seq; Type: ACL; Schema: public; Owner: aart
--

REVOKE ALL ON SEQUENCE useraudittrailhistory_id_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE useraudittrailhistory_id_seq FROM aart;
GRANT ALL ON SEQUENCE useraudittrailhistory_id_seq TO aart;
GRANT SELECT ON SEQUENCE useraudittrailhistory_id_seq TO aart_reader;
GRANT ALL ON SEQUENCE useraudittrailhistory_id_seq TO aart_user;
GRANT ALL ON SEQUENCE useraudittrailhistory_id_seq TO etl_user;


--
-- PostgreSQL database dump complete
--

