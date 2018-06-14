BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =119574;

update aartuser
set    username='sami.graham@wasatch.edu',
       email='sami.graham@wasatch.edu',
	   uniquecommonidentifier='sami.graham@wasatch.edu',
	   modifieddate =now(),
	   modifieduser =12
where id =109564;


update userorganizationsgroups
 set       status=1,
          activationno = '109564-125733',
         activationnoexpirationdate = now()+interval'30 days',
		 modifieddate = now(),
		 modifieduser =12
where id =125733;


COMMIT;
