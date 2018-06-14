--duplicate roster, studentid:1421464,1458123


begin;

select  dlm_duplicate_roster_update(2018, 1421464,3,'for ticket#757773' );
select  dlm_duplicate_roster_update(2018, 1421464,440,'for ticket#757773');
select  dlm_duplicate_roster_update(2018, 1458123,437,'for ticket#757773');

commit;




