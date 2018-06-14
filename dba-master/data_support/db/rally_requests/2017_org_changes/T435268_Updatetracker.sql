BEGIN;

update studenttracker
set    status='UNTRACKED',
       modifieddate=now(),
	   modifieduser=174744
where id in (417443,415808,416074);

COMMIT;
