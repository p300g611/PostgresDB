-- Table: public.dashboardatscalllinedaily

-- DROP TABLE public.dashboardatscalllinedaily;
CREATE TABLE dashboardatscalllinedaily
(
  call_id int,
  segment int,
  row_date date,
  row_time time,
  segstart time,
  segstop time,
  duration int,
  calling_party char(30),
  dialed_number bigint,
  dispivector int,
  disposition varchar(10),
  disposition_time int,
  dispsplit int,
  ans_logid int,
  talk_time int,
  hold_time int,
  acw_time int,
  transout char(1),
  conf char(1),
  assist char(1),
  acd  int,
  hold_talk int--,
  --CONSTRAINT call_line_pk PRIMARY KEY (call_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardatscalllinedaily
  OWNER TO postgres;
GRANT ALL ON TABLE dashboardatscalllinedaily TO postgres;


-- Table: public.dashboardatscalllinearchive

-- DROP TABLE public.dashboardatscalllinearchive;

CREATE TABLE dashboardatscalllinearchive
(
  id bigserial NOT NULL,
  call_id int,
  segment int,
  row_date date,
  row_time time,
  segstart time,
  segstop time,
  duration int,
  calling_party char(30),
  dialed_number bigint,
  dispivector int,
  disposition varchar(10),
  disposition_time int,
  dispsplit int,
  ans_logid int,
  talk_time int,
  hold_time int,
  acw_time int,
  transout char(1),
  conf char(1),
  assist char(1),
  acd  int,
  hold_talk int,
  createddate  timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone,
  modifieddate timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone,
  CONSTRAINT callachive_line_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardatscalllinearchive
  OWNER TO postgres;
GRANT ALL ON TABLE dashboardatscalllinearchive TO postgres;

--=======================================================
-- Table: public.dashboardatstenticketsdaily

-- DROP TABLE dashboardatstenticketsdaily;
CREATE TABLE dashboardatstenticketsdaily
(
  ticket_number int,
  date timestamp,
  subject varchar(200),
  from_user varchar(100),
  from_email varchar(100),
  priority varchar(20),
  department varchar(20),
  help_topic varchar(100),
  source varchar(20),
  current_status varchar(20),
  last_updated timestamp,
  due_date timestamp,
  overdue smallint,
  answered smallint,
  assigned_to varchar(100),
  agent_assigned varchar(100),
  team_assigned varchar(100),
  nine_minute_flag varchar(3),
  program varchar(10),
  state varchar(20),
  district varchar(20),
  school varchar(100),
  defect varchar(10),
  policy varchar(3),
  resolution varchar(100),
  user_file varchar(3),
  roster_file varchar(3),
  enrollment_file varchar(3),
  tec_file varchar(3),
  CONSTRAINT daily_10_pk PRIMARY KEY (ticket_number)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardatstenticketsdaily
  OWNER TO postgres;
GRANT ALL ON TABLE dashboardatstenticketsdaily TO postgres;


-- Table: public.dashboardatstenticketsachive
-- DROP TABLE public.dashboardatstenticketsachive;
CREATE TABLE dashboardatstenticketsachive
(  
  id bigserial NOT NULL,
  ticket_number int,
  date timestamp,
  subject varchar(200),
  from_user varchar(100),
  from_email varchar(100),
  priority varchar(20),
  department varchar(20),
  help_topic varchar(100),
  source varchar(20),
  current_status varchar(20),
  last_updated timestamp,
  due_date timestamp,
  overdue smallint,
  answered smallint,
  assigned_to varchar(100),
  agent_assigned varchar(100),
  team_assigned varchar(100),
  nine_minute_flag varchar(3),
  program varchar(10),
  state varchar(20),
  district varchar(20),
  school varchar(100),
  defect varchar(10),
  policy varchar(3),
  resolution varchar(100),
  user_file varchar(3),
  roster_file varchar(3),
  enrollment_file varchar(3),
  tec_file varchar(3),
  createddate timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone,
  modifieddate timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone,
  CONSTRAINT tickets_10_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE dashboardatstenticketsachive
  OWNER TO postgres;
GRANT ALL ON TABLE dashboardatstenticketsachive TO postgres;
--=======================
-- Table: public.dashboardatsosticketdaily

-- DROP TABLE public.dashboardatsosticketdaily;

CREATE TABLE public.dashboardatsosticketdaily
(
  ticket_number integer NOT NULL,
  date timestamp without time zone,
  subject character varying(200),
  from_user character varying(100),
  from_email character varying(100),
  priority character varying(20),
  department character varying(20),
  help_topic character varying(100),
  source character varying(20),
  current_status character varying(20),
  last_updated timestamp without time zone,
  due_date timestamp without time zone,
  overdue smallint,
  answered smallint,
  assigned_to character varying(100),
  agent_assigned character varying(100),
  team_assigned character varying(100),
  nine_minute_flag character varying(3),
  program character varying(10),
  state character varying(20),
  district character varying(20),
  school character varying(100),
  defect character varying(10),
  policy character varying(3),
  resolution character varying(100),
  user_file character varying(3),
  roster_file character varying(3),
  enrollment_file character varying(3),
  tec_file character varying(3),
  include smallint,
  include_open smallint,
  days_to_update numeric,
  age_since_created numeric,
  age_since_updated numeric,
  created_date date,
  in_current_year smallint,
  include_pending smallint,
  include_open_current_year smallint,
  include_pending_current_year smallint,
  include_current_year smallint,
  last_30 smallint,
  last_30_include smallint,
  last_30_pending_include smallint,
  last_30_open_include smallint,
  last_7 smallint,
  last_7_include smallint,
  last_7_pending_include smallint,
  last_7_open_include smallint--,
  --CONSTRAINT os_tickets_pk PRIMARY KEY (ticket_number)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.dashboardatsosticketdaily
  OWNER TO postgres;
GRANT ALL ON TABLE public.dashboardatsosticketdaily TO postgres;

-- Table: public.dashboardatsosticketachive

-- DROP TABLE public.dashboardatsosticketachive;

CREATE TABLE public.dashboardatsosticketachive
(
  id bigserial not null,
  ticket_number integer NOT NULL,
  date timestamp without time zone,
  subject character varying(200),
  from_user character varying(100),
  from_email character varying(100),
  priority character varying(20),
  department character varying(20),
  help_topic character varying(100),
  source character varying(20),
  current_status character varying(20),
  last_updated timestamp without time zone,
  due_date timestamp without time zone,
  overdue smallint,
  answered smallint,
  assigned_to character varying(100),
  agent_assigned character varying(100),
  team_assigned character varying(100),
  nine_minute_flag character varying(3),
  program character varying(10),
  state character varying(20),
  district character varying(20),
  school character varying(100),
  defect character varying(10),
  policy character varying(3),
  resolution character varying(100),
  user_file character varying(3),
  roster_file character varying(3),
  enrollment_file character varying(3),
  tec_file character varying(3),
  include smallint,
  include_open smallint,
  days_to_update numeric,
  age_since_created numeric,
  age_since_updated numeric,
  created_date date,
  in_current_year smallint,
  include_pending smallint,
  include_open_current_year smallint,
  include_pending_current_year smallint,
  include_current_year smallint,
  last_30 smallint,
  last_30_include smallint,
  last_30_pending_include smallint,
  last_30_open_include smallint,
  last_7 smallint,
  last_7_include smallint,
  last_7_pending_include smallint,
  last_7_open_include smallint,
  createddate timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone,
  modifieddate timestamp with time zone NOT NULL DEFAULT ('now'::text)::timestamp with time zone,
  CONSTRAINT os_tickets_pk PRIMARY KEY (id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE public.dashboardatsosticketachive
  OWNER TO postgres;
GRANT ALL ON TABLE public.dashboardatsosticketachive TO postgres;





