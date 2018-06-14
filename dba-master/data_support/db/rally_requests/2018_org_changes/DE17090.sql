begin;
update scoringassignmentstudent
set activeflag =true, 
    modifieddate=now(),
	modifieduser=174744
	where id =  392020;
	
update scoringassignmentstudent
set activeflag =false, 
    modifieddate=now(),
	modifieduser=174744
	where id =  414580;
	
commit;
