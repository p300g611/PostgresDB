--duplicate roster validation39
--studentid:873826,1423611
begin;
select  dlm_duplicate_roster_update(2018, 873826,3,'for ticket#314790' );
select  dlm_duplicate_roster_update(2018, 873826,440,'for ticket#314790');


select  dlm_duplicate_roster_update(2018, 1423611,3,'for ticket#314790' );
select  dlm_duplicate_roster_update(2018, 1423611,440,'for ticket#314790');

commit;

