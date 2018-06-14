BEGIN;
update organization 
    set activeflag = false,
	modifieduser = 12,
	modifieddate = now()
	where activeflag = true and displayidentifier in 
		  ('114644 418',
			'256822 405',
			'261619 172',
			'284043 418',
			'284043 427',
			'320333 209',
			'322124 409',
			'362205 409',
			'362205 172',
			'390018 172',
			'392754 209',
			'453029 209',
			'504725 414',
			'704581 463',
			'755486 109',
			'785510 172',
			'786750 409',
			'821611 945',
			'821611 236',
			'821611 499',
			'851359 436',
			'892834 109',
			'942313 218',
			'942313 209',
			'970270 418',
			'976039 427',
			'976039 445',
			'976039 544',
			'976039 961',
			'510090'
			);


update usersorganizations
    set activeflag =false,
        modifieduser =12,
        modifieddate = now()
    where activeflag = true and organizationid in (select id from organization where displayidentifier in 
			  ('114644 418',				
				'261619 172',
				'284043 418',
				'284043 427',
				'320333 209',				
				'362205 409',
				'362205 172',
				'390018 172',				
				'453029 209',				
				'704581 463',
				'755486 109',
				'785510 172',
				'786750 409',
				'821611 945',
				'821611 236',
				'821611 499',
				'851359 436',
				'942313 209',
				'970270 418',
				'976039 427',
				'976039 544',
				'976039 961',
				'510090'
				) )	;	
													 
--school from 322124 409 move to 322124 412												 
update 	usersorganizations 
  set organizationid = (select id from organization where displayidentifier = '322124 412'),
      modifieduser =12,
	  modifieddate = now()
	  where organizationid = (select id from organization where displayidentifier = '322124 409');
	  
	  
--school from 942313 218 move to 942313 227											 
update 	usersorganizations 
  set organizationid = (select id from organization where displayidentifier = '942313 227'),
      modifieduser =12,
	  modifieddate = now()
	  where organizationid = (select id from organization where displayidentifier = '942313 218');	  
	  

	  
--school from 392754 209 move to 390018 209											 
update 	usersorganizations 
  set organizationid = (select id from organization where displayidentifier = '390018 209'),
      modifieduser =12,
	  modifieddate = now()
	  where organizationid = (select id from organization where displayidentifier = '392754 209');	  


--school from 892834 109 move to 896592 109											 
update 	usersorganizations 
  set organizationid = (select id from organization where displayidentifier = '896592 109'),
      modifieduser =12,
	  modifieddate = now()
	  where organizationid = (select id from organization where displayidentifier = '892834 109');	


--school from 504725 414 move to 504725 432	
update 	usersorganizations 
  set organizationid = (select id from organization where displayidentifier = '504725 432'),
      modifieduser =12,
	  modifieddate = now()
	  where organizationid = (select id from organization where displayidentifier = '504725 414');	



--school from 976039 445 move to 976039 472	
  update 	usersorganizations 
  set organizationid = (select id from organization where displayidentifier = '976039 472'),
      modifieduser =12,
	  modifieddate = now()
	  where organizationid = (select id from organization where displayidentifier = '976039 445');		




--school from 256822 405 move to 256822 418	
update 	usersorganizations 
  set organizationid = (select id from organization where displayidentifier = '256822 418'),
      modifieduser =12,
	  modifieddate = now()
	  where organizationid = (select id from organization where displayidentifier = '256822 405');		

--delete organization from organizationtreedetail


delete from organizationtreedetail 

where statedisplayidentifier = 'IA' and schooldisplayidentifier in 
		   ('114644 418',
			'256822 405',
			'261619 172',
			'284043 418',
			'284043 427',
			'320333 209',
			'322124 409',
			'362205 409',
			'362205 172',
			'390018 172',
			'392754 209',
			'453029 209',
			'504725 414',
			'704581 463',
			'755486 109',
			'785510 172',
			'786750 409',
			'821611 945',
			'821611 236',
			'821611 499',
			'851359 436',
			'892834 109',
			'942313 218',
			'942313 209',
			'970270 418',
			'976039 427',
			'976039 445',
			'976039 544',
			'976039 961'
			
			) ;
			
--delete AK organization
delete from organizationtreedetail 

where statedisplayidentifier = 'AK' and schooldisplayidentifier ='510090';
	  
	  	  
COMMIT;	  
