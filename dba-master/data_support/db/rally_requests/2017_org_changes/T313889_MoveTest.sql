BEGIN;

update studentstests
set activeflag = false,
    modifieddate =now(),
	modifieduser =12
where id in (14475025,14475060,14475059,14475055,14475053,14475050,14475012,14475010);



COMMIT;