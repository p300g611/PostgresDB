BEGIN;

UPDATE studenttracker SET status='UNTRACKED',modifieduser = 174744, modifieddate = now()
     WHERE id IN (select id from studenttracker where studentid  in (1420534) and contentareaid in (440,3) and schoolyear=2018);

COMMIT;  
