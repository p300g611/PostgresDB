BEGIN;

UPDATE aartuser 
set    username=username||'_old',
       email=email||'_old',
	   activeflag =false,
	   modifieddate =now(),
	   modifieduser =12
where id =72836;

update aartuser
set    username='christine.spencer@forestgrove.k12.ok.us',
       email='christine.spencer@forestgrove.k12.ok.us',
	   uniquecommonidentifier='christine.spencer@forestgrove.k12.ok.us',
	   modifieddate =now(),
	   modifieduser =12
where id =173405;

COMMIT;