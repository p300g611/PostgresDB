-- Help Desk reactivated tests and manually ended the test session, start time and end time set null, 
-- Updated original start time and end time 

--both transaction and DW
begin;
update studentstests
set startdatetime='2018-04-13 13:06:55.56464+00',
enddatetime='2018-04-13 13:07:27.346986+00'
where id=21643139;
commit;