--update duplicate roster 
--studentid:640605,1472138,880413
begin;

select  dlm_duplicate_roster_update(2018, 640605,3,'for ticket#335511' );
select  dlm_duplicate_roster_update(2018, 640605,440,'for ticket#335511');


select  dlm_duplicate_roster_update(2018, 1472138,3,'for ticket#335511' );
select  dlm_duplicate_roster_update(2018, 1472138,440,'for ticket#335511');
select  dlm_duplicate_roster_update(2018, 1472138,437,'for ticket#335511');



select  dlm_duplicate_roster_update(2018, 880413,437,'for ticket#335511');
select  dlm_duplicate_roster_update(2018, 880413,441,'for ticket#335511');


commit;
