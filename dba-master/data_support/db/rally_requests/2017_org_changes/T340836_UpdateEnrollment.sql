BEGIN;

--ssid:7856718595

update enrollment 
set activeflag =true,
    modifieddate=now(),
	modifieduser =174744
where id = 