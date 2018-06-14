/*Ticket #141920
Subject: 	Validation 39 
*/

--1) Student 863401
begin;
select dlm_duplicate_roster_update(2018,863401,3,'for ticket #141920'); --3 = ELA
select dlm_duplicate_roster_update(2018,863401,440,'for ticket #141920'); -- 440=Math
select dlm_duplicate_roster_update(2018,863401,441,'for ticket #141920'); --3 = Science
commit;

--2) Student 1209334
begin;
select dlm_duplicate_roster_update(2018,1209334,3,'for ticket #141920'); --3 = ELA
select dlm_duplicate_roster_update(2018,1209334,440,'for ticket #141920'); -- 440=Math
--select dlm_duplicate_roster_update(2018,1209334,441,'for ticket #141920'); --3 = Science
commit;

--3) Student 1209335
begin;
select dlm_duplicate_roster_update(2018,1209335,3,'for ticket #141920'); --3 = ELA
select dlm_duplicate_roster_update(2018,1209335,440,'for ticket #141920'); -- 440=Math
select dlm_duplicate_roster_update(2018,1209335,441,'for ticket #141920'); --3 = Science
commit;

--4) Student 860056
begin;
select dlm_duplicate_roster_update(2018,860056,3,'for ticket #141920'); --3 = ELA
select dlm_duplicate_roster_update(2018,860056,440,'for ticket #141920'); -- 440=Math
--select dlm_duplicate_roster_update(2018,860056,441,'for ticket #141920'); --3 = Science
commit;
