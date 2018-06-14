BEGIN;

update studentassessmentprogram
set activeflag = true
where id in (77244,59462);

COMMIT;
    