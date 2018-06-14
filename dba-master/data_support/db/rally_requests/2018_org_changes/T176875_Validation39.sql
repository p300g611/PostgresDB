--sid:861304

begin;

select  dlm_duplicate_roster_update(2018, 861304,3,'for ticket#176875' );
select  dlm_duplicate_roster_update(2018, 861304,440,'for ticket#176875');
select  dlm_duplicate_roster_update(2018, 861304,441,'for ticket#176875');
select  dlm_duplicate_roster_update(2018, 861304,437,'for ticket#176875');

commit;