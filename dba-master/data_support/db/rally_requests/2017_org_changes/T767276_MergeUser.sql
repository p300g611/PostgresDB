BEGIN;

--EID 5313736868
UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =146929;


update aartuser
set    username='mgray@usd220.net',
       email='mgray@usd220.net',
	   uniquecommonidentifier='5313736868',
	   activeflag =true,
	   modifieddate =now(),
	   modifieduser =12
where id =21307;


update usersorganizations
set activeflag =false
  where id = 21240;
  
  

update userorganizationsgroups
set  status =2,
     activeflag = true,
	 isdefault = true,
	 modifieddate =now(),
	 modifieduser =12
where id =192458;	

update userorganizationsgroups
set  activeflag =false,
	 isdefault = false
where id =247543;	

update userassessmentprogram
set activeflag = true,
    isdefault = true,
	 modifieddate =now(),
	 modifieduser =12
where id = 341549;	 


update userassessmentprogram
set     activeflag = false,
       isdefault = false
where id = 415125;	 

--EID 7284564253

update userorganizationsgroups
set    status =2,
 	   modifieddate =now(),
	   modifieduser =12
where id =243088;    


COMMIT;

