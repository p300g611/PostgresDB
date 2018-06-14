BEGIN;

update aartuser 
set  firstname ='Gabrielle',
     surname ='Navickas',
	 displayname ='Gabrielle'||' '||'Navickas',
	 modifieddate = now(),
	 modifieduser =12
where id = 166572;

COMMIT;