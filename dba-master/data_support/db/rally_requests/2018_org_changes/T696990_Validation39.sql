/*Ticket #696990
Validation 39
studentid 1441611
*/
begin;
select dlm_duplicate_roster_update(2018,1441611,3,'for ticket #696990'); --3 = ELA
select dlm_duplicate_roster_update(2018,1441611,440,'for ticket #696990'); -- 440-math
commit;

