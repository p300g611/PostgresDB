--duplicate roster
--studentid:1416187,1416186,1324308,525697

begin;

select  dlm_duplicate_roster_update(2018, 1416187,3,'for ticket#508865' );
select  dlm_duplicate_roster_update(2018, 1416187,440,'for ticket#508865');


select  dlm_duplicate_roster_update(2018, 1416186,3,'for ticket#508865' );
select  dlm_duplicate_roster_update(2018, 1416186,440,'for ticket#508865');

select  dlm_duplicate_roster_update(2018, 1324308,3,'for ticket#508865' );
select  dlm_duplicate_roster_update(2018, 1324308,440,'for ticket#508865');


select  dlm_duplicate_roster_update(2018, 525697,3,'for ticket#508865' );
select  dlm_duplicate_roster_update(2018, 525697,440,'for ticket#508865');

commit;



