BEGIN;
--student ID:7147073681. need test moved to new school

--inactive old school enrollment
update enrollment 
set  activeflag = false, 
modifieduser = 12, modifieddate = now(), exitwithdrawaltype = -55,  
exitwithdrawaldate = now(), notes = 'inactivated according to US18889'
where id  = 2370772;


--update enrollment in old school to new school
update studentstests
set enrollmentid = 2391780, modifieddate =now(), modifieduser =12
where id in (14334475,14334474,14334473,14261847,14261850,14261848,14261849,12805419,12805420);


COMMIT;
