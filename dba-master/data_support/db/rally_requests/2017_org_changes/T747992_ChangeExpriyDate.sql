begin;

update operationaltestwindow
  set expirydate ='2016-10-04 23:59:59:00+00',
      modifieddate =now(),
	  modifieduser =12
	where id = 10295;
	
	
commit;