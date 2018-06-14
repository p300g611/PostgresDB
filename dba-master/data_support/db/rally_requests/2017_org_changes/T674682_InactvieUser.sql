BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =43199;

update usersorganizations
set activeflag = false,
    isdefault = false,
	modifieddate = now(),
	modifieduser =12
where id in (194564,158285,92776);


update usersorganizations
set 
    isdefault = true,
	modifieddate = now(),
	modifieduser =12
where id =194563 ;

update userorganizationsgroups
set  status =3,
     activeflag = false,
	 isdefault =false,
	 modifieddate = now(),
	 modifieduser =12
where id in (248484,192554,109025);

update userorganizationsgroups
set  
	 isdefault =true,
	 modifieddate = now(),
	 modifieduser =12
where id =248483 ;

update userassessmentprogram
set  activeflag = false,
     isdefault = false,
     modifieddate = now(),
	 modifieduser =12
where id in (416024,416023,341664,341663,263851,263850) ; 


update userassessmentprogram
set  
     isdefault = true,
     modifieddate = now(),
	 modifieduser =12
where id = 416022; 
COMMIT;