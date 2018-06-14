--duplicate Roster 
--studentid:863401,857904,1340963,1421464

begin;

select  dlm_duplicate_roster_update(2018, 863401,3,'for ticket#885350' );
select  dlm_duplicate_roster_update(2018, 863401,440,'for ticket#885350');
select  dlm_duplicate_roster_update(2018, 863401,441,'for ticket#885350');


select  dlm_duplicate_roster_update(2018, 857904,3,'for ticket#885350' );
select  dlm_duplicate_roster_update(2018, 857904,440,'for ticket#885350');
select  dlm_duplicate_roster_update(2018, 857904,441,'for ticket#885350');


select  dlm_duplicate_roster_update(2018, 1340963,3,'for ticket#885350' );
select  dlm_duplicate_roster_update(2018, 1340963,440,'for ticket#885350');



select  dlm_duplicate_roster_update(2018, 1421464,3,'for ticket#885350' );
select  dlm_duplicate_roster_update(2018, 1421464,440,'for ticket#885350');

commit;