--Per state request, please clear out all the extracts from the following user's account:
--email:heidi.shaw@adams12.org
begin;
	
update modulereport
set    activeflag =false,
       modifieddate=now(),
	  modifieduser= (select id from aartuser where email='ats_dba_team@ku.edu')
where 	 createduser= 129711 and modifieduser=129711 and activeflag is true;

	
commit;