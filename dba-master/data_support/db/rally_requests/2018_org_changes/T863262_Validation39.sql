/*Ticket #863262
Subject: 	Validation 39 
*/

--1) Student 1339915
begin;
select dlm_duplicate_roster_update(2018,1339915,3,'for ticket #863262'); -- 3=ELA
select dlm_duplicate_roster_update(2018,1339915,440,'for ticket #863262'); -- 440=Math
select dlm_duplicate_roster_update(2018,1339915,441,'for ticket #863262'); -- 441=Science
commit;

--2) Student 1021600
begin;
select dlm_duplicate_roster_update(2018,1021600,3,'for ticket #863262'); -- 3=ELA
select dlm_duplicate_roster_update(2018,1021600,441,'for ticket #863262'); -- 441=Science
commit;

--3) Student 1245746
begin;
select dlm_duplicate_roster_update(2018,1245746,3,'for ticket #863262'); -- 3=ELA
select dlm_duplicate_roster_update(2018,1245746,440,'for ticket #863262'); -- 440=Math
commit;
