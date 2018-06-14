BEGIN;

update studentassessmentprogram
set activeflag = true
where id in (77244,59462);

update studentassessmentprogram
set activeflag = false
where id in (706948,886845);

COMMIT;