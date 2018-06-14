--aart-stage(need to be on aai_backup_sa user)


select count(*) from batchupload;
select count(*) from batchuploadreason ;

\copy (select * from batchupload) to 'batchupload.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);
\copy (select * from batchuploadreason ) to 'batchuploadreason.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--aart-audit
-- need to truncate the existing table then insert 

-- truncate table batchupload;
-- truncate table batchuploadreason;

\COPY batchupload FROM 'batchupload.csv' DELIMITER ',' CSV HEADER ; 

-- select nextval('batchupload_id_seq1'::regclass)--do not run this this will show the value but skip next val  

SELECT last_value FROM batchupload_id_seq;
select max(id) from batchupload ;                       --55894 (max value)
ALTER SEQUENCE batchupload_id_seq RESTART WITH 56080;  -- replcae 55895= max values+1  
SELECT last_value FROM batchupload_id_seq;


\COPY batchuploadreason FROM 'batchuploadreason.csv' DELIMITER ',' CSV HEADER ; 

select count(*) from batchupload;       --55894
select count(*) from batchuploadreason ;--18354059

-- Foreign Key: batchuploadreason_batchuploadid_fkey

-- ALTER TABLE batchuploadreason DROP CONSTRAINT batchuploadreason_batchuploadid_fkey;

ALTER TABLE batchuploadreason
  ADD CONSTRAINT batchuploadreason_batchuploadid_fkey FOREIGN KEY (batchuploadid)
      REFERENCES batchupload (id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION;



CREATE INDEX idx_batchuploadreason_batchuploadid
  ON batchuploadreason
  USING btree
  (batchuploadid);

-- Index: idx_batchuploadreason_fieldname

-- DROP INDEX idx_batchuploadreason_fieldname;

CREATE INDEX idx_batchuploadreason_fieldname
  ON batchuploadreason
  USING btree
  (fieldname COLLATE pg_catalog."default");

-- Index: idx_batchuploadreason_line

-- DROP INDEX idx_batchuploadreason_line;

CREATE INDEX idx_batchuploadreason_line
  ON batchuploadreason
  USING btree
  (line COLLATE pg_catalog."default");    