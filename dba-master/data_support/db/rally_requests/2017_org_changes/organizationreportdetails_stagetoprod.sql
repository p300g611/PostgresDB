select count(*) from organizationreportdetails;

--prod backup
\copy (select * from organizationreportdetails) to 'organizationreportdetails_0919_prod.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--stage dlm data
\copy (select * from organizationreportdetails where schoolyear =2016 and assessmentprogramid=3) to 'organizationreportdetails_0919_stage.csv' (FORMAT CSV, HEADER TRUE, FORCE_QUOTE *);

--only dlm copy restore to prod

begin;
select * into temp tmp_stage from organizationreportdetails limit 1;
delete from tmp_stage;
select * from tmp_stage;

\copy tmp_stage from 'organizationreportdetails_0919_stage.csv' delimiter ',' csv header;

select count(*) from tmp_stage;
select count(*) from organizationreportdetails;

INSERT INTO organizationreportdetails(
             assessmentprogramid, contentareaid, gradeid, organizationid, 
            schoolyear, createddate, detailedreportpath, schoolreportpdfpath, 
            schoolreportpdfsize, schoolreportzipsize, batchreportprocessid, 
            gradecourseabbrname, summaryreportpath)
select assessmentprogramid, contentareaid, gradeid, organizationid, 
            schoolyear, createddate, detailedreportpath, schoolreportpdfpath,  
            schoolreportpdfsize, schoolreportzipsize, batchreportprocessid, 
            gradecourseabbrname, summaryreportpath from tmp_stage ;

select count(*) from organizationreportdetails;
commit;   