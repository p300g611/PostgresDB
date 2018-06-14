BEGIN;

update aartuser
set    username='stakeyj@waterlooschools.org',
       email='stakeyj@waterlooschools.org',
	   modifieddate =now(),
	   modifieduser =12
where id =70362;


update usersorganizations
set    isdefault = false,
       activeflag= false,
	   modifieddate =now(),
	   modifieduser =12
where id =71493;


update userorganizationsgroups 
set    isdefault = true,
     activeflag = true,
	  status =2, 
	  modifieddate =now(),
	  modifieduser =12
	  where id = 239400;
	  
	  
update userassessmentprogram
 set   isdefault = true,
     activeflag = true,
	  modifieddate =now(),
	  modifieduser =12
	  where id = 399329; 

update userassessmentprogram
 set   isdefault = false,
     activeflag = false,
	  modifieddate =now(),
	  modifieduser =12
	  where id in (405729,405728,405727,405726,405723); 			   
			   
COMMIT;