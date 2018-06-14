--SSID:866794,1325123 

--run 
begin;
select dlm_duplicate_roster_update(2018, 866794,3,'for ticket#145179' );
select dlm_duplicate_roster_update(2018, 866794,440,'for ticket#145179' );
select dlm_duplicate_roster_update(2018, 866794,441,'for ticket#145179' );

select dlm_duplicate_roster_update(2018, 1325123,3,'for ticket#145179' );
select dlm_duplicate_roster_update(2018, 1325123,440,'for ticket#145179' );

commit;