/*Ticket #558920
Subject: Validation 39 
*/

--Student 1206767
begin;
select dlm_duplicate_roster_update(2018,1206767,3,'for ticket #558920'); --3 = ELA
select dlm_duplicate_roster_update(2018,1206767,440,'for ticket #558920'); -- 440-math
commit;

--Student 1417096
begin;
select dlm_duplicate_roster_update(2018,1417096,3,'for ticket #558920'); --3 = ELA
select dlm_duplicate_roster_update(2018,1417096,440,'for ticket #558920'); -- 440-math
commit;
