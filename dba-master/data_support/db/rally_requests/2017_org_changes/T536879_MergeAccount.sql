BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   uniquecommonidentifier=uniquecommonidentifier||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =165299;


update aartuser
set    username='agreen@pvillecsd.org',
       email='agreen@pvillecsd.org',
	   uniquecommonidentifier='972642',
	   modifieddate =now(),
	   modifieduser =12
where id =78059;


update roster 
set teacherid = 78059,
     modifieddate =now(),
	 	   modifieduser =12
where id in (1089045,1089044);


update userorganizationsgroups
set    activeflag =false,
       isdefault=false,
	   modifieddate =now(),
	   modifieduser =12
where id = 245507;

update userorganizationsgroups
set    activeflag =true,
       status=2,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =12
where id = 75526;

			   
			   
			   
update userassessmentprogram
set    activeflag =false,
       isdefault=false,
	   modifieddate =now(),
	   modifieduser =12
where id in (410296,410295,410294,410282,240015);

update userassessmentprogram
set    activeflag =true,
       isdefault=true,
	   modifieddate =now(),
	   modifieduser =12
where id =410279;
COMMIT;