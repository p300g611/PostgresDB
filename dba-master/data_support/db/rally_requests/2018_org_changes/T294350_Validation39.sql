/*Ticket #294350
Subject: 	Validation 39 
*/

--Student 1157785

begin;
select dlm_duplicate_roster_update(2018,1157785,3,'for ticket #294350'); --3 = ELA
select dlm_duplicate_roster_update(2018,1157785,440,'for ticket #294350'); -- 440=Math
select dlm_duplicate_roster_update(2018,1157785,441,'for ticket #294350'); --3 = Science
commit;

--Student 1438597

begin;
select dlm_duplicate_roster_update(2018,1438597,3,'for ticket #294350'); --3 = ELA
select dlm_duplicate_roster_update(2018,1438597,440,'for ticket #294350'); -- 440-math
commit;
