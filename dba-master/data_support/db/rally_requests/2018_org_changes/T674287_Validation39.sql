
--duplicate roster  stid in (1464574,1432132,1205901)

begin;

select  dlm_duplicate_roster_update(2018, 1464574,3,'for ticket#674287' );
select  dlm_duplicate_roster_update(2018, 1464574,440,'for ticket#674287');

update testsession 
set   rosterid=1263034,
      modifieddate=now(),
	  modifieduser=174744
	  where id = 6932139;
	  
	  
select  dlm_duplicate_roster_update(2018, 1432132,3,'for ticket#674287' );	  
	  
	  
select  dlm_duplicate_roster_update(2018, 1205901,440,'for ticket#674287');	  
	  
	  
	  
	  
commit;


