Begin;

--before update:42022--9594269936;61187--4194591615;13926--7687499565
UPDATE aartuser
set    uniquecommonidentifier=null,
      modifieddate=now(),
	  modifieduser =174744
	  
where id in (42022,61187,13926);

COMMIT;